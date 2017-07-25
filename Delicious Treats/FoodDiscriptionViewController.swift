//
//  FoodDiscriptionViewController.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 21.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import UIKit

class FoodDiscriptionViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var indexPathLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    var name = ""
    var id = ""
    var desc = ""
    var price = ""
    var weight = ""
    var url = ""
    var imageData = NSData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        let image = UIImage(data: imageData as Data)
        iconImage.image = image
        indexPathLabel.text = name + "  " + id + "  " + desc + "  " + price + "  " + weight + "  " + url
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        print("desription did disappear")
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        print("tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
