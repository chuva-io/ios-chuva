import UIKit
import Eureka

protocol CreateFormDelegate: class {
    func cancelActionHandler(vc: CreateFormVC)
    func doneActionHandler(vc: CreateFormVC, form: [BaseQuestion])
}

class CreateFormVC: FormViewController {
    
    weak var delegate: CreateFormDelegate?
    weak var currentQuestionRow: BaseRow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Form"
        prepareBarButtons()
        
        let formTitleRow = TextRow("formTitle") {
            $0.title = "Form Title"
            $0.add(rule: RuleRequired(msg: "Form title is required."))
        }
        
        let questionsSection = MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete], header: "Options") {
            $0.tag = "questionsSection"
            $0.multivaluedRowToInsertAt = { index in
                return ButtonRow() { row in
                    let questionVC = CreateQuestionVC()
                    questionVC.delegate = self
                    self.currentQuestionRow = row
                    self.navigationController?.pushViewController(questionVC, animated: true)
                }
            }
            
            $0.showInsertIconInAddButton = false
            
            $0.addButtonProvider = { _ in
                return ButtonRow(){ row in
                    // Allows me to validate section
                    let optionCountRule = RuleClosure<String> { _ in
                        return row.section!.count < 2 ? ValidationError(msg: "At least one question is required.") : nil
                    }
                    row.add(rule: optionCountRule)
                    row.title = "Add Question"
                }
            }
            
        }
        
        var section = Section()
        section += [formTitleRow]
        form += [section, questionsSection]
        
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
        delegate?.cancelActionHandler(vc: self)
    }
    
    @objc fileprivate func doneBarButtonTapped() {
        
        // Prepare tags for Eureka validation
        if let section = form.sectionBy(tag: "questionsSection"),
            section.isHidden == false,
            section.count > 2 {
            for i in 0..<section.count - 1 {
                section[i].tag = "\(i)"
            }
        }
        
        if (form.validate().isEmpty) {
            // Valid form
            print("Valid form")
            print(form.values())
            delegate?.doneActionHandler(vc: self, form: [])
        }
        else {
            // Invalid form
            print("Invalid form")
            _ = form.validate().map { print($0.msg) }
        }
        
    }
    
}

extension CreateFormVC: CreateQuestionDelegate {
    func cancelActionHandler(viewController: CreateQuestionVC) {
        currentQuestionRow?.baseCell.height = { 0 }
        currentQuestionRow?.baseCell.isHidden = true
        currentQuestionRow?.reload()
        currentQuestionRow = nil
        if let navVC = viewController.navigationController {
            navVC.popViewController(animated: true)
        }
        else {
            viewController.dismiss(animated: true)
        }
    }
    
    func doneActionHandler(viewController: CreateQuestionVC, created question: BaseQuestion) {
        currentQuestionRow?.title = question.title
        currentQuestionRow?.reload()
        print(question)
        currentQuestionRow = nil
        if let navVC = viewController.navigationController {
            navVC.popViewController(animated: true)
        }
        else {
            viewController.dismiss(animated: true)
        }
    }
    
}

