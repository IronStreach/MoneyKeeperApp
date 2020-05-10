//
//  CreateExpenses.swift
//  MoneyKeeper
//
//  Created by Станислав Никишков on 07.05.2020.
//  Copyright © 2020 Станислав Никишков. All rights reserved.
//

import UIKit

class CreateExpenses: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var nameOfExp: UITextField!
    @IBOutlet weak var summOfExp: UITextField!
    @IBOutlet weak var priorityOfExp: UITextField!
    @IBAction func changePriority(_ sender: UIStepper) {
       
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var name = nameOfExp.text
        var summ = Int(summOfExp.text!)
        var priority = Int(priorityOfExp.text!)
    }
   

}
