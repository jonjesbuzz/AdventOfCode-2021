// Day 15: Chiton

import Foundation
import AdventCore

class Chiton: Solution {

    var inputs: Input<String> = Day15.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 40, part2: 315)

    var grid: Grid<Int> = Grid(matrix: [])

    func reset() {
        let matrix = activeInput.stringArray().map { $0.singleDigitIntArray }
        self.grid = Grid(matrix: matrix)
    }

    func part1() -> Int {
        let start = self.grid.startPoint
        let destination = self.grid.endPoint
        return self.grid.minCost(from: start, to: destination)
    }

    func part2() -> Int {
        var newGrid = Grid(rows: grid.rows * 5, columns: grid.columns * 5, initialValue: 0)
        for (r, row) in newGrid.grid.enumerated() {
            for (c, _) in row.enumerated() {
                let ri = r / grid.rows
                let ci = c / grid.columns
                let ro = r % grid.rows
                let co = c % grid.columns
                var newVal = grid[ro, co] + ri + ci
                if newVal > 9 { newVal %= 9 }
                newGrid[r, c] = newVal
            }
        }

        let start = newGrid.startPoint
        let destination = newGrid.endPoint

        return newGrid.minCost(from: start, to: destination)
    }
}

extension Int {
}
