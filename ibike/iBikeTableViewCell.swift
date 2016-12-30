//
//  iBikeTableViewCell.swift
//  ibike
//
//  Created by devilcry on 2016/7/29.
//  Copyright © 2016年 devilcry. All rights reserved.
//

import UIKit

class iBikeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var locationLabel:UILabel!
    @IBOutlet weak var rentLabel:UILabel!
    @IBOutlet weak var emptyLabel:UILabel!
    //@IBOutlet weak var mapButton:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
