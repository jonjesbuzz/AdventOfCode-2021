// Day 19: Beacon Scanner

import Foundation
import AdventCore

class BeaconScanner: Solution {

    var inputs: Input<String> = Day19.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 79, part2: 0)

    var scanners: [[Point3D]] = []

    func reset() {
        let lines = activeInput.stringArray()
        var scannerIndex = -1
        for line in lines {
            if line.isEmpty { continue }
            if line.contains("---") {
                scannerIndex += 1
                scanners.append([])
            } else {
                scanners[scannerIndex].append(Point3D(stringValue: line))
            }
        }
        print(scanners)
    }


    func part1() -> Int {
//        let distanceSets: [Set<Point3D>] = scanners.map { scanner in
//            var distanceSet = Set<Point3D>()
//            for beacon1 in scanner {
//                for beacon2 in scanner {
//                    distanceSet.insert(beacon1.manhattanDistance(to: beacon2))
//                }
//            }
//            return distanceSet
//        }
//
//        print(distanceSets.map(\.description).joined(separator: "\n"))
//
//        for ds0 in distanceSets {
//            for (i, ds1) in distanceSets.enumerated() {
//                if ds0 == ds1 { continue }
//                let intersect = ds1.intersection(ds0)
//                if intersect.count >= 12 { print ("Hello Frank!", i, intersect.count) }
//            }
//        }

//        var knownBeacons = Set(scanners[0])
//        var unknownBeacons = scanners[1...]

//        for unknown in unknownBeacons {
//            let rotated = unknown.map { $0.rotations }
//            for rotate in rotated {
//                let set = Set(rotate)
//            }
//        }

        return 0
    }

    func part2() -> Int {
        return 0
    }
}

struct Point3D: CustomStringConvertible, Hashable {
    let x: Int
    let y: Int
    let z: Int

    static func ==(lhs: Point3D, rhs: Point3D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }

    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    init(stringValue: String) {
        let s = stringValue.intArray(separatedBy: ",")
        self.x = s[0]
        self.y = s[1]
        self.z = s[2]
    }

    var description: String {
        return "\(String(x)),\(String(y)),\(String(z))"
    }

    func distance(to point: Point3D) -> Double {
        let dx = point.x - self.x
        let dy = point.y - self.y
        let dz = point.z - self.z
        return sqrt(Double(dx * dx + dy * dy + dz * dz))
    }

    func manhattanDistance(to point: Point3D) -> Point3D {
        return Point3D(x: abs(point.x - self.x), y: abs(point.y - self.y), z: abs(point.z - self.z))
    }

    // https://stackoverflow.com/questions/16452383/how-to-get-all-24-rotations-of-a-3-dimensional-array
    var rotations: [Point3D] {
        var rotations = [Point3D]()
        var v = self
        for _ in 0..<2 {
            for _ in 0..<3 {
                v = v.rolled
                rotations.append(v)
                for _ in 0..<3 {
                    v = v.turned
                    rotations.append(v)
                }
            }
            v = v.rolled.turned.rolled
        }
        print(rotations.count)
        return rotations
    }

    private var rolled: Point3D {
        return .init(x: x, y: z, z: -y)
    }

    private var turned: Point3D {
        return .init(x: -y, y: x, z: z)
    }

    static let zero = Point3D(x: 0, y: 0, z: 0)
}
