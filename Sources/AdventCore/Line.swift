import Foundation

/// A Line is represented by a start and end point.
///
/// This instance is immutable and read-only after it is constructed.
public struct Line: Equatable, CustomStringConvertible {

    /// The start point of this line.
    public let start: Point

    /// The end point of this line.
    public let end: Point

    /// Initializes a line from a start point and an end point.
    public init(start: Point, end: Point) {
        self.start = start
        self.end = end
    }

    /// Initializes a line going from `x1,y1` to `x2,y2`.
    public init(x1: Int, y1: Int, x2: Int, y2: Int) {
        self.start = Point(x: x1, y: y1)
        self.end = Point(x: x2, y: y2)
    }

    /// Initializes a line from a string representation.
    ///
    /// The expected string representation is `x1,y1 -> x2,y2`. For example, `1,1 -> 3,5`.
    public init(stringValue: String) {
        let points = stringValue.components(separatedBy: " -> ")
        self.start = Point(stringValue: points[0])
        self.end = Point(stringValue: points[1])
    }

    public static func ==(lhs: Line, rhs: Line) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }

    public var description: String {
        return "\(start) -> \(end)"
    }
}
