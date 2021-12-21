# ``AdventCore/Grid``

## Creating a Grid
A Grid can be instantiated with a specified number of rows and columns, and an initial value to prefill the grid with.

```swift
let grid = Grid(rows: 10, columns: 10, initialValue: 0)
```

A Grid can also be instantiated from a two-dimensional array, as shown below.

```swift
let matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]
let grid = Grid(matrix: matrix)
```

## Accessing Values Within the Grid
You can index the grid using either integers or ``Point`` instances, as shown below.

```swift
let point = Point(row: 6, column: 4)
grid[3,1] = 3 // That is, grid[row, column]
grid[point] = 24
```

## Topics

### Creating a Grid

- ``init(rows:columns:initialValue:)``
- ``init(matrix:)``

### Getting Values
- ``subscript(_:)``
- ``subscript(_:_:)``

### Counting Items and Bounds Checking
- ``count``
- ``rows``
- ``columns``
- ``startPoint``
- ``endPoint``
- ``contains(point:)``
- ``contains(row:column:)``

### Representations
- ``grid``
- ``flattened``

### Operations
- ``minCost(from:to:)``
- ``subgrid(from:to:)``
- ``subscript(from:to:)``

