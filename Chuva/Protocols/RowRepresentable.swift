import Eureka

protocol BaseRowRepresentable {
    var baseRow: BaseRow { get }
}

protocol TypedRowRepresentable: BaseRowRepresentable {
    associatedtype RowType: BaseRow
    var row: RowType { get }
}

extension TypedRowRepresentable {
    var baseRow: BaseRow {
        get { return row }
    }
}
