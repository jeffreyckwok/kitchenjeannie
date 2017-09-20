//
//  PreferencesViewController.swift
//  Kitchen_Jeannie
//
//  Created by Tanna Brauer on 5/30/17.
//  Copyright © 2017 Tanna Brauer. All rights reserved.
//

import UIKit
import CoreData

class PreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var foodType = [Food]()

    var dietPreference = [Preference]()
    var recipeName: String?
    var intoleranceArr = [String]()
    var typeArr = [String]()
    
    
    var prefType = ["breakfast", "main course", "side dish", "dessert", "appetizer", "salad", "soup", "bread", "sauce", "beverage", "drink"]
    
    var preferences = ["gluten", "dairy", "egg", "peanut", "sesame", "soy", "sulfite", "wheat"]
    
    
    //Outlets
    @IBOutlet weak var prefTableView: UITableView!

    
    //actions
    
    @IBAction func recipesButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        for pref in dietPreference {
            
            if pref.checkmark == true {
                intoleranceArr.append(pref.intolerance!)
            }
        }
        for food in foodType {
            if food.checkmark == true {
                typeArr.append(food.type!)
            }
        }
        performSegue(withIdentifier: "doneAndSaved", sender: sender)
        
    }
    
    //reload functions
    func fetchprefs() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Preference")
        do {
            let results = try context.fetch(request)
            dietPreference = results as! [Preference]
            
            addprefs()
            if let tv = prefTableView {
                tv.reloadData()
                
            }
            
            
        } catch {
            print("\(error)")
            
        }
        
        let foodrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        do {
            let results = try context.fetch(foodrequest)
            foodType = results as! [Food]
            
            addtype()
            if let tv = prefTableView {
                tv.reloadData()
                
            }
            
            
        } catch {
            print("\(error)")
            
        }
    }
    
    
    func addtype() {
        if foodType.count < 2 {
            for food in prefType {
                let newType = NSEntityDescription.insertNewObject(forEntityName: "Food", into: context) as! Food
                newType.type = food
                newType.checkmark = false
            }
        }
    }
    func addprefs() {
        
        print("************************")
//        print(recipeName!)
        print(dietPreference.count)
        
        if dietPreference.count < 1 {
            print("+++++++++++++++++++++++++++++++++")
            for pref in preferences {
                
                
                print(pref)
                
                let newPref = NSEntityDescription.insertNewObject(forEntityName: "Preference", into: context) as! Preference
                newPref.intolerance = pref
                newPref.checkmark = false
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                    print("Success")
                    //                    fetchprefs()
                } catch {
                    print("\(error)")
                }
            }
        }
    }
    
    
    //view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchprefs()
//        if let tv = prefTableView {
//            tv.reloadData()
//
//        }
        print(recipeName!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "doneAndSaved") {
            let vc = segue.destination as! DietChoiceViewController
            vc.dietName = recipeName
            vc.intolerance = intoleranceArr
            vc.fdtypes = typeArr
            
            
        }

    }
    
    
    //Tables=====================================================
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Intolerances"
        } else {
            return "Food Type"
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dietPreference.count
        } else {
            return foodType.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefs", for: indexPath) as! PrefCell
        
        if indexPath.section == 0 {
            cell.prefNameLabel?.text = dietPreference[indexPath.row].intolerance
            if dietPreference[indexPath.row].checkmark {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }else {
            cell.prefNameLabel?.text = foodType[indexPath.row].type
            if foodType[indexPath.row].checkmark {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
        }
        
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if indexPath.section == 0 {
                
                if cell.accessoryType == .checkmark {

                    let prefItem = dietPreference[indexPath.row]
                    prefItem.checkmark = false
                    //so if there was a checkmark then we will take it away and change the data to false....
                    
                } else {
                    cell.accessoryType = .checkmark
                    let prefItem = dietPreference[indexPath.row]
                    prefItem.checkmark = true
                }
            } else {
                if cell.accessoryType == .checkmark {

                    let prefItem = foodType[indexPath.row]
                    prefItem.checkmark = false
                    //so if there was a checkmark then we will take it away and change the data to false....
                    
                } else {
                    cell.accessoryType = .checkmark
                    let prefItem = foodType[indexPath.row]
                    prefItem.checkmark = true
                }
                
            }
            
        }
        if context.hasChanges {
            do {
                try context.save()
                print("Success")
                fetchprefs()
            } catch {
                print("\(error)")
            }
        }
    }

}
