/// A Grid is a wrapper around a two-dimensional matrix, with convenience methods to make computations easier.
public struct SparseGrid<Element>: CustomStringConvertible {

    /// The underlying two-dimensional array of the grid.
    private(set) public var grid: [Point: Element]

    private(set) public var rows: Int
    private(set) public var columns: Int

    public init(rows: Int, columns: Int) {
        self.grid = [:]
        self.rows = rows
        self.columns = columns
    }

    /// The number of values in the SparseGrid.
    public var count: Int {
        return self.grid.count
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
        return Point(row: 0, column: 0)
    }

    /// The ``Point`` representing one past the bottom-right corner of the grid.
    public var endPoint: Point {
        return Point(row: self.rows, column: self.columns)
    }

    /// Returns the entire grid as a one-dimensional array.
    ///
    /// This is useful for performing iteration over all values in the grid, and for
    /// functional operations such as `map`, `filter`, and `reduce`.
    public var flattened: [Element] {
        return Array(self.grid.values)
    }

    public var description: String {
        return grid.map({String(describing: $0)}).joined(separator: ",\n")
    }
}

public extension SparseGrid {

    /// Determines if the point represents a valid cell in this grid.
    /// - Parameter point: The point to check in this grid.
    /// - Returns: `true` if the point lies within this grid, `false` otherwise.
    func contains(point: Point) -> Bool {
        return point.containedWithin(rowRange: 0..<rows, columnRange: 0..<columns)
    }

    func containsValue(at point: Point) -> Bool {
        return self.grid[point] != nil
    }

    /// Determines if the point at (row, column) represents a valid cell in this grid.
    /// - Parameter row: The row to check in this grid.
    /// - Parameter column: The column to check in this grid.
    /// - Returns: `true` if the point lies within this grid, `false` otherwise.
    func contains(row: Int, column: Int) -> Bool {
        return (0..<rows).contains(row) && (0..<columns).contains(column)
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
