import Foundation
import SwiftUI

struct OpGate : Identifiable {
  let id : UUID
  var name : String = ""
  var sources : [Source]
  var operation : GateOperation
  var offset : CGPoint = .init(x: 20, y: 20)
  var imageName : String
  var color : Color
}
