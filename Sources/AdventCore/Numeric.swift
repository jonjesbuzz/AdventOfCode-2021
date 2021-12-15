import Foundation

/// This module's Numeric type defines additional requirements
/// on top of Swift's numeric type. This allows certain APIs to accept various numeric types, if necessary.
public protocol Numeric: Comparable, Swift.Numeric {
    /// The maximum value described by this numeric type.
    static var max: Self { get }

    /// The zero value described by this numeric type.
    static var zero: Self { get }
}

// MARK: - Conformances
extension Int: AdventCore.Numeric {}

extension Double: AdventCore.Numeric {
    public static var max: Double { return Double.greatestFiniteMagnitude }
}
