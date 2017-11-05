/*
 
 Signal
     - Owner of Signal has unilateral control of event stream.
     - Observers may register at any time.
     - Observation has no side effects.
     - Used to represent event streams that are already “in progress” (user input).
 
 Signal Producer
     - Defers work until SignalProducer is started.
     - Every invocation to `start` creates a new Signal and the deferred work is started.
 
 Property
     - A variable that can be observed for changes.
     - The latest value is always available.
     - The stream will never fail.
     - Similar to Signal.
 
 */


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
    
    var titleIsHidden: Property<Bool> { get }
}

public final class LargeInlineTextFieldViewModel: LargeInlineTextFieldViewModelType, LargeInlineTextFieldViewModelInputs,  LargeInlineTextFieldViewModelOutputs {
    
    public init() {
        valueText = .init(initial: "valueText",
                          then: valueTextChanged.signal)
        
        titleIsHidden = .init(initial: false,
                              then: valueText.producer.map { $0?.isEmpty ?? true })
    }

    
    //MARK: Type
    public var inputs: LargeInlineTextFieldViewModelInputs { return self }
    public var outputs: LargeInlineTextFieldViewModelOutputs { return self }

    
    //MARK: Inputs
    public let valueTextChanged: MutableProperty<String?> = MutableProperty<String?>(nil)

    
    //MARK: Outputs
    public let titleText: Property<String> = Property(value: "titleText")
    public let valueText: Property<String?>
    public let errorText: Property<String?> = Property(value: "errorText")
    
    public var titleIsHidden: Property<Bool>

}
