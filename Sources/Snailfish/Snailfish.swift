// Day 18: Snailfish

import Foundation
import AdventCore

class Snailfish: Solution {

    var inputs: Input<String> = Day18.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 4140, part2: 3993)

    var numbers: [[Number]] = []

    func reset() {
        let lines = activeInput.stringArray()
        numbers = lines.map(parseLine(_:))
//        print(numbers.map(\.description).joined(separator: "\n"))
    }

    func parseLine(_ line: String) -> [Number] {
        var num = [Number]()
        var curr = line.startIndex
        var depth = 0
        curr = line.index(curr, offsetBy: 1) // Skip first [
        while curr < line.endIndex {

            // [ increments depth
            // ] decrements depth
            // integer is a literal
            // everything else is garbage
            let char = String(line[curr])
            if let digit = Int(char) {
                num.append(Number(value: digit, depth: depth))
            } else if char == "[" {
                depth += 1
            } else if char == "]" {
                depth -= 1
            }
            curr = line.index(curr, offsetBy: 1)
        }
        return num
    }

    static func add(_ lhs: [Number], _ rhs: [Number]) -> [Number] {
        let answer = lhs + rhs
        answer.forEach { $0.depth = $0.depth + 1 }
        return reduce(answer)
    }

    static func reduce(_ array: [Number]) -> [Number] {
        var array = array
        array = explode(array)
        return array
    }

    static func explode(_ array: [Number]) -> [Number] {
        var array = array
        // If there is an element of depth 4, there's a pair of depth 4
        // They are guaranteed to be adjacent.
        if array.map(\.depth).max()! == 4 {

            // Find the first index of the depth 4 element, label it left
            let leftIndex = array.firstIndex(where: { $0.depth == 4 })!
            // The adjacent element is the right of the pair
            let rightIndex = leftIndex + 1

            // If there's an element to the left, add the left value to it.
            if leftIndex > 0 {
                array[leftIndex - 1].value += array[leftIndex].value
            }
            // If there's an element to the right, add the right value to it.
            if rightIndex < array.endIndex - 1 {
                array[rightIndex + 1].value += array[rightIndex].value
            }

            // Remove the right item
            array.remove(at: rightIndex)

            // The pair itself "explodes" to zero, and lowers in depth.
            array[leftIndex].value = 0
            array[leftIndex].depth = 3

            // Continue searching for pairs to explode in the array.
            array = explode(array)
        }

        // Once we've completed exploding, we go to the split phase.
        array = split(array)
        return array
    }

    static func split(_ array: [Number]) -> [Number] {

        // Check if there's anything to split.
        let shouldSplit = array.map(\.value).contains(where: { $0 >= 10 })
        if !shouldSplit { return array }

        var array = array
        // Find the first index to remove
        let i = array.firstIndex(where: { $0.value >= 10 })!
        let n = array[i]

        // Remove it and replace it with the split pair.
        array.remove(at: i)
        array.insert(contentsOf: [Number(value: n.value / 2, depth: n.depth + 1), Number(value: n.value / 2 + n.value % 2, depth: n.depth + 1)], at: i)
//        print("after split:", array)

        // Since we did a split, we have to go back and try exploding.
        array = explode(array)
        return array
    }

    static func magnitude(_ array: [Number]) -> Int {
        var array = array
        for d in (0...3).reversed() { // Start from depth 3, down to zero.
            var combined = false
            repeat {
                combined = false
                for (i, n) in array.enumerated() {
                    if i == array.endIndex - 1 { break }
                    if d != n.depth { continue }

                    // Grab a pair and combine them according to the 3 * x + 2 * y rule
                    let right = array.remove(at: i + 1)
                    let left = array.remove(at: i)
//                    print("L R", left, right)

                    // Reintroduce it into the list.
                    array.insert(Number(value: 3 * left.value + 2 * right.value, depth: n.depth - 1), at: i)

                    // And break and repeat the loop here.
                    combined = true
                    break
                }
            } while (combined)
        }
        // By the end, we should have only one value left.
        return array[0].value
    }

    func part1() -> Int {
//        print("Magnitude", magnitude(parseLine("[[1,2],[[3,4],5]]")))
        var sum = Self.add(self.numbers[0], self.numbers[1])
//        print("After adding 0 + 1", sum)
        for i in 2..<numbers.count {
            sum = Self.add(sum, numbers[i])
//            print("After adding \(i)", sum)
        }
//        print("Sum", sum)
        return Self.magnitude(sum)
    }

    func part2() -> Int {
//        print("Begin part 2")
        var maxMagnitude = 0

        // Generate index pairs
        for i in 0..<self.numbers.count {
            for j in 0..<self.numbers.count {
                // Skip where i == j
                if i == j { continue }

                // Add i + j
                let m = self.numbers[i]
                let n = self.numbers[j]
                let mn = Self.add(m, n)

                // We're using reference types, sigh
                reset()

                // Add j + i
                let o = self.numbers[i]
                let p = self.numbers[j]
                let nm = Self.add(p, o)

                reset()
//                print("Sums", mn, nm)

                // Compute magnitudes
                let mnMagnitude = Self.magnitude(mn)
                let nmMagnitude = Self.magnitude(nm)
//                print("Magnitudes", mnMagnitude, nmMagnitude)

                // Take the maximum of the triple
                maxMagnitude = max(maxMagnitude, mnMagnitude, nmMagnitude)
            }
        }
        return maxMagnitude
    }
}

class Number: CustomStringConvertible {
    var value: Int
    var depth: Int

    init(value: Int, depth: Int) {
        self.value = value
        self.depth = depth
    }

    var description: String {
        return "\(value) @ depth:\(depth)"
    }
}
