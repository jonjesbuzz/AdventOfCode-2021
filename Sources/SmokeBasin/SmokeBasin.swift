// Day 9: Smoke Basin

import Foundation
import AdventCore

class SmokeBasin: Solution {
    var inputs: Input<String> = Day9.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 15, part2: 1134)

    var basin: Grid = Grid(rows: 0, columns: 0, initialValue: 0)

    func reset() {
        let rows = activeInput.stringArray()
        let matrix = rows.map { Array($0).map { $0.wholeNumberValue! } }
        self.basin = Grid(matrix: matrix)
    }

    func part1() -> Int {
        var lowPoints = [Int]()
        let rowBound = self.basin.rows
        let colBound = self.basin.columns
        for (r, row) in self.basin.grid.enumerated() {
            for (c, val) in row.enumerated() {
                if r > 0 && self.basin[r - 1, c] <= val { continue }
                if r < rowBound - 1 && self.basin [r + 1, c] <= val { continue }
                if c > 0 && self.basin[r, c - 1] <= val { continue }
                if c < colBound - 1 && self.basin[r, c + 1] <= val { continue }
                lowPoints.append(val)
            }
        }
        return lowPoints.reduce(lowPoints.count, +)
    }

    func part2() -> Int {
        let rowBound = self.basin.rows
        let colBound = self.basin.columns

        // Perform a DFS on the grid to group the basins together
        let members = Grid(rows: rowBound, columns: colBound, initialValue: -1)

        var currentBasin = 0 // Gives each basin an identifier
        var visited = Set<Point>()

        for r in 0..<rowBound {
            for c in 0..<colBound {
                if basin[r, c] == 9 { continue }
                var stack = [Point(row: r, column: c)]
                while !stack.isEmpty {
                    guard let curr = stack.popLast() else { break }
                    guard !visited.contains(curr) else { continue }
                    visited.insert(curr)
                    if basin[curr] == 9 { continue }
                    if curr.row + 1 < rowBound { stack.append(Point(row: curr.row + 1, column: curr.column)) }
                    if curr.row > 0 { stack.append(Point(row: curr.row - 1, column: curr.column)) }
                    if curr.column + 1 < colBound { stack.append(Point(row: curr.row, column: curr.column + 1)) }
                    if curr.column > 0 { stack.append(Point(row: curr.row, column: curr.column - 1)) }
                    members[curr] = currentBasin
                }
                currentBasin += 1
            }
        }

        // Count how many of each identifier we got, excluding the -1 values
        var sizes = [Int: Int]()
        for vals in members.flattened.filter({ $0 != -1 }) {
            sizes[vals, default: 0] += 1
        }

        // A fancy way to say get the product of the three largest
        return sizes.values.sorted(by: >)[0..<3].reduce(1, *)
    }
}
