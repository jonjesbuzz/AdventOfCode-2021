// Day 25: Sea Cucumber

import Foundation
import AdventCore

class SeaCucumber: Solution {

    var inputs = Day25.input
    var activeInput = ""

    var testAnswer = Answer(part1: 58, part2: 0)
    var grid: [Point: Cucumber] = [:]
    var maxBound: Point = .zero

    func reset() {
        grid = [:]
        let lines = activeInput.stringArray()
        let rows = lines.count
        let columns = lines[0].count
        maxBound = .init(row: rows, column: columns)
        for (r, row) in lines.enumerated() {
            for (c, value) in row.enumerated() {
                if value == "." { continue }
                let point = Point(row: r, column: c)
                grid[point] = Cucumber(point: point, herdValue: value)
            }
        }
//        print("Initial Grid, bounds", maxBound.rowDescription)
//        printGrid()
    }

    func step() -> Bool {
        var didMove = false

        var grid = self.grid
        // East-facing
        print("East")
        for row in 0..<maxBound.row {
            for column in 0..<maxBound.column {
                let point = Point(row: row, column: column)
                if let cucumber = grid[point], cucumber.herd == .east, cucumber.point == point {
                    didMove = doMove(point: point, cucumber: cucumber, in: &grid) || didMove
                }
            }
        }

        self.grid = grid
        fixPoints()

        // South-facing
        print("South")
        for row in 0..<maxBound.row {
            for column in 0..<maxBound.column {
                let point = Point(row: row, column: column)
                if let cucumber = grid[point], cucumber.herd == .south, cucumber.point == point {
                    didMove = doMove(point: point, cucumber: cucumber, in: &grid) || didMove
                }
            }
        }

        self.grid = grid
        fixPoints()
        return didMove
    }

    private func fixPoints() {
        for (point, cucumber) in grid {
            cucumber.point = point
        }
    }

    private func doMove(point: Point, cucumber: Cucumber, in grid: inout [Point: Cucumber]) -> Bool {
        var didMove = false
        var adjacentPoint = point.adjacentPoint(at: cucumber.herd.direction)

        if adjacentPoint.column >= maxBound.column && cucumber.herd == .east {
            adjacentPoint = Point(row: adjacentPoint.row, column: 0)
        } else if adjacentPoint.row >= maxBound.row && cucumber.herd == .south {
            adjacentPoint = Point(row: 0, column: adjacentPoint.column)
        }

        if self.grid[adjacentPoint] == nil {
//            print("\tMoving \(point.rowDescription) to \(adjacentPoint.rowDescription)")
            grid.removeValue(forKey: point)
            grid[adjacentPoint] = cucumber
            didMove = true
        }

        return didMove
    }

    func part1() -> Int {
        var didMove = false
        var steps = 0
        repeat {
            steps += 1
            print("Step \(steps)")
            didMove = step()
//            printGrid()
        } while didMove

        return steps
    }

    func part2() -> Int {
        return 0
    }

    func printGrid() {
        for row in 0..<maxBound.row {
            for column in 0..<maxBound.column {
                let point = Point(row: row, column: column)
                if let cucumber = grid[point] { print(cucumber.description, terminator: "") }
                else { print(".", terminator: "") }
            }
            print()
        }
    }
}

class Cucumber: CustomStringConvertible {
    var herd: Herd
    var point: Point

    init(point: Point, herd: Herd) {
        self.point = point
        self.herd = herd
    }
    init(point: Point, herdValue: Character) {
        self.point = point
        self.herd = Herd(rawValue: herdValue)!
    }

    enum Herd: Character {
        case east = ">"
        case south = "v"

        var direction: Point.Direction {
            switch self {
            case .east:
                return .right
            case .south:
                return .down
            }
        }
    }

    var description: String {
        return "\(herd.rawValue)"
    }
}
