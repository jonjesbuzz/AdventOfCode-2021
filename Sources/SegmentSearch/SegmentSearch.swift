// Day 8: Seven Segment Search

import Foundation
import AdventCore

class Entry {
    var signalPatterns: [String]
    var outputValues: [String]

    init(stringValue: String) {
        let delimited = stringValue.stringArray(separatedBy: "|")
        self.signalPatterns = delimited[0].stringArray(separatedBy: " ")
        self.outputValues = delimited[1].stringArray(separatedBy: " ")
    }

    static func entries(from stringValue: String) -> [Entry] {
        return stringValue.stringArray().map(Entry.init(stringValue:))
    }
}

class SegmentSearch: Solution {
    var inputs: Input<String> = Day8.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 26, part2: 61229)

    var entries: [Entry] = []

    func reset() {
        self.entries = Entry.entries(from: self.activeInput)
    }

    func part1() -> Int {
        let uniques = Set([2, 3, 4, 7])
        return entries.flatMap { $0.outputValues.map { $0.count } }.filter { uniques.contains($0) }.count
    }

    func part2() -> Int {
        var sum = 0

        for entry in self.entries {
            // Step 1: Determine 1, 4, 7, 8
            let patterns = entry.signalPatterns
            print(patterns.joined(separator: " "))
            var digits = Array<Set<Character>>(repeating: Set(), count: 10)
            digits[1] = Set(patterns.first(where: { $0.count == 2 }) ?? "")
            digits[4] = Set(patterns.first(where: { $0.count == 4 }) ?? "")
            digits[7] = Set(patterns.first(where: { $0.count == 3 }) ?? "")
            digits[8] = Set("abcdefg")

            let aCharacter: Set<Character> = {
                let charSet = digits[7].subtracting(digits[1])
                if charSet.count != 1 { return Set() }
                return charSet
            }()
            print("a ->", aCharacter)
            let fivePatterns = patterns.filter { $0.count == 5 }
            let sixPatterns = patterns.filter { $0.count == 6 }
            let cCharacter: Set<Character> = {
                for pattern in sixPatterns {
                    let charSet = digits[1].subtracting(Set(pattern))
                    if charSet.count != 1 { continue }
                    return charSet
                }
                return Set()
            }()
            print("c ->", cCharacter)
            digits[6] = digits[8].subtracting(cCharacter)

            let eCharacter: Set<Character> = {
                for pattern in fivePatterns {
                    let charSet = digits[6].subtracting(Set(pattern))
                    if charSet.count != 1 { continue }
                    return charSet
                }
                return Set()
            }()
            print("e ->", eCharacter)

            // Step 2a: Determine 0, 6, 9 (6 segments)
            digits[9] = digits[8].subtracting(eCharacter)
            digits[0] = {
                let remaining = sixPatterns.filter { s in
                    let chars = Set(s)
                    return chars != digits[9] && chars != digits[6]
                }
                return Set(Set(remaining).first!)
            }()

            let dCharacter = digits[8].subtracting(digits[0])
            print("d -> ", dCharacter)
            let bCharacter = digits[4].subtracting(digits[1]).subtracting(dCharacter)
            print("b -> ", bCharacter)

            // Step 2b: Determine 2, 3, 5 (5 segments)
            digits[5] = digits[6].subtracting(eCharacter)
            digits[3] = digits[5].subtracting(bCharacter).union(cCharacter)
            digits[2] = {
                let remaining = fivePatterns.filter { s in
                    let chars = Set(s)
                    return chars != digits[5] && chars != digits[3]
                }
                return Set(Set(remaining).first!)
            }()

//            for (i, n) in digits.enumerated() {
//                print(i, String(n))
//            }

            // Step 3: Decipher entries
            var num = 0
            var place = 1000
            for value in entry.outputValues {
                let digit = digits.firstIndex(of: Set(value)) ?? 0
                num += digit * place
                place /= 10
            }
            print("\(entry.outputValues.joined(separator: " ")) is \(num)")
            sum += num
        }

        return sum
    }
}

struct Display {
    var on = Array(repeating: false, count: 7)
    // 000000
    // 1    2
    // 1    2
    // 333333
    // 4    5
    // 4    5
    // 666666

    init(on: [Bool]) {
        assert(on.count == 7)
        self.on = on
    }

    static let digits = [
        Self(on: [true, true, true, false, true, true, true]),     // 0
        Self(on: [false, false, true, false, false, true, false]), // 1
        Self(on: [true, false, true, true, true, false, true]),    // 2
        Self(on: [true, false, true, true, false, true, true]),    // 3
        Self(on: [false, true, true, true, false, true, false]),   // 4
        Self(on: [true, true, false, true, false, true, true]),    // 5
        Self(on: [true, true, false, true, true, true, true]),     // 6
        Self(on: [true, false, true, false, false, true, false]),  // 7
        Self(on: Array(repeating: true, count: 7)),                // 8
        Self(on: [true, true, true, true, false, true, true])      // 9
    ]
}
