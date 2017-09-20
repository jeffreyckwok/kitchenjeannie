//
//  SavedRecipesViewController.swift
//  Kitchen_Jeannie
//
//  Created by Tanna Brauer on 5/30/17.
//  Copyright © 2017 Tanna Brauer. All rights reserved.
//

import UIKit
import CoreData

class SavedRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //variables
    var sCache: Int?
    var recipeName: String?
    var recipePic: String?
    var recipes = [Recipe]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    //actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //outlets
    @IBOutlet weak var myTableView: UITableView!
    
    
    //when view loads==========================
    override func viewDidAppear(_ animated: Bool) {
        fetchItems()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    //Segues==========================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "displayRecipe") {
            let vc = segue.destination as! RecipeDetailsViewController
            if sender is Int {
                if let s = sender as? Int {
                    vc.recipeTitle = recipes[s].title
                    vc.recipeImage = recipes[s].picture
                    vc.recipeId = Int(recipes[s].id)
                    sCache = s
                }
            }
        }
        
    }
    
    
    
   
    //TableView functions===============
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipes") as! SavedRecipeCell
        let savedRecipe = recipes[indexPath.row]
        cell.recipeTitle?.text = savedRecipe.title!
        let imgURL = NSURL(string: savedRecipe.picture!)
        cell.recipeImage.af_setImage(withURL: imgURL! as URL)
        // return the cell so that it can be
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(recipes[indexPath.row])
        if context.hasChanges {
            do {
                try context.save()
                print("Success")
                fetchItems()
                
            } catch {
                print("\(error)")
            }
        }
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "displayRecipe", sender: indexPath.row)
    }
    
    


}
