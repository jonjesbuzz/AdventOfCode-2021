public extension String {

    /// Returns an array of strings separated by the separator.
    ///
    /// This method will create new String instances, and is not an array of Substring instances.
    /// - Parameter separator: A separator character to use, or newline (`\n`) if none is specified.
    /// - Returns: An array of strings separated by the separator character.
    func stringArray(separatedBy separator: Character = "\n") -> [String] {
        return self.split(separator: separator).map(String.init)
    }

    /// Returns an array of  `Int` separated by the separator.
    ///
    /// If the strings cannot be instantiated as an `Int`, the function will crash with an unwrapping error.
    /// - Parameter separator: A separator character to use, or newline (`\n`) if none is specified.
    /// - Returns: An array of `Int` separated by the separator character.
    func intArray(separatedBy separator: Character = "\n") -> [Int] {
        return self.split(separator: separator).map { Int($0)! }
    }

    /// Returns an array of integers where each character in the string is converted to a whole number.
    ///
    /// For example, `12345` becomes `[1, 2, 3, 4, 5]`.
    /// If any character in the string is a non-numeric value, the function crashes with an unwrapping error.
    func singleDigitIntArray() -> [Int] {
        return Array(self).map { $0.wholeNumberValue! }
    }
}
