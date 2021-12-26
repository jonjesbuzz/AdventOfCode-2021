import Foundation

/// Solution provides basic functionality for validating the test input and providing the answer to the actual puzzle input.
public protocol Solution : AnyObject {

    /// The type of the provided input.
    associatedtype InputType
    /// The type of the answer.
    associatedtype AnswerType: Equatable

    /// The Input instance with the test and actual input.
    var inputs: Input<InputType> { get }

    /// The actual input being operated on.
    ///
    /// When this value is set, ``reset()`` MUST be called to rebuild any data structures held by the Solution instance.
    var activeInput: InputType { get set }

    /// The answers to part 1 and part 2's test input.
    var testAnswer: Answer<AnswerType> { get }

    /// This function should reset any data structures held by the instance.
    ///
    /// Generally, you should create any structures held by your solution as a function of the ``activeInput``.
    /// > Important: This method **must** be called if ``activeInput`` is changed during execution.
    func reset()

    /// The implementation of part 1.
    func part1() -> AnswerType

    /// The implementation of part 2.
    func part2() -> AnswerType
}

public extension Solution {

    /// Executes part 1 and part 2 with the test input defined in the problem.
    ///
    /// If the answer does not match what is given in ``testAnswer``, an assertion is thrown to stop the program.
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

        print("""
              [Test] Part 1: \(ans1), Part 2: \(ans2)
              """)
    }


    /// Executes part 1 and part 2 with the actual puzzle input,
    /// and will print out the answer to part 1 and part 2.
    func runWithActualInput() {
        self.activeInput = inputs.actual

        reset()

        let ans1 = part1()
        print("[Actual] Part 1 answer: \(ans1)")

        reset()

        let ans2 = part2()
        print("[Actual] Part 2 answer: \(ans2)")

        print("""
              [Actual] Part 1: \(ans1), Part 2: \(ans2)
              """)
    }
}
