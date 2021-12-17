// Day 17: Trick Shot

import Foundation
import AdventCore

class TrickShot: Solution {

    var inputs: Input = Input(test: (x: 20...30, y: (-10)...(-5)), actual: (x: 137...171, y: (-98)...(-73)))
    var activeInput = (x: (0...1), y: (0...1))

    var testAnswer: Answer<Int> = Answer(part1: 45, part2: 112)

    var velocity = (x: 0, y: 0)

    func reset() {
    }

    func step(_ point: Point) -> Point {
        let newX = point.x + self.velocity.x
        let newY = point.y + self.velocity.y

        self.velocity.y -= 1

        if self.velocity.x > 0 {
            self.velocity.x -= 1
        } else if self.velocity.x < 0 {
            self.velocity.x += 1
        }

        return Point(x: newX, y: newY)
    }

    // This is by far the worst brute force I've ever done.
    // The solution is actually `abs(activeInput.y.lowerBound) * (abs(activeInput.y.lowerBound) - 1) / 2`.
    func part1() -> Int {
        var maxY = 0
        for x in -100...100 {
            for y in -100...100 {
                self.velocity = (x, y)
                var point = Point(x: 0, y: 0)
                var didIntersect = false
                let oldMaxY = maxY
                while (velocity.x != 0 && point.x <= activeInput.x.upperBound) || point.y >= activeInput.y.lowerBound {
                    point = step(point)
                    maxY = max(point.y, maxY)
                    let isIntersecting = point.containedWithin(xRange: activeInput.x, yRange: activeInput.y)
                    if isIntersecting {
                        didIntersect = true
                    } else if !isIntersecting && didIntersect {
                        break
                    }
                }
                if !didIntersect {
                    maxY = oldMaxY
                }
            }
        }

        return maxY
    }

    // This is even worse.
    func part2() -> Int {
        var intersectCounts = 0
        for x in -500...500 {
            for y in -500...500 {
                self.velocity = (x, y)
                var point = Point(x: 0, y: 0)
                var didIntersect = false
                while (velocity.x != 0 && point.x <= activeInput.x.upperBound) || point.y >= activeInput.y.lowerBound {
                    point = step(point)
                    let isIntersecting = point.containedWithin(xRange: activeInput.x, yRange: activeInput.y)
                    if isIntersecting {
                        didIntersect = true
                        intersectCounts += 1
                        break
                    } else if !isIntersecting && didIntersect {
                        break
                    }
                }
            }
        }
        return intersectCounts
    }
}
