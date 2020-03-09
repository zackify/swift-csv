import XCTest
@testable import SwiftCSV

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

final class swift_csvTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        let csv = SwiftCSV.generate(testRows) {
            [
                $0.text(name: "Name", value: $0.row.name),
                $0.array(name: "Address", value: $0.row.addresses) { $0.street },
                $0.text(name: "Phone number", value: $0.row.phoneNumber)
            ]
        }

        XCTAssertEqual(csv, 
            """
            "Name","Address","Address #2","Address #3","Phone number"
            "Test","New York","California","","5493939393"
            "Bob","Montana","California","Texas","483884828"
            """
        )    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
