
protocol GateOperation {
  func compute (_ values: [Bool]) -> Bool
}

extension GateOperation {
  func compute (_ values: [Bool?]) -> Bool? {
    let compactValues = values.compactMap{$0}
    guard compactValues.count == values.count else {
      return nil
    }
    return self.compute(compactValues)
  }
}
