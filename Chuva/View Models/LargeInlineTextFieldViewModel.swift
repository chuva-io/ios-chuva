import Foundation
import ReactiveSwift
import Result

public protocol LargeInlineTextFieldViewModelType {
    var inputs: LargeInlineTextFieldViewModelInputs { get }
    var outputs: LargeInlineTextFieldViewModelOutputs { get }
}

public protocol LargeInlineTextFieldViewModelInputs {
    var valueTextChanged: MutableProperty<String?> { get }
}

public protocol LargeInlineTextFieldViewModelOutputs {
    var titleText:  Property<String> { get }
    var valueText:  Property<String?> { get }
    var errorText:  Property<String?> { get }
    
    var valueIsHidden: Property<Bool> { get }
}

public final class LargeInlineTextFieldViewModel: LargeInlineTextFieldViewModelType, LargeInlineTextFieldViewModelInputs,  LargeInlineTextFieldViewModelOutputs {
    
    public init(title: String) {
        titleText = Property(value: title)
        
        valueText = .init(initial: nil,
                          then: valueTextChanged.signal)
        
        valueIsHidden = .init(initial: false,
                              then: valueText.producer.map { $0?.isEmpty ?? true })
    }

    
    //MARK: Type
    public var inputs: LargeInlineTextFieldViewModelInputs { return self }
    public var outputs: LargeInlineTextFieldViewModelOutputs { return self }

    
    //MARK: Inputs
    public let valueTextChanged: MutableProperty<String?> = MutableProperty<String?>(nil)

    
    //MARK: Outputs
    public let titleText: Property<String>
    public let valueText: Property<String?>
    public let errorText: Property<String?> = Property(value: nil)
    
    public var valueIsHidden: Property<Bool>

}
