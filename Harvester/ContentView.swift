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
      NavigationView{
        ZStack {
          ForEach(self.world.buttons) { button in
            HVButtonView(
              state:
                self.world.bindingFor(keyPath: \.buttons, withID: button.id)
            )
          }
          ForEach(self.world.gateValues) { gate in
            HVGateView(updatePosition: self.world.updatePosition(forID:position:), state:  self.world.bindingFor(keyPath: \.gateValues, withID: gate.id))
          }
        }.toolbar {
          ToolbarItemGroup {
            HStack{
              Button {
                
              } label: {
                Image(systemName: "plus")
              }
            }
          }
        }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
