import UIKit
import ReactiveCocoa
import ReactiveSwift

@IBDesignable
class LargeInlineTextField: UIView {
    private let viewModel: LargeInlineTextFieldViewModelType = LargeInlineTextFieldViewModel()
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var textField: UITextField!
    @IBOutlet fileprivate weak var baselineView: UIView!
    @IBOutlet fileprivate weak var errorLabel: UILabel!

    
    //MARK:- Reactive
    
    func bindViewModel() {
        
        // Inputs
        titleLabel.reactive.text <~ viewModel.outputs.titleText
        textField.reactive.text <~ viewModel.outputs.valueText
        errorLabel.reactive.text <~ viewModel.outputs.errorText
        
        titleLabel.reactive.isHidden <~ viewModel.outputs.titleIsHidden
        
        
        // Outputs
        viewModel.inputs.valueTextChanged <~ textField.reactive.continuousTextValues
        
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
