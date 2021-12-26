/// A protocol representing a two-dimensional grid.
public protocol GridProtocol {

    /// The type of the element contained within the grid.
    associatedtype Element

    /// The number of rows in the grid.
    var rows: Int { get }

    /// The number of columns in the grid.
    var columns: Int { get }

    /// The valid range of values for row indices.
    var rowRange: ClosedRange<Int> { get }

    /// The valid range of values for column indices.
    var columnRange: ClosedRange<Int> { get }

    /// The number of populated elements in the grid.
    var count: Int { get }

    /// Sets or returns the value at the specified ``Point``.
    subscript(_ point: Point) -> Element { get set }

    /// Sets or returns the value at the specified row and column.
    subscript(row: Int, col: Int) -> Element { get set }

    /// The ``Point`` representing the top-left corner of the grid.
    var startPoint: Point { get }

    /// The ``Point`` representing the bottom-right corner of the grid.
    var endPoint: Point { get }
}


public extension GridProtocol {

    /// Determines if the point represents a valid cell in this grid.
    /// - Parameter point: The point to check in this grid.
    /// - Returns: `true` if the point lies within this grid, `false` otherwise.
    func contains(point: Point) -> Bool {
        return point.containedWithin(rowRange: 0..<rows, columnRange: 0..<columns)
    }

    /// Determines if the point at (row, column) represents a valid cell in this grid.
    /// - Parameter row: The row to check in this grid.
    /// - Parameter column: The column to check in this grid.
    /// - Returns: `true` if the point lies within this grid, `false` otherwise.
    func contains(row: Int, column: Int) -> Bool {
        return (0..<rows).contains(row) && (0..<columns).contains(column)
    }
}
