//
//  GiftHomeView.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/10/24.
//

import Alamofire
import Defaults
import RealmSwift
import SwiftUI
import SwiftyJSON

extension Defaults.Keys {
    static let giftsNew = Key<[String: VipInfo]>("gistNewList", default: [:])
}

/// 服务器端礼物领取记录
struct GiftClaimRecord: Identifiable, Decodable {
    let id: UInt
    let phone: String
    let name: String
    let cardLevel: String
    let balance: Int
    let cardID: String
    let cardType: String
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID", phone, name, balance
        case cardLevel = "cardLevel"
        case cardID = "cardID"
        case cardType = "cardType"
        case createdAt = "CreatedAt"
    }
}

struct GiftHomeView: View {
    @State private var searchText: String = ""
    @FocusState private var phoneFocus
    @State private var viplist: [VipInfo] = []
    @State private var claims: [GiftClaimRecord] = []
    @State private var claimingPhone: String?
    @Default(.defaultHome) var defaultHome
    @State private var showGifts = false

    private var claimedPhones: Set<String> {
        Set(claims.map(\.phone))
    }

    private var claimsYear: Int { VipInfoRealmMode.YEAR() }

    @State private var searchLoading: Bool = false

    @ObservedResults(
        VipInfoRealmMode.self,
        sortDescriptor: SortDescriptor(
            keyPath: \VipInfoRealmMode.createDate,
            ascending: false
        )
    ) var vipGiftlist

    var background: Color {
        let diskBool = claimedPhones.contains(searchText)

        let lingCount = viplist.filter { item in
            claimedPhones.contains(item.phone)
        }.count
        if diskBool {
            return lingCount == viplist.count ? .red : .yellow
        } else {
            switch lingCount {
            case 0:
                return .green
            case viplist.count:
                return .red
            default:
                return .yellow
            }
        }
    }

    var titlegift: String {
        let diskBool = claims.contains { $0.phone == searchText }

        let lingCount = viplist.filter { item in
            claims.contains { $0.phone == item.phone }
        }.count
        if diskBool {
            return lingCount == viplist.count ? "已领" : "部分"
        } else {
            if viplist.count == 0 {
                return "礼品领取"
            } else {
                switch lingCount {
                case 0:
                    return "未领"
                case viplist.count:
                    return "已领"
                default:
                    return "部分"
                }
            }
        }
    }

    @State private var showGiftList: Bool = false

    var body: some View {
        ZStack {
            Text(titlegift)
                .font(.system(size: 600).bold())
                .minimumScaleFactor(0.5)

            VStack {
                Spacer()
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        ForEach(viplist, id: \.id) { item in
                            VipListView(item: item)
                                .frame(width: 340)
                                .scrollTransition { content, phase in
                                    content.scaleEffect(phase.isIdentity ? 1 : 0.9)
                                        .opacity(phase.isIdentity ? 1 : 0.5)
                                }
                        }
                    }
                    .padding(.horizontal)
                }

                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
            }

            VStack(alignment: .leading) {
                HStack {
                    Text("查询结果:")
                        .foregroundStyle(.gray)
                    Text(viplist.count == 0 ? "没有结果" : "查询到\(viplist.count)个结果")
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)

                HStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .frame(width: 600, height: 100)
                        .overlay {
                            TextField("输入手机号码搜索", text: $searchText)
                                .font(.largeTitle)
                                .padding(.leading, 80)
                                .disabled(searchLoading)
                                .focused($phoneFocus)
                                .submitLabel(.search)
                                .onSubmit {
                                    self.getVipList(search: searchText)
                                    self.phoneFocus = false
                                }
                        }
                        .overlay {
                            HStack {
                                Image(systemName: searchLoading ? "hourglass.circle.fill" : "phone")
                                    .font(.largeTitle)
                                    .padding(.horizontal)
                                    .symbolEffect(.pulse, isActive: searchLoading)

                                Spacer()
                                if searchLoading {
                                    ProgressView()
                                        .controlSize(.large)
                                        .padding(.trailing, 12)
                                } else if searchText.count > 0 {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.secondary)
                                        .padding(.trailing)
                                        .onTapGesture {
                                            withAnimation {
                                                self.searchText = ""
                                                self.viplist = []
                                            }
                                        }
                                }
                            }
                        }
                        .overlay(alignment: .bottom) {
                            if searchLoading {
                                HStack(spacing: 6) {
                                    ProgressView().scaleEffect(0.7)
                                    Text("正在查询…")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(.black.opacity(0.6)))
                                .offset(y: 18)
                            }
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 20))
                }
            }.offset(y: -130)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        peacock.shared.page = defaultHome
                    }
                } label: {
                    Image(systemName: "xmark")
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }

            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.showGiftList.toggle()
                } label: {
                    Image(systemName: "pencil.and.list.clipboard")
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
        }
        .ignoresSafeArea()
        .background(background)
        .sheet(isPresented: $showGiftList) {
            NavigationStack {
                List {
                    ForEach(claims) { value in
                        HStack {
                            Text(value.phone)
                            Spacer()
                            Text(value.name)

                            Text(verbatim: "-")

                            Text(value.cardLevel)
                            Spacer()
                            Text(claimDate(value.createdAt))
                        }
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 10)
                        .font(.title2)
                    }
                }
                .navigationTitle("领取列表")
                .toolbar {
                    if claims.count > 0 {
                        ToolbarItem {
                            Text("\(claims.count)")
                                .padding(.horizontal)
                                .contentShape(Rectangle())
                        }
                    }
                }
            }
        }
        .onAppear { Task { await loadClaims() } }
    }

    @ViewBuilder
    func VipListView(item: VipInfo) -> some View {
        let success = claimedPhones.contains(item.phone)
        let claiming = claimingPhone == item.phone
        GiftMemberCard(
            item: item,
            success: success,
            claiming: claiming,
            onClaim: { Task { await claimGift(item: item) } }
        )
        .id(item.phone)
    }

    func getVipList(search: String) {
        // 统一走会员服务器认证接口, 不再单独配置地址/key
        guard MemberAuth.shared.isLoggedIn else {
            searchLoading = false
            peacock.shared.toast("请先登录", mode: .error)
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(MemberAuth.shared.token)"
        ]
        searchLoading = true

        AF.request(
            MemberAuth.shared.baseURL + "/ios/gift",
            method: .get,
            parameters: ["text": search, "page": 1],
            headers: headers
        ).response { response in
            switch response.result {
            case .success(let result):
                if let result = result, let json = try? JSON(data: result) {
                    self.viplist = dataHandler(data: json)
                    // 搜索结果出来后同步一次领取状态
                    Task { await loadClaims() }
                }

            case .failure(let err):
                debugPrint(err.localizedDescription)
            }

            self.searchLoading = false
        }
    }

    private func authHeaders() -> HTTPHeaders {
        ["Authorization": "Bearer \(MemberAuth.shared.token)"]
    }

    /// 加载当年已领取记录; 首次同时迁移本地旧记录并删除
    private func loadClaims() async {
        guard MemberAuth.shared.isLoggedIn else { return }
        let (list, _, _, _): ([GiftClaimRecord], Int?, Int?, Int?) = await memberFetchAsync(
            "/ios/gifts",
            parameters: ["year": String(claimsYear)]
        )
        claims = list
        await migrateLocalClaims()
    }

    /// 本地历史领取记录批量上传, 成功后删除本地数据
    private func migrateLocalClaims() async {
        let local = vipGiftlist.filter { $0.year == claimsYear }
        guard !local.isEmpty else { return }
        let items = local.map {
            [
                "phone": $0.phone,
                "name": $0.name,
                "cardLevel": $0.cardLevel,
                "balance": $0.balance,
                "cardID": $0.cardID,
                "cardType": $0.cardType,
            ] as [String: Any]
        }
        let url = MemberAuth.shared.baseURL + "/ios/gift/batch"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(MemberAuth.shared.token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["items": items])
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                let phones = Set(local.map(\.phone))
                let toDelete = Array(vipGiftlist.filter { phones.contains($0.phone) })
                if let realm = toDelete.first?.realm {
                    try? realm.write {
                        realm.delete(toDelete)
                    }
                }
            }
        } catch {
            debugPrint(error)
        }
    }

    /// 原子领取: 服务端按(手机号,年)唯一约束, 返回 claimed=true 表示已领过
    private func claimGift(item: VipInfo) async {
        claimingPhone = item.phone
        defer { claimingPhone = nil }
        let url = MemberAuth.shared.baseURL + "/ios/gift"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(MemberAuth.shared.token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "phone": item.phone,
            "name": item.name,
            "cardLevel": item.cardLevel,
            "balance": item.balance,
            "cardID": item.cardID,
            "cardType": item.cardType,
        ])
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                peacock.shared.toast("领取失败, 请重试", mode: .error)
                return
            }
            struct ClaimResult: Decodable { let claimed: Bool? }
            if let result = try? JSONDecoder().decode(ClaimResult.self, from: data) {
                await loadClaims()
                if result.claimed == true {
                    peacock.shared.toast("已领取过", mode: .light)
                } else {
                    peacock.shared.toast("🎁 领取成功", mode: .success)
                }
            }
        } catch {
            debugPrint(error)
            peacock.shared.toast("网络异常, 请重试", mode: .error)
        }
    }

    private func claimDate(_ iso: String?) -> String {
        guard let iso, let date = isoDateFormatter.date(from: iso) else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }

    func dataHandler(data: JSON) -> [VipInfo] {
        //		debugPrint(data["data"]["data"])

        let vipList = data["data"]["data"]

        var result: [VipInfo] = []

        for (_, item) in vipList {
            let balance = item["info"]["balance"].rawValue as? Int ?? 0
            let cardLevel = item["cardLevel"].rawValue as? String ?? ""
            let name = item["name"].rawValue as? String ?? ""
            let cardID = item["card"].rawValue as? String ?? ""
            let cardType = item["cardType"].rawValue as? String ?? ""
            let phone = item["phone"].rawValue as? String ?? ""
            debugPrint(item)
            if cardType == "4" || cardType == "8" || cardType == "11", phone != "" {
                result
                    .append(
                        VipInfo(
                            name: name,
                            cardLevel: cardLevel,
                            balance: balance,
                            cardID: cardID,
                            cardType: cardType,
                            phone: phone,
                            date: vipGiftlist.first(where: { $0.phone == phone })?.createDate
                        )
                    )
            }
        }

        return result
    }

    func createDate(_ date: Date?) -> String {
        var date2: Date { date ?? Date() }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date2)
    }
}

struct VipInfo: Codable, Defaults.Serializable {
    var id: String = UUID().uuidString
    var name: String
    var cardLevel: String
    var balance: Int
    var cardID: String
    var cardType: String
    var phone: String
    var date: Date?
    var isGift: Bool = false
}

/// 礼品会员卡: 会员信息 + 领取按钮, 领取成功打勾动画
struct GiftMemberCard: View {
    let item: VipInfo
    let success: Bool
    let claiming: Bool
    let onClaim: () -> Void

    @State private var checkScale: CGFloat = 0.1
    @State private var cardScale: CGFloat = 1

    var body: some View {
        VStack(spacing: 0) {
            // 顶部: 等级 + 手机号
            HStack(alignment: .firstTextBaseline) {
                Text(item.cardLevel)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                Spacer()
                Text(item.phone)
                    .font(.title3.bold())
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.top, 16)

            // 会员姓名
            HStack {
                Text("会员姓名")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
                Spacer()
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 18)
            .padding(.top, 10)

            // 卡号
            HStack {
                Text("卡号")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
                Spacer()
                Text(item.cardID)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 18)
            .padding(.top, 6)
            .padding(.bottom, 14)

            // 领取按钮
            Button(action: onClaim) {
                HStack(spacing: 8) {
                    if claiming {
                        ProgressView().tint(.white)
                    } else if success {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .scaleEffect(checkScale)
                        Text("已领取")
                            .font(.headline)
                    } else {
                        Image(systemName: "gift.fill")
                            .font(.headline)
                        Text("点击领取")
                            .font(.title3.bold())
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
            }
            .buttonStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(success ? Color.green.opacity(0.55) : Color.white)
            )
            .foregroundStyle(success ? .white : Palette.blueDeep)
            .disabled(success || claiming)
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(
            LinearGradient(
                colors: success
                    ? [Color(hex: "2ECC87"), Color(hex: "1FA06C")]
                    : [Palette.blue, Palette.blueDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: (success ? Color.green : Palette.blueDeep).opacity(0.35),
                radius: 12, y: 8)
        .scaleEffect(cardScale)
        .animation(.spring(response: 0.35, dampingFraction: 0.6), value: cardScale)
        .onChange(of: success) { _, isSuccess in
            if isSuccess {
                // 成功: 卡片弹一下 + 打勾弹入
                cardScale = 1.06
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    cardScale = 1
                }
                withAnimation(.spring(response: 0.4, dampingFraction: 0.45)) {
                    checkScale = 1
                }
            } else {
                checkScale = 0.1
            }
        }
    }
}

#Preview {
    GiftHomeView()
        .ignoresSafeArea()
}
