import UIKit

class AddExpenseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false
        warningLabel.isHidden = true
        
        nameTF.delegate = self
        summTF.delegate = self
        priorityTF.delegate = self
        
        stepperPriority.value = 1
        stepperPriority.minimumValue = 1
        stepperPriority.maximumValue = 1000
        
        priorityTF.text = "\(Int(stepperPriority.value))" // set priority value as initial stepper value
        
        summTF.keyboardType = .numbersAndPunctuation
        priorityTF.keyboardType = .numbersAndPunctuation
    }
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var summTF: UITextField!
    @IBOutlet weak var priorityTF: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var stepperPriority: UIStepper!
    
    @IBAction func changePriority(_ sender: UIStepper) {
        priorityTF.text = "\(Int(stepperPriority.value))"
    }
}

extension AddExpenseViewController: UITextFieldDelegate {
    // end edtiting when touch view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // end edititng and next TF become first responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        switch textField {
        case nameTF:
            summTF.becomeFirstResponder()
            return true
        case summTF:
            priorityTF.becomeFirstResponder()
            return true
        case priorityTF:
            resignFirstResponder()
            return true
        default:
            return true
        }
    }
    // check data for correctness
    func textFieldDidEndEditing(_ textField: UITextField) {
        doneButton.isEnabled = false
        
        if !checkDataIsEmpty(data: nameTF) && !nameTF.isFirstResponder {
            warningLabel.text = "Не введены данные"
            warningLabel.isHidden = false
            return
        }
        
        if !checkDataIsPositiveNumber(data: summTF) && !summTF.isFirstResponder {
            warningLabel.text = "Неправильно введена сумма"
            warningLabel.isHidden = false
            return
        }
        
        if !checkDataIsPositiveNumber(data: priorityTF) && !priorityTF.isFirstResponder {
            warningLabel.text = "Неправильно задан приоритет"
            warningLabel.isHidden = false
            return
        }
        
        warningLabel.isHidden = true
        doneButton.isEnabled = true
        return
    }
    
}
