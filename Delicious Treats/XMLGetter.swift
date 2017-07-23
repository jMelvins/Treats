//
//  XMLGetter.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 23.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import Foundation
import AEXML

protocol CustomXMLGetterDelegate {
    func didGetCategory(_ category: ParsedCategory)
    func didGetOffer(_ offer: ParsedOffer)
}

struct ParsedCategory {
    var categoryID: String
    var categoryName: String
}

struct ParsedOffer {
    var name: String
    var price: String
    var description: String
    var pictureURL: String
    var id: String
    var weight: String
}



class XMLGetter{
    
    fileprivate let littleLink = "http://ufa.farfor.ru/getyml/?key=ukAXxeJYZN"
    fileprivate var delegate: CustomXMLGetterDelegate
    
    //To parse the category
    var parsedCategoryArray = [ParsedCategory]()
    var categoryID = ""
    var categoryName = ""
    
    //To parse the offer
    var parsedOffersArray = [ParsedOffer]()
    var offerName = ""
    var offerPrice = ""
    var offerDescription = ""
    var offerPictureURL = ""
    var offerID = ""
    var offerWeight = ""
    
    init(delegate: CustomXMLGetterDelegate) {
        self.delegate = delegate
    }
    
    func performParseFromLink(){
//        guard
//            //let xmlPath = Bundle.main.path(forResource: littleLink, ofType: "xml"),
//            let data = try? Data(contentsOf: URL(string: littleLink)!)
//            else { return }
        
        let session = URLSession.shared
        let requestURL = URL(string: littleLink)!
        
        let dataTask = session.dataTask(with: requestURL as URL) {
            (data: Data?, response: URLResponse?, error: Error?) in

            if error != nil {
                print("Error:\n\(error)")
            }else {
                var options = AEXMLOptions()
                options.parserSettings.shouldProcessNamespaces = false
                options.parserSettings.shouldReportNamespacePrefixes = false
                options.parserSettings.shouldResolveExternalEntities = false
                
                do {
                    let xmlDoc = try? AEXMLDocument(xml: data!, options: options)
                    
                    for categories in (xmlDoc?.root["shop"]["categories"]["category"].all!)! {
                        
                        self.categoryID = categories.attributes["id"]!
                        self.categoryName = categories.value!
                        
                        //Добавление в структуру
                        let newCategory = ParsedCategory(categoryID: self.categoryID, categoryName: self.categoryName)
                        self.delegate.didGetCategory(newCategory)
                        
                        //self.parsedCategoryArray.append(newCategory)
                    }
                    
                    for categories in (xmlDoc?.root["shop"]["offers"]["offer"].all!)! {
                        self.offerName = categories.children[1].value!
                        self.offerPrice = categories.children[2].value!
                        if let desc = categories.children[3].value{
                            self.offerDescription = desc
                        }
                        self.offerPictureURL = categories.children[4].value!
                        self.offerID = categories.children[5].value!
                        self.offerWeight = categories.children[6].value!
                        
                        //Добавление в структуру
                        let newOffer = ParsedOffer(name: self.offerName, price: self.offerPrice, description: self.offerDescription, pictureURL: self.offerPictureURL, id: self.offerID, weight: self.offerWeight)
                        
                        self.delegate.didGetOffer(newOffer)
                        //self.parsedOffersArray.append(newOffer)
                    }
                }
            }
        }
        dataTask.resume()
    }
}
