import Foundation

// MARK: - Parsing
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
    var singleDigitIntArray: [Int] {
        return Array(self).map { $0.wholeNumberValue! }
    }
}

// MARK: - Character Frequencies
public extension String {
    /// Returns the frequency of each character in this string.
    var characterFrequencyTable: [Character: Int] {
        var frequencyTable: [Character: Int] = [:]
        for char in Array(self) {
            frequencyTable[char, default: 0] += 1
        }
        return frequencyTable
    }
}

// MARK: - Binary and Hex String Handling
public extension String {

    /// Converts a hexadecimal string to a binary string for easier manipulation.
    ///
    /// This property will perform erratically or fail if the String contains non-hexadecimal characters.
    var binaryStringFromHexString: String {

        // Gather the bytes (which is 2 hex characters)
        // Aside: Substring shares storage with the original string so it's fast and efficient to operate on.
        var hexBytes: [Substring] = []
        var index = self.startIndex
        for _ in 0..<self.count / 2 {
            let endIndex = self.index(index, offsetBy: 2)
            hexBytes.append(self[index..<endIndex])
            index = endIndex
        }

        let bytes = hexBytes.map { UInt8($0, radix: 16)!.binaryString(leftPadded: true) }
        let result = bytes.joined(separator: "")

        // Each hex character should have become 4 binary digits.
        // If not, we've failed, and we need to assert and exit.
        assert(result.count == self.count * 4)

        return result
    }
}
