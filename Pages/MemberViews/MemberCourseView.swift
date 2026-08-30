//
//  MemberCourseView.swift
//  PeacockMenus
//
//  会员课程查询: 搜索会员 -> 课程卡片 -> 消费记录
//

import Alamofire
import Defaults
import RealmSwift
import SwiftUI

// ponytail: 默认地址, 登录页可修改/扫码, 真机/部署按实际服务器
var memberAPIBase: String {
    let saved = Defaults[.memberServerURL]
    return saved.isEmpty ? "http://192.168.0.4:7001" : saved
}

extension Defaults.Keys {
    static let memberServerURL = Key<String>("memberServerURL", default: "")
}

// MARK: - 登录态

@Observable
final class MemberAuth {
    static let shared = MemberAuth()
    var token: String
    var userName: String = ""
    var isAdmin: Bool = false
    var serverURL: String = Defaults[.memberServerURL]

    var isLoggedIn: Bool { !token.isEmpty }

    private init() {
        token = KeychainHelper.shared.memberToken() ?? ""
        isAdmin = UserDefaults.standard.bool(forKey: "memberIsAdmin")
        userName = UserDefaults.standard.string(forKey: "memberUserName") ?? ""
    }

    var baseURL: String {
        serverURL.isEmpty ? "http://192.168.0.4:7001" : serverURL
    }

    /// 探测接口地址是否有效(/ios/health)
    func checkServer(_ address: String) async -> Bool {
        let trimmed = address.trimmingCharacters(in: .whitespaces)
        guard let url = URL(string: trimmed + "/ios/health") else { return false }
        var request = URLRequest(url: url)
        request.timeoutInterval = 6
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return false }
            struct Health: Decodable { let code: Int?; let service: String? }
            let health = try? JSONDecoder().decode(Health.self, from: data)
            return health?.service == "peacock-menus"
        } catch {
            return false
        }
    }

    func login(account: String, password: String, server: String) async throws {
        let trimmed = server.trimmingCharacters(in: .whitespaces)
        guard let url = URL(string: trimmed + "/ios/login") else {
            throw MemberLoginError("接口地址不正确")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "account": account, "password": password
        ])

        let (data, response) = try await URLSession.shared.data(for: request)
        if let http = response as? HTTPURLResponse, http.statusCode == 401 {
            throw MemberLoginError("账号或密码错误")
        }
        struct LoginResult: Decodable {
            let code: Int
            let message: String?
            let data: Payload?
            struct Payload: Decodable {
                let token: String
                let name: String
                let admin: Bool?
            }
        }
        let result: LoginResult
        do {
            result = try JSONDecoder().decode(LoginResult.self, from: data)
        } catch {
            throw MemberLoginError("接口地址无效, 请检查")
        }
        guard result.code == 200, let payload = result.data else {
            throw MemberLoginError(result.message ?? "登录失败")
        }
        serverURL = trimmed
        Defaults[.memberServerURL] = trimmed
        applyToken(payload.token, name: payload.name, admin: payload.admin ?? false)
        // 登录成功后通过认证接口同步价目表
        peacock.shared.syncMenusFromMemberServer(token: payload.token)
    }

    func logout() {
        token = ""
        userName = ""
        isAdmin = false
        KeychainHelper.shared.clearMemberToken()
        UserDefaults.standard.removeObject(forKey: "memberIsAdmin")
        UserDefaults.standard.removeObject(forKey: "memberUserName")
        UserDefaults.standard.removeObject(forKey: "memberTokenDate")
    }

    /// 续签新 token, 成功则更新本地; 失败(已失效/离职)返回 false
    @discardableResult
    func refresh() async -> Bool {
        guard isLoggedIn, !isRefreshing else { return false }
        isRefreshing = true
        defer { isRefreshing = false }

        guard let url = URL(string: baseURL + "/ios/refresh") else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 8
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                // token 真过期了
                return false
            }
            struct RefreshResult: Decodable {
                let code: Int
                let data: Payload?
                struct Payload: Decodable {
                    let token: String
                    let name: String
                    let admin: Bool?
                }
            }
            let result = try JSONDecoder().decode(RefreshResult.self, from: data)
            guard result.code == 200, let payload = result.data else { return false }
            applyToken(payload.token, name: payload.name, admin: payload.admin ?? isAdmin)
            return true
        } catch {
            return false
        }
    }

    /// 启动时检查: token 临期(签发超 10 天)就自动续签
    func autoRenewIfNeeded() async {
        guard isLoggedIn else { return }
        let saved = UserDefaults.standard.double(forKey: "memberTokenDate")
        let age = Date().timeIntervalSince(Date(timeIntervalSince1970: saved))
        // 15 天有效期, 10 天后主动续签
        if saved == 0 || age > 10 * 24 * 3600 {
            await refresh()
        }
    }

    private var isRefreshing = false

    func applyToken(_ newToken: String, name: String, admin: Bool) {
        token = newToken
        userName = name
        isAdmin = admin
        KeychainHelper.shared.saveMemberToken(newToken)
        UserDefaults.standard.set(admin, forKey: "memberIsAdmin")
        UserDefaults.standard.set(name, forKey: "memberUserName")
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "memberTokenDate")
    }
}

struct MemberLoginError: Error, Identifiable {
    let id = UUID()
    let message: String
    init(_ message: String) { self.message = message }
}

/// 会员列表本地缓存表
final class MemberUserCache: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var userId: Int = 0
    @Persisted var userName: String = ""
    @Persisted var phone: String = ""
    @Persisted var card: String = ""
    @Persisted var courseCount: Int = 0
    @Persisted var lastArrivalTime: String = ""
    @Persisted var bookClass: String = ""
    @Persisted var bookPage: Int = 0
    @Persisted var bookNumber: Int = 0
    @Persisted var createdAt: String?

    convenience init(_ user: MemberUser) {
        self.init()
        userId = Int(user.id)
        userName = user.userName
        phone = user.phone
        card = user.card
        courseCount = user.courseCount
        lastArrivalTime = user.lastArrivalTime
        bookClass = user.bookClass
        bookPage = user.bookPage
        bookNumber = user.bookNumber
        createdAt = user.createdAt
    }

    var memberUser: MemberUser {
        MemberUser(
            id: UInt(userId),
            userName: userName,
            phone: phone,
            card: card,
            courseCount: courseCount,
            lastArrivalTime: lastArrivalTime,
            bookClass: bookClass,
            bookPage: bookPage,
            bookNumber: bookNumber,
            createdAt: createdAt
        )
    }

    /// 读全部缓存, 按账本 类-号-页 排序
    static func loadAll() -> [MemberUser] {
        guard let realm = try? Realm() else { return [] }
        return realm.objects(MemberUserCache.self)
            .sorted(by: [
                SortDescriptor(keyPath: "bookClass"),
                SortDescriptor(keyPath: "bookNumber"),
                SortDescriptor(keyPath: "bookPage"),
            ])
            .map { $0.memberUser }
    }

    /// 清空会员缓存表(账号离职/失效时调用), 在后台线程执行
    static func clearAll() {
        guard let realm = try? Realm() else { return }
        try? realm.write {
            // 只删本功能的表, 不动价目表等其他 Realm 数据
            realm.delete(realm.objects(MemberUserCache.self))
        }
    }

    /// 逐行对比, 只写入新增/变化的行; 返回是否有改动。Realm 操作在调用线程执行, 请在后台调用
    @discardableResult
    static func upsert(_ users: [MemberUser]) -> Bool {
        guard let realm = try? Realm() else { return false }
        let cachedByID = Dictionary(
            realm.objects(MemberUserCache.self).map { ($0.userId, $0) },
            uniquingKeysWith: { first, _ in first }
        )
        let changed = users.filter { user in
            guard let row = cachedByID[Int(user.id)] else { return true }
            return row.memberUser != user
        }
        guard !changed.isEmpty else { return false }
        do {
            try realm.write {
                realm.add(changed.map(MemberUserCache.init), update: .modified)
            }
            return true
        } catch {
            return false
        }
    }
}

private struct MemberApiResult<T: Decodable>: Decodable {
    let code: Int
    let data: T?
    let total: Int?
    let days: Int?
    let sumCount: Int?
}

struct MemberUser: Identifiable, Codable, Equatable {
    let id: UInt
    let userName: String
    let phone: String
    let card: String
    let courseCount: Int
    let lastArrivalTime: String
    let bookClass: String
    let bookPage: Int
    let bookNumber: Int
    let createdAt: String?

    // gorm.Model 序列化成大写的 ID
    enum CodingKeys: String, CodingKey {
        case id = "ID", userName, phone, card, courseCount,
             lastArrivalTime, bookClass, bookPage, bookNumber,
             createdAt = "CreatedAt"
    }

    /// 账本位置: 类-号-页, 如 W-3-38
    var bookLocation: String {
        guard !bookClass.isEmpty else { return "" }
        return "\(bookClass)-\(bookNumber)-\(bookPage)"
    }

    /// 距上次到店天数, 无记录返回 nil
    var daysSinceArrival: Int? {
        guard !lastArrivalTime.isEmpty,
              let date = arrivalDateFormatter.date(from: lastArrivalTime)
        else { return nil }
        let days = Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: date),
            to: Calendar.current.startOfDay(for: Date())
        ).day ?? 0
        return max(0, days)
    }
    /// 入会周数(创建到现在), 无法解析返回 nil
    var memberWeeks: Int? {
        guard let createdAt,
              let date = isoDateFormatter.date(from: createdAt)
        else { return nil }
        let days = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
        return days / 7
    }
}

let isoDateFormatter: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime]
    return f
}()

private let arrivalDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd HH:mm:ss"
    f.locale = Locale(identifier: "en_US_POSIX")
    return f
}()

struct MemberCourse: Identifiable, Decodable {
    let id: UInt
    let type: String // one 单课 / group 组合课
    let name: String
    let buyCount: Int
    let balance: Int
    let usedCount: Int
    let money: Double
    let createdAt: String
    let expiration: String // 过期日期 yyyy-MM-dd, 空=不过期

    var isExpired: Bool {
        guard !expiration.isEmpty,
              let day = expirationDateFormatter.date(from: expiration)
        else { return false }
        return day < Calendar.current.startOfDay(for: Date())
    }

    var remainingRatio: Double {
        guard buyCount > 0 else { return 0 }
        return min(1, Double(balance) / Double(buyCount))
    }
}

private let expirationDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "yyyy-MM-dd"
    return f
}()

enum CourseFilter: String, CaseIterable, Identifiable {
    case active = "可用"
    case used = "已用"
    var id: String { rawValue }

    func matches(_ course: MemberCourse) -> Bool {
        switch self {
        case .active:
            course.balance > 0
        case .used:
            course.balance <= 0
        }
    }
}

struct MemberRecord: Identifiable, Decodable {
    let id: UInt
    let name: String
    let count: Int
    let userA: String // 美发师
    let userB: String // 烫染师
    let createdAt: String
}

private func memberFetch<T: Decodable>(
    _ path: String,
    parameters: [String: String],
    retried: Bool = false,
    completion: @escaping ([T], Int?, Int?, Int?) -> Void
) {
    var headers: HTTPHeaders = [:]
    if !MemberAuth.shared.token.isEmpty {
        headers["Authorization"] = "Bearer \(MemberAuth.shared.token)"
    }
    AF.request(MemberAuth.shared.baseURL + path, method: .get, parameters: parameters, headers: headers)
        .responseDecodable(of: MemberApiResult<[T]>.self) { response in
            switch response.result {
            case .success(let result):
                completion(result.data ?? [], result.total, result.days, result.sumCount)
            case .failure(let err):
                if response.response?.statusCode == 401 && !retried {
                    // 先尝试自动续签并重试一次
                    Task {
                        if await MemberAuth.shared.refresh() {
                            memberFetch(path, parameters: parameters, retried: true,
                                        completion: completion)
                        } else {
                            handleAuthExpired()
                            completion([], nil, nil, nil)
                        }
                    }
                    return
                }
                if response.response?.statusCode == 401 {
                    handleAuthExpired()
                }
                debugPrint(err)
                completion([], nil, nil, nil)
            }
        }
}

/// 登录彻底失效: 登出并清缓存
private func handleAuthExpired() {
    MemberAuth.shared.logout()
    Task.detached { MemberUserCache.clearAll() }
}

func memberFetchAsync<T: Decodable>(
    _ path: String,
    parameters: [String: String]
) async -> ([T], total: Int?, days: Int?, sumCount: Int?) {
    await withCheckedContinuation { continuation in
        memberFetch(path, parameters: parameters) {
            (result: [T], total: Int?, days: Int?, sumCount: Int?) in
            continuation.resume(returning: (result, total, days, sumCount))
        }
    }
}

// MARK: - 视觉基调

enum Palette {
    static let blue = Color(hex: "4C9AFF")
    static let blueDeep = Color(hex: "2F7CF6")
    static let green = Color(hex: "2ECC87")
    static let orange = Color(hex: "FF9F43")
    static let red = Color(hex: "FF6B6B")
    static let purple = Color(hex: "8B7BFF")
    static let textSub = Color.secondary

    // 头像渐变色对, 按名字散列取色
    static let avatarGradients: [[Color]] = [
        [Color(hex: "5AA9E6"), Color(hex: "7FC8F8")],
        [Color(hex: "F77F8A"), Color(hex: "FFA8A8")],
        [Color(hex: "7B68EE"), Color(hex: "A294FF")],
        [Color(hex: "34C77B"), Color(hex: "6BE0A5")],
        [Color(hex: "FF9F43"), Color(hex: "FFC266")],
        [Color(hex: "FF6B9D"), Color(hex: "FFA3C0")],
    ]

    static func gradient<T: StringProtocol>(for key: T) -> [Color] {
        var h: UInt64 = 0
        for byte in String(key).utf8 {
            h = h &* 31 &+ UInt64(byte)
        }
        return avatarGradients[Int(h % UInt64(avatarGradients.count))]
    }
}

/// 首字头像, 渐变底
private struct AvatarView: View {
    let name: String
    var size: CGFloat = 52

    var body: some View {
        let initial = String(name.prefix(1))
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: Palette.gradient(for: name.isEmpty ? " " : name),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Text(initial)
                .font(.system(size: size * 0.42, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
    }
}

/// 圆角图标块
private struct IconTile: View {
    let systemImage: String
    var color: Color = Palette.blue
    var size: CGFloat = 42

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(
                RoundedRectangle(cornerRadius: size * 0.3, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.85), color.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
    }
}

private struct Badge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.14), in: Capsule())
            .foregroundStyle(color)
    }
}

/// 卡片按压反馈
private struct CardPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

private extension View {
    func cardChrome(dimmed: Bool = false, highlight: Bool = false) -> some View {
        self
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .memberCardStyle(dimmed: dimmed, highlight: highlight)
    }

    func memberCardStyle(dimmed: Bool = false, highlight: Bool = false) -> some View {
        self
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                // 深色模式下阴影不可见, 用发丝描边分离卡片和背景
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(
                        highlight ? Palette.blue.opacity(0.8) : Color.primary.opacity(0.07),
                        lineWidth: highlight ? 2.5 : 1
                    )
            }
            .shadow(
                color: highlight ? Palette.blue.opacity(0.35) : .black.opacity(0.07),
                radius: highlight ? 14 : 12,
                x: 0,
                y: highlight ? 4 : 6
            )
            .opacity(dimmed ? 0.72 : 1)
    }
}

/// 瀑布流布局: 每个子视图测量后放进当前最矮的列, 卡片高度变化时自动重排
// ponytail: Layout 协议非懒加载, 所有卡片参与测量; 会员页 50 条分批增长、课程页 ≤50 条, 量级够用
struct MasonryLayout: Layout {
    var minimum: CGFloat = 340
    var spacing: CGFloat = 16

    private func columnCount(for width: CGFloat) -> Int {
        max(1, Int((width + spacing) / (minimum + spacing)))
    }

    private func shortestColumn(_ heights: [CGFloat]) -> Int {
        heights.firstIndex(of: heights.min() ?? 0) ?? 0
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        guard !subviews.isEmpty, let width = proposal.width, width > 0 else {
            return .zero
        }
        let cols = columnCount(for: width)
        let colWidth = (width - spacing * CGFloat(cols - 1)) / CGFloat(cols)
        var heights = Array(repeating: CGFloat.zero, count: cols)
        for subview in subviews {
            let size = subview.sizeThatFits(.init(width: colWidth, height: nil))
            let col = shortestColumn(heights)
            heights[col] += size.height + spacing
        }
        return CGSize(width: width, height: max(0, (heights.max() ?? 0) - spacing))
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        guard !subviews.isEmpty else { return }
        let cols = columnCount(for: bounds.width)
        let colWidth = (bounds.width - spacing * CGFloat(cols - 1)) / CGFloat(cols)
        var colHeight = Array(repeating: CGFloat.zero, count: cols)
        for subview in subviews {
            let size = subview.sizeThatFits(.init(width: colWidth, height: nil))
            let col = shortestColumn(colHeight)
            let x = bounds.minX + CGFloat(col) * (colWidth + spacing)
            subview.place(
                at: CGPoint(x: x, y: bounds.minY + colHeight[col]),
                anchor: .topLeading,
                proposal: .init(size)
            )
            colHeight[col] += size.height + spacing
        }
    }
}

/// 滚动到底部检测(瀑布流非懒加载, onAppear 不可靠, 用全局位置判断)
private struct ReachBottomKey: PreferenceKey {
    static var defaultValue: CGFloat = .infinity
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = min(value, nextValue())
    }
}

/// 卡片网格: 窄屏(iPhone)单列, 宽屏(iPad/横屏)自动多列, 瀑布流排列
private struct MemberCardGrid<Content: View>: View {
    var minimum: CGFloat = 340
    /// 排列变化依据(当前显示数量), 变化时卡片弹簧动画重排
    var reflowToken: Int = 0
    /// 滚动接近底部时回调(用于加载更多)
    var onReachBottom: (() -> Void)? = nil
    @ViewBuilder var content: Content

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    MasonryLayout(minimum: minimum, spacing: 16) {
                        content
                    }
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.82),
                        value: reflowToken
                    )
                    // 底部哨兵: 全局位置进入屏幕下方 300pt 内即触发
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: ReachBottomKey.self,
                            value: geo.frame(in: .global).maxY
                        )
                    }
                    .frame(height: 1)
                }
                // 内容为空/很少时也撑满视口, 空状态和刷新控件才不会塌陷
                .frame(minHeight: proxy.size.height, alignment: .top)
                .padding(20)
            }
            .onPreferenceChange(ReachBottomKey.self) { maxY in
                if maxY < UIScreen.main.bounds.maxY + 300 {
                    onReachBottom?()
                }
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Palette.blue.opacity(0.08),
                    Color(.systemGroupedBackground),
                    Color(.systemGroupedBackground),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - 会员搜索

struct MemberSearchView: View {
    @State private var searchText = ""
    @State private var allUsers: [MemberUser] = []
    @State private var visibleCount = 50
    @State private var loading = false
    @State private var compact = true
    @State private var selectedUser: MemberUser?
    @Namespace private var userSpace
    @Default(.defaultHome) var defaultHome

    private let pageSize = 50

    // 搜索框纯前端过滤: 姓名 / 手机号 / 卡号
    private var filtered: [MemberUser] {
        let keyword = searchText.trimmingCharacters(in: .whitespaces)
        guard !keyword.isEmpty else { return allUsers }
        return allUsers.filter {
            $0.userName.localizedCaseInsensitiveContains(keyword)
                || $0.phone.localizedCaseInsensitiveContains(keyword)
                || $0.card.localizedCaseInsensitiveContains(keyword)
        }
    }

    private var displayed: [MemberUser] {
        Array(filtered.prefix(visibleCount))
    }

    var body: some View {
        MemberCardGrid(
            reflowToken: displayed.count,
            onReachBottom: {
                guard filtered.count > visibleCount else { return }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.82)) {
                    visibleCount += pageSize
                }
            }
        ) {
            ForEach(displayed) { user in
                Button {
                    selectedUser = user
                } label: {
                    MemberUserCard(user: user, compact: compact)
                }
                .buttonStyle(CardPressStyle())
                .matchedTransitionSource(id: user.id, in: userSpace)
            }
            // 滚到底部时显示加载指示(实际触发由哨兵回调处理)
            if filtered.count > visibleCount {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
        }
        .fullScreenCover(item: $selectedUser) { user in
            NavigationStack {
                MemberCourseListView(user: user)
            }
            .navigationTransition(.zoom(sourceID: user.id, in: userSpace))
        }
        .navigationTitle("课程查询")
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "姓名 / 手机号 / 卡号"
        )
        .onChange(of: searchText) { _,_ in
            visibleCount = pageSize
        }
        .animation(.easeInOut(duration: 0.2), value: compact)
        .onAppear {
            Task {
                await MemberAuth.shared.autoRenewIfNeeded()
                await load()
            }
        }
        .refreshable { await load() }
        .overlay {
            if loading && allUsers.isEmpty {
                ProgressView().controlSize(.large)
            } else if !loading && filtered.isEmpty {
                ContentUnavailableView(
                    "没有找到会员",
                    systemImage: "person.slash",
                    description: Text("换个姓名、手机号或卡号试试")
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    compact.toggle()
                } label: {
                    Label(
                        compact ? "详细" : "简约",
                        systemImage: compact
                            ? "list.bullet.rectangle"
                            : "list.dash.header.rectangle"
                    )
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        peacock.shared.showVipHairCourse = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
        }
    }

    // 先读 Realm 本地缓存显示, 再拉远程; Realm 读写放后台线程避免卡顿
    private func load() async {
        if allUsers.isEmpty {
            allUsers = await Task.detached { MemberUserCache.loadAll() }.value
        }
        if allUsers.isEmpty { loading = true }

        let (result, _, _, _): ([MemberUser], Int?, Int?, Int?) = await memberFetchAsync(
            "/ios/search/users",
            parameters: [:]
        )
        // ponytail: 请求失败也返回空数组, 空结果时保留缓存不清空
        guard !result.isEmpty else {
            loading = false
            return
        }

        // 694 是公司内部账户, 不展示
        let fresh = result.filter { $0.id != 694 }

        // 逐行对比写库放后台
        let changed = await Task.detached { MemberUserCache.upsert(fresh) }.value
        guard changed || allUsers.isEmpty else {
            loading = false
            return
        }

        withAnimation(.easeInOut(duration: 0.25)) {
            allUsers = fresh
            loading = false
        }
    }
}

struct MemberUserCard: View {
    let user: MemberUser
    var compact: Bool = false

    var body: some View {
        VStack(spacing: 12) {
            // 头部: 头像 + 姓名/手机号 + 课程数
            HStack(spacing: 12) {
                AvatarView(name: user.userName)

                VStack(alignment: .leading, spacing: 4) {
                    Text(user.userName.isEmpty ? "未命名" : user.userName)
                        .font(.headline)
                        .lineLimit(1)

                    Label(
                        user.phone.isEmpty ? "未绑定" : user.phone,
                        systemImage: "phone.fill"
                    )
                    .font(.caption)
                    .foregroundStyle(user.phone.isEmpty ? .secondary : Palette.blue)
                }

                Spacer(minLength: 8)

                Text("\(user.courseCount)")
                    .font(.title2.bold())
                    .foregroundStyle(user.courseCount > 0 ? Palette.blueDeep : .secondary)

                Text("课程")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(.tertiary)
            }

            if !compact {
                Divider()

                // 账本编号(简约模式隐藏)
                HStack(alignment: .top, spacing: 12) {
                    InfoRow(
                        systemImage: "creditcard.fill",
                        text: user.card.isEmpty ? "未绑定" : user.card,
                        placeholder: user.card.isEmpty
                    )
                    InfoRow(
                        systemImage: "book.pages.fill",
                        text: user.bookLocation.isEmpty ? "未建档" : user.bookLocation,
                        placeholder: user.bookLocation.isEmpty
                    )
                }

                // 到店状态(简约模式隐藏)
                HStack {
                    ArrivalBadge(days: user.daysSinceArrival)
                    Spacer()
                }
            } else {
                Label(user.card.isEmpty ? "未绑定" : user.card, systemImage: "creditcard.fill")
                    .font(.caption)
                    .foregroundStyle(user.card.isEmpty ? .secondary : .secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .memberCardStyle()
    }
}

/// 卡片信息行: 图标 + 单行文本
private struct InfoRow: View {
    let systemImage: String
    let text: String
    var placeholder: Bool = false

    var body: some View {
        Label(text, systemImage: systemImage)
            .font(.caption)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .foregroundStyle(placeholder ? Color.secondary : Color.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// 距上次到店胶囊: 30 天内绿色, 90 天内橙色, 更久红色
private struct ArrivalBadge: View {
    let days: Int?

    private var color: Color {
        guard let days else { return .gray }
        switch days {
        case ...30: return Palette.green
        case ...90: return Palette.orange
        default: return Palette.red
        }
    }

    private var text: String {
        guard let days else { return "无到店记录" }
        if days == 0 { return "今天到店" }
        return "\(days) 天未到店"
    }

    var body: some View {
        Label(text, systemImage: "figure.walk")
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.14), in: Capsule())
            .foregroundStyle(color)
    }
}

// MARK: - 课程卡片

struct MemberCourseListView: View {
    let user: MemberUser
    @State private var courses: [MemberCourse] = []
    @State private var loading = false
    @State private var filter: CourseFilter = .active
    @State private var flippedID: UInt?
    @State private var showAllRecords = false
    @Namespace private var allRecordsSpace
    @Environment(\.dismiss) private var dismiss

    private var filtered: [MemberCourse] {
        courses.filter { filter.matches($0) }
    }

    private func count(_ f: CourseFilter) -> Int {
        courses.filter { f.matches($0) }.count
    }

    var body: some View {
        MemberCardGrid(reflowToken: filtered.count) {
            ForEach(filtered) { course in
                CourseCard(
                    course: course,
                    flipped: flippedID == course.id,
                    onFlip: { toBack in
                        withAnimation(.spring(response: 0.42, dampingFraction: 0.9)) {
                            flippedID = toBack ? course.id : nil
                        }
                    }
                )
            }
        }
        .navigationTitle(user.userName.isEmpty ? "会员课程" : user.userName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if courses.isEmpty { Task { await load() } } }
        .refreshable { await load() }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAllRecords = true
                } label: {
                    Image(systemName: "list.clipboard")
                }
                .matchedTransitionSource(id: "allRecords", in: allRecordsSpace)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Picker("课程分类", selection: $filter) {
                    ForEach(CourseFilter.allCases) { f in
                        Text("\(f.rawValue) \(count(f))").tag(f)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: 100)
            }
        }
        .fullScreenCover(isPresented: $showAllRecords) {
            NavigationStack {
                MemberAllRecordsView(user: user)
            }
            .navigationTransition(.zoom(sourceID: "allRecords", in: allRecordsSpace))
        }
        .overlay {
            if loading && courses.isEmpty {
                ProgressView().controlSize(.large)
            } else if !loading && filtered.isEmpty {
                ContentUnavailableView(
                    "没有\(filter.rawValue)的课程",
                    systemImage: "scissors",
                    description: Text(
                        filter == .active ? "该会员当前没有可用课程" : "换个分类看看"
                    )
                )
            }
        }
    }

    private func load() async {
        loading = true
        let (result, _, _, _): ([MemberCourse], Int?, Int?, Int?) = await memberFetchAsync(
            "/ios/courses",
            parameters: ["userId": String(user.id)]
        )
        withAnimation(.easeInOut(duration: 0.25)) {
            // 过期课程不展示
            courses = result.filter { !$0.isExpired }
            loading = false
        }
    }
}

struct CourseCard: View {
    let course: MemberCourse
    var flipped: Bool = false
    var onFlip: (Bool) -> Void = { _ in }

    @State private var records: [MemberRecord] = []
    @State private var recordsLoading = false
    @State private var angle: Double = 0 // 0 正面, 180 背面

    private var showBack: Bool { angle >= 90 }

    private var stateColor: Color {
        if course.isExpired { return Palette.red }
        if course.balance <= 0 { return .gray }
        return Palette.green
    }

    var body: some View {
        ZStack {
            if !showBack {
                frontFace.cardChrome(dimmed: course.isExpired)
            } else {
                backFace
                    .cardChrome(dimmed: course.isExpired, highlight: true)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
        .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0), perspective: 0.45)
        .onChange(of: flipped) { _, toBack in
            if toBack, records.isEmpty, !recordsLoading {
                Task { await loadRecords() }
            }
            // 两段式翻转: 先转到 90° 换面, 再转完
            withAnimation(.easeInOut(duration: 0.28)) {
                angle = 90
            } completion: {
                withAnimation(.easeInOut(duration: 0.28)) {
                    angle = toBack ? 180 : 0
                }
            }
        }
    }

    // MARK: 正面: 课程信息

    private var frontFace: some View {
        VStack(alignment: .leading, spacing: 14) {
            // 标题行: 图标块即消费记录入口(角标提示)
            HStack(spacing: 12) {
                Button {
                    onFlip(true)
                } label: {
                    IconTile(
                        systemImage: course.type == "group" ? "square.stack.3d.up.fill" : "scissors",
                        color: course.isExpired || course.balance <= 0 ? .gray : Palette.blue
                    )
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "list.clipboard.fill")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(Palette.blueDeep)
                            .padding(4)
                            .background(Circle().fill(.white))
                            .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
                            .offset(x: 5, y: 5)
                    }
                }
                .buttonStyle(CardPressStyle())

                VStack(alignment: .leading, spacing: 5) {
                    Text(course.name)
                        .font(.headline)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    HStack(spacing: 6) {
                        if course.isExpired {
                            Badge(text: "已过期", color: Palette.red)
                        } else if course.balance <= 0 {
                            Badge(text: "已用完", color: .gray)
                        }
                        if course.type == "group" {
                            Badge(text: "组合课", color: Palette.orange)
                        }
                    }
                }

                Spacer(minLength: 0)
            }

            // 剩余次数 + 进度条
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("剩余")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(course.balance)")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(stateColor)
                    Text("次")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("共 \(course.buyCount) 次 · 已用 \(course.usedCount)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(.systemGray5))
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [stateColor.opacity(0.7), stateColor],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * course.remainingRatio)
                    }
                }
                .frame(height: 8)
            }

            // 时间信息
            VStack(alignment: .leading, spacing: 4) {
                Label(course.createdAt, systemImage: "calendar")
                Label("有效期至 \(course.expiration)", systemImage: "hourglass")
                    .foregroundStyle(course.isExpired ? Palette.red : .secondary)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    // MARK: 背面: 消费记录

    private var backFace: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // 点标题翻回正面
                Button {
                    onFlip(false)
                } label: {
                    HStack(spacing: 6) {
                        Label("消费记录", systemImage: "list.clipboard.fill")
                            .font(.subheadline.bold())
                        if !records.isEmpty {
                            Text("\(records.count) 条")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundStyle(.primary)
                }
                .buttonStyle(CardPressStyle())
                Spacer()
                // 关闭翻回
                Button {
                    onFlip(false)
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .padding(8)
                        .background(Color(.systemGray5), in: Circle())
                }
                .buttonStyle(CardPressStyle())
            }

            Divider()

            if recordsLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else if records.isEmpty {
                Text("暂无消费记录")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(records) { record in
                            RecordRow(record: record)
                            if record.id != records.last?.id {
                                Divider().padding(.leading, 38)
                            }
                        }
                    }
                }
                .frame(maxHeight: 260)
            }
        }
    }

    private func loadRecords() async {
        recordsLoading = true
        let parameters: [String: String] = course.type == "group"
            ? ["groupId": String(course.id)]
            : ["courseId": String(course.id)]
        (records, _, _, _) = await memberFetchAsync("/ios/records", parameters: parameters)
        recordsLoading = false
    }
}

/// 展开卡片内的紧凑消费记录行
private struct RecordRow: View {
    let record: MemberRecord

    private var dateText: String {
        record.createdAt.count >= 16
            ? String(record.createdAt.prefix(16)) : record.createdAt
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "scissors.circle.fill")
                .font(.title3)
                .foregroundStyle(Palette.blue.opacity(0.6))

            VStack(alignment: .leading, spacing: 3) {
                Text(dateText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 10) {
                    Text(record.userA.isEmpty ? "—" : record.userA)
                    Text(record.userB.isEmpty ? "—" : record.userB)
                        .foregroundStyle(.secondary)
                }
                .font(.caption.bold())
            }

            Spacer()

            Text("×\(record.count)")
                .font(.subheadline.bold())
                .foregroundStyle(Palette.blueDeep)
        }
        .padding(.vertical, 8)
    }
}

/// 会员全部课程的消费记录汇总, 每页 20 条滚动加载
struct MemberAllRecordsView: View {
    let user: MemberUser
    @State private var records: [MemberRecord] = []
    @State private var loading = false
    @State private var loadingMore = false
    @State private var hasMore = true
    @State private var page = 1
    @State private var total = 0 // 服务器端记录总数
    @State private var totalDays = 0 // 服务器端消费天数
    @State private var totalSessions = 0 // 服务器端累计次数
    private let pageSize = 20
    @Environment(\.dismiss) private var dismiss

    // 按天分组(接口按时间倒序, 同一天连续, 跨分页也只会续在最后一组)
    private var dayGroups: [(day: String, records: [MemberRecord])] {
        var groups: [(day: String, records: [MemberRecord])] = []
        for record in records {
            let day = String(record.createdAt.prefix(10))
            if groups.last?.day == day {
                groups[groups.count - 1].records.append(record)
            } else {
                groups.append((day, [record]))
            }
        }
        return groups
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroCard

                HStack(spacing: 12) {
                    StatTile(title: "消费记录", value: "\(records.count)", unit: "/ \(total) 条")
                    StatTile(title: "累计次数", value: "\(totalSessions)", unit: "次")
                    StatTile(title: "消费天数", value: "\(totalDays)", unit: "天")
                }

                LazyVStack(spacing: 12) {
                    ForEach(dayGroups, id: \.day) { group in
                        DaySectionCard(day: group.day, records: group.records)
                    }

                    // 初始加载完成且可能有下一页时才插入, 保证滚到底部可靠触发
                    if hasMore && !loading && !records.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .onAppear { loadMore() }
                    }

                    if records.isEmpty && !loading {
                        ContentUnavailableView(
                            "暂无消费记录",
                            systemImage: "doc.text.magnifyingglass"
                        )
                        .frame(height: 300)
                    }
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("全部消费记录")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
        }
        .task {
            if records.isEmpty { await load() }
        }
        .refreshable { await load() }
        .overlay {
            if loading && records.isEmpty {
                ProgressView().controlSize(.large)
            }
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text(user.userName.isEmpty ? "会员" : user.userName)
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                        
                    }
                    Text("全部课程消费记录")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                }
                Spacer()
                Image(systemName: "person.text.rectangle.fill")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))
            }

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(total)")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("条记录")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                Spacer()
                if let weeks = user.memberWeeks {
                    Text("会员第 \(max(1, weeks + 1)) 周")
                        .font(.caption2.bold())
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(.white.opacity(0.25), in: Capsule())
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Palette.blue, Palette.blueDeep],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: Palette.blueDeep.opacity(0.3), radius: 12, y: 6)
    }

    private func load() async {
        loading = true
        page = 1
        let (result, totalCount, dayCount, sum): ([MemberRecord], Int?, Int?, Int?) = await memberFetchAsync(
            "/ios/allRecords",
            parameters: ["userId": String(user.id), "page": "1"]
        )
        records = result
        total = totalCount ?? result.count
        totalDays = dayCount ?? dayGroups.count
        totalSessions = sum ?? result.reduce(0) { $0 + $1.count }
        hasMore = result.count >= pageSize
        page = 2
        loading = false
    }

    private func loadMore() {
        guard hasMore, !loadingMore, !loading else { return }
        loadingMore = true
        let nextPage = page
        Task {
            let (result, totalCount, dayCount, sum): ([MemberRecord], Int?, Int?, Int?) = await memberFetchAsync(
                "/ios/allRecords",
                parameters: ["userId": String(user.id), "page": String(nextPage)]
            )
            records.append(contentsOf: result)
            if let totalCount { total = totalCount }
            if let dayCount { totalDays = dayCount }
            if let sum { totalSessions = sum }
            hasMore = result.count >= pageSize
            page = nextPage + 1
            loadingMore = false
        }
    }
}

/// 大屏统计小块
private struct StatTile: View {
    let title: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title3.bold())
                    .foregroundStyle(Palette.blueDeep)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                if !unit.isEmpty {
                    Text(unit)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

/// 按天分组的消费记录卡: 日期头 + 当天记录时间线
private struct DaySectionCard: View {
    let day: String // yyyy-MM-dd
    let records: [MemberRecord]

    private var info: (dayNum: String, title: String, weekday: String, relative: String?) {
        let parts = day.split(separator: "-")
        guard parts.count == 3,
              let month = Int(parts[1]), let dateNum = Int(parts[2])
        else { return (day, day, "", nil) }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd"
        var weekday = ""
        var relative: String?
        if let date = formatter.date(from: day) {
            let names = ["日", "一", "二", "三", "四", "五", "六"]
            let wd = Calendar.current.component(.weekday, from: date) - 1
            weekday = "周\(names[wd])"
            if Calendar.current.isDateInToday(date) { relative = "今天" }
            else if Calendar.current.isDateInYesterday(date) { relative = "昨天" }
        }
        return ("\(dateNum)", "\(parts[0])年\(month)月\(dateNum)日", weekday, relative)
    }

    var body: some View {
        let d = info
        VStack(alignment: .leading, spacing: 0) {
            // 日期头
            HStack(spacing: 12) {
                Text(d.dayNum)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 46, height: 46)
                    .background(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Palette.blue, Palette.blueDeep],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(d.title).font(.subheadline.bold())
                        if !d.weekday.isEmpty {
                            Text(d.weekday)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        if let rel = d.relative {
                            Text(rel)
                                .font(.caption2.bold())
                                .padding(.horizontal, 7)
                                .padding(.vertical, 2)
                                .background(Palette.green.opacity(0.15), in: Capsule())
                                .foregroundStyle(Palette.green)
                        }
                    }
                    Text("\(records.count) 条记录")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)

            Divider()

            ForEach(records) { record in
                DayRecordRow(record: record)
                if record.id != records.last?.id {
                    Divider().padding(.leading, 62)
                }
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
        }
    }
}

/// 当天记录行: 时间 + 课程/员工 + 次数
private struct DayRecordRow: View {
    let record: MemberRecord

    private var time: String {
        record.createdAt.count >= 16
            ? String(record.createdAt.prefix(16).suffix(5)) : ""
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(time)
                .font(.caption.monospacedDigit().bold())
                .foregroundStyle(Palette.blueDeep)
                .frame(width: 46, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text(record.name.isEmpty ? "未知课程" : record.name)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                HStack(spacing: 12) {
                    StylistMini(systemImage: "scissors", name: record.userA)
                    StylistMini(systemImage: "paintpalette.fill", name: record.userB)
                }
            }

            Spacer(minLength: 4)

            Text("×\(record.count)")
                .font(.caption.bold())
                .foregroundStyle(Palette.blueDeep)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Palette.blue.opacity(0.12), in: Capsule())
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}

/// 员工行: 图标 + 姓名
private struct StylistMini: View {
    let systemImage: String
    let name: String

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: systemImage)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
            Text(name.isEmpty ? "—" : name)
                .font(.caption.bold())
                .foregroundStyle(name.isEmpty ? .secondary : .primary)
                .lineLimit(1)
        }
    }
}

// MARK: - 登录页

struct MemberLoginView: View {
    @State private var account = ""
    @State private var password = ""
    @State private var server = Defaults[.memberServerURL]
    @State private var loading = false
    @State private var error: MemberLoginError?
    @State private var showScanner = false
    @FocusState private var focusedField: Field?
    private enum Field { case server, account, password }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Palette.blue, Palette.blueDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // 头部图标
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.15))
                            .frame(width: 88, height: 88)
                        Image(systemName: "scissors")
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 16)

                    Text("美发课程系统")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("员工登录")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.top, 4)

                    // 表单卡
                    VStack(spacing: 14) {
                        // 服务器地址 + 扫码
                        HStack(spacing: 10) {
                            Image(systemName: "globe")
                                .font(.subheadline)
                                .foregroundStyle(Palette.blue)
                                .frame(width: 24)
                            TextField("服务器地址", text: $server)
                                .font(.caption)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .focused($focusedField, equals: .server)
                                .submitLabel(.next)
                            Button {
                                showScanner = true
                            } label: {
                                Image(systemName: "qrcode.viewfinder")
                                    .font(.subheadline)
                                    .foregroundStyle(Palette.blue)
                                    .frame(width: 32, height: 32)
                                    .background(
                                        Palette.blue.opacity(0.12),
                                        in: RoundedRectangle(cornerRadius: 8)
                                    )
                            }
                        }
                        .padding(.horizontal, 14)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(.systemGray6))
                        )

                        LoginField(
                            icon: "person.fill",
                            placeholder: "工号或手机号",
                            text: $account,
                            isSecure: false
                        )
                        .focused($focusedField, equals: .account)

                        LoginField(
                            icon: "lock.fill",
                            placeholder: "密码",
                            text: $password,
                            isSecure: true
                        )
                        .focused($focusedField, equals: .password)
                        .onSubmit { submit() }

                        if let error {
                            Label(error.message, systemImage: "exclamationmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(Palette.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button(action: submit) {
                            HStack(spacing: 8) {
                                if loading {
                                    ProgressView()
                                        .tint(.white)
                                }
                                Text(loading ? "登录中…" : "登 录")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                        }
                        .buttonStyle(.plain)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(
                                    canSubmit
                                        ? AnyShapeStyle(Color.white)
                                        : AnyShapeStyle(Color.white.opacity(0.4))
                                )
                        )
                        .foregroundStyle(canSubmit ? Palette.blueDeep : Color.white.opacity(0.7))
                        .disabled(!canSubmit || loading)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color(.secondarySystemGroupedBackground))
                    )
                    .frame(maxWidth: 460)
                    .padding(.horizontal, 28)
                    .padding(.top, 32)
                }
                .padding(.vertical, 30)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onTapGesture { focusedField = nil }
        .overlay(alignment: .topTrailing) {
            Button {
                peacock.shared.showVipHairCourse = false
            } label: {
                Image(systemName: "xmark")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.white.opacity(0.2), in: Circle())
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showScanner) {
            ScanView { code in
                if code.hasPrefix("http") {
                    server = code
                }
                showScanner = false
                return true
            }
        }
    }

    private var canSubmit: Bool {
        !account.trimmingCharacters(in: .whitespaces).isEmpty
            && !password.isEmpty
            && server.trimmingCharacters(in: .whitespaces).hasPrefix("http")
    }

    private func submit() {
        guard canSubmit, !loading else { return }
        focusedField = nil
        loading = true
        error = nil
        Task {
            do {
                try await MemberAuth.shared.login(
                    account: account.trimmingCharacters(in: .whitespaces),
                    password: password,
                    server: server
                )
            } catch let e as MemberLoginError {
                error = e
            } catch _ {
                error = MemberLoginError("网络异常, 请检查地址")
            }
            loading = false
        }
    }
}

private struct LoginField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Palette.blue)
                .frame(width: 24)
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.phonePad)
                }
            }
            .font(.subheadline)
            .submitLabel(isSecure ? .go : .next)
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    NavigationStack {
        MemberSearchView()
    }
}
