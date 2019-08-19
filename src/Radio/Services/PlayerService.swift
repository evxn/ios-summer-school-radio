//
//  BaseService.swift
//  Radio
//
//  Created by evg on 18/08/2019.
//  Copyright © 2019 evgn. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AVKit
import StreamingKit
import RxSwiftExt

class PlayerService {
	static let shared = PlayerService()
	
	let currentlyPlayingId: Observable<Int?>;
	
	private let player: STKAudioPlayer
	private let bag = DisposeBag()
	private let toggleIdSubject = ReplaySubject<Int>.create(bufferSize: 1)
	
	
	init() {
		var options = STKAudioPlayerOptions()
		options.bufferSizeInSeconds = 3
		let player = STKAudioPlayer(options: options)
		
		let currentlyPlayingId_ = BehaviorSubject<Int?>(value: nil)
		let currentlyPlayingId = currentlyPlayingId_.asObservable()
		
		let playerStatus = player.rx
			.observe(STKAudioPlayerState.self, #keyPath(STKAudioPlayer.state))
			.unwrap()
		
		let toggleId = toggleIdSubject.asObservable()
		
		toggleId
			.flatMapLatest { id in
				BaseService.shared.getRadioStations()
					.observeOn(MainScheduler.instance)
					.map {list in list.first {$0.id == id}}
					.unwrap()
					.map {$0.stream}
					.map {urlToPlay in (id, urlToPlay)}
			}
			.withLatestFrom(currentlyPlayingId, resultSelector: {arg0, currentlyPlayingId -> (Int, String, Int?) in
				let (toggleId, urlToPlay) = arg0
				return (toggleId, urlToPlay, currentlyPlayingId)
			})
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: { arg0 in
				let (toggleId, urlToPlay, currentlyPlayingId) = arg0
				if currentlyPlayingId == toggleId {
					player.stop()
				} else {
					player.play(urlToPlay)
				}
			})
			.disposed(by: bag)
		
		playerStatus
			.observeOn(MainScheduler.instance)
			.withLatestFrom(
				toggleId,
				resultSelector: { playerStatus, toggleId in (playerStatus, toggleId) }
			)
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: { arg0 in
				let (playerStatus, toggleId) = arg0
				
				switch playerStatus {
				case STKAudioPlayerState.paused,
					 STKAudioPlayerState.stopped,
					 STKAudioPlayerState.disposed,
					 STKAudioPlayerState.error:
					currentlyPlayingId_.onNext(nil)
				case STKAudioPlayerState.playing,
					 STKAudioPlayerState.buffering,
					 STKAudioPlayerState.running:
					currentlyPlayingId_.onNext(toggleId)
				default:
					print("Unknown value: \(playerStatus)")
				}
			})
			.disposed(by: bag)
		
			
		self.currentlyPlayingId = currentlyPlayingId
		self.player = player
	}
	
	func togglePlay(by id: Int) {
		self.toggleIdSubject.onNext(id)
	}

}
