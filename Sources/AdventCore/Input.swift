import Foundation

/// Input encapsulates the puzzle input.
///
/// The test input and actual inputs are provided and used by the ``Solution``
/// protocol to test the test input, and to provide the answer for the actual puzzle input.
///
/// This instance is immutable and read-only after it is constructed.
public struct Input<T> {

    /// The test input, which is usually smaller and has the answer provided.
    public let test: T

    /// The actual input for which an answer is being derived.
    public let actual: T

    /// Initializes the input with the test and actual inputs.
    public init(test: T, actual: T) {
        self.test = test
        self.actual = actual
    }
}
