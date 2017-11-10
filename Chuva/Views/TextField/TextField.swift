import UIKit
import ReactiveCocoa
import ReactiveSwift
import Chameleon

@IBDesignable
class TextField: UIView {

    private let viewModel: TextFieldViewModelType = TextFieldViewModel(placeholder: "first name")

    @IBOutlet fileprivate weak var valueTextField: UITextField!
    @IBOutlet fileprivate weak var baselineView: UIView!
    @IBOutlet fileprivate weak var errorLabel: UILabel!
    
    func applyStyle() {
        valueTextField.font = valueTextField.font?.withSize(20)
        valueTextField.textColor = UIColor.flatRed()
        errorLabel.font = errorLabel.font.withSize(10)
        errorLabel.textColor = UIColor.flatNavyBlue()
    }

    //MARK:- Reactive

    func bindViewModel() {

        // Inputs
        valueTextField.reactive.makeBindingTarget { textField, placeholder in
            textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: [.foregroundColor: UIColor.flatRed().withAlphaComponent(0.5)])
        } <~ viewModel.outputs.placeholderText
        valueTextField.reactive.text <~ viewModel.outputs.valueText
        errorLabel.reactive.text <~ viewModel.outputs.errorText

        baselineView.reactive.backgroundColor <~ viewModel.outputs.valueText.producer.map {
            ($0?.isEmpty ?? true) ? UIColor.flatRed().withAlphaComponent(0.5) : UIColor.flatRed()
        }
        
        // Outputs
        viewModel.inputs.valueTextChanged <~ valueTextField.reactive.continuousTextValues
    }

    
    //MARK:- Nib Boilerplate

    var contentView : UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        xibSetup()
        bindViewModel()
        applyStyle()
    }

    func xibSetup() {
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(contentView!)
    }

    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }
}
