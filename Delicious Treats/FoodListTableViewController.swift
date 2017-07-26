//
//  FoodListTableViewController.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 21.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import UIKit
import CoreData

class FoodListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var image = UIImage()
    
    var categoryID = ""
    var categoryName = ""

    var offers = [Offer]()
    var importantOffers = [Offer]()
    
    var managedObjectContext : NSManagedObjectContext!
    lazy var fetchedOfferResultsController:
        NSFetchedResultsController<Offer> = {
            let fetchRequest = NSFetchRequest<Offer>()
            let entity = Offer.entity()
            fetchRequest.entity = entity
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchBatchSize = 20
            let fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: self.managedObjectContext,
                sectionNameKeyPath: nil,
                cacheName: "offerEntity")
            
            fetchedResultsController.delegate = self
            return fetchedResultsController
    }()
    
    deinit {
        fetchedOfferResultsController.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        performFetch()
        
        navigationItem.title = categoryName
        
        print("Category: \(categoryID)")

    }
    
    func backBtn(){
        dismiss(animated: true, completion: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        print("food did disappear")
    }
    
    // MARK: - Prepare
    
    func performFetch(){
        do {
            try fetchedOfferResultsController.performFetch()
        } catch {
            print("Error: \(error)")
            //fatalCoreDataError(error)
        }
        offers = fetchedOfferResultsController.fetchedObjects!
        for object in offers{
            if object.id == categoryID{
                importantOffers.append(object)
            }
        }
        
        
    }


    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return importantOffers.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodList", for: indexPath) as! FoodListTableViewCell
        
        //cell.iconImage.image = nil
        
        cell.offer = importantOffers[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodDescription" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! FoodDiscriptionViewController
                controller.name = importantOffers[indexPath.row].name!
                controller.id = importantOffers[indexPath.row].id!
                controller.desc = importantOffers[indexPath.row].desc!
                controller.price = importantOffers[indexPath.row].price!
                controller.weight = importantOffers[indexPath.row].weight!
                controller.url = importantOffers[indexPath.row].url!
                if let image = importantOffers[indexPath.row].imageID {
                    controller.imageData = image
                    controller.contentMode = UIViewContentMode.scaleAspectFit
                }else {
                    //Если до сих пор картинка не загружена, передаем вопрос
                    let image = UIImagePNGRepresentation(UIImage(named: "question")!)
                    controller.imageData = image! as NSData
                    //content mode для вопроса должен быть таким, чтобы его не растягивало 
                    controller.contentMode = UIViewContentMode.scaleAspectFill
                    controller.imageIsHiden = false
                }
            }
        }
    }

}


extension FoodListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerWillChangeContent")
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            if let cell = tableView.cellForRow(at: indexPath!) {
                importantOffers[(indexPath?.row)!].imageID = fetchedOfferResultsController.object(at: indexPath!).imageID
//                let image = UIImage(data: importantOffers[(indexPath?.row)!].imageID! as Data)
//                cell.iconImage.image = image
//                cell.foodNameLabel.text = importantOffers[(indexPath?.row)!].name
//                cell.weightLabel.text = importantOffers[(indexPath?.row)!].weight
//                cell.costLabel.text = importantOffers[(indexPath?.row)!].price! + " RUB"
                //cell.offer = importantOffers[(indexPath?.row)!]
                
            }
        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        } }
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
}

