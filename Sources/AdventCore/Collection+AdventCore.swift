public extension Collection where Element: Comparable, Element: Swift.Numeric {

    /// Returns the difference between the largest and smallest number in the collection.
    var range: Element {
        return self.max()! - self.min()!
    }
}

public extension Array {

    /// Takes the current array, and returns an array of arrays each containing `itemCount` items in it.
    func grouped(every itemCount: Int) -> [[Element]] {
        var arrays = [[Element]]()

        for (i, n) in self.enumerated() {
            if i % itemCount == 0 { arrays.append([]) }
            arrays[i / itemCount].append(n)
        }

        return arrays
    }
}
