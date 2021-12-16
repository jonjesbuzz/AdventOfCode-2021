import Foundation

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

    /// Returns the frequency of each character in this string.
    var characterFrequencyTable: [Character: Int] {
        var frequencyTable: [Character: Int] = [:]
        for char in Array(self) {
            frequencyTable[char, default: 0] += 1
        }
        return frequencyTable
    }
}

public extension String {

    /// Converts a hexadecimal string to a binary string for easier manipulation.
    var hexadecimalToBinaryString: String {
        let arr = Array(self).map(String.init)
        var s: [String] = []
        for i in 0..<arr.count / 2 {
            s.append(arr[2 * i] + arr[2 * i + 1])
        }
        let ints = s.map({ UInt8($0, radix: 16)! })
        let result = ints.reduce("") { partialResult, num in
            if num == 0 { return partialResult + "00000000" }
            let str = String(num, radix: 2)
            let zero = String(repeating: "0", count: num.leadingZeroBitCount)
            return partialResult.appending(zero + str)
        }
        assert(result.count == self.count * 4)
        return result
    }
}
