//
//  AddIngredientViewController.swift
//  Kitchen_Jeannie
//
//  Created by Tanna Brauer on 6/1/17.
//  Copyright © 2017 Tanna Brauer. All rights reserved.
//

import UIKit
import CoreData

class AddIngredientViewController: UIViewController {
//    var addIngredientDel: AddIngredientDelegate?
    var addIngredientDel: AddIngredientDelegate?
    var ingredientToEdit: String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    //outlets
    @IBOutlet weak var ingredientTextField: UITextField!
    
    
    //actions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let newIngredient = NSEntityDescription.insertNewObject(forEntityName: "Fridge", into: context) as! Fridge
        newIngredient.ingredient = ingredientTextField.text!
        
        if context.hasChanges {
            do {
                try context.save()
                print("Success")
                addIngredientDel?.doneAdding()
                dismiss(animated: true, completion: nil)
            } catch {
                print("\(error)")
            }
        }
        dismiss(animated: true, completion: nil)
//        addIngredientDel?.doneAdding()
        
    
    
    
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
