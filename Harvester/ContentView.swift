//
//  ContentView.swift
//  Harvester
//
//  Created by Leo Dion on 11/20/22.
//

import SwiftUI

class World : ObservableObject {
  @Published var buttons : [HVButton]
  
  
  init () {
    self.buttons = [HVButton(imageName: "007-cloud", color: .blue), HVButton(imageName: "017-fire", color: .orange)]
  }
  
  func bindingForButton(withID id: UUID) -> Binding<HVButton> {
    let index = self.buttons.firstIndex(where: {$0.id == id})
    
    guard let index else {
      preconditionFailure()
    }
    
    return .init {
      return self.buttons[index]
    } set: { button in
      self.buttons[index] = button
    }

  }
}

struct ContentView: View {
  @StateObject var world = World()

  
    var body: some View {
      ForEach(self.world.buttons) { button in
        let buttonBinding = self.world.bindingForButton(withID: button.id)
              HVButtonView(state: buttonBinding)
      }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
