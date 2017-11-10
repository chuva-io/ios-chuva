import ReactiveSwift

public protocol TextFieldViewModelType {
    var inputs: TextFieldViewModelInputs { get }
    var outputs: TextFieldViewModelOutputs { get }
}

public protocol TextFieldViewModelInputs {
    var valueTextChanged: MutableProperty<String?> { get }
}

public protocol TextFieldViewModelOutputs {
    var placeholderText: Property<String> { get }
    var valueText: Property<String?> { get }
    var errorText: Property<String?> { get }
}

public final class TextFieldViewModel: TextFieldViewModelType, TextFieldViewModelInputs,  TextFieldViewModelOutputs {

    public init(placeholder: String) {
        placeholderText = Property(value: placeholder)

        valueText = .init(initial: nil,
                          then: valueTextChanged.signal)
    }


    //MARK: Type
    public var inputs: TextFieldViewModelInputs { return self }
    public var outputs: TextFieldViewModelOutputs { return self }


    //MARK: Inputs
    public let valueTextChanged: MutableProperty<String?> = MutableProperty<String?>(nil)


    //MARK: Outputs
    public let placeholderText: Property<String>
    public let valueText: Property<String?>
    public let errorText: Property<String?> = Property(value: "error text")

}
