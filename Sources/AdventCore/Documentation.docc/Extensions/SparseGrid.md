# ``AdventCore/SparseGrid``

## Backed by Dictionary
Elements in a SparseGrid are stored in a dictionary keyed by ``Point`` instances. The underlying dictionary can be accessed using the ``grid`` property. While it conforms to ``GridProtocol``, it will return `nil` for values that are not defined in the grid, and error out if the indices are not contained within the grid, similar to the array-backed ``Grid``.

> Warning: Manipulating the dictionary directly through the ``grid`` property may lead to undefined behavior. It is recommended to subscript the `SparseGrid` instance directly.

## Creating a SparseGrid
A SpareseGrid can be instantiated with a specified number of rows and columns.

```swift
let grid = SparseGrid<Int>(rows: 10, columns: 10)
```

A SparseGrid can also be instantiated from a two-dimensional array when the element type conforms to `Equatable`, as shown below.

```swift
let matrix = [
    [0, 2, 3],
    [4, 0, 6],
    [7, 8, 0]
]
let grid = SparseGrid(matrix: matrix, defaultValue: 0)
```

## Accessing Values Within the SparseGrid
You can index the sparse grid using either integers or ``Point`` instances, as shown below.

```swift
let point = Point(row: 6, column: 4)
grid[3, 1] = 3 // That is, grid[row, column]
grid[point] = 24
```

## Topics

### Creating a Grid

- ``init(rows:columns:)``
- ``init(matrix:defaultValue:)``

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

### Operations
- ``minCost(from:to:directions:)``

