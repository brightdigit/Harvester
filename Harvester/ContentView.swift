//
//  ContentView.swift
//  Harvester
//
//  Created by Leo Dion on 11/20/22.
//

import SwiftUI

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
