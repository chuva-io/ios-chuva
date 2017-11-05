import UIKit
import ReactiveCocoa
import ReactiveSwift

@IBDesignable
class LargeInlineTextField: UIView {
    
    private let viewModel: LargeInlineTextFieldViewModelType = LargeInlineTextFieldViewModel(title: "first name")
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var valueTextField: UITextField!
    @IBOutlet fileprivate weak var baselineView: UIView!
    @IBOutlet fileprivate weak var errorLabel: UILabel!
    
    @IBOutlet fileprivate weak var titleLabelTopAlignment: NSLayoutConstraint!
    @IBOutlet fileprivate weak var titleLabelBottomAlignment: NSLayoutConstraint!
    
    
    //MARK:- Reactive
    
    func bindViewModel() {
        
        // Inputs
        titleLabel.reactive.text <~ viewModel.outputs.titleText
        valueTextField.reactive.text <~ viewModel.outputs.valueText
        errorLabel.reactive.text <~ viewModel.outputs.errorText
        
        viewModel.outputs.valueIsHidden.skipRepeats().producer.startWithSignal { observer, disposable in
            observer.observeValues {
                self.animateTitleLabel(position: $0 ? .bottom : .top)
            }
        }
        
        
        // Outputs
        viewModel.inputs.valueTextChanged <~ valueTextField.reactive.continuousTextValues
        
    }
    
    //MARK:- Animations
    
    fileprivate enum TitleLabelPosition {
        case top, bottom
    }
    
    fileprivate func animateTitleLabel(position: TitleLabelPosition) {
        self.layoutIfNeeded()
        
        switch position {
        case .top:
            titleLabelTopAlignment.priority = .defaultHigh
            titleLabelBottomAlignment.priority = .defaultLow
        case .bottom:
            titleLabelTopAlignment.priority = .defaultLow
            titleLabelBottomAlignment.priority = .defaultHigh
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
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
