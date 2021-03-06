/// A SparseGrid represents a two-dimensional grid but does not allocate space for every possible index.
///
/// Instead, it uses a backing dictionary that maps ``Point`` instances to the element.
public struct SparseGrid<Element>: CustomStringConvertible {

    /// The underlying dictionary representation of the grid.
    private(set) public var grid: [Point: Element]

    /// The number of rows contained in this grid.
    private(set) public var rows: Int

    /// The valid range of values for row indices.
    public var rowRange: ClosedRange<Int> {
        return 0...(rows - 1)
    }

    /// The valid range of values for column indices.
    public var columnRange: ClosedRange<Int> {
        return 0...(columns - 1)
    }

    /// The number of columns contained in this grid.
    private(set) public var columns: Int

    private var defaultValueString: String

    public init(rows: Int, columns: Int) {
        self.grid = [:]
        self.rows = rows
        self.columns = columns
        self.defaultValueString = "."
    }

    /// Initialize the grid with a prepopulated matrix.
    ///
    /// - Warning: If all rows of the matrix are not of the same length, this initializer will assert.
    /// - Parameter matrix: The prepopulated matrix of values for this grid.
    /// - Parameter defaultValue: The value to turn into the sparse portion of the grid.
    public init(matrix: [[Element]], defaultValue: Element) where Element: Equatable {
        assert(Set(matrix.map(\.count)).count == 1)
        self.grid = [:]
        self.rows = matrix.count
        self.columns = self.rows > 0 ? matrix[0].count : 0
        self.defaultValueString = String(describing: defaultValue)

        for (r, row) in matrix.enumerated() {
            for (c, value) in row.enumerated() {
                if value == defaultValue { continue }
                let point = Point(row: r, column: c)
                self.grid[point] = value
            }
        }
    }

    /// The number of populated values in the SparseGrid.
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
            if !point.containedWithin(rowRange: 0..<rows, columnRange: 0..<columns) { return nil }
            return self.grid[point]
        }
        set {
            if !point.containedWithin(rowRange: 0..<rows, columnRange: 0..<columns) { fatalError("Attempting to store a value at a point outside of the grid bounds.") }
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
            if !point.containedWithin(rowRange: 0..<rows, columnRange: 0..<columns) { return nil }
            return self.grid[point]
        }
        set {
            let point = Point(row: row, column: col)
            if !point.containedWithin(rowRange: 0..<rows, columnRange: 0..<columns) { fatalError("Attempting to store a value at a point outside of the grid bounds.") }
            self.grid[point] = newValue
        }
    }

    /// The ``Point`` representing the top-left corner of the grid.
    public var startPoint: Point {
        return Point(row: 0, column: 0)
    }

    /// The ``Point`` representing the bottom-right corner of the grid.
    public var endPoint: Point {
        return Point(row: self.rows - 1, column: self.columns - 1)
    }

    /// The ``Point`` representing the bounds of this grid, useful for iterating.
    public var endBound: Point {
        return Point(row: self.rows, column: self.columns)
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

public extension SparseGrid {

    /// Returns `true` if the grid is populated at `point`.
    /// - Parameter point: The ``Point`` to check
    /// - Returns: `true` if the grid is populated at this point, `false` otherwise.
    func containsValue(at point: Point) -> Bool {
        return self.grid[point] != nil
    }
}

// MARK: - Numeric-Specific Extensions
public extension SparseGrid where Element: AdventCore.Numeric {

    /// Returns the minimum path cost from a start point to a destination.
    ///
    /// The values in the grid are considered the cost of traversing across it.
    ///
    /// The implementation of this function uses Dijkstra's algorithm with a heap behaving as a priority queue.
    /// - Parameters:
    ///   - start: The starting point of the search. This node will have a cost of 0.
    ///   - destination: The destination of this search.
    /// - Returns: The minimum cost to reach `destination` from `start`.
    func minCost(from start: Point, to destination: Point, directions: [Point.Direction] = Point.Direction.nonDiagonal) -> Element {
        var costGrid = SparseGrid(rows: self.rows, columns: self.columns)
        costGrid[start] = .zero
        var pq = Heap<(Point, Element)>(comparator: { $0.1 < $1.1 })
        pq.insert((start, .zero))

        while !pq.isEmpty {
            let tuple = pq.remove()
            let current = tuple.0
            let currentCost = costGrid[current, default: Element.max]
            for direction in directions {
                guard let point = current.adjacentPoint(at: direction, in: self), let value = self[point] else { continue }
                let pointCost = costGrid[point, default: Element.max]
                if pointCost > currentCost + value {
                    let costAtPoint = currentCost + value
                    costGrid[point] = costAtPoint
                    pq.insert((point, costAtPoint))
                }

                // We can afford to be greedy.
                if point == destination { break }
            }
        }
        return costGrid[destination]!
    }
}

extension SparseGrid: GridProtocol {}
