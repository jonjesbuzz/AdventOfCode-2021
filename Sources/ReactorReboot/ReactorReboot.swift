// Day 22: Reactor Reboot

import Foundation
import AdventCore

class ReactorReboot: Solution {

    var inputs: Input<String> = Day22.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 474140, part2: 2758514936282235)
    var steps: [RebootStep] = []

    func reset() {
        let lines = activeInput.stringArray()
        self.steps = lines.map(RebootStep.init(stringValue:))
    }

    func part1_naive() -> Int {

        struct Point3D: Hashable {
            let x: Int
            let y: Int
            let z: Int
        }

        var states: Set<Point3D> = []
        
        for step in steps {
            if !step.ranges.allSatisfy({ r in r.lowerBound >= -50 && r.upperBound <= 50 }) {
                continue
            }
            for x in step.xRange {
                for y in step.yRange {
                    for z in step.zRange {
                        let p = Point3D(x: x, y: y, z: z)
                        if step.on {
                            states.insert(p)
                        } else {
                            states.remove(p)
                        }
                    }
                }
            }
        }
        return states.count
    }

    func countEnabledCubes(_ steps: [RebootStep]) -> Int {
        var cubes: Array<Cube> = []

        for step in steps {
            for cube in cubes {
                cube.subtract(step.cube)
            }
            if step.on {
                cubes.append(step.cube)
            }
        }

        let volumes = cubes.map(\.volume)
        return volumes.reduce(0, +)
    }

    func part1() -> Int {
        self.steps.removeAll(where: { r in !r.ranges.allSatisfy({ r in r.lowerBound >= -50 && r.upperBound <= 50 }) })
        return countEnabledCubes(self.steps)
    }

    func part2() -> Int {
        return countEnabledCubes(self.steps)
    }
}

class Cube: Hashable, CustomStringConvertible {

    static func == (lhs: Cube, rhs: Cube) -> Bool {
        return lhs.ranges == rhs.ranges && lhs.vacuums == rhs.vacuums
    }

    var ranges: [ClosedRange<Int>]

    var xRange: ClosedRange<Int> {
        set { ranges[0] = newValue }
        get { return ranges[0] }
    }
    var yRange: ClosedRange<Int> {
        set { ranges[1] = newValue }
        get { return ranges[1] }
    }
    var zRange: ClosedRange<Int> {
        set { ranges[2] = newValue }
        get { return ranges[2] }
    }

    var vacuums: [Cube] = []

    init(x: ClosedRange<Int>, y: ClosedRange<Int>, z: ClosedRange<Int>) {
        self.ranges = [x, y, z]
    }

    init(stringValue: String) {
        let xyz = stringValue.split(separator: ",")
        self.ranges = xyz.map { n in
            let rangeBounds = n.split(separator: "=")[1].split(separator: ".").map { Int($0)! }
            return rangeBounds[0]...rangeBounds[1]
        }
    }

    func intersects(_ other: Cube) -> Bool {
        for (r0, r1) in zip(self.ranges, other.ranges) {
            if r0.overlaps(r1) { return true }
        }
        return false
    }

    func subtract(_ other: Cube) {
        let newRanges = zip(self.ranges, other.ranges).compactMap { $0.0.intersection($0.1) }
        if newRanges.count != 3 { return }
        let vac = Cube(x: newRanges[0], y: newRanges[1], z: newRanges[2])
        for vacuum in self.vacuums {
            vacuum.subtract(vac)
        }
        vacuums.append(vac)
    }

    var volume: Int {
        return self.ranges.map { $0.upperBound - $0.lowerBound + 1 }.reduce(1, *) - vacuums.map(\.volume).reduce(0, +)
    }

    var description: String {
        return "x=\(xRange),y=\(yRange),z=\(zRange)"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ranges)
        hasher.combine(vacuums)
    }
}

struct RebootStep: CustomStringConvertible, Hashable {
    let on: Bool
    var cube: Cube

    var xRange: ClosedRange<Int> {
        return cube.xRange
    }
    var yRange: ClosedRange<Int> {
        return cube.yRange
    }
    var zRange: ClosedRange<Int> {
        return cube.zRange
    }

    var ranges: [ClosedRange<Int>] {
        return cube.ranges
    }

    init(on: Bool, xRange: ClosedRange<Int>, yRange: ClosedRange<Int>, zRange: ClosedRange<Int>) {
        self.on = on
        self.cube = Cube(x: xRange, y: yRange, z: zRange)
    }

    init(on: Bool, cube: Cube) {
        self.on = on
        self.cube = cube
    }

    init(stringValue: String) {
        let parts = stringValue.split(separator: " ")
        self.on = parts[0] == "on"
        self.cube = Cube(stringValue: String(parts[1]))
    }

    var description: String {
        return "\(on ? "on" : "off") \(cube)"
    }
}
