public class Columns {
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