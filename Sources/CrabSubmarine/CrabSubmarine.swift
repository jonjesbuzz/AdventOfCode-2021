// Day 7: The Treachery of Whales

import Foundation
import AdventCore

// Day 7: The Treachery of Whales
public class CrabSubmarine: Solution {
    public var inputs: Input<[Int]>
    public var activeInput: [Int]

    public var testAnswer: Answer<Int>

    public init() {
        self.inputs = Day7.input
        self.activeInput = []
        self.testAnswer = Answer(part1: 37, part2: 168)
    }

    public func reset() {

    }

    public func part1() -> Int {
        var optimalCost = Int.max
        let maxPosition = self.activeInput.max()!
        for i in 0..<maxPosition {
            let distances = self.activeInput.map { abs($0 - i) }
            let cost = distances.reduce(0, +)
            optimalCost = min(cost, optimalCost)
        }
        return optimalCost
    }

    public func part2() -> Int {
        var optimalCost = Int.max
        let maxPosition = self.activeInput.max()!
        for i in 0..<maxPosition {
            let distances = self.activeInput.map { c -> Int in
                let dist = abs(c - i)
                return dist * (dist + 1) / 2
            }
            let cost = distances.reduce(0, +)
            optimalCost = min(cost, optimalCost)
        }
        return optimalCost
    }
}


/* Old version that manually mapped the active input */

//
//public class CrabSubmarine: Solution {
//    public var inputs: Input<[Int]>
//    public var activeInput: [Int]
//
//    public var testAnswer: Answer<Int>
//
//    public init() {
//        self.inputs = Day7.input
//        self.activeInput = []
//        self.testAnswer = Answer(part1: 37, part2: 168)
//    }
//
//    public func reset() {
//
//    }
//
//    public func part1() -> Int {
//        var optimalCost = Int.max
//        let maxPosition = self.activeInput.max()!
//        for i in 0..<maxPosition {
//            var distances = Array(repeating: -1, count: self.activeInput.count)
//            for (j, c) in self.activeInput.enumerated() {
//                distances[j] = abs(c - i)
//            }
//            let cost = distances.reduce(0, +)
//            optimalCost = min(cost, optimalCost)
//        }
//        return optimalCost
//    }
//
//    public func part2() -> Int {
//        var optimalCost = Int.max
//        let maxPosition = self.activeInput.max()!
//        for i in 0..<maxPosition {
//            var distances = Array(repeating: -1, count: self.activeInput.count)
//            for (j, c) in self.activeInput.enumerated() {
//                let dist = abs(c - i)
//                distances[j] = dist * (dist + 1) / 2
//            }
//            let cost = distances.reduce(0, +)
//            optimalCost = min(cost, optimalCost)
//        }
//        return optimalCost
//    }
//}
