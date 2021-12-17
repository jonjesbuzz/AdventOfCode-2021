import Foundation

public extension FixedWidthInteger {

    /// Generates the binary representation of this integer as a string.
    ///
    /// - Parameter leftPadded: When true, the string will be left padded with zeroes to fill the entirety of the bit width of this integer.
    /// - Returns: The binary representation of this integer as a string.
    func binaryString(leftPadded: Bool = true) -> String {
        // Zero is treated special, because `leadingZeroBitCount` is `bitWidth`,
        // but `binaryNumber` will be "0", so you get `bitWidth + 1` digits.
        if self == .zero {
            return leftPadded ? String(repeating: "0", count: self.bitWidth) : "0"
        }

        let binaryNumber = String(self, radix: 2)

        if !leftPadded {
            return binaryNumber
        } else {
            let zeroPadding = String(repeating: "0", count: self.leadingZeroBitCount)
            return zeroPadding + binaryNumber
        }
    }
}
