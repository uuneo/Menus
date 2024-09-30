//
//  AudioManager.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/29.
//

import Foundation
import AVFoundation
import Combine

enum PlayType{
	case playing
	case pause
	case stop
}


class AudioPlayerManager: ObservableObject{
	static let shard = AudioPlayerManager()
	
	private init() {}
	
	
	@Published var musics: [URL]?
	@Published var currentlyPlayingURL: URL?
	@Published var isPlaying:PlayType = .stop
	
	
	private var audioPlayer: AVAudioPlayer?
	private var cancellable: AnyCancellable?
	
	@Published var currentTime: Double = 0
	@Published var totalTime: Double = 0
	

	func getCurrentTime() -> Double{
		guard let audioPlayer else{
			return 0
		}
		return audioPlayer.currentTime
	}
	
	
}


extension AudioPlayerManager{
	func togglePlay(_ audioURL: URL? = nil) {
		switch isPlaying {
		case .playing:
			self.Pause()
		case .pause:
			self.play(audioURL)
		case .stop:
			self.play(audioURL)
		}
		
	}
	
	func nextMusic() {
		if isPlaying != .stop {
			self.stop()
		}
		if let musics {
			// 获取当前播放音乐的索引
			if let currentIndex = musics.firstIndex(where: { $0 == self.currentlyPlayingURL }) {
				// 计算下一首音乐的索引，如果超过音乐列表长度则回到第一个
				let nextIndex = currentIndex + 1 >= musics.count ? 0 : currentIndex + 1
				
				// 设置当前播放的音乐 URL 为下一首音乐
				self.currentlyPlayingURL = musics[nextIndex]
				
				// 调用播放函数播放下一首音乐
				play(self.currentlyPlayingURL)
			}
		}
	}
	
	
	func previousMusic() {
		
		if isPlaying != .stop {
			self.stop()
		}
		
		if let musics {
			// 获取当前播放音乐的索引
			if let currentIndex = musics.firstIndex(where: { $0 == self.currentlyPlayingURL }) {
				// 计算上一首音乐的索引，如果当前是第一首则回到最后一首
				let previousIndex = currentIndex - 1 < 0 ? musics.count - 1 : currentIndex - 1
				
				// 设置当前播放的音乐 URL 为上一首音乐
				self.currentlyPlayingURL = musics[previousIndex]
				
				// 调用播放函数播放上一首音乐
				play( self.currentlyPlayingURL)
			}
		}
	}

	
	func play(_ audioURL: URL? = nil) {
		
		if let audioURL{
			do {
				
				audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
				audioPlayer?.play()
				currentlyPlayingURL = audioURL
				self.isPlaying = .playing
				

			} catch {
	#if DEBUG
				print("playFail: \(error.localizedDescription)")
	#endif
			}
		}else{
			audioPlayer?.play()
			self.isPlaying = .playing
		}
	
		
	}
	
	func Pause(){
		self.audioPlayer?.pause()
		self.isPlaying = .pause
	}

	func stop() {
		audioPlayer?.stop()
		currentlyPlayingURL = nil
		self.isPlaying = .stop
	}
	

}


extension AudioPlayerManager{
	func writeToLibrarySoundsDirectory() {
		// 获取 Library 目录
		guard let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
#if DEBUG
			print("Failed to get Library directory.")
#endif
			
			return
		}
		
		// 创建 /Library/Sounds 目录的路径
		let soundsDirectory = libraryDirectory.appendingPathComponent("Sounds")
		
		// 检查 /Library/Sounds 目录是否存在，如果不存在则创建
		do {
			try FileManager.default.createDirectory(at: soundsDirectory, withIntermediateDirectories: true, attributes: nil)
		} catch {
#if DEBUG
			print("Error creating Sounds directory: \(error)")
#endif
			
			return
		}

	}
	
	/// 将指定文件保存在 Library/Sound，如果存在则覆盖
	func saveSound(url: URL) {
		if  let soundsDirectoryUrl = getSoundsDirectory() {
			let soundUrl = soundsDirectoryUrl.appendingPathComponent(url.lastPathComponent)
			do{
				// 如果文件已存在，先尝试删除
				if FileManager.default.fileExists(atPath: soundUrl.path) {
					try FileManager.default.removeItem(at: soundUrl)
				}
				
				try FileManager.default.copyItem(at: url, to: soundUrl)
			}catch{
#if DEBUG
				print(error)
#endif
				
			}
		}
		
	}
	
	func deleteSound(url: URL) {
		try? FileManager.default.removeItem(at: url)
	}
	
	/// 获取 Library 目录下的 Sounds 文件夹
	/// 如果不存在就创建
	func getSoundsDirectory() -> URL? {
		// 获取音频文件夹路径
		if let soundFolderPath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("Sounds"){
			// 检查文件夹是否存在
			var isDirectory: ObjCBool = false
			if !FileManager.default.fileExists(atPath: soundFolderPath.path, isDirectory: &isDirectory) || !isDirectory.boolValue {
				// 如果文件夹不存在，则创建它
				do {
					try FileManager.default.createDirectory(at: soundFolderPath, withIntermediateDirectories: true, attributes: nil)
#if DEBUG
					print("音频文件夹已创建：\(soundFolderPath)")
#endif
					
				} catch {
#if DEBUG
					print("无法创建音频文件夹：\(error)")
#endif
					
				}
			}
			return soundFolderPath
		}
		return nil
	}
	
	
	func listFilesInDirectory() -> ([ URL],[URL]) {
		let urls:[URL] = {
			var temurl = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) ?? []
			temurl.sort { u1, u2 -> Bool in
				u1.lastPathComponent.localizedStandardCompare(u2.lastPathComponent) == ComparisonResult.orderedAscending
			}
			return temurl
		}()
		
		let customSounds: [URL] = {
			guard let soundsDirectoryUrl = getSoundsDirectory() else{
#if DEBUG
				print("铃声获取失败")
#endif
				
				return []
			}
			
			var urlemp = self.getFilesInDirectory(directory: soundsDirectoryUrl.path(), suffix: "caf")
			urlemp.sort { u1, u2 -> Bool in
				u1.lastPathComponent.localizedStandardCompare(u2.lastPathComponent) == ComparisonResult.orderedAscending
			}
			
			return urlemp
		}()
		
		return (urls,customSounds)
	}
	
	
	/// 返回指定文件夹，指定后缀的文件列表数组
	func getFilesInDirectory(directory: String, suffix: String) -> [URL] {
		let fileManager = FileManager.default
		do {
			let files = try fileManager.contentsOfDirectory(atPath: directory)
			return files.compactMap { file -> URL? in
				if file.hasSuffix(suffix) {
					return URL(fileURLWithPath: directory).appendingPathComponent(file)
				}
				return nil
			}
		} catch {
			return []
		}
	}
}
