//
//  FoodListTableViewController.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 21.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import UIKit
import CoreData
import moa

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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FoodListTableViewController.backBtn))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .done, target: self, action: #selector(FoodListTableViewController.backBtn))

        
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        performFetch()
        
        navigationItem.title = categoryName
        
        print(categoryID)

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

        //cell.iconImage.image = UIImage(named: "Test")
        
        cell.iconImage.image = nil
//        
//        if let imageFromDataBase = fetchedOfferResultsController.object(at: indexPath).imageID{
//            cell.iconImage.image = UIImage(data: imageFromDataBase as Data)
//            print("Image loaded from database.")
//        }else{
//            //cell.iconImage.moa.errorImage  = UIImage(named: "Test")
//            //cell.iconImage.moa.url = importantOffers[indexPath.row].url
//            getImage(indexPath: indexPath, cell: cell)
//            print("Start download image.")
//        }
        
        //cell.iconImage.moa.errorImage  = UIImage(named: "Test")
        //cell.iconImage.moa.url = importantOffers[indexPath.row].url
        
        if importantOffers[indexPath.row].imageID != nil{
            cell.iconImage.image = UIImage(data: importantOffers[indexPath.row].imageID! as Data)
        }else {
            cell.iconImage.image = UIImage(named: "question")
        }
        cell.foodNameLabel.text = importantOffers[indexPath.row].name
        cell.weightLabel.text = importantOffers[indexPath.row].weight
        cell.costLabel.text = importantOffers[indexPath.row].price! + " RUB"

        return cell
    }
    
    func saveImageInCoreData(from data: Data) {
        let entityItem = Offer(context: managedObjectContext)
        entityItem.imageID = data as NSData?
        
        do {
            try self.managedObjectContext.save()
            print("image save")
        }catch{
            print("Couldnt save data \(error.localizedDescription)")
        }

    }
    
    func getImage(indexPath: IndexPath, cell: FoodListTableViewCell){
        let session = URLSession.shared
        
        let weatherRequestURL = URL(string: importantOffers[indexPath.row].url!)
        
        let dataTask = session.dataTask(with: weatherRequestURL!) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
                //self.delegate.didNotGetWeather(networkError as NSError)
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                do {
                    self.saveImageInCoreData(from: data!)
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data!)!
                        cell.iconImage.image = self.image
                    }
                }
            }
        }
        
        dataTask.resume()
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
                    //content mode для вопроса должен быть таким, чтобы его не ратягивало 
                    controller.contentMode = UIViewContentMode.scaleAspectFill
                    controller.imageIsHiden = false
                }
            }
        }
    }

}


//Описание слушателя кор даты. Реагирует на любые изменения в ней, следовательно перересовывает tableView
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
            if let cell = tableView.cellForRow(at: indexPath!)
                as? FoodListTableViewCell {
                importantOffers[(indexPath?.row)!].imageID = fetchedOfferResultsController.object(at: indexPath!).imageID
                let image = UIImage(data: importantOffers[(indexPath?.row)!].imageID! as Data)
                cell.iconImage.image = image
                cell.foodNameLabel.text = importantOffers[(indexPath?.row)!].name
                cell.weightLabel.text = importantOffers[(indexPath?.row)!].weight
                cell.costLabel.text = importantOffers[(indexPath?.row)!].price! + " RUB"
            }
        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        } }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (section)")
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (section)")
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (section)")
        case .move:
            print("*** NSFetchedResultsChangeMove (section)")
        }
    }
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
}

