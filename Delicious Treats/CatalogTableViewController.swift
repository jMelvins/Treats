 //
//  CatalogTableViewController.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 21.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import UIKit
import CoreData

class CatalogTableViewController: UITableViewController, CustomXMLGetterDelegate {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var parsedOfferStruct = [ParsedOffer]()
    var parsedCategoryStruct = [ParsedCategory]()
    var xmlGetter: XMLGetter!

    var managedObjectContext : NSManagedObjectContext!
    var categoryEntity = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
        let presentRequest:NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        presentRequest.sortDescriptors = [sortDescriptor]
        do{
            self.categoryEntity = try self.managedObjectContext.fetch(presentRequest)
        }catch{
            print("Couldnt load data from database \(error.localizedDescription)")
        }
        
        //Поменять этот метод не на говнокод
        if !categoryEntity.isEmpty{
            writeInCategoryStruct()
        }else {
            xmlGetter = XMLGetter(delegate: self)
            xmlGetter.performParseFromLink()
        }
        
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        print("catalog did disappear")
    }
    
    // MARK: - 
    
    func writeInCategoryStruct(){
        for index in 0...categoryEntity.count-1{
            let tempCat = ParsedCategory(categoryID: categoryEntity[index].id!, categoryName: categoryEntity[index].name!, categoryDate: categoryEntity[index].date! as Date)
            parsedCategoryStruct.append(tempCat)
        }
    }
    
    // MARK: - Image
    // TODO: - Сделать сохранине картинок в CoreData
    
    var imageData = NSData()
    var counter = 0
    func loadImage(_ urlString: String){
        
        let url:URL = URL(string: urlString)!
        let session = URLSession.shared
        
        let task = session.downloadTask(with: url) {
            (Url: URL?, respone: URLResponse?, error: Error?) in
            guard let _:URL = Url, let _:URLResponse = respone, error == nil else {
                print("error")
                return
            }
            
            let imageData = try? Data(contentsOf: Url!)
            self.imageData = imageData! as NSData
            print("\(self.counter) image downloaded")
            self.counter += 1
        }
        task.resume()
    }

    func downloadAndSaveInCoreData(objectToSave: ParsedOffer){
        let entityItem = Offer(context: self.managedObjectContext)
        entityItem.id = objectToSave.id
        entityItem.name = objectToSave.name
        if !objectToSave.description.isEmpty{
            entityItem.desc = objectToSave.description
        }
        entityItem.price = objectToSave.price
        entityItem.weight = objectToSave.weight
        entityItem.url = objectToSave.pictureURL
 
        let url:URL = URL(string: entityItem.url!)!
        let session = URLSession.shared
        
        let task = session.downloadTask(with: url) {
            (Url: URL?, respone: URLResponse?, error: Error?) in
            guard let _:URL = Url, let _:URLResponse = respone, error == nil else {
                print("error")
                return
            }
            
            let imageData = try? Data(contentsOf: Url!)
            entityItem.imageID = imageData as! NSData
            
            print("\(self.counter) image downloaded")
            self.counter += 1
            
            do {
                try self.managedObjectContext.save()
            }catch{
                print("Couldnt save data \(error.localizedDescription)")
            }

        }
        task.resume()

    }
    
    
    // MARK: - XMLGetter
    func didGetOffer(_ offers: [ParsedOffer]) {
        parsedOfferStruct = offers
        
        DispatchQueue.global(qos: .default).async {
            for object in offers{
                self.downloadAndSaveInCoreData(objectToSave: object)
//                let entityItem = Offer(context: self.managedObjectContext)
//                entityItem.id = object.id
//                entityItem.name = object.name
//                if !object.description.isEmpty{
//                    entityItem.desc = object.description
//                }
//                entityItem.price = object.price
//                entityItem.weight = object.weight
//                entityItem.url = object.pictureURL
//                self.loadImage(entityItem.url!)
//                entityItem.imageID = self.imageData
            }
//            do {
//                try self.managedObjectContext.save()
//            }catch{
//                print("Couldnt save data \(error.localizedDescription)")
//            }
        }
        
    }
    
    func didGetCategory(_ categories: [ParsedCategory]) {
        DispatchQueue.main.async {
            self.parsedCategoryStruct = categories
            self.tableView.reloadData()
        }
        
        for object in categories{
            let entityItem = Category(context: managedObjectContext)
            entityItem.id = object.categoryID
            entityItem.name = object.categoryName
            entityItem.date = object.categoryDate as NSDate
        }
        do {
            try managedObjectContext.save()
        }catch{
            print("Couldnt save data \(error.localizedDescription)")
        }
        
    }
    
    func didNotGet(_ error: NSError) {
        print("Error \(error)")
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedCategoryStruct.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CatalogTableViewCell
        
        cell?.iconImage.image = UIImage(named: "\(indexPath.row+1)")
        cell?.categoryNameLabel.text = parsedCategoryStruct[indexPath.row].categoryName

        return cell!
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodList" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let navVC = segue.destination as! UINavigationController
                let controller = navVC.viewControllers.first as! FoodListTableViewController
                //controller.offersArray = parsedOfferStruct
                controller.categoryName = parsedCategoryStruct[indexPath.row].categoryName
                controller.categoryID = parsedCategoryStruct[indexPath.row].categoryID
            }
        }
    }

}
