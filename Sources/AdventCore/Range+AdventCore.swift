import Foundation

// https://forums.swift.org/t/add-range-intersect-to-the-standard-library-analogous-to-nsintersectionrange/16757
public extension ClosedRange {
    /// Returns the intersection of the two ranges, or `nil` if they do not overlap.
    func intersection(_ other: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        if self.overlaps(other) {
            return self.clamped(to: other)
        }
        return nil
    }
}
