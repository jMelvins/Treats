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
    //var parsedCategoryStruct = [ParsedCategory]()
    var xmlGetter: XMLGetter!

    var managedObjectContext : NSManagedObjectContext!
    var categoryEntity = [Category]()
    
    lazy var fetchedCategoryResultsController:
        NSFetchedResultsController<Category> = {
            let fetchRequest = NSFetchRequest<Category>()
            let entity = Category.entity()
            fetchRequest.entity = entity
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchBatchSize = 20
            let fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: self.managedObjectContext,
                sectionNameKeyPath: nil,
                cacheName: "categoryEntity")
            
            fetchedResultsController.delegate = self
            return fetchedResultsController
    }()
    
    deinit {
        fetchedCategoryResultsController.delegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        do {
            try fetchedCategoryResultsController.performFetch()
        } catch {
            print("Error: \(error)")
            //fatalCoreDataError(error)
        }
        
        if !(fetchedCategoryResultsController.fetchedObjects?.isEmpty)! {
            return
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
        return fetchedCategoryResultsController.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CatalogTableViewCell
        
        cell?.iconImage.image = UIImage(named: "Test")
        cell?.categoryNameLabel.text = fetchedCategoryResultsController.object(at: indexPath).name

        return cell!
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodList" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! FoodListTableViewController
                controller.categoryID = fetchedCategoryResultsController.object(at: indexPath).id!
                controller.managedObjectContext = managedObjectContext
            }
        }
    }

}


//Описание слушателя кор даты. Реагирует на любые изменения в ней, следовательно перересовывает tableView
extension CatalogTableViewController: NSFetchedResultsControllerDelegate {
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
                as? CatalogTableViewCell {
                cell.iconImage.image = UIImage(named: "Test")
                cell.categoryNameLabel.text = fetchedCategoryResultsController.object(at: indexPath!).name
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

