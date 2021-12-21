/// A binary heap returns elements in sorted order.
public struct Heap<Element> {

    /// The function that compares two elements to determine their ordering.
    /// Returns `true` when elements are in sorted order.
    private var comparator: (Element, Element) -> Bool

    /// The backing array for the heap.
    ///
    /// The first value (at index zero) is always `nil` for easier indexing.
    /// This, unfortunately, means that accessing an element will always return an optional.
    private var heap: [Element?]

    /// Initialize this heap with the provided comparator.
    /// - Parameter comparator: A function that takes two elements and returns `true` if they are in sorted order.
    public init(comparator: @escaping ((Element, Element) -> Bool)) {
        self.heap = [nil]
        self.comparator = comparator
    }

    /// Initialize this heap with the provided comparator, and inserts the elements in the provided sequence.
    ///
    /// - Parameter comparator: A function that takes two elements and returns `true` if they are in sorted order.
    /// - Parameter contentsOf: A sequence to insert into the heap upon initialization.
    public init<S>(comparator: @escaping ((Element, Element) -> Bool), contentsOf elements: S) where Element == S.Element, S : Sequence {
        self.init(comparator: comparator)
        for element in elements {
            self.insert(element)
        }
    }

    /// The number of elements in the heap.
    public var count: Int {
        return heap.count - 1
    }

    /// Returns whether the heap is empty or not.
    public var isEmpty: Bool {
        return self.count == 0
    }

    /// Inserts the given element into the heap.
    /// - Parameter element: The element to insert in the heap.
    public mutating func insert(_ element: Element) {
        heap.append(element)
        heapify(heap.count - 1)
    }

    private mutating func heapify(_ index: Int) {
        if index <= 1 { return }
        let parentIndex = index / 2
        guard let item = heap[index], let parent = heap[parentIndex] else { return }
        if comparator(item, parent) {
            heap[parentIndex] = item
            heap[index] = parent
        }
        heapify(parentIndex)
    }

    /// Removes and returns the next sorted element in the heap.
    ///
    /// If the heap is empty, this method will throw an exception.
    public mutating func remove() -> Element {
        guard !heap.isEmpty else { fatalError("Heap is empty") }
        let returnValue = heap[1]!
        heap[1] = heap[heap.count - 1]
        heap.removeLast()
        if heap.count > 1 {
            downHeapify()
        }
        return returnValue
    }

    private mutating func downHeapify(_ index: Int = 1) {
        guard let item = self.heap[index] else { return }
        let count = self.heap.count
        if index >= count { return }

        let leftIndex = index * 2
        let rightIndex = index * 2 + 1
        var smallest: (index: Int, item: Element) = (index, item)

        if leftIndex < count, let leftItem = self.heap[leftIndex], comparator(leftItem, item) {
            smallest = (leftIndex, leftItem)
        }

        if rightIndex < count, let rightItem = self.heap[rightIndex], comparator(rightItem, smallest.item) {
            smallest = (rightIndex, rightItem)
        }

        if smallest.index == index { return }
        heap[smallest.index] = item
        heap[index] = smallest.item
        downHeapify(smallest.index)
    }
}

public extension Heap where Element: Comparable {

    /// For Elements that conform to `Comparable`, the heap can use the default implementation.
    enum HeapType {
        /// Have the heap perform like a minimum heap, where the smallest values are returned first.
        case minHeap

        /// Have the heap perform like a maximum heap, where the largest values are returned first.
        case maxHeap

        /// The comparator for this heap type.
        internal var comparator: ((Element, Element) -> Bool) {
            switch self {
            case .minHeap:
                return { $0 < $1 }
            case .maxHeap:
                return { $0 > $1 }
            }
        }
    }

    /// Initialize the heap with the given heap type.
    /// - Parameter type: Either a min heap or a max heap.
    init(type: HeapType) {
        self.init(comparator: type.comparator)
    }
}
