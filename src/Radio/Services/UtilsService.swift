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
		DispatchQueue.main.async {
			let spinnerView = UIView(frame: containerView.bounds)
			spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
			let indicator = UIActivityIndicatorView(style: .whiteLarge)
			indicator.startAnimating()
			indicator.center = spinnerView.center
			spinnerView.addSubview(indicator)
			containerView.addSubview(spinnerView)
		}
	}
	
	func openViewContoller(
		withIdentifier: String,
		in navigationController: UINavigationController?,
		transform callback: ((_ vc: UIViewController) -> UIViewController)?
	) {
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Radio"))
		let viewController = storyboard.instantiateViewController(withIdentifier: withIdentifier)
		let transform = callback ?? {x in x}
		
		navigationController?.pushViewController(transform(viewController), animated: true)
	}
}
