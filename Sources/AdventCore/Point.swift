/// Represents a point in two-dimensional space, or within a ``Grid``.
///
/// This instance is immutable and read-only once it has been constructed.
public struct Point {

    // MARK: - x,y Representation
    /// The x-coordinate of this point.
    public let x: Int

    /// The y-coordinate of this point.
    public let y: Int

    /// Initialize a point using an (x, y) coordinate pair.
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    /// Instantiates a point based on a string value given as `x,y`. For example, `3,4`.
    public init(stringValue: String) {
        let vals = stringValue.intArray(separatedBy: ",")
        self.x = vals[0]
        self.y = vals[1]
    }

    /// Returns the point at (0, 0).
    public static let zero = Point(x: 0, y: 0)

    // MARK: - Row-Column Representation

    /// The row represenation of this point.
    ///
    /// Row is represented by the ``y`` value of the point.
    public var row: Int {
        return self.y
    }

    /// The column represenation of this point.
    ///
    /// Column is represented by the ``x`` value of the point.
    public var column: Int {
        return self.x
    }

    /// Initialize a point using (row, column) as the coordinate pair.
    ///
    /// This is most useful in conjunction with the ``Grid`` class.
    public init(row: Int, column: Int) {
        self.y = row
        self.x = column
    }

    // MARK: - Adjacent Point Finding

    /// A representation of all 8 possible directions from a given point.
    public enum Direction: CaseIterable {

        /// The point above the current point.
        case up
        /// The point below the current point.
        case down
        /// The point to the left of the current point.
        case left
        /// The point to the right of the current point.
        case right

        /// The point diagonally up and to the left of the current point.
        case upLeft
        /// The point diagonally up and to the right of the current point.
        case upRight
        /// The point diagonally down and to the left of the current point.
        case downLeft
        /// The point diagonally down and to the right of the current point.
        case downRight

        /// The directions that are non-diagonal directions.
        public static let nonDiagonal: [Direction] = [.up, .down, .left, .right]
    }

    /// Returns a new point adjacent to this point in the specified direction.
    ///
    /// - Parameter direction: The direction to generate a point in.
    /// - Returns: A point adjacent to the current point in the specified direction.
    public func adjacentPoint(at direction: Direction) -> Point {
        let point: Point
        switch direction {
        case .up:
            point = Point(x: self.x, y: self.y - 1)
        case .down:
            point = Point(x: self.x, y: self.y + 1)
        case .left:
            point = Point(x: self.x - 1, y: self.y)
        case .right:
            point = Point(x: self.x + 1, y: self.y)
        case .upLeft:
            point = Point(x: self.x - 1, y: self.y - 1)
        case .upRight:
            point = Point(x: self.x + 1, y: self.y - 1)
        case .downLeft:
            point = Point(x: self.x - 1, y: self.y + 1)
        case .downRight:
            point = Point(x: self.x + 1, y: self.y + 1)
        }
        return point
    }


    /// Returns a point in the specified direction if it is valid for the input grid.
    /// 
    /// If the point does not exist in the grid (that is, if the point is out of the bounds of the grid), `nil` is returned instead.
    ///
    /// - Parameters:
    ///   - direction: The direction to generate a point in.
    ///   - grid: The Grid to use for checking if the point exists in that grid.
    /// - Returns: The adjacent point in the specified Grid, or `nil` if the point is out of bounds.
    public func adjacentPoint<T>(at direction: Direction, in grid: Grid<T>? = nil) -> Point? {
        let point = self.adjacentPoint(at: direction)
        if let grid = grid, !grid.contains(point: point) {
            return nil
        }
        return point
    }

    public func adjacentPoint<T>(at direction: Direction, in grid: SparseGrid<T>? = nil) -> Point? {
        let point = self.adjacentPoint(at: direction)
        if let grid = grid, !grid.contains(point: point) {
            return nil
        }
        return point
    }
}

// MARK: - Range Comparison
public extension Point {
    /// Determines if the pair of (x,y) ranges contains this point.
    /// - Parameters:
    ///   - xRange: A range of x-values.
    ///   - yRange: A range of y-values.
    /// - Returns: Whether this Point is contained within the provided ranges.
    func containedWithin<T: RangeExpression>(xRange: T, yRange: T) -> Bool where T.Bound == Int {
        return xRange.contains(self.x) && yRange.contains(self.y)
    }

    /// Determines if the pair of (row, column) ranges contains this point.
    /// - Parameters:
    ///   - rowRange: A range of row values.
    ///   - columnRange: A range of column values.
    /// - Returns: Whether this Point is contained within the provided ranges.
    func containedWithin<T: RangeExpression>(rowRange: T, columnRange: T) -> Bool where T.Bound == Int {
        return rowRange.contains(self.row) && columnRange.contains(self.column)
    }
}

// MARK: - Protocol Conformances
extension Point: CustomStringConvertible {
    public var description: String {
        return "\(x),\(y)"
    }

    public var rowDescription: String {
        return "\(row),\(column)"
    }
}

extension Point: Equatable, Hashable {
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Point: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(x),\(y))"
    }
}
