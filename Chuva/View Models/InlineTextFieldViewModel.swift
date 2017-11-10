import ReactiveSwift

public protocol InlineTextFieldViewModelType {
    var inputs: InlineTextFieldViewModelInputs { get }
    var outputs: InlineTextFieldViewModelOutputs { get }
}

public protocol InlineTextFieldViewModelInputs {
    var valueTextChanged: MutableProperty<String?> { get }
}

public protocol InlineTextFieldViewModelOutputs {
    var style: Property<Style> { get }
    var titleText: Property<String> { get }
    var valueText: Property<String?> { get }
    var errorText: Property<String?> { get }

    var valueIsHidden: Property<Bool> { get }
}

public enum Style {
    case large, normal
}

public final class InlineTextFieldViewModel: InlineTextFieldViewModelType, InlineTextFieldViewModelInputs,  InlineTextFieldViewModelOutputs {

    public init(title: String, style: Style) {
        self.style = Property(value: style)
        titleText = Property(value: title)

        valueText = .init(initial: nil,
                          then: valueTextChanged.signal)

        valueIsHidden = .init(initial: false,
                              then: valueText.producer.map { $0?.isEmpty ?? true })
    }


    //MARK: Type
    public var inputs: InlineTextFieldViewModelInputs { return self }
    public var outputs: InlineTextFieldViewModelOutputs { return self }


    //MARK: Inputs
    public let valueTextChanged: MutableProperty<String?> = MutableProperty<String?>(nil)


    //MARK: Outputs
    public let style: Property<Style>
    public let titleText: Property<String>
    public let valueText: Property<String?>
    public let errorText: Property<String?> = Property(value: "error text")

    public var valueIsHidden: Property<Bool>

}
