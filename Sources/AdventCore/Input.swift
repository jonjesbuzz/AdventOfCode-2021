import Foundation

/// The Input struct helps define the test and actual inputs used by a given problem.
public struct Input<T> {
    public let test: T
    public let actual: T

    public init(test: T, actual: T) {
        self.test = test
        self.actual = actual
    }
}
