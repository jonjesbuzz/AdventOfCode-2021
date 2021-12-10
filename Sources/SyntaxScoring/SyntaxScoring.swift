// Day 10: Syntax Scoring
import Foundation
import AdventCore

class SyntaxScoring: Solution {
    var inputs: Input<String> = Day10.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 26397, part2: 288957)

    func opener(for closer: Character) -> Character {
        let matching: [Character: Character] = [
            ")": "(",
            "]": "[",
            "}": "{",
            ">": "<"
        ]
        return matching[closer]!
    }

    func closer(for opener: Character) -> Character {
        let matching: [Character: Character] = [
            "(": ")",
            "[": "]",
            "{": "}",
            "<": ">"
        ]
        return matching[opener]!
    }

    let openers: Set<Character> = ["(", "[", "{", "<"]

    var lines: [String] = []

    func reset() {
        self.lines = activeInput.stringArray()
    }

    func part1() -> Int {
        let scoring: [Character: Int] = [
            ")": 3,
            "]": 57,
            "}": 1197,
            ">": 25137
        ]

        var corruptScore = 0

        for line in lines {
            var stack = [Character]()
            let charArray = Array(line)
            for char in charArray {
                if openers.contains(char) {
                    stack.append(char)
                } else if let lastOpener = stack.popLast() {
                    // char is a closing character
                    if opener(for: char) != lastOpener {
                        // The last opener does not match this closing character
                        // Add the closing character's score to the corrupted characters score
                        corruptScore += scoring[char]!
                        break
                    }
                } else {
                    // Incomplete line, ignore.
                    break
                }
            }
        }

        return corruptScore
    }

    func part2() -> Int {
        let scoring: [Character: Int] = [
            ")": 1,
            "]": 2,
            "}": 3,
            ">": 4
        ]
        
        var completionScores = [Int]()

        for line in lines {
            var isBrokenLine = false

            var stack = [Character]()
            let charArray = Array(line)

            for char in charArray {
                if openers.contains(char) {
                    stack.append(char)
                } else if let last = stack.popLast() {
                    // char == closing character
                    if opener(for: char) != last {
                        // Broken line, ignore.
                        isBrokenLine = true
                        break

                    }
                }
            }

            // We don't care about broken lines.
            if isBrokenLine { continue }

            // stack contains the remaining openers that have no matching closer.
            // So, we can get the closers for everything in the stack, and reverse it.
            // In Swift, reversed() returns a ReversedCollection
            // A ReversedCollection is a view into the original collection, so it's O(1)
            let completion = stack.map { closer(for: $0) }.reversed()

            let score = completion.reduce(0) { partialResult, char in
                return partialResult * 5 + scoring[char]!
            }

            completionScores.append(score)
        }

        // Find the middle element
        // Per problem specification, the count is guaranteed to be odd, so there's always only one middle element.
        return completionScores.sorted()[completionScores.count / 2]
    }
}
