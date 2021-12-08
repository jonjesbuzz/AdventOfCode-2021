import Foundation

public protocol Solution : AnyObject {
    associatedtype InputType
    associatedtype AnswerType: Equatable

    var inputs: Input<InputType> { get }
    var activeInput: InputType { get set }
    var testAnswer: Answer<AnswerType> { get }

    func reset()

    func part1() -> AnswerType
    func part2() -> AnswerType
}

public extension Solution {

    func runWithTestInput() {
        self.activeInput = inputs.test

        reset()

        let ans1 = part1()
        print("[Test] Part 1 answer: \(ans1); expected \(testAnswer.part1)")
        assert(ans1 == testAnswer.part1, "Part 1 does not match, expected \(testAnswer.part1), but got \(ans1)")

        reset()

        let ans2 = part2()
        print("[Test] Part 2 answer: \(ans2); expected \(testAnswer.part2)")
        assert(ans2 == testAnswer.part2, "Part 2 does not match, expected \(testAnswer.part2), but got \(ans2)")
    }

    func runWithActualInput() {
        self.activeInput = inputs.actual

        reset()

        let ans1 = part1()
        print("[Actual] Part 1 answer: \(ans1)")

        reset()

        let ans2 = part2()
        print("[Actual] Part 2 answer: \(ans2)")
    }
}
