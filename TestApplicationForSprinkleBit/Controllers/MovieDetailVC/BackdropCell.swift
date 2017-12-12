//
//  BackdropCell.swift
//  TestApplicationForSprinkleBit
//
//  Created by Dennis Ritchie on 12/11/17.
//  Copyright © 2017 Dennis Ritchie. All rights reserved.
//

import UIKit

class BackdropCell: UITableViewCell {
    @IBOutlet weak var backdropImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
