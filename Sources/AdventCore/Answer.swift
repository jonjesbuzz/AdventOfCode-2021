import Foundation

/// The Answer struct holds the expected answers for a given input.
///
/// This answer is usually given for the test inputs, and the ``Solution`` protocol uses it to
/// determine if the solutions to part 1 and part 2 generate the expected outputs.
public struct Answer<T: Equatable>: Equatable {

    /// The answer to part 1.
    public let part1: T

    /// The answer to part 2.
    public let part2: T

    /// Create an input pair.
    /// - Parameters:
    ///   - part1: The answer to part 1.
    ///   - part2: The answer to part 2.
    public init(part1: T, part2: T) {
        self.part1 = part1
        self.part2 = part2
    }

    public static func ==(lhs: Answer<T>, rhs: Answer<T>) -> Bool {
        return lhs.part1 == rhs.part1 && lhs.part2 == rhs.part2
    }
}
