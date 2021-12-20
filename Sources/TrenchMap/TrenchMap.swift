// Day 20: Trench Map

import Foundation
import AdventCore

class TrenchMap: Solution {

    var inputs: Input<String> = Day20.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 35, part2: 3351)

    var algorithm = [Bool]()
    var map = [Point: Bool]()
    var minPoint: Point = .zero
    var maxPoint: Point = .zero

    func reset() {
        self.map = [:]
        let parts = activeInput.components(separatedBy: "\n\n")
        self.algorithm = parts[0].map { $0 == "#" }

        let map = parts[1]
        let lines = map.stringArray()
        for (r, row) in lines.enumerated() {
            for (c, value) in row.enumerated() {
                let p = Point(row: r, column: c)
                self.map[p] = (value == "#")
            }
        }
        self.minPoint = .zero
        self.maxPoint = Point(row: lines.count, column: lines[0].count)
//        debugPrintMap()
    }

    func enhance(_ i: Int) {
        let minP = minPoint
        let maxP = maxPoint
        var map = map
        for row in minP.row-2...maxP.row+2 {
            for col in minP.column-2...maxP.column+2 {
                let p = Point(row: row, column: col)
                var bits = [Bool]()

                for r0 in (p.row - 1)...(p.row + 1) {
                    for c0 in (p.column - 1)...(p.column + 1) {
                        let p0 = Point(row: r0, column: c0)
                        let def: Bool
                        if algorithm[0] {
                            def = i % 2 == 1 ? algorithm[0] : algorithm[511]
                        } else {
                            def = false
                        }
                        bits.append(self.map[p0, default: def])
                        if c0 < minPoint.column { minPoint = Point(row: minPoint.row, column: c0) }
                        if c0 >= maxPoint.column { maxPoint = Point(row: maxPoint.row, column: c0 + 1) }
                    }
                    if r0 < minPoint.row { minPoint = Point(row: r0, column: minPoint.column) }
                    if r0 >= maxPoint.row { maxPoint = Point(row: r0 + 1, column: maxPoint.column) }
                }

                assert(bits.count == 9)
                var idx = 0
                for b in bits {
                    idx = idx << 1
                    if b { idx += 1 }
                }
                map[p] = algorithm[idx]
                //                    print("Point", p, map[p]! ? "#" : ".", "AlgI", idx)
            }
        }
        self.map = map
//        debugPrintMap()
    }

    func part1() -> Int {
        for i in 0..<2 {
            enhance(i)
        }
        return map.values.filter { $0 == true }.count
    }

    func debugPrintMap() {
        for row in minPoint.row..<maxPoint.row {
            for col in minPoint.column..<maxPoint.column {
                let p = Point(row: row, column: col)
                print(map[p, default: algorithm[0]] ? "#" : ".", terminator: "")
            }
            print()
        }
    }

    func part2() -> Int {
        for i in 0..<50 {
            enhance(i)
        }
        return map.values.filter { $0 == true }.count
    }
}
