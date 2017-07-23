//
//  TestViewController.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 23.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, CustomXMLGetterDelegate {
    
    var something: XMLGetter!
    var name: String = ""
    var desc: String = ""
    var cat: String = ""
    var catID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("start")
        something = XMLGetter(delegate: self)
        
        something.performParseFromLink()
        
        
        print("end")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didGetOffer(_ offer: ParsedOffer) {
        DispatchQueue.main.async {
            self.name = offer.name
            self.desc = offer.id
        }
        print("\(name) and \(desc)")
    }
    
    func didGetCategory(_ category: ParsedCategory) {
        DispatchQueue.main.async {
            self.catID = category.categoryID
            self.cat = category.categoryName
        }
        print("\(catID) \(cat)")
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
