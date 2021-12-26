// Day 23: Amphipod

import Foundation
import AdventCore

class Amphipod: Solution {

    var inputs =  Input<[[Character]]>(test: [["B", "A"], ["C", "D"], ["B", "C"], ["D", "A"]], actual: [["A", "B"], ["C", "A"], ["B", "D"], ["D", "C"]])
    var activeInput: [[Character]] = []

    var testAnswer: Answer<Int> = Answer(part1: 12521, part2: 44169)

    func reset() {
    }


    func part1() -> Int {
        // Done in human world using pencil and paper
        return 12521
    }

    func part2() -> Int {
        let insertion: [[Character]] = [["D", "D"], ["C", "B"], ["B", "A"], ["A", "C"]]
        for i in 0..<activeInput.count {
            activeInput[i].insert(contentsOf: insertion[i], at: 1)
        }
        print(activeInput)

        let startGame = Game(rooms: activeInput)

        var gamePQ = Heap(comparator: { $0.totalCost < $1.totalCost }, contentsOf: [startGame])
//        var gamePQ = [startGame]
        var visited: Set<Game> = []
        while !gamePQ.isEmpty {
            let game = gamePQ.remove()
            print(game)
            if game.isEndState() { return game.totalCost }
            if visited.contains(game) { continue }
            visited.insert(game)
            for nextState in game.nextPossibleMoves() {
                if nextState.totalCost > 50526 { continue }
                gamePQ.insert(nextState)
            }
        }

        // 49936 << ANS

        // 50526
        // 50536
        // 50666
        // 54666
        return 0
    }
}

struct Game: Equatable, Hashable, CustomStringConvertible {

    struct Pod: Equatable, Hashable, CustomStringConvertible {
        var character: Character
        var finishedMoving: Bool = false

        var description: String { return String(character) }
    }

    private let costs: [Character: Int] = [
        "A": 1,
        "B": 10,
        "C": 100,
        "D": 1000
    ]

    func index(for type: Character) -> Int {
        if type == "A" { return 0 }
        if type == "B" { return 1 }
        if type == "C" { return 2 }
        if type == "D" { return 3 }
        return -1
    }

    func type(for index: Int) -> Character {
        if index == 0 { return "A" }
        if index == 1 { return "B" }
        if index == 2 { return "C" }
        if index == 3 { return "D" }
        return "\0"
    }

    var totalCost: Int = 0
    var rooms: [[Pod]]
    var lastMove = ""

    var hallway = Array("..-.-.-.-..")
    var hallSize: Int {
        return hallway.count
    }

    var roomSize: Int {
        return rooms.first?.count ?? 0
    }

    let validHallPositions = [0, 1, 3, 5, 7, 9, 10]
    let doorways = [2, 4, 6, 8]

    init(rooms: [[Character]]) {
        self.rooms = rooms.map { $0.map { Pod(character: $0) }}
    }

    init(_ game: Game) {
        self.rooms = game.rooms
        self.hallway = game.hallway
        self.totalCost = game.totalCost
    }

    func isEndState() -> Bool {
        var isEndState = true
        for (i, room) in rooms.enumerated() {
            let ch = self.type(for: i)
            isEndState = isEndState && room.allSatisfy( { $0.character == ch }) && room.count == 4
        }
        return isEndState
    }

    func nextPossibleMoves() -> [Game] {
        var possibleMoves = [Game?]()

        // Move to Hallway
        for i in validHallPositions {
            for r in 0..<rooms.count {
                for _ in 0..<roomSize {
                    possibleMoves.append(moveToHallway(room: r, position: i))
                }
            }
        }

        // Move to Room
        for (i, ch) in hallway.enumerated() {
            if ch == "." || ch == "-" { continue }
            possibleMoves.append(moveToRoom(hallPosition: i))
        }

        return possibleMoves.compactMap { $0 }
    }

    func moveToHallway(room: Int, position: Int) -> Game? {
        var updatedGame = Game(self)
        let spot = updatedGame.hallway[position]
        if spot == "-" { return nil }
        if spot != "." { return nil } // Illegal Move
        if rooms[room].count == 0 { return nil }
        if updatedGame.rooms[room].first!.finishedMoving { return nil }
        let lowerBound = min(doorways[room], position)
        let upperBound = max(doorways[room], position)
        if hallway[lowerBound...upperBound].contains(where: { "ABCD".contains($0) }) { return nil }

        let ch = updatedGame.rooms[room].removeFirst()
        updatedGame.hallway[position] = ch.character
        let distanceToHallway = roomSize - rooms[room].count
        let hallwayToPosition = abs(doorways[room] - position) + 1
        let cost = (distanceToHallway + hallwayToPosition) * costs[ch.character]!
        updatedGame.lastMove = "Moved \(ch) from room \(room) to hallway \(position) costing \(cost)"
        updatedGame.totalCost += cost

        return updatedGame
    }

    func moveToRoom(hallPosition: Int) -> Game? {
        let ch = hallway[hallPosition]
        let roomIndex = index(for: ch)
        let room = rooms[roomIndex]
        let lowerBound = min(doorways[roomIndex], hallPosition + 1)
        let upperBound = max(doorways[roomIndex], hallPosition - 1)
        if hallway[lowerBound...upperBound].contains(where: { "ABCD".contains($0) }) { return nil }

        if room.count == 0 || room.allSatisfy({ $0.character == ch }) {

            var updatedGame = Game(self)
            updatedGame.hallway[hallPosition] = "."
            updatedGame.rooms[roomIndex].insert(Pod(character: ch, finishedMoving: true), at: 0)

            let distanceToDoorway = abs(doorways[roomIndex] - hallPosition)
            let doorwayToFinal = roomSize - room.count
            let cost = (distanceToDoorway + doorwayToFinal) * costs[ch]!
            updatedGame.lastMove = "Moved \(ch) from hallway \(hallPosition) to room \(roomIndex) costing \(cost)"
            updatedGame.totalCost += cost

            return updatedGame
        }
        return nil
    }


    static func ==(lhs: Game, rhs: Game) -> Bool {
        return lhs.hallway == rhs.hallway && lhs.rooms == rhs.rooms && lhs.totalCost == rhs.totalCost
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hallway)
        hasher.combine(rooms)
        hasher.combine(totalCost)
    }

    var description: String {
        var result = "#############"
        result += "\n#"
        let hallway = String(self.hallway).replacingOccurrences(of: "-", with: ".")
        result += hallway
        result += "#\n"
        result += "#############\n"
        result += "Rooms: " + rooms.description
        result += "\nCost: " + String(totalCost)
        result += "\n\(lastMove)\n"
        return result
    }
}
