public extension String {
    func stringArray(separatedBy separator: Character = "\n") -> [String] {
        return self.split(separator: separator).map(String.init)
    }

    func intArray(separatedBy separator: Character = "\n") -> [Int] {
        return self.split(separator: separator).map { Int($0)! }
    }
}
