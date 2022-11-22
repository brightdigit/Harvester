//
//  HVButton.swift
//  Harvester
//
//  Created by Leo Dion on 11/20/22.
//

import SwiftUI

struct HVButton : Identifiable {
  let id : UUID = UUID()
  var name : String = ""
  var isOn : Bool = false
  var offset : CGPoint = .init(x: 20, y: 20)
  var imageName : String
  var color : Color
}

struct HVButtonView: View {
  var simpleDrag: some Gesture {
    
      DragGesture()
          .onChanged { value in
            self.state.offset = value.location
          }
  }
  @Binding var state : HVButton
    var body: some View {
      ZStack {
        Image("046-push button").resizable().aspectRatio( contentMode: .fit)
        Image(self.state.imageName).resizable().renderingMode(.template).aspectRatio( contentMode: .fit).offset(y: -10).scaleEffect(.init(width: 0.5, height: 0.5)).foregroundColor(state.color)
      }.frame(height: 80).opacity(state.isOn ? 1.0 : 0.5).position(state.offset)     .onTapGesture {
                self.state.isOn.toggle()
              }
            .gesture(
              simpleDrag
            )
    }
}

struct HVButton_Previews: PreviewProvider {
    static var previews: some View {
      HVButtonView(state: .constant(.init(imageName: "017-fire", color: .orange)))
    }
}
