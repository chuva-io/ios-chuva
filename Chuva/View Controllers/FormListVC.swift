import UIKit
import Disk

class FormListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var questions: [BaseQuestion] = []
    var forms: [Form] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let newFormVC = CreateFormVC()
        newFormVC.delegate = self
        
        let navVC = UINavigationController(rootViewController: newFormVC)
        present(navVC, animated: true)
    }
    
    @IBAction func submitButtonTapped() {
        for question in questions {
            print("Question: \(question.title)\nAnswer: \(String(describing: question.baseAnswer?.baseValue))")
            print("")
        }
    }
    
}


// MARK: - UITableViewDelegate
extension FormListVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UITableViewDataSource
extension FormListVC: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forms.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = forms[indexPath.row].title
        return cell
    }
    
}


// MARK: - CreateFormDelegate
extension FormListVC: CreateFormDelegate {
    
    func cancelActionHandler(vc: CreateFormVC) {
        vc.dismiss(animated: true)
    }
    
    func doneActionHandler(vc: CreateFormVC, form: Form) {
        forms.append(form)
        tableView.reloadData()
        vc.dismiss(animated: true)
    }
    
}
