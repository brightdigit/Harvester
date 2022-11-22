import Foundation

struct OpGateValue : Identifiable {
  var gate : OpGate
  let value : Bool?
  
  var id: UUID {
    return gate.id
  }
}
