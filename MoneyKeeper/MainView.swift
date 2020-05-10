//
//  MainView.swift
//  MoneyKeeper
//
//  Created by Станислав Никишков on 07.05.2020.
//  Copyright © 2020 Станислав Никишков. All rights reserved.
//

import UIKit

class MainView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var summ: Int
        var priority: Int

       
    }
    var name: String
    @IBOutlet weak var tableOfExp: UITableView!
    
    @IBAction func unwind(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "segue" else { return }
        guard let source = unwindSegue.source as? UIViewController else { return }
        n
        
    }
    @IBAction func createExpenses(_ sender: UIButton) {
        
    }
}
    
