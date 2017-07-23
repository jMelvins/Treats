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
    var entity = [Entity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let presentRequest:NSFetchRequest<Entity> = Entity.fetchRequest()
        do{
            self.entity = try self.managedObjectContext.fetch(presentRequest)
        }catch{
            print("Couldnt load data from database \(error.localizedDescription)")
        }
        
        if !entity.isEmpty{
            for index in 0...entity.count-1{
                print(entity[index].id!)
                let tempCat = ParsedCategory(categoryID: entity[index].id!, categoryName: entity[index].name!)
                parsedCategoryStruct.append(tempCat)
            }
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        print("catalog did disappear")
    }
    
    // MARK: - XMLGetter
    func didGetOffer(_ offers: [ParsedOffer]) {
        parsedOfferStruct = offers
    }
    
    func didGetCategory(_ categories: [ParsedCategory]) {
        DispatchQueue.main.async {
            self.parsedCategoryStruct = categories
            self.tableView.reloadData()
        }
    }
    
    func didNotGet(_ error: NSError) {
        print("Error \(error)")
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedCategoryStruct.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CatalogTableViewCell
        
        cell?.iconImage.image = UIImage(named: "Test")
        cell?.categoryNameLabel.text = parsedCategoryStruct[indexPath.row].categoryName

        return cell!
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodList" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! FoodListTableViewController
                controller.offersArray = parsedOfferStruct
                controller.categoryID = parsedCategoryStruct[indexPath.row].categoryID
            }
        }
    }

}
