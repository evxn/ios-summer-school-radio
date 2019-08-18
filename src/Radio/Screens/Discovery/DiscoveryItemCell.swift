//
//  DiscoveryItemViewCell.swift
//  Radio
//
//  Created by evg on 18/08/2019.
//  Copyright © 2019 evgn. All rights reserved.
//

import UIKit

class DiscoveryItemCell: UITableViewCell {
	@IBOutlet weak var titleLable: UILabel!
	@IBOutlet weak var thumbnailImage: UIImageView!
	@IBOutlet weak var thumbnailImageLoadingOverlay: UIView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		UtilsService.shared.setupSpinner(for: thumbnailImageLoadingOverlay)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

}
