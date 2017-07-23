//
//  CatalogTableViewCell.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 21.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //imageIcon.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
