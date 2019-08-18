//
//  ViewController.swift
//  Radio
//
//  Created by evg on 15/08/2019.
//  Copyright © 2019 evgn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
	let bag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		BaseService.shared.getRadioStations()
			.asDriver(onErrorJustReturn: [])
			.drive(
				tableView.rx.items(
					cellIdentifier: "DiscoveryItemCell",
					cellType: DiscoveryItemCell.self
				)
			) { index, station, cell in
				cell.titleLable?.text = station.title
				
				cell.thumbnailImageLoadingOverlay.isHidden = false
				BaseService.shared.loadImage(by: station.imageUrl)
					.observeOn(MainScheduler.instance)
					.asSingle()
					.subscribe({ (event) in
						cell.thumbnailImageLoadingOverlay.isHidden = true
						
						switch event {
						case SingleEvent.success(let data):
							cell.thumbnailImage?.image = UIImage.init(data: data)
						case SingleEvent.error:
							// set placeholder image
							cell.thumbnailImage?.image = UIImage(named: "icons8-microphone")
							cell.thumbnailImage?.backgroundColor = UIColor.init(red: 1, green: 0.8, blue: 0, alpha: 1)
						}
					})
					.disposed(by: self.bag)
			}
			.disposed(by: bag)
	}
	

}

