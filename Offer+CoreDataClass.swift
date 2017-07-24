//
//  Offer+CoreDataClass.swift
//  
//
//  Created by Vladislav Shilov on 24.07.17.
//
//

import Foundation
import CoreData

@objc(Offer)
public class Offer: NSManagedObject {
    
    //MARK: - Work with photo
    
    var hasPhoto: Bool {
        return imageID != nil
    }
    
    var imageURL: URL {
        //This property computes the full URL to the JPEG file for the photo. Recall that iOS uses URLs to refer to files, even those saved on the local device instead of on the internet.
        assert(imageID != nil, "No photo ID set")
        let filename = "Photo-\(photoID!.intValue).jpg"
        //get the URL to that directory
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        //returns a UIImage object by loading the image file
        return UIImage(contentsOfFile: imageURL.path)
    }
    
    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID")
        userDefaults.set(currentID + 1, forKey: "PhotoID")
        userDefaults.synchronize()
        return currentID
    }
        
}
