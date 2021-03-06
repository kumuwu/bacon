//
//  ChildTagCell.swift
//  bacon
//
//  Created by Lizhi Zhang on 11/4/19.
//  Copyright © 2019 nus.CS3217. All rights reserved.
//

import UIKit

class ChildTagCell: UITableViewCell {

    // swiftlint:disable private_outlet
    @IBOutlet weak var childTagLabel: UILabel!
    // swiftlint:enable private_outlet

    var canEdit = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if canEdit {
            return
        }
        if selected {
            childTagLabel.textColor = UIColor.green.withAlphaComponent(0.5)
        } else {
            childTagLabel.textColor = UIColor.black
        }
    }

}
