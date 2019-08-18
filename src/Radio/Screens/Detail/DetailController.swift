//
//  DetailController.swift
//  Radio
//
//  Created by evg on 18/08/2019.
//  Copyright © 2019 evgn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailController: UIViewController {
	@IBOutlet weak var coverLoadingOverlay: UIView!
	@IBOutlet weak var cover: UIImageView!
	
	let bag = DisposeBag()
	var model: RadioStationDto?
		
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
				.disposed(by: self.bag)
			
		}
		
    }
	
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
