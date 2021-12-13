// Day 12: Passage Pathing

import Foundation
import AdventCore

class PassagePathing: Solution {

    var inputs: Input<String> = Day12.input
    var activeInput: String = ""

    var testAnswer: Answer<Int> = Answer(part1: 10, part2: 36)

    var adjacencyList: [Vertex: [Vertex]] = [:]
    var vertexes: [String: Vertex] = [:]

    func reset() {
        adjacencyList = [:]
        vertexes = [:]
        let edges = self.activeInput.stringArray()
        for edge in edges {
            let vertices = edge.split(separator: "-").map(String.init)
            if vertexes[vertices[0]] == nil {
                vertexes[vertices[0]] = Vertex(vertices[0])
            }
            if vertexes[vertices[1]] == nil {
                vertexes[vertices[1]] = Vertex(vertices[1])
            }
            let start = vertexes[vertices[0]]!
            let end = vertexes[vertices[1]]!
            adjacencyList[start, default: []].append(end)
            adjacencyList[end, default: []].append(start)
        }
    }

    func search1(v: Vertex, dst: Vertex, visited: Set<Vertex>) -> Int {
        if v == dst { return 1 }
        if v.isSmallCave && visited.contains(v) { return 0 }
        var visited = visited
        visited.insert(v)
        var count = 0
        for adj in (adjacencyList[v] ?? []) {
            count += search1(v: adj, dst: dst, visited: visited)
        }
        return count
    }

    func part1() -> Int {
        print(adjacencyList)

        let start = vertexes["start"]!
        let end = vertexes["end"]!
        return search1(v: start, dst: end, visited: [])
    }

    func search2(v: Vertex, dst: Vertex, visited: Set<Vertex>, duplicate: Vertex? = nil) -> Int {
        if v == dst { return 1 }
        let start = vertexes["start"]!
        if v == start && visited.contains(v) { return 0 }
        var duplicate = duplicate
        if v.isSmallCave && visited.contains(v) {
            if duplicate == nil {
                duplicate = v
            } else {
                return 0
            }
        }
        var visited = visited
        visited.insert(v)
        var count = 0
        for adj in (adjacencyList[v] ?? []) {
            count += search2(v: adj, dst: dst, visited: visited, duplicate: duplicate)
        }
        return count
    }

    func part2() -> Int {
        let start = vertexes["start"]!
        let end = vertexes["end"]!
        return search2(v: start, dst: end, visited: [])
    }
}

class Vertex: Hashable, CustomStringConvertible {
    let value: String
    let isSmallCave: Bool

    init(_ element: String) {
        self.value = element
        self.isSmallCave = (element.uppercased() != element)
    }

    static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.value)
    }

    var description: String {
        return "(\(value))"
    }
}
