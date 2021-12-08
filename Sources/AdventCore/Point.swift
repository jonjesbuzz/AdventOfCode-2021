public struct Point: Equatable, CustomStringConvertible, Hashable {
    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

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
}
