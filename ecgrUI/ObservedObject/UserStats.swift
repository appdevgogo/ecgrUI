import Foundation
import SwiftUI
import Combine

class UserState: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    
    var currentPosition = false {
        willSet {
            self.objectWillChange.send()
        }
    }
}


class TestObject: ObservableObject {
    @Published var text = "변경전 내용"
}
