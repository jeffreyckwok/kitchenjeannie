//
//  RecipeDetailsViewController.swift
//  Kitchen_Jeannie
//
//  Created by Tanna Brauer on 5/30/17.
//  Copyright © 2017 Tanna Brauer. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import AlamofireImage

class RecipeDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recipes = [Recipe]()
    var recipeTitle: String?
    var recipeId: Int?
    var recipeSteps = [String]()
    var ingredients = [String]()
    var recipeImage: String?
    
    //actions
    @IBAction func recipesButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        fetchItems()
        let newRecipeSaved = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: context) as! Recipe
        newRecipeSaved.id = Int32(recipeId!)
        newRecipeSaved.title = recipeTitle
        newRecipeSaved.picture = recipeImage
        if context.hasChanges {
            do {
                try context.save()
                print("Success")
                performSegue(withIdentifier: "saveRecipe", sender: sender)
            } catch {
                print("\(error)")
            }
        }
        
        
    }
    
    //Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 140
        recipeTitleLabel.text = recipeTitle
        getPicture()
        callAPI()
        callAPI2()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Segues=============================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "saveRecipe") {
            let vc = segue.destination as! SavedRecipesViewController
            vc.recipeName = recipeTitle
            vc.recipePic = recipeImage
            vc.sCache = recipeId
         
        }
//        else if (segue.identifier == "backtoMain") {
//            let vc = segue.destination as! KitchenJeannieViewController
//            vc.viewDidLoad()
//        }
    }
    
    

    //fetchFunction==========
    func fetchItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        do {
            let results = try context.fetch(request)
            recipes = results as! [Recipe]
            myTableView.reloadData()
            
        } catch {
            print("\(error)")
            
        }
    }
    
    
    
    
    //Call Api===========================================
    
    func getPicture() {
        let imgURL = NSURL(string: recipeImage!)
        recipeImageView.af_setImage(withURL: imgURL! as URL)
    }
    
    func callAPI() {
        var url: URL?
        url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(recipeId!)/analyzedInstructions")
        print(url ?? "nil")
        
        let headers: HTTPHeaders = [
            "X-Mashape-Key": "NIDNT5lgrumshEiE5SArMD1vzfBRp1BS8BpjsnKVl5gyah0rQF",
            "Accept": "application/json"
        ]
        Alamofire.request(url!, method: .get, parameters: nil, headers: headers)
            .responseJSON { response in
                if let jsonResult = response.result.value as? NSArray {
                    print(jsonResult)
                    for result in jsonResult {
                        if let r = result as? NSDictionary {
                            if let s = r["steps"] as? NSArray {
                                
                                for step in s {
                                    
                                    if let oneStep = step as? NSDictionary {
                                        
                                        //print("Step# \(oneStep["number"]!) ---- \(oneStep["step"]!)")
                                        let eachStep = "Step# \(oneStep["number"]!) - \(oneStep["step"]!)"
                                        self.recipeSteps.append(eachStep)
                                    }
                                    
                                    
                                }
                            }
                        }
                        //print(self.recipeSteps)
                        DispatchQueue.main.async {
                            self.myTableView.reloadData()
                        }
                    }
                }
        }
        
        
    }
    
    func callAPI2() {
        var url: URL?
        url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/\(recipeId!)/information?includeNutrition=true")
        print(url ?? "nil")
        
        let headers: HTTPHeaders = [
            "X-Mashape-Key": "NIDNT5lgrumshEiE5SArMD1vzfBRp1BS8BpjsnKVl5gyah0rQF",
            "Accept": "application/json"
        ]
        Alamofire.request(url!, method: .get, parameters: nil, headers: headers)
            .responseJSON { response in
                if let jsonResult = response.result.value as? NSDictionary {
                    
                    if let result = jsonResult["extendedIngredients"] as? NSArray {
                        
                        for r in result {
                            
                            if let ing = r as? NSDictionary {
                                
                                if let os = ing["originalString"] as? String {
                                    self.ingredients.append(os)
                                    print("==============")
                                    print(os)
                                }
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                        }
                    }
                }
    }
    
    //TABLES==========================
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Ingredients"
        } else {
            return "Directions"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return ingredients.count
        } else {
            return recipeSteps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeDetails", for: indexPath) as! RecipeDetailCell
        // set the default cell label to the corresponding element in the people array
        if indexPath.section == 0 {
            cell.detailLabelText?.text = ingredients[indexPath.row]
        } else {
            cell.detailLabelText?.text = recipeSteps[indexPath.row]
        }
        // return the cell so that it can be rendered
        return cell
    }

    


}
