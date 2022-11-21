//
//  ContentView.swift
//  Harvester
//
//  Created by Leo Dion on 11/20/22.
//

import SwiftUI

struct Source {
  let id : UUID
}

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

struct AndGateOp : GateOperation {
  func compute(_ values: [Bool]) -> Bool {
    values.allSatisfy{$0}
  }
}

struct OpGate : Identifiable {
  let id : UUID
  var sources : [Source]
  var operation : GateOperation
  var offset : CGPoint = .init(x: 20, y: 20)
  var imageName : String
  var color : Color
}

struct OpGateValue : Identifiable {
  var gate : OpGate
  let value : Bool?
  
  var id: UUID {
    return gate.id
  }
}
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
  
  func bindingForButton(withID id: UUID) -> Binding<HVButton> {
    let keyPath = \World.buttons
    
    return bindingFor(keyPath: keyPath, withID: id)
//    let index = self[keyPath: keyPath].firstIndex(where: {$0.id == id})
//
//    guard let index else {
//      preconditionFailure()
//    }
//
//    return .init {
//      return self[keyPath: keyPath][index]
//    } set: { button in
//      self[keyPath: keyPath][index] = button
//    }

  }
}

struct ContentView: View {
  @StateObject var world = World()

  
    var body: some View {
      ForEach(self.world.buttons) { button in
        let buttonBinding = self.world.bindingForButton(withID: button.id)
              HVButtonView(state: buttonBinding)
      }
      
      ForEach(self.world.gateValues) { gate in
        HVGateView(updatePosition: self.world.updatePosition(forID:position:), state:  self.world.bindingFor(keyPath: \.gateValues, withID: gate.id))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
