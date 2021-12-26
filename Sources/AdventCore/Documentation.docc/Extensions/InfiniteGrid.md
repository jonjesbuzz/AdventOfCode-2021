# ``AdventCore/InfiniteGrid``

## Backed by Dictionary
Elements in an InfiniteGrid are stored in a dictionary keyed by ``Point`` instances. The underlying dictionary can be accessed using the ``grid`` property. While it conforms to ``GridProtocol``, it will return `nil` for values that are not defined in the grid.

> Tip: Unlike other grids, InfiniteGrid supports negative indices, and does not impose any limitations on what the row and column values can be.

## Creating an InfiniteGrid
In addition to the default initializer, an InfiniteGrid can be instantiated from a two-dimensional array when the element type conforms to `Equatable`, as shown below.

```swift
let matrix = [
    [0, 2, 3],
    [4, 0, 6],
    [7, 8, 0]
]
let grid = InfiniteGrid(matrix: matrix, defaultValue: 0, startingAt: .zero)
```

## Accessing Values Within the InfiniteGrid
You can index the sparse grid using either integers or ``Point`` instances, as shown below.

```swift
let point = Point(row: 6, column: 4)
grid[3, 1] = 3 // That is, grid[row, column]
grid[point] = 24
```

## Topics

### Creating a Grid

- ``init()``
- ``init(matrix:defaultValue:startingAt:)``

### Getting Values
- ``subscript(_:)``
- ``subscript(_:_:)``
- ``subscript(_:default:)``

### Counting Items and Bounds Checking
- ``count``
- ``capacity``
- ``rows``
- ``columns``
- ``rowRange``
- ``columnRange``
- ``startPoint``
- ``endPoint``
- ``endBound``
- ``occupiedPoints``
- ``contains(point:)``
- ``contains(row:column:)``
- ``containsValue(at:)``

### Representations
- ``grid``
- ``flattened``
- ``orderedList``
- ``description``
