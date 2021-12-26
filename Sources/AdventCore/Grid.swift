/// A Grid is a wrapper around a two-dimensional matrix, with convenience methods to make computations easier.
public struct Grid<Element>: CustomStringConvertible {

    /// The underlying two-dimensional array of the grid.
    private(set) public var grid: [[Element]]

    /// Creates a Grid of `rows` × `columns` filled with the `initialValue` in all positions.
    /// - Parameters:
    ///   - rows: The number of rows in the grid.
    ///   - columns: The number of columns in the grid.
    ///   - initialValue: The initial value to fill in all of the positions.
    public init(rows: Int, columns: Int, initialValue: Element) {
        guard rows > 0 else { self.grid = []; return }
        self.grid = Array(repeating: Array(repeating: initialValue, count: columns), count: rows)
    }

    /// Initialize the grid with a prepopulated matrix.
    ///
    /// - Warning: If all rows of the matrix are not of the same length, this initializer will assert.
    /// - Parameter matrix: The prepopulated matrix of values for this grid.
    public init(matrix: [[Element]]) {
        assert(Set(matrix.map(\.count)).count == 1)
        self.grid = matrix
    }

    /// The number of rows in the Grid.
    public var rows: Int {
        return self.grid.count
    }

    /// The number of columns in the Grid.
    public var columns: Int {
        return self.grid.count > 0 ? self.grid[0].count : 0
    }

    /// The valid range of values for row indices.
    public var rowRange: ClosedRange<Int> {
        return 0...(rows - 1)
    }

    /// The valid range of values for column indices.
    public var columnRange: ClosedRange<Int> {
        return 0...(columns - 1)
    }

    /// The number of values in the Grid.
    ///
    /// This is the product of `rows` and `columns`.
    public var count: Int {
        return rows * columns
    }

    /// Sets or returns the value at the specified ``Point``.
    public subscript(_ point: Point) -> Element {
        get {
            return self.grid[point.y][point.x]
        }
        set {
            self.grid[point.y][point.x] = newValue
        }
    }

    /// Sets or returns the value at the specified row and column.
    public subscript(row: Int, col: Int) -> Element {
        get {
            return self.grid[row][col]
        }
        set {
            self.grid[row][col] = newValue
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

    /// Returns the entire grid as a one-dimensional array.
    ///
    /// This is useful for performing iteration over all values in the grid, and for
    /// functional operations such as `map`, `filter`, and `reduce`.
    public var flattened: [Element] {
        return self.grid.flatMap { $0 }
    }

    public var description: String {
        return grid.map({String(describing: $0)}).joined(separator: ",\n")
    }
}

public extension Grid {

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

// MARK: - Numeric-Specific Extensions
public extension Grid where Element: AdventCore.Numeric {

    /// Returns the minimum path cost from a start point to a destination.
    ///
    /// The values in the grid are considered the cost of traversing across it.
    ///
    /// The implementation of this function uses Dijkstra's algorithm with a heap behaving as a priority queue.
    /// - Parameters:
    ///   - start: The starting point of the search. This node will have a cost of 0.
    ///   - destination: The destination of this search.
    ///   - directions: The directions to search in
    /// - Returns: The minimum cost to reach `destination` from `start`.
    func minCost(from start: Point, to destination: Point, directions: [Point.Direction] = Point.Direction.nonDiagonal) -> Element {
        var costGrid = Grid(rows: self.rows, columns: self.columns, initialValue: Element.max)
        costGrid[start] = .zero
        var pq = Heap<(Point, Element)>(comparator: { $0.1 < $1.1 })
        pq.insert((start, .zero))

        while !pq.isEmpty {
            let tuple = pq.remove()
            let current = tuple.0
            let currentCost = costGrid[current]
            for direction in directions {
                guard let point = current.adjacentPoint(at: direction, in: self) else { continue }
                let pointCost = costGrid[point]
                if pointCost > currentCost + self[point] {
                    costGrid[point] = currentCost + self[point]
                    pq.insert((point, costGrid[point]))
                }

                // We can afford to be greedy.
                if point == destination { break }
            }
        }
        return costGrid[destination]
    }
}

// MARK: - Sub-Grid Functions
public extension Grid {

    /// Generates a new Grid containing only the values contained within the subgrid bounded by the two points.
    ///
    /// - Warning: If `from` and `to` do not form the bounds of a grid, this method will assert.
    /// - Parameters:
    ///   - from: The point in the top-left corner to start the subgrid from.
    ///   - to: The point in the bottom-right corner to end the subgrid.
    /// - Returns: The subgrid bounded by the points.
    func subgrid(from: Point, to: Point) -> Grid {
        if from == .zero && (to.row == self.rows - 1 && to.column == self.columns - 1) {
            return Grid(matrix: self.grid)
        }
        assert(to.row > from.row)
        assert(to.row > from.row)

        var submatrix: [[Element]] = []
        var r0 = 0
        var c0 = 0
        for r in from.row..<to.row {
            submatrix.append([])
            for c in from.column..<to.column {
                submatrix[r0][c0] = self[r, c]
                c0 += 1
            }
            r0 += 1
        }

        return Grid(matrix: submatrix)
    }

    /// Returns the subgrid bounded by the two points.
    ///
    /// This is the same as calling ``subgrid(from:to:)``.
    subscript(from from: Point, to to: Point) -> Grid {
        return self.subgrid(from: from, to: to)
    }
}

extension Grid: GridProtocol {}
