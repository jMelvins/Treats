//
//  FoodListTableViewController.swift
//  Delicious Treats
//
//  Created by Vladislav Shilov on 21.07.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import UIKit

class FoodListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var someNumber = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        print("food did disappear")
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodList", for: indexPath) as! FoodListTableViewCell

        if indexPath.row == 0{
            cell.foodNameLabel.text = "1231231"
        }
        
        cell.iconImage.image = UIImage(named: "Test")
        cell.foodNameLabel.text = "Говядина чили 30см"
        cell.weightLabel.text = "Weight: 610.00 гр"
        cell.costLabel.text = "Cost: \(someNumber)."

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodDescription" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! FoodDiscriptionViewController
                controller.indexPath = "\(indexPath.row)"
            }
        }
    }

}
