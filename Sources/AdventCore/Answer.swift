import Foundation

public struct Answer<T: Equatable>: Equatable {

    private(set) public var part1: T
    private(set) public var part2: T

    public init(part1: T, part2: T) {
        self.part1 = part1
        self.part2 = part2
    }

    public static func ==(lhs: Answer<T>, rhs: Answer<T>) -> Bool {
        return lhs.part1 == rhs.part1 && lhs.part2 == rhs.part2
    }
}
