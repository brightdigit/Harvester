//
//  ContentView.swift
//  Harvester
//
//  Created by Leo Dion on 10/27/22.
//

import SwiftUI
import Combine


class Machine : ObservableObject {
  let sourceA = PassthroughSubject<Void, Never>()
  let sourceB = PassthroughSubject<Void, Never>()
  let sourceC = PassthroughSubject<Void, Never>()
  @Published var resultD = false
  @Published var resultE = false
  @Published var resultF = false
  func buttonPressedA() {
    sourceA.send()
  }
  
  
  func buttonPressedB() {
    sourceB.send()
  }
  
  
  func buttonPressedC() {
    sourceC.send()
    
  }
  
  init () {
    let switchA = sourceA.scan(false, { last,_  in
      return !last
    }).prepend(false).share()
    
      let switchB = sourceB.scan(false, { last,_  in
        return !last
      }).prepend(false).share()
    
    
      let switchC = sourceC.scan(false, { last,_  in
        return !last
      }).prepend(false).share()
    
    switchA.receive(on: DispatchQueue.main).assign(to: &self.$resultD)
    
    switchA.combineLatest(switchB).map { a,b in
      return a && b
    }.receive(on: DispatchQueue.main).assign(to: &self.$resultE)
    
    
    switchB.combineLatest(switchC).map { a,b in
      return a != b
    }.receive(on: DispatchQueue.main).assign(to: &self.$resultF)
  }
}

struct ContentView: View {
  @StateObject var machine = Machine()
    var body: some View {
      NavigationView{
          VStack{
            
            Button {
              machine.buttonPressedA()
            } label: {
              Text("A")
              Image(systemName: "target")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            }
            
            Button {
              machine.buttonPressedB()
            } label: {
              Text("B")
              
              Image(systemName: "target")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            }
            
            Button {
              machine.buttonPressedC()
            } label: {
              Text("C")
              
              Image(systemName: "target")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            }
            HStack{
              Text("D")
              Circle().foregroundColor(self.machine.resultD ? .green : .red)
            }
            
            HStack{
              Text("E")
              Circle().foregroundColor(self.machine.resultE ? .green : .red)
            }
            
            HStack{
              Text("F")
              Circle().foregroundColor(self.machine.resultF ? .green : .red)
            }
          }
        .padding().toolbar {
          ToolbarItemGroup {
            Button {
              
            } label: {
              Text("Add")
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
