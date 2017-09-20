//
//  SearchRecipeViewController.swift
//  Kitchen_Jeannie
//
//  Created by Tanna Brauer on 6/1/17.
//  Copyright © 2017 Tanna Brauer. All rights reserved.
//

import UIKit
import CoreData

class SearchRecipeViewController: UIViewController, AddIngredientDelegate, UITabBarDelegate, UITableViewDataSource {
    
    //variables
    var fridgeContents = [Fridge]()
    var idxCache: Int?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //outlets
    @IBOutlet weak var searchTableView: UITableView!
    
    
    //actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddIngredientButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func searchIngButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "searchIngs", sender: sender)
    }
    
    
    //view did load======================
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFridge()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Table View Functions
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingredients"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fridgeContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        // Set some data
        cell.textLabel?.text = fridgeContents[indexPath.row].ingredient
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Delete
        //        listArr.remove(at: indexPath.row)
        
        context.delete(fridgeContents[indexPath.row])
        
        if context.hasChanges {
            do {
                try context.save()
                print("Success")
                searchTableView.reloadData()
                fetchFridge()
                
                
            } catch {
                print("\(error)")
            }
        }
    }
    
    
    func fetchFridge(){
        print("fetching from core data")
        let ingredientRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Fridge")
        
        do {
            // get the results by executing the fetch request we made earlier
            let results = try context.fetch(ingredientRequest)
            fridgeContents = results as! [Fridge]
            if let tv = searchTableView {
                tv.reloadData()
                
            }
            
        } catch {
            // print the error if it is caught (Swift automatically saves the error in "error")
            print("\(error)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "addIng") {
            let vc = segue.destination as! AddIngredientViewController
            // Adding
            vc.addIngredientDel = self
        } else if (segue.identifier == "searchIngs") {
            let vc = segue.destination as! DietChoiceViewController
            vc.viewDidLoad()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchFridge()
    }
    
    // Protocol functions
    func doneAdding() {
        //        listArr.append(item)
        fetchFridge()
        //        tableView.reloadData()
    }
    
    

}
