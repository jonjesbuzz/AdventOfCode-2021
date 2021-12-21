// Day 11: Dumbo Octopus

import Foundation
import AdventCore

class DumboOctopus: Solution {

    var inputs: Input<String> = Day11.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 1656, part2: 195)

    var grid = Grid(rows: 0, columns: 0, initialValue: 0)

    func reset() {
        self.grid = Grid(matrix: activeInput.stringArray().map { $0.singleDigitIntArray })
    }

    func tick(grid: inout Grid<Int>) -> Grid<Bool> {
        for r in 0..<grid.rows {
            for c in 0..<grid.columns {
                grid[r, c] += 1
            }
        }

        var didFlash = Grid(rows: grid.rows, columns: grid.columns, initialValue: false)
        while grid.flattened.contains(where: { $0 >= 10 }) {
            // Flash all the ones that reached 10 or more
            for r in 0..<grid.rows {
                for c in 0..<grid.columns {
                    // If this octopus already flashed, we ignore it.
                    let point = Point(row: r, column: c)
                    if grid[point] >= 10 && !didFlash[point] {
                        didFlash[point] = true

                        for direction in Point.Direction.allCases {
                            if let adjacent = point.adjacentPoint(at: direction, in: grid) {
                                grid[adjacent] += 1
                            }
                        }
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
            let didFlash = self.tick(grid: &self.grid)
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
            let _ = tick(grid: &self.grid)
        }

        return ticks
    }
}
