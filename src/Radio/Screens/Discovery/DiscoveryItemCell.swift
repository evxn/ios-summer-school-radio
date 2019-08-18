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
	@IBOutlet weak var thumbImage: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
