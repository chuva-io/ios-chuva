import UIKit
import Eureka

protocol CreateQuestionDelegate: class {
    func cancelActionHandler(viewController: CreateQuestionVC)
    func doneActionHandler(viewController: CreateQuestionVC, question: BaseQuestion)
}

class CreateQuestionVC: FormViewController {
    
    weak var delegate: CreateQuestionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Question"
        prepareBarButtons()
        
        let questionTitleRow = TextRow("questionTitle") {
            $0.title = "Question Title"
            $0.add(rule: RuleRequired(msg: "Question title is required."))
        }
        
        let questionTypePickerRow = AlertRow<String>("questionType") {
            $0.title = "Question Type"
            $0.options = ["Integer", "Decimal", "Text", "Single Choice", "Multiple Choice"]
            $0.add(rule: RuleRequired(msg: "Question type is required."))
        }
        
        let choicesSection = MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete], header: "Options") {
            $0.tag = "choicesSection"
            $0.hidden = Condition.function(["questionType"]) { form in
                guard let row = form.rowBy(tag: "questionType") as? AlertRow<String>,
                    row.value == "Single Choice" || row.value == "Multiple Choice" else {
                        return true
                }
                return false
            }
            
            $0.multivaluedRowToInsertAt = { index in
                return TextRow() { row in
                    row.onCellSelection { cell, row in
                        let questionVC = CreateQuestionVC()
                        self.navigationController?.pushViewController(questionVC, animated: true)
                    }
                    row.placeholder = "Option \(index + 1)"
                    row.add(rule: RuleRequired(msg: "You have empty options."))
                }
            }
            
            $0.showInsertIconInAddButton = false
            
            $0.addButtonProvider = { _ in
                return ButtonRow(){ row in
                    // Allows me to validate section
                    let optionCountRule = RuleClosure<String> { _ in
                        return row.section!.count < 3 ? ValidationError(msg: "At least 2 options are required.") : nil
                    }
                    row.add(rule: optionCountRule)
                    row.title = "Add Option"
                }
            }
            
        }
        
        var section = Section()
        section += [questionTitleRow, questionTypePickerRow]
        form += [section, choicesSection]
        
    }
    
    fileprivate func prepareBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelBarButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                           target: self,
                                                           action: #selector(doneBarButtonTapped))
    }
    
    @objc fileprivate func cancelBarButtonTapped() {
        delegate?.cancelActionHandler(viewController: self)
    }
    
    @objc fileprivate func doneBarButtonTapped() {
        
        // Prepare tags for Eureka validation
        if let section = form.sectionBy(tag: "choicesSection"),
            section.isHidden == false,
            section.count > 2 {
            for i in 0..<section.count - 1 {
                section[i].tag = "\(i)"
            }
        }
        
        if (form.validate().isEmpty) {
            // Valid form
            print("Valid question")
            print(form.values())
//            created(form: form) // Serialize form
            delegate?.doneActionHandler(viewController: self, question: Question.Text(title: "myQuestion", answer: nil))
        }
        else {
            // Invalid form
            print("Invalid question")
            _ = form.validate().map { print($0.msg) }
        }
        
    }
    
}
