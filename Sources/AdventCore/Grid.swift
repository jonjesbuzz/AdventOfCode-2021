/// A Grid is a wrapper around a two-dimensional matrix, with convenience methods to make computations easier.
///
/// You can index the grid using either integers or Point instances as follows:
/// ```
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
