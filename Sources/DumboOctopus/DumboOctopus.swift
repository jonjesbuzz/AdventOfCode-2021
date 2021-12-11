// Day 11: Dumbo Octopus

import Foundation
import AdventCore

class DumboOctopus: Solution {

    var inputs: Input<String> = Day11.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 1656, part2: 195)

    var grid = Grid(rows: 0, columns: 0, initialValue: 0)

    func reset() {
        self.grid = Grid(matrix: activeInput.stringArray().map { $0.singleDigitIntArray() })
    }

    func tick(grid: Grid<Int>) -> Grid<Bool> {
        for r in 0..<grid.rows {
            for c in 0..<grid.columns {
                grid[r, c] += 1
            }
        }

        let didFlash = Grid(rows: grid.rows, columns: grid.columns, initialValue: false)
        while grid.flattened.contains(where: { $0 >= 10 }) {
            // Flash all the ones that reached 10 or more
            for r in 0..<grid.rows {
                for c in 0..<grid.columns {
                    // If this octopus already flashed, we ignore it.
                    if grid[r, c] >= 10 && !didFlash[r, c] {
                        didFlash[r, c] = true

                        // Up, Down, Left, Right
                        if r > 0 { grid[r - 1, c] += 1 }
                        if r < grid.rows - 1 { grid[r + 1, c] += 1 }
                        if c > 0 { grid[r, c - 1] += 1 }
                        if c < grid.columns - 1 { grid[r, c + 1] += 1 }

                        // Diagonals
                        if r > 0 && c > 0 { grid[r - 1, c - 1] += 1 }
                        if r < grid.rows - 1 && c > 0 { grid[r + 1, c - 1] += 1 }
                        if r > 0 && c < grid.columns - 1 { grid[r - 1, c + 1] += 1 }
                        if r < grid.rows - 1 && c < grid.columns - 1 { grid[r + 1, c + 1] += 1 }
                    }
                }
            }

            // Set all the ones that flashed to 0.
            for r in 0..<grid.rows {
                for c in 0..<grid.columns {
                    if didFlash[r, c] {
                        grid[r, c] = 0
                    }
                }
            }
        }
        return didFlash
    }

    func part1() -> Int {
        let ticks = 100
        var flashCount = 0

        for _ in 0..<ticks {
            let didFlash = self.tick(grid: self.grid)
            let stepCount = didFlash.flattened.reduce(into: 0) { partialResult, flashed in
                partialResult += flashed ? 1 : 0
            }
            flashCount += stepCount
//            print("After step \(i + 1) (\(stepCount) flashes):\n\(grid)")
//            print()
        }

        return flashCount
    }

    func part2() -> Int {
        var ticks = 0

        // We can just wait for the grid to only contain 0s
        while !grid.flattened.filter({ $0 != 0 }).isEmpty {
            ticks += 1
            let _ = tick(grid: self.grid)
        }

        return ticks
    }
}
