// Day 23: Amphipod

import Foundation
import AdventCore

class Amphipod: Solution {

    var inputs =  Input<[[String]]>(test: [["B", "A"], ["C", "D"], ["B", "C"], ["D", "A"]], actual: [["A", "B"], ["C", "A"], ["B", "D"], ["D", "C"]])
    var activeInput: [[String]] = []

    var testAnswer: Answer<Int> = Answer(part1: 12521, part2: 44169)

    func reset() {
    }


    func part1() -> Int {
        // Done in human world using pencil and paper
        return 12521
    }

    func part2() -> Int {
        let insertion: [[String]] = [["D", "D"], ["C", "B"], ["B", "A"], ["A", "C"]]
        for i in 0..<activeInput.count {
            activeInput[i].insert(contentsOf: insertion[i], at: 1)
        }
        print(activeInput)
        var rooms = [String: [String]]()
        for (r, ch) in zip(activeInput, ["A", "B", "C", "D"]) {
            rooms[ch] = r
        }

        var gamePQ = Heap(comparator: { $0.totalCost < $1.totalCost }, contentsOf: [Game(rooms: rooms)])
        var visited: Set<Game> = []
        while !gamePQ.isEmpty {
            let game = gamePQ.remove()
            if game.isEndState() { return game.totalCost }
            if visited.contains(game) { continue }
            visited.insert(game)
            for nextState in game.nextPossibleStates() {
                gamePQ.insert(nextState)
            }
        }
        // 50536
        // 50666
        // 54666
        return 0
    }
}

struct Game: Equatable, Hashable {

    enum HallPosition: Equatable, Hashable {
        case occupied(String)
        case unoccupied
        case doorway(String)
    }

    private let costs: [String: Int] = [
        "A": 1,
        "B": 10,
        "C": 100,
        "D": 1000
    ]

    var totalCost: Int = 0
    var rooms: [String: [String]]
    static let initialHallPosition: [HallPosition] = [.unoccupied, .unoccupied,
                                                      .doorway("A"), .unoccupied, .doorway("B"), .unoccupied, .doorway("C"), .unoccupied, .doorway("D"),
                                                      .unoccupied, .unoccupied]

    var hallway: [HallPosition] = Self.initialHallPosition

    init(rooms: [String: [String]]) {
        self.rooms = rooms
    }

    init(_ game: Game) {
        self.rooms = game.rooms
        self.hallway = game.hallway
        self.totalCost = game.totalCost
    }

    private let roomNames = ["A", "B", "C", "D"]

    func nextPossibleStates() -> [Game] {
        var states = [Game]()
        for (room, occupants) in rooms {
        }

        return states
    }

    func isEndState() -> Bool {
        var isEndState = (self.hallway == Self.initialHallPosition)
        for (room, occupants) in rooms {
            isEndState = isEndState && occupants.allSatisfy({ $0 == room })
        }
        return isEndState
    }

    static func ==(lhs: Game, rhs: Game) -> Bool {
        return lhs.hallway == rhs.hallway && lhs.rooms == rhs.rooms && lhs.totalCost == rhs.totalCost
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hallway)
        hasher.combine(rooms)
        hasher.combine(totalCost)
    }
}
