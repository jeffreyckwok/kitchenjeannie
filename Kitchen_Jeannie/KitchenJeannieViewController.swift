//
//  ViewController.swift
//  Kitchen_Jeannie
//
//  Created by Tanna Brauer on 5/29/17.
//  Copyright © 2017 Tanna Brauer. All rights reserved.
//

import UIKit

class KitchenJeannieViewController: UIViewController {

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    //Outlets
    @IBOutlet weak var VeganLabel: UIButton!
    @IBOutlet weak var vegetarianLabel: UIButton!
    @IBOutlet weak var pescetarianLabel: UIButton!
    @IBOutlet weak var carnivoreLabel: UIButton!
 
    //Actions
    @IBAction func DietChoiceButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "dietSegue", sender: sender)
        
    }
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "searchView", sender: sender)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "dietSegue") {
            let s = sender as! UIButton
            let vc = segue.destination as! DietChoiceViewController
            if s.tag == 1 {
                vc.dietName = VeganLabel.currentTitle
            } else if s.tag == 2 {
                vc.dietName = vegetarianLabel.currentTitle
            } else if s.tag == 3 {
                vc.dietName = pescetarianLabel.currentTitle
            } else if s.tag == 4 {
                vc.dietName = carnivoreLabel.currentTitle
            }
            
        } else if (segue.identifier == "searchView") {
            let vc = segue.destination as! SearchRecipeViewController
            vc.viewDidLoad()
        }

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        widthConstraint.constant = self.view.frame.width / 2
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

