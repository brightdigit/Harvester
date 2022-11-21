//
//  HVGateView.swift
//  Harvester
//
//  Created by Leo Dion on 11/20/22.
//

import SwiftUI

struct HVGateView: View {
  let updatePosition : (UUID, CGPoint) -> Void
  @Binding var state : OpGateValue
  var simpleDrag: some Gesture {
    
      DragGesture()
          .onChanged { value in
            updatePosition(self.state.id, value.location)
            
          }
  }
    var body: some View {
      ZStack {
        Image(self.state.gate.imageName).resizable().renderingMode(.template).aspectRatio( contentMode: .fit).offset(y: -10).scaleEffect(.init(width: 0.5, height: 0.5)).foregroundColor(state.gate.color)
      }.frame(height: 80).opacity(state.value == true ? 1.0 : 0.5).position(state.gate.offset)
            .gesture(
              simpleDrag
            )
    }
}

struct ValueGateOperation : GateOperation {
  let value : Bool
  func compute(_ values: [Bool]) -> Bool {
    return value
  }
}

struct HVGateView_Previews: PreviewProvider {
    static var previews: some View {
      HVGateView(updatePosition: {_,_ in }, state:
          .constant(.init(gate: .init(id: .init(), sources: [], operation: ValueGateOperation(value: true), imageName: "008-coin", color: .red), value: true))
      )
    }
}
