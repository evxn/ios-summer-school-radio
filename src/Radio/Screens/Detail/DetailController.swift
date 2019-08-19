//
//  DetailController.swift
//  Radio
//
//  Created by evg on 18/08/2019.
//  Copyright © 2019 evgn. All rights reserved.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa
import StreamingKit

class DetailController: UIViewController {
	@IBOutlet weak var coverLoadingOverlay: UIView!
	@IBOutlet weak var cover: UIImageView!
	@IBOutlet weak var playPauseButton: UIImageView!
	@IBOutlet weak var playPauseButtonTap: UITapGestureRecognizer!
		
	let bag = DisposeBag()
	var model: RadioStationDto?
	
	deinit {
//		BaseService.shared.player.stop()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		UtilsService.shared.setupSpinner(for: coverLoadingOverlay)
		
		if let model = model {
			Observable.just(model.title)
				.bind(to: navigationItem.rx.title)
				.disposed(by: bag)
			
			coverLoadingOverlay.isHidden = false
			BaseService.shared.loadImage(by: model.imageUrl)
				.observeOn(MainScheduler.instance)
				.asSingle()
				.subscribe({ (event) in
					self.coverLoadingOverlay.isHidden = true
					
					switch event {
					case SingleEvent.success(let data):
						self.cover?.image = UIImage.init(data: data)
						self.cover?.backgroundColor = UIColor.white
					case SingleEvent.error:
						// set placeholder image
						self.cover?.image = UIImage(named: "icons8-microphone")
						self.cover?.backgroundColor = UIColor.init(red: 1, green: 0.8, blue: 0, alpha: 1)
					}
					
					self.addDropShadow(for: self.cover)
				})
				.disposed(by: bag)
			
			PlayerService.shared.currentlyPlayingId
				.observeOn(MainScheduler.instance)
				.map {id in id == model.id}
				.subscribeOn(MainScheduler.instance)
				.subscribe(onNext: {currentlyPlaying in
					self.playPauseButton.image = UIImage(named: currentlyPlaying ? "icons8-pause" : "icons8-play")
				})
				.disposed(by: bag)
			
			self.playPauseButtonTap.rx.event
				.observeOn(MainScheduler.instance)
				.subscribeOn(MainScheduler.instance)
				.subscribe(onNext: {status in
					PlayerService.shared.togglePlay(by: model.id)
				})
				.disposed(by: bag)
		}
    }
		
//	override func observeValue(forKeyPath keyPath: String?,
//							   of object: Any?,
//							   change: [NSKeyValueChangeKey : Any]?,
//							   context: UnsafeMutableRawPointer?) {
//		// Only handle observations for the playerItemContext
//		guard context == &playerItemContext else {
//			super.observeValue(
//				forKeyPath: keyPath,
//				of: object,
//				change: change,
//				context: context
//			)
//			return
//		}
//
//
//		if keyPath == #keyPath(AVPlayerItem.status) {
//			let status: AVPlayerItem.Status
//			// Get the status change from the change dictionary
//			if let statusNumber = change?[.newKey] as? NSNumber {
//				status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
//			} else {
//				status = AVPlayerItem.Status.unknown
//			}
//
//			// Switch over the status
//			switch status {
//			case AVPlayerItem.Status.readyToPlay:
//				print("AVPlayerItem.readyToPlay")
//			case AVPlayerItem.Status.failed:
//				print("AVPlayerItem.failed")
//			case AVPlayerItem.Status.unknown:
//				print("AVPlayerItem.unknown")
//			}
//		}
//	}
	
	private func addDropShadow(for view: UIView) {
		let shadowPath = UIBezierPath(rect: view.bounds.insetBy(dx: 20.0, dy: 20.0))
		view.layer.shadowPath = shadowPath.cgPath
		view.layer.masksToBounds =  false
		view.layer.shadowColor = UIColor.gray.cgColor;
		view.layer.shadowOffset = CGSize(width: -10, height: -10)
		view.layer.shadowOpacity = 1.0
		view.layer.shadowRadius = 15.0
	}

}
