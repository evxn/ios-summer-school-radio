//
//  RadioStation.swift
//  Radio
//
//  Created by evg on 18/08/2019.
//  Copyright © 2019 evgn. All rights reserved.
//

import Foundation

struct RadioStationDto: Codable {
	let id: Int
	let title: String
	let description: String
	let websiteUrl: String
	let imageUrl: String
	let stream: String
}
