
struct AndGateOp : GateOperation {
  func compute(_ values: [Bool]) -> Bool {
    values.allSatisfy{$0}
  }
}
