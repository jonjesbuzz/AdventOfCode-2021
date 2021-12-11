/// Represents a point in space, or on a `Grid`.
///
/// This instance is immutable and read-only once it has been constructed.
public struct Point: Equatable, CustomStringConvertible, Hashable {

    /// The x-coordinate of this point.
    public let x: Int

    /// The y-coordinate of this point.
    public let y: Int

    /// Initialize a point using an (x, y) coordinate pair.
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    /// Initialize a point using (row, column) as the coordinate pair.
    /// This is most useful in conjunction with the `Grid` class.
    public init(row: Int, column: Int) {
        self.y = row
        self.x = column
    }

    /// Returns the row represenation of this point.
    ///
    /// Row is represented by the `y` value of the point.
    public var row: Int {
        return self.y
    }

    /// Returns the column represenation of this point.
    ///
    /// Column is represented by the `x` value of the point.
    public var column: Int {
        return self.x
    }

    /// Instantiates a point based on a value given as `"x,y"`.
    public init(stringValue: String) {
        let vals = stringValue.intArray(separatedBy: ",")
        self.x = vals[0]
        self.y = vals[1]
    }

    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    public var description: String {
        return "\(x),\(y)"
    }

    /// A representation of all 8 possible directions from a given point.
    public enum Direction: CaseIterable {

        case up
        case down
        case left
        case right

        case upLeft
        case upRight
        case downLeft
        case downRight

        /// Returns only the directions that are non-diagonal directions.
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
        if let grid = grid {
            if point.row < 0 || point.row >= grid.rows { return nil }
            if point.column < 0 || point.column >= grid.columns { return nil }
        }
        return point
    }
}
