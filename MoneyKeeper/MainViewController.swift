import UIKit
import CoreData
import Foundation

class MainViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Расходы"
        self.navigationController?.navigationBar.prefersLargeTitles = false
     
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        
        if UIScreen.main.traitCollection.userInterfaceStyle == .light {  // Change the image of add button
            addButton.setImage(UIImage(named: "Image"), for: .normal)    // depending on the choosen theme
        } else {
            addButton.setImage(UIImage(named: "whiteButton"), for: .normal)
        }
        
        UserDefaults.standard.register(defaults: ["ascending": true]) // set standart sort for ascending
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let fetchRequest = getFetchRequest()
        
        //sorting data in coreData
        let sortDescriptor = NSSortDescriptor(key: "priority", ascending: UserDefaults.standard.bool(forKey: "ascending"))
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //load data from coreData when app launch
        let context = getContext()
        do {
            expenses = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIButton!
    var expenses: [Expenses] = []
    var sortedAscending: Bool = UserDefaults.standard.bool(forKey: "ascending")
    
    // sorting array of expenses when user touch up sortButton and reload table view
    @IBAction func sort(_ sender: UIBarButtonItem) {
        if !sortedAscending {
            expenses = expenses.sorted(by: { $0.priority < $1.priority })
            table.reloadData()
            sortButton.image = UIImage(named: "unsortButton")
            sortedAscending = true
            saveSortedAscendingStatus(status: sortedAscending)
        } else {
            expenses = expenses.sorted(by: { $0.priority > $1.priority })
            table.reloadData()
            sortButton.image = UIImage(named: "sortButton")
            sortedAscending = false
            saveSortedAscendingStatus(status: sortedAscending)
        }
    }

    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? AddExpenseViewController else { return } // get data from view controller
        let context = getContext()
        
        // get entity as Expense class
        guard let entity = NSEntityDescription.entity(forEntityName: "Expenses", in: context) else { return }
        let expense = Expenses(entity: entity, insertInto: context)
        
        // get name, summ and priority from view controller to our class instance
        expense.name = svc.nameTF.text!
        expense.summ = Int32(svc.summTF.text!)!
        expense.priority = Int32(svc.priorityTF.text!)!
        expenses.append(expense)
        
        table.reloadData()
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // change data of selected instance
    @IBAction func unwindFromEditController(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? EditViewController else { return }
        expenses[svc.index].name = svc.editNameTF.text!
        expenses[svc.index].summ = Int32(svc.editSummTF.text!)!
        expenses[svc.index].priority = Int32(svc.editPriorityTF.text!)!
        table.reloadData()
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func getFetchRequest() -> NSFetchRequest<Expenses> {
        let fetchRequest: NSFetchRequest<Expenses> = Expenses.fetchRequest()
        return fetchRequest
    }
    
    private func saveSortedAscendingStatus(status: Bool) {
        UserDefaults.standard.set(status, forKey: "ascending")
        UserDefaults.standard.synchronize()
}
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! CustomCell
        cell.nameLabel?.text = expenses[indexPath.row].name
        cell.summLabel?.text = "\(expenses[indexPath.row].summ)₽"
        cell.priority = expenses[indexPath.row].priority
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "EditViewContoller") as? EditViewController {
            vc.nameForEdit = expenses[indexPath.row].name!
            vc.summForEdit = "\(expenses[indexPath.row].summ)"
            vc.priorityForEdit = "\(expenses[indexPath.row].priority)"
            vc.index = indexPath.row
            navigationController?.showDetailViewController(vc, sender: nil)
        }
    }
    
    // add delete button in cell and delete instance from coreData and expenses array with name identifier
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let context = getContext()
            let fetchRequest = getFetchRequest()
            if let objects = try? context.fetch(fetchRequest) {
                for object in objects {
                    if object.name == expenses[indexPath.row].name {
                    context.delete(object)
                }
            }
            
            expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
                
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
}
    // change title of delete button
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }

}
