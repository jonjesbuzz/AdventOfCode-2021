// Day 13: Transparent Origami

import Foundation
import AdventCore

class TransparentOrigami: Solution {

    var inputs: Input<String> = Day13.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 17, part2: 0)
    var folds: [Fold] = []
    var points: Set<Point> = []

    func reset() {
        let pieces = activeInput.components(separatedBy: "\n\n")
        self.points = Set(pieces[0].stringArray().map(Point.init(stringValue:)))
        self.folds = pieces[1].stringArray().map { $0.replacingOccurrences(of: "fold along ", with: "") }.map(Fold.init(stringValue:))
    }

    func part1() -> Int {
        let fold = self.folds.first!
        self.points = self.fold(fold, points: self.points)
        return self.points.count
    }

    func part2() -> Int {
        var points = self.points
        for fold in folds {
            points = self.fold(fold, points: points)
//            print(points)
        }

        let maxX = points.map { $0.x }.max()! + 1
        let maxY = points.map { $0.y }.max()! + 1
//        print(maxX, maxY)

        var grid = Grid(rows: maxY, columns: maxX, initialValue: false)
        for point in points {
            grid[point] = true
        }
        print(grid.origamiRepresentation)

        // Note: Part 2 was to read the printed output as a string
        // There is no numeric answer for this.
        return 0
    }

    func fold(_ fold: Fold, points: Set<Point>) -> Set<Point> {
        return Set(points.map { point in
            switch fold {
            case .up(let y):
                if y > point.y { return point }
                return Point(x: point.x, y: 2 * y - point.y)
            case .left(let x):
                if x > point.x { return point }
                return Point(x: 2 * x - point.x, y: point.y)
            }
        })
    }
}

enum Fold {
    case up(y: Int)
    case left(x: Int)

    init(stringValue: String) {
        let split = stringValue.split(separator: "=")
        let val = Int(split[1])!
        if split[0] == "x" {
            self = .left(x: val)
        } else {
            self = .up(y: val)
        }
    }
}

extension Grid where Element == Bool {
    var origamiRepresentation: String {
        var rep = ""
        for r in self.grid {
            for c in r {
                if c { rep += "#" }
                else { rep += "." }
            }
            rep += "\n"
        }
        return rep
    }

/* This logic doesn't work for some reason. */
//    func fold(along fold: Fold) -> Grid<Bool> {
//        switch fold {
//        case .up(let y):
//            return self.foldUp(y: y)
//        case .left(let x):
//            return self.foldLeft(x: x)
//        }
//    }
//
//    private func foldUp(y: Int) -> Grid<Bool> {
//        var foldedGrid = Grid(rows: y, columns: self.columns, initialValue: false)
//
//        // Copy over into new grid
//        for r in 0..<y {
//            for c in 0..<columns {
//                foldedGrid[r, c] = self[r, c]
//            }
//        }
//
//        for r in (y + 1)..<rows {
//            for c in 0..<columns {
//                foldedGrid[rows - r - 1, c] = foldedGrid[rows - r - 1, c] || self[r, c]
//            }
//        }
//
//        return foldedGrid
//    }
//
//    private func foldLeft(x: Int) -> Grid<Bool> {
//        var foldedGrid = Grid(rows: self.rows, columns: x, initialValue: false)
//
//        // Copy over into new grid
//        for r in 0..<rows {
//            for c in 0..<x {
//                foldedGrid[r, c] = self[r, c]
//            }
//        }
//
//        for r in 0..<rows {
//            for c in (x + 1)..<columns {
//                foldedGrid[r, columns - c - 1] = foldedGrid[r, columns - c - 1] || self[r, c]
//            }
//        }
//
//        return foldedGrid
//    }
}
