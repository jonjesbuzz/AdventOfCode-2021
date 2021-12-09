open class Grid<T>: CustomStringConvertible {
    public var grid: [[T]]

    public init(rows: Int, columns: Int, initialValue: T) {
        guard rows > 0 else { self.grid = []; return }
        self.grid = Array(repeating: Array(repeating: initialValue, count: columns), count: rows)
    }

    public init(matrix: [[T]]) {
        self.grid = matrix
    }

    public var rows: Int {
        return self.grid.count
    }

    public var columns: Int {
        return self.grid.count > 0 ? self.grid[0].count : 0
    }

    public var count: Int {
        return rows * columns
    }

    public subscript(_ point: Point) -> T {
        get {
            return self.grid[point.y][point.x]
        }
        set {
            self.grid[point.y][point.x] = newValue
        }
    }

    public subscript(row: Int, col: Int) -> T {
        get {
            return self.grid[row][col]
        }
        set {
            self.grid[row][col] = newValue
        }
    }

    public var flattened: [T] {
        return self.grid.flatMap { $0 }
    }

    public var description: String {
        return grid.map({String(describing: $0)}).joined(separator: ",\n")
    }
}
