// Day 21: Dirac Dice

import Foundation
import AdventCore

class DiracDice: Solution {

    var inputs =  Input(test: [4, 8], actual: [4, 5])
    var activeInput = [Int]()

    var testAnswer: Answer<Int> = Answer(part1: 739785, part2: 444356092776315)

    var die = DeterministicDie()
    var player1 = Player(position: 0)
    var player2 = Player(position: 0)
    var quantumRolls: [Int] = []

    func reset() {
        die = DeterministicDie()
        player1 = Player(position: activeInput[0])
        player2 = Player(position: activeInput[1])

        quantumRolls = []
        for i in 1...3 {
            for j in 1...3 {
                for k in 1...3 {
                    quantumRolls.append(i + j + k)
                }
            }
        }
        cache = [:]
    }


    func part1() -> Int {
        let scoreBound = 1000
        while player1.score < scoreBound && player2.score < scoreBound {
            let p1move = die.roll(times: 3).reduce(0, +)
            player1.move(p1move)
//            print("Player 1", p1move, "Position", player1.position, "Score", player1.score)
            if player1.score >= scoreBound { break }
            
            let p2move = die.roll(times: 3).reduce(0, +)
            player2.move(p2move)
//            print("Player 2", p2move, "Position", player2.position, "Score", player2.score)
        }
//        print("player 1 score", player1.score)
//        print("player 2 score", player2.score)
        return min(player1.score, player2.score) * die.rolls
    }

    func part2() -> Int {
        let (my, other) = part2(myPosition: self.player1.position, myScore: 0, otherPosition: self.player2.position, otherScore: 0)
        return max(my, other)
    }

    var cache: [Memoization: Result] = [:]

    // Thanks to this individual for explaining it.
    // https://github.com/mebeim/aoc/blob/master/2021/README.md#day-21---dirac-dice
    func part2(myPosition: Int, myScore: Int, otherPosition: Int, otherScore: Int) -> (Int, Int) {
        if myScore >= 21 { return (1,0) }
        if otherScore >= 21 { return (0,1) }

        let memoization = Memoization(myPos: myPosition, myScore: myScore, otherPos: otherPosition, otherScore: otherScore)
        if let val = cache[memoization] {
            return (val.me, val.other)
        }

        var myWins = 0
        var otherWins = 0

        for roll in self.quantumRolls {
            let newPosition = (myPosition + roll - 1) % 10 + 1
            let newScore = myScore + newPosition

            let (ow, mw) = part2(myPosition: otherPosition, myScore: otherScore, otherPosition: newPosition, otherScore: newScore)

            myWins += mw
            otherWins += ow
        }

        cache[memoization] = Result(me: myWins, other: otherWins)
        return (myWins, otherWins)
    }

    func player(for index: Int) -> Player {
        if index < 0 || index > 1 { fatalError() }
        if index == 0 { return self.player1 }
        return self.player2
    }
}

struct Result: Hashable {
    let me: Int
    let other: Int
}

struct Memoization: Hashable {
    let myPos: Int
    let myScore: Int
    let otherPos: Int
    let otherScore: Int

    static func ==(lhs: Memoization, rhs: Memoization) -> Bool {
        return lhs.myPos == rhs.myPos &&
            lhs.myScore == rhs.myScore &&
            lhs.otherPos == rhs.otherPos &&
            lhs.otherScore == rhs.otherScore
    }
}

struct DeterministicDie {
    private(set) var value = 1
    private(set) var rolls = 0

    mutating func roll() -> Int {
        let v = value
        value += 1
        rolls += 1
        if value > 100 { value = 1 }
        return v
    }

    mutating func roll(times n: Int) -> [Int] {
        var vals: [Int] = []
        for _ in 0..<n {
            vals.append(roll())
        }
        return vals
    }
}

class Player {
    var position: Int
    var score: Int

    init(position: Int) {
        self.position = position
        self.score = 0
    }

    func move(_ positions: Int) {
        self.position = (self.position + positions - 1) % 10 + 1
        self.score += self.position
    }
}
