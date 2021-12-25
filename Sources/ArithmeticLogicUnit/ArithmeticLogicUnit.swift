import Foundation
import AdventCore

class ArithmeticLogicUnit: Solution {

    var inputs = Day24.input
    var activeInput = ""

    var testAnswer = Answer(part1: 0, part2: 0)
    var program = [ALU.Operation]()

    func reset() {
        let lines = activeInput.stringArray()
        self.program = ALU.assemble(lines)
        print(self.program)
    }

    func part1() -> Int {
        let grouped = self.program.grouped(every: self.program.count / 14)
        var z = 0
        for i in 1...9 {
            for group in grouped {
                let block = Block(group, input: i)
                z = block.nextZ(z)
                print("block", block, "z", z)
            }
        }
        return 0
    }

    func part2() -> Int {
        return 0
    }

}

struct Block: CustomStringConvertible {
    var w: Int
    let xA: Int
    let yA: Int
    let zA: Int

    init(_ lines: [ALU.Operation], input: Int) {
        self.w = input
        self.zA = lines[4].literal!
        self.yA = lines[15].literal!
        self.xA = lines[5].literal!
    }

    func nextZ(_ z: Int = 0) -> Int {
        if w != z % 26 + xA {
            return z / zA * (26 + w + yA)
        } else {
            return z / zA
        }
    }

    var description: String {
        return "w: \(w), xA: \(xA), yA: \(yA), zA: \(zA)"
    }
}

class ALU: CustomStringConvertible {
    enum Variable: Character, Hashable, CaseIterable {
        case w = "w"
        case x = "x"
        case y = "y"
        case z = "z"
    }

    var w: Int { return variables[.w]! }
    var x: Int { return variables[.x]! }
    var y: Int { return variables[.y]! }
    var z: Int { return variables[.z]! }

    func reset() {
        self.variables = [
            .w: 0,
            .x: 0,
            .y: 0,
            .z: 0
        ]
    }

    var variables: [Variable: Int] = [
        .w: 0,
        .x: 0,
        .y: 0,
        .z: 0
    ]

    struct Operation: CustomStringConvertible {
        enum Opcode: String {
            case input = "inp"
            case add = "add"
            case multiply = "mul"
            case divide = "div"
            case modulo = "mod"
            case equal = "eql"
        }
        let opcode: Opcode
        let var0: Variable
        let var1: Variable?
        let literal: Int?

        init(opcode: Opcode, var0: Variable, var1: Variable) {
            self.opcode = opcode
            self.var0 = var0
            self.var1 = var1
            self.literal = nil
        }

        init(opcode: Opcode, var0: Variable, literal: Int) {
            self.opcode = opcode
            self.var0 = var0
            self.literal = literal
            self.var1 = nil
        }

        init(stringValue: String) {
            let components = stringValue.split(separator: " ").map(String.init)
            self.opcode = Opcode(rawValue: components[0])!
            self.var0 = Variable(rawValue: components[1].first!)!
            if opcode == .input {
                self.literal = nil
                self.var1 = nil
                return
            }
            let last = components[2]
            if let value = Int(last) {
                self.literal = value
                self.var1 = nil
            } else {
                self.var1 = Variable(rawValue: last.first!)!
                self.literal = nil
            }
        }

        var description: String {
            let lastOp: String
            if let literal = self.literal {
                lastOp = String(literal)
            } else if let var1 = self.var1 {
                lastOp = String(var1.rawValue)
            } else {
                lastOp = ""
            }
            return "\(self.opcode.rawValue) \(self.var0.rawValue) \(lastOp)".trimmingCharacters(in: .whitespaces)
        }
    }

    static func assemble(_ lines: [String]) -> [Operation] {
        return lines.map(Operation.init(stringValue:))
    }

    func execute(_ operation: Operation, input: Int? = nil) {
        switch operation.opcode {
        case .input:
            self.input(to: operation.var0, value: input!)
        case .add:
            self.doArithmeticOperation(operation, using: +)
        case .multiply:
            self.doArithmeticOperation(operation, using: *)
        case .divide:
            self.doArithmeticOperation(operation, using: /)
        case .modulo:
            self.doArithmeticOperation(operation, using: %)
        case .equal:
            self.doArithmeticOperation(operation, using: { $0 == $1 ? 1 : 0 })
        }
    }

    func input(to variable: Variable, value: Int) {
        self.variables[variable] = value
    }

    func doArithmeticOperation(_ operation: Operation, using function: ((Int, Int)->(Int))) {
        let rhs = operation.literal ?? variables[operation.var1!]!
        let lhs = variables[operation.var0]!
        variables[operation.var0] = function(lhs, rhs)
    }

    var description: String {
        return Variable.allCases.compactMap { "\($0.rawValue): \(self.variables[$0]!)" }.joined(separator: "\n")
    }
}
