class Columns {
  var counts: [String: Int]
  var tempCounts: [String: Int]
  var names: [String]

  init() {
    self.counts = [:]
    self.tempCounts = [:]
    self.names = []
  }

  func headings() -> String {
    let headings = self.names.map { (name) -> [String] in
      var heading: [String] = []
      let lastIndex = self.counts[name]! - 1

      for index in 0...lastIndex {
        if index == 0 {
          heading.append(name)
        } else {
          heading.append("\(name) #\(index + 1)")
        }
      }
      return heading
    }.flatMap {$0}
   
   return arrayToCSVRow(headings)
  }
  
  func next() {
    //check if temp count is larger than current max count for item
    self.tempCounts.forEach { key, value in 
      if self.counts[key] == nil || self.counts[key]! < self.tempCounts[key]! {
        self.counts[key] = self.tempCounts[key]
      }
    }
    self.tempCounts = [:]
  }

  func incrementCount(_ name: String) {
    if self.tempCounts[name] != nil {
      return self.tempCounts[name]! += 1
    }

    if !names.contains(name) {
      names.append(name)
    }
    return self.tempCounts[name] = 1
  }
}

class RowRenderer<Row> {
  var row: Row
  var columns: Columns
  var rowData: [String]

  init(row: Row, columns: Columns) {
    self.row = row
    self.rowData = []
    self.columns = columns
  }

  func text(name: String, value: String) -> Cell {
    self.columns.incrementCount(name)
    return Cell([value], name)
  } 

  func array<Value>(name: String, value: [Value], callback: (Value) -> String) -> Cell {   
    let items = value.map { (item) -> String in
      self.columns.incrementCount(name)
      return callback(item)
    }
    return Cell(items, name)
  }
}

class Cell {
  var name: String
  var value: [String]

  init(_ value: [String], _ name: String) {
    self.name = name
    self.value = value
  }

  func text(_ columns: Columns) -> String {
    let lastIndex = columns.counts[self.name]! - 1

    for index in 0...lastIndex {
      if(!self.value.indices.contains(index)) {
        self.value.append("")
      }
    }

    return arrayToCSVRow(self.value)
  }
}

func GenerateCSV<Row>(_ rows: [Row], renderRow: (RowRenderer<Row>) -> [Cell]) -> String {
  let columns = Columns()

  // We loop over all rows once, so we can find the column headers
  // one row may have more array items, so the headings have to loop all rows 
  let resultRow = rows.map { row -> [Cell] in
    let rowRenderer = RowRenderer(row: row, columns: columns)
    let rowItem = renderRow(rowRenderer)
    columns.next()
    return rowItem
  }

  // now that we have correct column counts, we can render the individual rows and cells
  let results = resultRow.map{ 
    $0.map{
      $0.text(columns)
    }.joined(separator: ",") 
  }.joined(separator: "\n")

  return """
  \(columns.headings())
  \(results)
  """
}

func arrayToCSVRow(_ strings: [String]) -> String {
  return strings.map { 
    "\"\($0)\"" 
  }.joined(separator: ",")
}