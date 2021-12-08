// Day 6: Lanternfish

import Foundation
import AdventCore

public class Lanternfish: Solution {
    public var inputs: Input<[Int]>
    public var activeInput: [Int]
    public var testAnswer: Answer<UInt64> = Answer(part1: 5934, part2: 26984457539)
    // Days: # of fish
    var fish = [Int: UInt64]()

    public init() {
        self.inputs = Day6.inputs
        self.activeInput = self.inputs.test
    }

    public func reset() {
        self.fish = [:]
        for i in self.activeInput {
            fish[i, default: 0] += 1
        }
        print("Initial: \(fish)")
    }

    func multiply(days: Int) -> UInt64 {
        for i in 0..<days {
            var newDictionary = [Int: UInt64]()
            for f in 1..<9 {
                newDictionary[f - 1] = self.fish[f]
            }
            newDictionary[8] = self.fish[0]
            newDictionary[6, default: 0] += self.fish[0, default: 0]
            self.fish = newDictionary
            print("After day \(i): \t \(self.fish)")
        }
        return self.fish.values.reduce(0, +)
    }

    public func part1() -> UInt64 {
        return multiply(days: 80)
    }

    public func part2() -> UInt64 {
        return multiply(days: 256)
    }
}

class Fish: CustomStringConvertible {
    var timer: Int

    init() {
        self.timer = 8
    }

    init(timer: Int) {
        self.timer = timer
    }

    var description: String {
        return "\(timer)"
    }

    func tick() -> Fish? {
        if timer == 0 {
            timer = 6
            return Fish()
        }
        timer -= 1
        return nil
    }
}


//import Dispatch
//import Foundation
//
//public class Lanternfish: Solution {
//    public var inputs: Input<[Int]>
//    public var activeInput: [Int]
//    public var testAnswer: Answer<Int> = Answer(part1: 5934, part2: 26984457539)
//    var fish: [Fish]
//
//    public init() {
//        self.inputs = Day6.inputs
//        self.activeInput = self.inputs.test
//        self.fish = []
//    }
//
//    public func reset() {
//        self.fish = activeInput.map(Fish.init(timer:))
//        self.fish.reserveCapacity(500000)
//    }
//
//    func multiply(days: Int) -> Int {
//        for i in 0..<days {
//
//            var newFish = [Fish]()
//            let lock = NSRecursiveLock()
//            DispatchQueue.concurrentPerform(iterations: self.fish.count) { i in
//                let f = fish[i]
//                let n = f.tick()
//                if let n = n {
//                    lock.lock()
//                    newFish.append(n)
//                    lock.unlock()
//                }
//            }
//
//            self.fish.append(contentsOf: newFish)
//            print("After day \(i): \(self.fish.count)")
//        }
//        return self.fish.count
//    }
//
//    public func part1() -> Int {
//        return multiply(days: 80)
//    }
//
//    public func part2() -> Int {
//        return multiply(days: 256)
//    }
//}
//
//class Fish: CustomStringConvertible {
//    var timer: Int
//
//    init() {
//        self.timer = 8
//    }
//
//    init(timer: Int) {
//        self.timer = timer
//    }
//
//    var description: String {
//        return "\(timer)"
//    }
//
//    func tick() -> Fish? {
//        if timer == 0 {
//            timer = 6
//            return Fish()
//        }
//        timer -= 1
//        return nil
//    }
//}
