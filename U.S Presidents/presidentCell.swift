//
//  presidentCell.swift
//  U.S Presidents
//
//  Created by Vanessa Aguilar on 11/17/20.
//  Copyright © 2020 Personal Team. All rights reserved.
//

import UIKit

class presidentCell: UITableViewCell {

    @IBOutlet weak var presidentImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
