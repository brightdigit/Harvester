import Combine
import Foundation
import SwiftUI

class World : ObservableObject {
  @Published var buttons : [HVButton]
  @Published var gates: [OpGate]
  
  @Published var gateValues = [OpGateValue]()
  
  func updatePosition(forID id: UUID, position: CGPoint) {
    let index = self.gates.firstIndex{$0.id == id    }
    
    guard let index else {
      preconditionFailure()
    }
    
    self.gates[index].offset = position
  }
  
  init () {
    let buttons = [HVButton(imageName: "007-cloud", color: .blue), HVButton(imageName: "017-fire", color: .orange)]
    self.buttons = buttons
    
    self.gates = [
      OpGate(id: .init(), sources: buttons.map{
      .init(id: $0.id)
      }, operation: AndGateOp(), imageName: "008-coin", color: .red)]
    
    let buttonValueDictionary = self.$buttons.map{
      $0.map{
        ($0.id, $0.isOn)
      }
    }.map(Dictionary.init(uniqueKeysWithValues:))

    
    self.$gates.combineLatest(buttonValueDictionary).map { gates, values in
      return gates.map { gate in
        let values = gate.sources.map{
          values[$0.id]
        }
        let value = gate.operation.compute(values)
        return OpGateValue(gate: gate, value: value)
      }
    }.receive(on: DispatchQueue.main).assign(to: &self.$gateValues)
  }
  
  func bindingFor<CollectionType : MutableCollection, ObjectIdentifierType> (keyPath :
                                                                      ReferenceWritableKeyPath<World, CollectionType>, withID id: ObjectIdentifierType) -> Binding<CollectionType.Element> where CollectionType.Element : Identifiable, CollectionType.Element.ID == ObjectIdentifierType  {
    
    let index = self[keyPath: keyPath].firstIndex(where: {$0.id == id})
    
    guard let index else {
      preconditionFailure()
    }
    
    return .init {
      return self[keyPath: keyPath][index]
    } set: { button in
      self[keyPath: keyPath][index] = button
    }
  }
  
  @available(*, deprecated)
  func bindingForButton(withID id: UUID) -> Binding<HVButton> {
    let keyPath = \World.buttons
    
    return bindingFor(keyPath: keyPath, withID: id)

  }
}
