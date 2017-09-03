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
        
        loadForms()
    }
    
    func loadForms() {
        do {
            let formData = try Disk.retrieve("forms.json", from: .documents, as: [Data].self)
            let formJson = try formData.map { try JSONSerialization.jsonObject(with: $0, options: []) as? [String: AnyObject] }
                .flatMap { $0 }
            forms = formJson.map { Form.serialize($0) }
                .flatMap { $0 }
        }
        catch {
            forms = []
        }
        defer {
            tableView.reloadData()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let newFormVC = CreateFormVC()
        newFormVC.delegate = self
        
        let navVC = UINavigationController(rootViewController: newFormVC)
        present(navVC, animated: true)
    }
    
    @IBAction func submitButtonTapped() { }
    
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
        let formData = try! JSONSerialization.data(withJSONObject: form.deserialize(), options: [])
        try! Disk.append(formData, to: "forms.json", in: .documents)
        loadForms()
        vc.dismiss(animated: true)
    }
    
}
