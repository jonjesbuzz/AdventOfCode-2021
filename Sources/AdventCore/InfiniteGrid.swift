/// An InfiniteGrid represents a two-dimensional grid that can grow arbitirarily in all directions.
public struct InfiniteGrid<Element>: CustomStringConvertible {

    /// The underlying dictionary representation of the grid.
    private(set) public var grid: [Point: Element]

    /// The number of rows contained in this grid.
    public var rows: Int {
        return self.endPoint.row - self.startPoint.row + 1
    }

    /// The valid range of values for row indices.
    public var rowRange: ClosedRange<Int> {
        return self.startPoint.row...self.endPoint.row
    }

    /// The number of columns contained in this grid.
    public var columns: Int {
        return self.endPoint.column - self.startPoint.column + 1
    }

    /// The valid range of values for column indices.
    public var columnRange: ClosedRange<Int> {
        return self.startPoint.column...self.endPoint.column
    }

    /// The string used to represent the default value.
    private var defaultValueString: String

    /// Initializes an empty grid.
    public init() {
        self.grid = [:]
        self.defaultValueString = "."
    }

    /// Initialize the grid with a prepopulated matrix, starting at a specified point.
    ///
    /// - Warning: If all rows of the matrix are not of the same length, this initializer will assert.
    /// - Parameter matrix: The prepopulated matrix of values for this grid.
    /// - Parameter defaultValue: The value to turn into the sparse portion of the grid.
    /// - Parameter startingAt: The ``Point`` to represent the top-left element in the grid.
    public init(matrix: [[Element]], defaultValue: Element, startingAt startPoint: Point = .zero) where Element: Equatable {
        assert(Set(matrix.map(\.count)).count == 1)
        self.grid = [:]
        self.defaultValueString = String(describing: defaultValue)

        for (r, row) in matrix.enumerated() {
            let rowIndex = startPoint.row + r
            for (c, value) in row.enumerated() {
                if value == defaultValue { continue }
                let point = Point(row: rowIndex, column: startPoint.column + c)
                self.grid[point] = value
            }
        }
    }

    /// The number of populated values in the InfiniteGrid.
    public var count: Int {
        return self.grid.count
    }

    /// The number of spaces represented by the grid.
    public var capacity: Int {
        return self.rows * self.columns
    }

    /// The set of points that are currently occupied.
    public var occupiedPoints: Set<Point> {
        return Set(self.grid.keys)
    }

    /// Sets or returns the value at the specified ``Point``.
    public subscript(_ point: Point) -> Element? {
        get {
            return self.grid[point]
        }
        set {
            self.grid[point] = newValue
        }
    }

    /// Returns the value at the specified ``Point``, or `defaultValue` if the point is not populated.
    public subscript(_ point: Point, default defaultValue: Element) -> Element {
        get {
            return self.grid[point, default: defaultValue]
        }
    }

    /// Sets or returns the value at the specified row and column.
    public subscript(row: Int, col: Int) -> Element? {
        get {
            let point = Point(row: row, column: col)
            return self.grid[point]
        }
        set {
            let point = Point(row: row, column: col)
            self.grid[point] = newValue
        }
    }

    /// The ``Point`` representing the top-left corner of the grid.
    public var startPoint: Point {
        if self.count == 0 { return .zero }
        let row = self.grid.keys.map(\.row).min()!
        let col = self.grid.keys.map(\.column).min()!
        return Point(row: row, column: col)
    }

    /// The ``Point`` representing the bottom-right corner of the grid.
    public var endPoint: Point {
        if self.count == 0 { return .zero }
        let row = self.grid.keys.map(\.row).max()!
        let col = self.grid.keys.map(\.column).max()!
        return Point(row: row, column: col)
    }

    /// The ``Point`` representing the bounds of this grid, useful for iterating.
    public var endBound: Point {
        return Point(row: self.endPoint.row + 1, column: self.endPoint.column + 1)
    }

    /// Returns the entire grid as a one-dimensional array.
    ///
    /// - Warning: These values are **not** guaranteed to be returned in order. Use ``orderedList`` instead.
    ///
    /// This is useful for performing iteration over all values in the grid, and for
    /// functional operations such as `map`, `filter`, and `reduce`.
    public var flattened: [Element] {
        return Array(self.grid.values)
    }

    /// Returns the entire grid as a one-dimensional array, in the order they appear from top-left to bottom-right.
    ///
    /// This is useful for performing iteration over all values in the grid, and for
    /// functional operations such as `map`, `filter`, and `reduce`.
    public var orderedList: [Element] {
        var items = [Element]()

        for r in 0..<rows {
            for c in 0..<columns {
                let point = Point(row: r, column: c)
                if let value = self[point] { items.append(value) }
            }
        }

        return items
    }

    /// Returns a description of this matrix, with
    public var description: String {
        var result = ""
        for r in 0..<rows {
            for c in 0..<columns {
                let point = Point(row: r, column: c)
                if let value = self.grid[point] {
                    result.append(String(describing: value))
                } else {
                    result.append(self.defaultValueString)
                }
                if c != columns - 1 { result.append(contentsOf: ", ") }
            }
            result.append(contentsOf: "\n")
        }
        return result
    }
}

public extension InfiniteGrid {

    /// Returns `true` if the grid is populated at `point`.
    /// - Parameter point: The ``Point`` to check
    /// - Returns: `true` if the grid is populated at this point, `false` otherwise.
    func containsValue(at point: Point) -> Bool {
        return self.grid[point] != nil
    }
}

extension InfiniteGrid: GridProtocol {}
