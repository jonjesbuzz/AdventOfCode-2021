# ``AdventCore/Point``

## Point Representations
Point instances represent either an (x,y) coordinate, or a (row, column) pair.

```swift
let pointA = Point(x: 10, y: 2)
let pointB = Point(row: 3, column: 5)
```

> Important: Points can be translated between (x,y) and (row, column) freely. Be careful when mixing and matching points constructed with different representations, as ``row`` corresponds to the ``y`` coordinate, and ``column`` corresponds to the ``x`` coordinate.

### Computing Adjacent Points
Point provides support for generating adjacent points and, optionally, for validating that the point exists within a grid.

```swift
let pointA = Point(x: 10, y: 3)
let left = pointA.adjacentPoint(at: .left)

let grid = Grid(rows: 2, columns: 2, initialValue: false)
let pointB = Point(row: 0, column: 0)
let right = pointB.adjacentPoint(at: .downRight, in: grid)
```

## Topics

### Zero Point
- ``zero``

### (x,y) Representation
- ``init(x:y:)``
- ``x``
- ``y``

### Row-Column Representation
- ``init(row:column:)``
- ``row``
- ``column``

### String Representation
- ``init(stringValue:)``
- ``description``

### Finding Adjacent Points
- ``Direction``
- ``adjacentPoint(at:)``
- ``adjacentPoint(at:in:)``

### Range Comparison
- ``containedWithin(xRange:yRange:)``
- ``containedWithin(rowRange:columnRange:)``

