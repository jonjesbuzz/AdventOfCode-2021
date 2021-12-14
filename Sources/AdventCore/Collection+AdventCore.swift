public extension Collection where Element: Comparable, Element: Numeric {

    /// Returns the difference between the largest and smallest number in the collection.
    var range: Element {
        return self.max()! - self.min()!
    }
}
