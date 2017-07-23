//
//  CatalogTableViewController.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 21.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import UIKit

class CatalogTableViewController: UITableViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

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

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CatalogTableViewCell
        
        cell?.iconImage.image = UIImage(named: "Test")
        cell?.categoryNameLabel.text = "Category \(indexPath.row + 1)"

        return cell!
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodList" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! FoodListTableViewController
                var passedData = indexPath.row * 50
                controller.someNumber = "\(passedData) RUB"
            }
        }
    }

}
