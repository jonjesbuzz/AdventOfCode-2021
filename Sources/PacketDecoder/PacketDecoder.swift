// Day 16: Packet Decoder

import Foundation
import AdventCore

class PacketDecoder: Solution {

    var inputs: Input<String> = Day16.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 14, part2: 3)

    var packet: Packet = .init()

    func reset() {
        self.packet = .packet(from: self.activeInput)
    }

    func part1() -> Int {
        return self.packet.versionSum
    }

    func part2() -> Int {
        return self.packet.value
    }
}

class Packet {

    enum `Type`: Int {
        case literal = 4

        case sum = 0
        case product = 1
        case minimum = 2
        case maximum = 3
        case greaterThan = 5
        case lessThan = 6
        case equalTo = 7
    }

    var version: Int
    var type: `Type`
    var literal: Int?
    var subpackets: [Packet]

    init() {
        self.subpackets = []
        self.version = 0
        self.type = .literal
    }

    /// Decodes a top-level packet recursively from the provided hexadecimal string
    /// - Parameter stringValue: A hexadecimal string representing the packet
    /// - Returns: The top level packet.
    static func packet(from stringValue: String) -> Packet {
        let s = stringValue.hexadecimalToBinaryString
        let a = Array(s)
        var cursor = 0
        return decodeNextPacket(a, cursor: &cursor)
    }

    /// Decodes the next packet in the series starting at the provided cursor.
    /// - Parameters:
    ///   - binaryString: The array of binary digits
    ///   - cursor: The starting position of the packet
    /// - Returns: The next packet in the series.
    static func decodeNextPacket(_ binaryString: [String.Element], cursor: inout Int) -> Packet {
        let p = Packet()

        // Version is the first 3 bits
        let versionString = String(binaryString[cursor..<cursor + 3])
        p.version = Int(versionString, radix: 2)!
        cursor += 3

        // Type is the next 3 bits
        let typeString = String(binaryString[cursor..<cursor + 3])
        let typeInt = Int(typeString, radix: 2)!
        p.type = Type(rawValue: typeInt)!
        cursor += 3

        // Then the packet's payload, which is either a literal
        // or an operator with a series of subpackets.
        if p.type == .literal {
            p.decodeLiteral(binaryString, cursor: &cursor)
        } else {
            p.decodeOperator(binaryString, cursor: &cursor)
        }

        return p
    }

    /// Decodes the literal embedded in this packet.
    private func decodeLiteral(_ binaryString: [String.Element], cursor: inout Int) {
        var literal = 0

        // We start off by parsing the first nibble
        var parse = true

        while parse {
            // If the first digit of the 5 bits is 1,
            // there's another nibble to parse after this one.
            parse = (binaryString[cursor] == "1")

            // Move the cursor over the "next" marker
            cursor += 1

            // Bitshift the literal over to make room for this one.
            literal = literal << 4

            // Compute the new nibble and add it to the literal
            let nibble = String(binaryString[cursor..<cursor + 4])
            literal |= Int(nibble, radix: 2)!

            // Move the cursor over.
            cursor += 4
        }
        self.literal = literal
    }

    private func decodeOperator(_ binaryString: [String.Element], cursor: inout Int) {

        // The first bit determines the way the length of the subpackets are represented
        let lengthType = binaryString[cursor]
        cursor += 1

        if lengthType == "0" {
            // Total length of subpackets is in number of bits
            // That number is the next 15 bits in the string
            let lengthString = String(binaryString[cursor..<cursor + 15])
            let length = Int(lengthString, radix: 2)!
            cursor += 15

            // Decode packets until we've consumed the number of bits specified.
            let end = cursor + length
            while cursor < end {
                self.subpackets.append(Self.decodeNextPacket(binaryString, cursor: &cursor))
            }
        } else {
            // Total length of subpackets is represented by a count of packets
            // That count is the next 11 bits in the string
            let countString = String(binaryString[cursor..<cursor + 11])
            let count = Int(countString, radix: 2)!
            cursor += 11

            // Decode the next `count` packets.
            for _ in 0..<count {
                self.subpackets.append(Self.decodeNextPacket(binaryString, cursor: &cursor))
            }
        }
    }

    /// Returns the value of this packet based on the rules of the type of this packet and its subpackets.
    var value: Int {
        switch self.type {
        case .literal:
            return self.literal!

        case .sum:
            return self.subpackets.reduce(0, { $0 + $1.value })
        case .product:
            return self.subpackets.reduce(1, { $0 * $1.value })
        case .minimum:
            return self.subpackets.min(by: { $0.value < $1.value })!.value
        case .maximum:
            return self.subpackets.max(by: { $0.value < $1.value })!.value

        // These three are guaranteed to only have 2 subpackets.
        case .greaterThan:
            return self.subpackets[0].value > self.subpackets[1].value ? 1 : 0
        case .lessThan:
            return self.subpackets[0].value < self.subpackets[1].value ? 1 : 0
        case .equalTo:
            return self.subpackets[0].value == self.subpackets[1].value ? 1 : 0
        }
    }

    /// Returns the version sum of this packet and its subpackets.
    var versionSum: Int {
        return self.version + self.subpackets.reduce(0, { $0 + $1.versionSum })
    }
}
