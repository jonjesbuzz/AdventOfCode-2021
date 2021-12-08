import Foundation

public struct Line: Equatable, CustomStringConvertible {
    public var start: Point
    public var end: Point

    public init(start: Point, end: Point) {
        self.start = start
        self.end = end
    }

    public init(stringValue: String) {
        let points = stringValue.components(separatedBy: " -> ")
        start = Point(stringValue: points[0])
        end = Point(stringValue: points[1])
    }

    public static func ==(lhs: Line, rhs: Line) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end
    }

    public var description: String {
        return "\(start) -> \(end)"
    }
}
