//
//  UtilsService.swift
//  Radio
//
//  Created by evg on 18/08/2019.
//  Copyright © 2019 evgn. All rights reserved.
//

import UIKit

class UtilsService {
	static let shared = UtilsService()
	
	func setupSpinner(for containerView: UIView) {
		let spinnerView = UIView.init(frame: containerView.bounds)
		spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
		let indicator = UIActivityIndicatorView.init(style: .whiteLarge)
		indicator.startAnimating()
		indicator.center = spinnerView.center
		spinnerView.addSubview(indicator)
		containerView.addSubview(spinnerView)
	}
}
