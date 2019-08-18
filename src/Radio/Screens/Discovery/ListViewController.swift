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
			.subscribeOn(MainScheduler.instance)
			.bind(
				to: tableView.rx.items(
					cellIdentifier: "DiscoveryItemCell",
					cellType: DiscoveryItemCell.self
				)
			) { index, station, cell in
//				print(cell.thumbImage!)
//				cell.thumbImage?.image = UIImage(named: "icon8-microphone")
				cell.titleLable?.text = station.title
			}
			.disposed(by: bag)
	}
}

