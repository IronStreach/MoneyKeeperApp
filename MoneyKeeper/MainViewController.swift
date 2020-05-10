import UIKit

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
    
    @IBOutlet weak var addButton: UIButton!
    var nameOfExpenses: [String] = []
    var summOfExpenses: [String] = []
    var priorityOfExpenses: [String] = []
    var helpCanAcces: String = ""
    
    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? SecondViewController else { return }
        nameOfExpenses.append(svc.nameTF.text!)
        summOfExpenses.append(svc.summTF.text!)
        priorityOfExpenses.append(svc.priorityTF.text!)
        table.reloadData()
    }
    
    @IBAction func unwindFromEditController(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? EditViewController else { return }
        nameOfExpenses[svc.index] = svc.editNameTF.text!
        summOfExpenses[svc.index] = svc.editSummTF.text!
        priorityOfExpenses[svc.index] = svc.editPriorityTF.text!
        table.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameOfExpenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! CustomCell
        cell.nameLabel?.text = nameOfExpenses[indexPath.row]
        cell.summLabel?.text = "\(summOfExpenses[indexPath.row])₽"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "EditViewContoller") as? EditViewController {
            vc.nameForEdit = nameOfExpenses[indexPath.row]
            vc.summForEdit = summOfExpenses[indexPath.row]
            vc.priorityForEdit = priorityOfExpenses[indexPath.row]
            vc.index = indexPath.row
            navigationController?.showDetailViewController(vc, sender: nil)
        }
    }
    
}
