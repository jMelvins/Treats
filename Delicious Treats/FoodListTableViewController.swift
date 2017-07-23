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
    
    var offersArray = [ParsedOffer]()
    var importantOffers = [ParsedOffer]()
    var categoryID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        print(categoryID)
        prepareForDisplay(the: offersArray)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        print("food did disappear")
    }
    
    // MARK: -
    
    func prepareForDisplay(the data: [ParsedOffer]){
        for object in data{
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

        cell.iconImage.image = UIImage(named: "Test")
        cell.foodNameLabel.text = importantOffers[indexPath.row].name
        cell.weightLabel.text = importantOffers[indexPath.row].weight
        cell.costLabel.text = importantOffers[indexPath.row].price + " RUB"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodDescription" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! FoodDiscriptionViewController
                controller.indexPath = importantOffers[indexPath.row].id
            }
        }
    }

}
