import Foundation
import AdventCore

public class HydrothermalVent: Solution {
    var lines: [Line]
    var grid: Grid<Int>

    public var inputs: Input<String>
    public var activeInput: String
    public var testAnswer: Answer<Int>

    init() {
        self.lines = []
        self.grid = Grid(rows: 0, columns: 0, initialValue: 0)
        self.inputs = Day5.input
        self.activeInput = inputs.test
        self.testAnswer = Answer(part1: 5, part2: 12)
    }

    public func reset() {
        self.lines = self.activeInput.stringArray().map(Line.init)
        let allPoints = Set(self.lines.flatMap { [$0.start, $0.end] })
        let maxX = allPoints.map { $0.x }.max()! + 1
        let maxY = allPoints.map { $0.y }.max()! + 1
        print("grid dimension: \(maxY), \(maxX)")
        self.grid = Grid(rows: maxY, columns: maxX, initialValue: 0)
    }

    public func part1() -> Int {
        for line in self.lines {
            if line.start.x == line.end.x {
                for i in min(line.start.y, line.end.y)..<max(line.start.y, line.end.y)+1 {
                    grid[i, line.start.x] += 1
                }
            } else if line.start.y == line.end.y {
                for i in min(line.start.x, line.end.x)..<max(line.start.x, line.end.x)+1 {
                    grid[line.start.y, i] += 1
                }
            } else {
                //                  print("Skipping \(line)")
            }
            //              print("After \(line)\n", grid, "\n")
        }
        //          print("Final grid:\n\(grid)")
        let answer = grid.flattened.filter { $0 > 1 }.count
        return answer
    }

    public func part2() -> Int {
        for line in self.lines {
            if line.start.x == line.end.x {
                for i in min(line.start.y, line.end.y)..<max(line.start.y, line.end.y)+1 {
                    grid[i, line.start.x] += 1
                }
            } else if line.start.y == line.end.y {
                for i in min(line.start.x, line.end.x)..<max(line.start.x, line.end.x)+1 {
                    grid[line.start.y, i] += 1
                }
            } else { // Diagonal
                let dX = (line.start.x < line.end.x) ? 1 : -1
                let dY = (line.start.y < line.end.y) ? 1 : -1
                var currX = line.start.x
                var currY = line.start.y
                while (dX > 0 && currX <= line.end.x) || (dX < 0 && currX >= line.end.x) {
                    grid[currY, currX] += 1
                    currX += dX
                    currY += dY
                }
            }
            //              print("After \(line)\n", grid, "\n")
        }
        return grid.flattened.filter { $0 > 1 }.count
    }
}
