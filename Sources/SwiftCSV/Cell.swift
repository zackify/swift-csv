public class Cell {
  var name: String
  var value: [String]

  init(_ value: [String], _ name: String) {
    self.name = name
    self.value = value
  }

  public func text(_ columns: Columns) -> String {
    let lastIndex = columns.counts[self.name]! - 1

    for index in 0...lastIndex {
      if(!self.value.indices.contains(index)) {
        self.value.append("")
      }
    }

    return arrayToCSVRow(self.value)
  }
}