# swift-csv

## Install

Add to your Package.swift dependencies:

```
.package(url: "https://github.com/zackify/swift-csv.git", from: "0.0.4")
```

## Example

Generate CSVs with dynamic column headings and row data.

If you have a data structure with unknown amount of values, it can be frustrating to make that fit into a CSV. For example, imagine a CSV with people, and an unknown number of addresses. With this library, you can return an array, and column headings will be calculated for you:

```swift
import SwiftCSV

let csv = SwiftCSV.generate(testRows) {
    [
        $0.text(name: "Name", value: $0.row.name),
        $0.array(name: "Address", value: $0.row.addresses) { $0.street },
        $0.text(name: "Phone number", value: $0.row.phoneNumber)
    ]
}
```

Here's the output:

```
"Name","Address","Address #2","Address #3","Phone number"
"Test","New York","California","","5493939393"
"Bob","Montana","California","Texas","483884828"
```

By naming the field `Address` the headings and rows fill in with empty data where needed.

In the example, testRows looks like this:

```swift
struct Address {
  var street: String
}

struct Person {
  var id: String
  var name: String
  var phoneNumber: String
  var addresses: [Address]
}

let testRows = [
  Person(
    id: "1",
    name: "Test",
    phoneNumber: "5493939393",
    addresses: [
      Address(street: "New York"),
      Address(street: "California"),
    ]
  ),
  Person(
    id: "1",
    name: "Bob",
    phoneNumber: "483884828",
    addresses: [
      Address(street: "Montana"),
      Address(street: "California"),
      Address(street: "Texas"),
    ]
  )
]
```
