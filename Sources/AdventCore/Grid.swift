/// A Grid is a wrapper around a two-dimensional matrix, with convenience methods to make computations easier.
///
/// You can index the grid using either integers or Point instances as follows:
/// ```swift
/// let grid = Grid(rows: 10, columns: 10, initialValue: 0)
/// let point = Point(row: 6, column: 4)
/// grid[3,1] = 3 // That is, grid[row, column]
/// grid[point] = 24
/// ```
public struct Grid<T>: CustomStringConvertible {

    /// The underlying two-dimensional array of the grid.
    private(set) public var grid: [[T]]

    /// Creates a Grid of `rows` × `columns` filled with the `initialValue` in all positions.
    /// - Parameters:
    ///   - rows: The number of rows in the grid.
    ///   - columns: The number of columns in the grid.
    ///   - initialValue: The initial value to fill in all of the positions.
    public init(rows: Int, columns: Int, initialValue: T) {
        guard rows > 0 else { self.grid = []; return }
        self.grid = Array(repeating: Array(repeating: initialValue, count: columns), count: rows)
    }

    /// Initialize the grid with a prepopulated matrix.
    /// - Parameter matrix: The prepopulated matrix of values for this grid.
    public init(matrix: [[T]]) {
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

    /// The number of values in the Grid.
    ///
    /// This is the product of `rows` and `columns`.
    public var count: Int {
        return rows * columns
    }

    /// Sets or returns the value at the specified Point.
    public subscript(_ point: Point) -> T {
        get {
            return self.grid[point.y][point.x]
        }
        set {
            self.grid[point.y][point.x] = newValue
        }
    }

    /// Sets or returns the value at the specified row and column.
    public subscript(row: Int, col: Int) -> T {
        get {
            return self.grid[row][col]
        }
        set {
            self.grid[row][col] = newValue
        }
    }

    /// The point representing the top-left corner of the grid.
    public var startPoint: Point {
        return Point(row: 0, column: 0)
    }

    /// The point representing the bottom-right corner of the grid.
    public var endPoint: Point {
        return Point(row: self.rows - 1, column: self.columns - 1)
    }

    /// Returns the entire grid as a one-dimensional array.
    ///
    /// This is useful for performing iteration over all values in the grid, and for
    /// functional operations such as `map`, `filter`, and `reduce`.
    public var flattened: [T] {
        return self.grid.flatMap { $0 }
    }

    public var description: String {
        return grid.map({String(describing: $0)}).joined(separator: ",\n")
    }
}

// MARK: - Numeric-specific Extensions

public extension Grid where T: AdventCore.Numeric {

    /// Returns the minimum path cost from a start point to a destination.
    ///
    /// The values in the grid are considered the cost of traversing across it.
    ///
    /// The implementation of this function uses Dijkstra's algorithm with a heap behaving as a priority queue.
    /// - Parameters:
    ///   - start: The starting point of the search. This node will have a cost of 0.
    ///   - destination: The destination of this search.
    /// - Returns: The minimum cost to reach `destination` from `start`.
    func minCost(from start: Point, to destination: Point) -> T {
        var costGrid = Grid(rows: self.rows, columns: self.columns, initialValue: T.max)
        costGrid[start] = .zero
        var pq = Heap<(Point, T)>(comparator: { $0.1 < $1.1 })
        pq.insert((start, .zero))

        while !pq.isEmpty {
            let tuple = pq.remove()
            let current = tuple.0
            let currentCost = costGrid[current]
            for direction in Point.Direction.nonDiagonal {
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
