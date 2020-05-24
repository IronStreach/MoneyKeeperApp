import UIKit

class EditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        editNameTF.text = nameForEdit
        editSummTF.text = summForEdit
        editPriorityTF.text = priorityForEdit
        
        editNameTF.delegate = self
        editSummTF.delegate = self
        editPriorityTF.delegate = self
        
        editWrongLabel.isHidden = true
        
        editSummTF.keyboardType = .numbersAndPunctuation
        editPriorityTF.keyboardType = .numbersAndPunctuation
        
        editStepper.value = Double(priorityForEdit)!
        editStepper.minimumValue = 1
        editStepper.maximumValue = 1000
        
    }
    
    @IBOutlet weak var editNameTF: UITextField!
    @IBOutlet weak var editSummTF: UITextField!
    @IBOutlet weak var editPriorityTF: UITextField!
    @IBOutlet weak var editWrongLabel: UILabel!
    @IBOutlet weak var editDoneButton: UIButton!
    @IBOutlet weak var editStepper: UIStepper!
    
    
    @IBAction func changePriority(_ sender: UIStepper) {
        editPriorityTF.text = "\(Int(editStepper.value))"
    }
    
    var nameForEdit: String = ""
    var summForEdit: String = ""
    var priorityForEdit: String = ""
    var index: Int = 0 // index of selected cell

}

extension EditViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    // check data for corectness
    func textFieldDidEndEditing(_ textField: UITextField) {
        editDoneButton.isEnabled = false
        
        if !checkDataIsEmpty(data: editNameTF) && !editNameTF.isFirstResponder {
            editWrongLabel.text = "Не введены данные"
            editWrongLabel.isHidden = false
            return
        }
        
        if !checkDataIsPositiveNumber(data: editSummTF) && !editSummTF.isFirstResponder {
            editWrongLabel.text = "Неправильно введена сумма"
            editWrongLabel.isHidden = false
            return
        }
        
        if !checkDataIsPositiveNumber(data: editPriorityTF) && !editPriorityTF.isFirstResponder {
            editWrongLabel.text = "Неправильно задан приоритет"
            editWrongLabel.isHidden = false
            return
        }
        
        editWrongLabel.isHidden = true
        editDoneButton.isEnabled = true
    }
}
