import UIKit
import ReactiveCocoa
import ReactiveSwift
import Chameleon

@IBDesignable
class InlineTextField: UIView {

    private let viewModel: LargeInlineTextFieldViewModelType = LargeInlineTextFieldViewModel(title: "first name", style: .large)

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

        viewModel.outputs.valueIsHidden.skipRepeats().producer.startWithValues {
            self.animateTitleLabel(position: $0 ? .bottom : .top)
        }

        baselineView.reactive.backgroundColor <~ SignalProducer
            .combineLatest(viewModel.outputs.valueText.producer,
                           viewModel.outputs.style.producer).map {
                            switch $1 {
                            case .large:
                                 return ($0?.isEmpty ?? true) ? UIColor.flatWhite().withAlphaComponent(0.5) : UIColor.flatWhite()
                            case .normal:
                                return ($0?.isEmpty ?? true) ? UIColor.flatRed().withAlphaComponent(0.5) : UIColor.flatRed()
                            }
                            
        }

        viewModel.outputs.style.producer.startWithValues {
            switch $0 {
            case .large:
                self.titleLabel.font = self.titleLabel.font.withSize(18)
                self.titleLabel.textColor = UIColor.flatWhite().withAlphaComponent(0.5)

                self.valueTextField.font = self.valueTextField.font?.withSize(24)
                self.valueTextField.textColor = UIColor.flatWhite()

                self.errorLabel.font = self.errorLabel.font.withSize(12)
                self.errorLabel.textColor = UIColor.flatNavyBlue()
            case .normal:
                self.titleLabel.font = self.titleLabel.font.withSize(14)
                self.titleLabel.textColor = UIColor.flatRed().withAlphaComponent(0.5)

                self.valueTextField.font = self.valueTextField.font?.withSize(20)
                self.valueTextField.textColor = UIColor.flatRed()

                self.errorLabel.font = self.errorLabel.font.withSize(10)
                self.errorLabel.textColor = UIColor.flatNavyBlue()
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
