//
//  FoodListTableViewCell.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 21.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import UIKit

class FoodListTableViewCell: UITableViewCell {
    
    var offer: Offer! {
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        foodNameLabel.text = offer.name
        weightLabel.text = offer.weight
        costLabel.text = offer.price! + " RUB"
        
        
        if offer.imageID == nil{
            iconImage.image = UIImage(named: "question")
            if let thumbnailURL = URL(string: offer.url!){
                let newtworkServise = NetworkService(url: thumbnailURL)
                newtworkServise.downloadImage({ (imageData) in
                    let image = UIImage(data: imageData as Data)
                    print("image downloaded")
                    DispatchQueue.main.async {
                        self.iconImage.image = image
                    }
                    
                })
            }
        }else {
            iconImage.image = UIImage(data: offer.imageID! as Data)
        }
        

    }

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
