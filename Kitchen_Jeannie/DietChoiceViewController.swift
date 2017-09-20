//
//  DietChoiceViewController.swift
//  Kitchen_Jeannie
//
//  Created by Tanna Brauer on 5/30/17.
//  Copyright © 2017 Tanna Brauer. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import AlamofireImage


class DietChoiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //variables-------------
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var intolerance = [String]()
    var fdtypes = [String]()
    var prefs = [Preference]()
    var dietName: String?
    var recipe = [String]()
    var images = [String]()
    var ingredients = [Fridge]()
//    var recipeId: Int?
//    var sCache: Int?
    var sCache = [Int]()
    
    //Actions---------------------------------------------
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "filterSegue", sender: sender)
    }
    
    //Outlets--------------------------------
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var dietNameLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    
    //view did load-----------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        if let d = dietName {
            dietNameLabel.text = d
            
            callAPI()
        } else {
            callAPI2()
            dietNameLabel?.text = "Searching Recipes"
            if let fb = filterButton {
                fb.isHidden = true
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //prepare for segue----------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "filterSegue") {
            let vc = segue.destination as! PreferencesViewController
            vc.recipeName = dietName
            vc.viewDidLoad()
        } else if (segue.identifier == "recipeDetails") {
            let vc = segue.destination as! RecipeDetailsViewController
            if sender is Int {
                if let s = sender as? Int {
                    vc.recipeTitle = recipe[s]
//                    sCache = s
                    vc.recipeId = sCache[s]
                    vc.recipeImage = images[s]
                    
                }
   
            }
        }
        
    }
    
    //Call Api-------------------------------------------------
    
    func callAPI() {
        var url: URL?
        
        // No Intolerence and No Types
        if intolerance.count == 0 && fdtypes.count == 0 {
            if let d = dietName {
                dietNameLabel.text = d
                if d != "carnivore" {
                    url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?diet=\(d)&number=10")
                    print(url!)
                } else {
                    url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?type=main+course&number=10")
                    print(url!)
                }
            }
            
            
        // Have Intolerences AND types
        } else if intolerance.count != 0 && fdtypes.count != 0 {
            
            if let d = dietName {
                
                dietNameLabel.text = d
                var first = ""
                var second = ""
                
                
                var third = ""
                
                
                var fourth = ""
                var fifth = ""
                
                if d != "carnivore" {
                    for i in intolerance {
                        first += i
                        first += "%2C"
                        third = first.replacingOccurrences(of: " ", with: "+")
                    }
                    let eI = third.index(third.endIndex, offsetBy: -3)
                    second = third.substring(to: eI)

                    
                    for f in fdtypes {
                        third += f
                        third += "%2C"
                        fourth = third.replacingOccurrences(of: " ", with: "+")
                    }
                    
                    let eII = fourth.index(fourth.endIndex, offsetBy: -3)
                    fifth = fourth.substring(to: eII)
                    
                    url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?diet=\(d)&number=10&intolerance=\(second)&type=\(fifth)")
                    print(url!)
                    
                } else {
                    for i in intolerance {
                        first += i
                        first += "%2C"
                    }
                    let endI = first.index(first.endIndex, offsetBy: -3)
                    second = first.substring(to: endI)
                    for f in fdtypes {
                        third += f
                        third += "%2C"
                        fourth = third.replacingOccurrences(of: " ", with: "+")
                    }
                    let endII = fourth.index(fourth.endIndex, offsetBy: -3)
                    fifth = fourth.substring(to: endII)
                    url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?excludeIngredients=tofu&number=10&intolerance=\(second)&type=\(fifth)")
                    print(url!)
       
                    
                }
            }
          
        } else if intolerance.count != 0 && fdtypes.count == 0 {
            
            if let d = dietName {
                dietNameLabel.text = d
                var int = ""
                var shortStr = ""
                
                if d != "carnivore" {
                    for i in intolerance {
                        int += i
                        int += "%2C"
                    }
                    let endN = int.index(int.endIndex, offsetBy: -3)
                    shortStr = int.substring(to: endN)
                    
                    url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?diet=\(d)&number=10&intolerance=\(shortStr)")
                    print(url!)
                } else {
                    for i in intolerance {
                        int += i
                        int += "%2C"
                    }
                    let endM = int.index(int.endIndex, offsetBy: -3)
                    shortStr = int.substring(to: endM)
                    url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search&excludeIngredients=tofu&number=10&intolerance=\(shortStr)")
                    print(url!)
                }
            }
            
            
        } else if intolerance.count == 0 && fdtypes.count != 0 {
            if let d = dietName {
                dietNameLabel.text = d
                var int = ""
                var shortStr = ""
                var newStr = ""
                
                if d != "carnivore" {
                    for i in fdtypes {
                        int += i
                        int += "%2C"
                    }
                    let endO = int.index(int.endIndex, offsetBy: -3)
                    shortStr = int.substring(to: endO)
                    
                    url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search?diet=\(d)&number=10&type=\(shortStr)")
                    print(url!)
                } else {
                    for i in fdtypes {
                        int += i
                        int += "%2C"
                        newStr = int.replacingOccurrences(of: " ", with: "+")
                        
                    }
                    let endP = newStr.index(newStr.endIndex, offsetBy: -3)
                    shortStr = newStr.substring(to: endP)
                    url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search&excludeIngredients=tofu&number=10&type=\(shortStr)")
                    print(url!)
                }
                
            }
            
        }
        
        
        let headers: HTTPHeaders = [
            "X-Mashape-Key": "apikey",
            "Accept": "application/json"
        ]
        Alamofire.request(url!, method: .get, parameters: nil, headers: headers)
            .responseJSON { response in
                
                if let jsonResult = response.result.value as? NSDictionary {
                    
                    if let resultsArr = jsonResult["results"] as? NSArray {
                        
                        for result in resultsArr {
                            
                            if let r = result as? NSDictionary {
                                
                                if let title = r["title"] as? String {
                                    self.recipe.append(title)
                                    
                                    print(title)
                                    if let id = r["id"] as? NSNumber {
                                        let intId = Int(id)
                                        self.sCache.append(intId)
                                        print(id)
                                        
                                    }
                                    if let pic = r["image"] as? String {
                                        let picurl = "https://spoonacular.com/recipeImages/\(pic)"
                                        self.images.append(picurl)
                                    }
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    self.myTableView.reloadData()
                    
                }
                
        }
        
        
        
        
        
    }
    
    func callAPI2(){
        /// Call api!
        
        // specify the url that we will be sending the GET Request to
        
        var ingredientStr = ""
        
        var shortStr = ""
        
        var newStr = ""
        
        let ingredientsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Fridge")
        
        do {
            let results = try context.fetch(ingredientsRequest)
            ingredients = results as! [Fridge]
            for ingredient1 in ingredients {
                ingredientStr += ingredient1.ingredient!
                ingredientStr += "%2C"
                newStr = ingredientStr.replacingOccurrences(of: " ", with: "+")
            }
            let endIndex = newStr.index(newStr.endIndex, offsetBy: -3)
            shortStr = newStr.substring(to: endIndex)
            
            print(shortStr)
        } catch {
            print("\(error)")
        }
        
        
        let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients?fillIngredients=true&ingredients=\(shortStr)&limitLicense=true&number=5&ranking=1")
        
        print(url!)
        
        
        let headers: HTTPHeaders = [
            "X-Mashape-Key": "apikey",
            "Accept": "application/json"
        ]
        
        Alamofire.request(url!, method: .get, parameters: nil, headers: headers)
            .responseJSON { response in
                // Perform action on response
                if let jsonResult = response.result.value as? NSArray {
                    // print(jsonResult[0])
                    
                    for result in jsonResult {
                        if let r = result as? NSDictionary {
                            
                            if let t = r["title"] as? String {
                                print(t)
                                self.recipe.append(t)
                            }
                            if let id = r["id"] as? NSNumber {
                                let intid = Int(id)
                                self.sCache.append(intid)
                            }
                            if let pic = r["image"] as? String {
                                self.images.append(pic)
                            }
                            
                        }
                        DispatchQueue.main.async {
                            self.myTableView.reloadData()
                        }
                    }
                    
                    
                }
                
        }
        
    }
    
    
    
    
    //table views----------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        // if we return - sections we won't have any sections to put our rows in
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchRecipes", for: indexPath) as! DietSearchCell
        // set the default cell label to the corresponding element in the people array
        cell.dietTitleLabel?.text = recipe[indexPath.row]
        let imgURL = NSURL(string: images[indexPath.row])
        cell.dietImageView.af_setImage(withURL: imgURL! as URL)
        // return the cell so that it can be rendered
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "recipeDetails", sender: indexPath.row)
        print(sCache[indexPath.row])
    }


}
