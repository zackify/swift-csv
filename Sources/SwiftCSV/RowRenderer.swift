public class RowRenderer<Row> {
  public var row: Row
  var columns: Columns
  var rowData: [String]

  init(row: Row, columns: Columns) {
    self.row = row
    self.rowData = []
    self.columns = columns
  }

  public func text(name: String, value: String) -> Cell {
    self.columns.incrementCount(name)
    return Cell([value], name)
  } 

  public func array<Value>(name: String, value: [Value], callback: (Value) -> String) -> Cell {   
    let items = value.map { (item) -> String in
      self.columns.incrementCount(name)
      return callback(item)
    }
    return Cell(items, name)
  }
}