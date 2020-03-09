struct SwiftCSV {
  static func generate<Row>(_ rows: [Row], renderRow: (RowRenderer<Row>) -> [Cell]) -> String {
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
}

func arrayToCSVRow(_ strings: [String]) -> String {
  return strings.map { 
    "\"\($0)\"" 
  }.joined(separator: ",")
}