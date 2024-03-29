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

enum BaseServiceErrors: Error {
	case invalidUrl(urlString: String)
}

class BaseService {
	static let shared = BaseService()
	
	func getRadioStations() -> Observable<[RadioStationDto]> {
		let urlString = "\(NetworkConstants.baseUrl)/stations.json"

		guard let url = URL(string: urlString) else {
			print("Invalid url: \(urlString)")
			return Observable.error(BaseServiceErrors.invalidUrl(urlString: urlString))
		}
		
		let request = URLRequest(url: url)
		return URLSession.shared.rx.data(request: request)
			.map({data in
				do {
					return try JSONDecoder().decode([RadioStationDto].self, from: data)
				} catch let error {
					print("Unable to decode data")
					throw RxCocoaURLError.deserializationError(error: error)
				}
			})
			.share(replay: 1, scope: .whileConnected)
	}
	
	func loadImage(by urlString: String) -> Observable<Data> {
		guard let url = URL(string: urlString) else {
			return  Observable.error(BaseServiceErrors.invalidUrl(urlString: urlString))
		}
		
		let request = URLRequest(url: url)
		
		if let data = URLCache.shared.cachedResponse(for: request)?.data {
			return Observable.just(data)
		} else {
			return URLSession.shared.rx.data(request: request)
				.timeout(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
		}
	}
}
