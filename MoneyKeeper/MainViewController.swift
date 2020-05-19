import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Расходы"
        self.navigationController?.navigationBar.prefersLargeTitles = false
     
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        
        if UIScreen.main.traitCollection.userInterfaceStyle == .light {
            addButton.setImage(UIImage(named: "Image"), for: .normal)
        } else {
            addButton.setImage(UIImage(named: "whiteButton"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let context = getContext()
        let fetchRequest = getFetchRequest()
        
        do {
            expenses = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    @IBOutlet weak var addButton: UIButton!
    var expenses: [Expenses] = []
    
    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? SecondViewController else { return }
        
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Expenses", in: context) else { return }
        
        let expense = Expenses(entity: entity, insertInto: context)
        expense.name = svc.nameTF.text!
        expense.summ = svc.summTF.text!
        expense.priority = svc.priorityTF.text!
        expenses.append(expense)
        
        table.reloadData()
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func unwindFromEditController(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? EditViewController else { return }
        expenses[svc.index].name = svc.editNameTF.text!
        expenses[svc.index].summ = svc.editSummTF.text!
        expenses[svc.index].priority = svc.editPriorityTF.text!
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
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! CustomCell
        cell.nameLabel?.text = expenses[indexPath.row].name
        cell.summLabel?.text = "\(expenses[indexPath.row].summ ?? "???")₽"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "EditViewContoller") as? EditViewController {
            vc.nameForEdit = expenses[indexPath.row].name!
            vc.summForEdit = expenses[indexPath.row].summ!
            vc.priorityForEdit = expenses[indexPath.row].priority!
            vc.index = indexPath.row
            navigationController?.showDetailViewController(vc, sender: nil)
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }

}
