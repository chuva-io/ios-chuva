import UIKit
import Eureka

class CreateFormVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionTitleRow = TextRow("questionTitle") {
            $0.title = "Question Title"
        }
        
        let questionTypePickerRow = AlertRow<String>("questionType") {
            $0.title = "Question Type"
            $0.options = ["Integer", "Decimal", "Text", "Single Choice", "Multiple Choice"]
        }
        
        let choicesSection = MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete], header: "Options") {
            $0.hidden = Condition.function(["questionType"]) { form in
                guard let row = form.rowBy(tag: "questionType") as? AlertRow<String>,
                    row.value == "Single Choice" || row.value == "Multiple Choice" else {
                        return true
                }
                return false
            }
            
            $0.multivaluedRowToInsertAt = { index in
                return TextRow() {
                    $0.placeholder = "Option \(index + 1)"
                }
            }
            
            $0.showInsertIconInAddButton = false
            $0.addButtonProvider = { _ in
                return ButtonRow(){
                    $0.title = "Add Option"
                }
            }
        }
        
        var section = Section()
        section += [questionTitleRow, questionTypePickerRow]
        form += [section, choicesSection]
        
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
