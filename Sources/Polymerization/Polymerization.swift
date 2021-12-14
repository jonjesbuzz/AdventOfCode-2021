// Day 14: Extended Polymerization

import Foundation
import AdventCore

class Polymerization: Solution {

    var inputs: Input<String> = Day14.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 1588, part2: 2188189693529)

    var polymer: String = ""
    var insertions: [String: InsertionRule] = [:]

    func reset() {
        let pieces = activeInput.components(separatedBy: "\n\n")
        self.polymer = pieces[0]
        let insertionRules = pieces[1].split(separator: "\n").map(InsertionRule.init(stringValue:))
        for rule in insertionRules {
            insertions[rule.pair] = rule
        }
    }

    // Naive polymer construction
    func step(_ polymer: String) -> String {
        let polymer = Array(polymer)
        var result = ""

        for i in 0..<(polymer.count - 1) {
            let pair = String(polymer[i]) + String(polymer[i + 1])
            if let rule = insertions[pair] {
                result.append(rule.replacement.left)
            } else {
                result.append(polymer[i])
            }
        }
        result.append(polymer[polymer.count - 1])

        return result
    }

    // Optimized polymer construction
    func polymerize(steps: Int) -> [Character: Int] {
        var pairFrequency = [String: Int]()
        var charFrequency = [Character: Int]()
        let polymer = Array(polymer)

        // Generate the pair and character frequency tables
        for i in 0..<(polymer.count - 1) {
            let pair = String(polymer[i]) + String(polymer[i + 1])
            pairFrequency[pair, default: 0] += 1
            charFrequency[polymer[i], default: 0] += 1
        }
        charFrequency[polymer[polymer.count - 1], default: 0] += 1

        for _ in 0..<steps {
            for (k, value) in pairFrequency {
                let pair = insertions[k]!
                let insertion = pair.insertion

                // Add the frequency of the new character
                charFrequency[insertion, default: 0] += value

                // Remove this pair from the polymer
                pairFrequency[k]! -= value

                // Add the left and right sides of the polymer
                pairFrequency[pair.replacement.left, default: 0] += value
                pairFrequency[pair.replacement.right, default: 0] += value
            }
        }

        return charFrequency
    }

    func part1() -> Int {
        let frequencyTable = polymerize(steps: 10)
        let vals = frequencyTable.values
        return vals.range
    }

    func part2() -> Int {
        let frequencyTable = polymerize(steps: 40)
        let vals = frequencyTable.values
        return vals.range
    }
}

struct InsertionRule: CustomStringConvertible {
    let pair: String
    let insertion: Character

    init(pair: String, insertion: Character) {
        self.pair = pair
        self.insertion = insertion
    }

    init(stringValue: StringProtocol) {
        let comps = stringValue.components(separatedBy: " -> ")
        self.pair = comps[0]
        self.insertion = comps[1].first!
    }

    var description: String {
        return "\(self.pair) -> \(self.insertion)"
    }

    var replacement: (left: String, right: String) {
        return (
            String(self.pair.first!) + String(self.insertion),
            String(self.insertion) + String(self.pair.last!)
            )
    }
}

