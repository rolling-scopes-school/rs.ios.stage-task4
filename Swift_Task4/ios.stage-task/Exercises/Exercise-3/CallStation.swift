import Foundation

final class CallStation { }

extension CallStation: Station {
    func users() -> [User] {
        []
    }
    
    func add(user: User) {

    }
    
    func remove(user: User) {

    }
    
    func execute(action: CallAction) -> CallID? {
        nil
    }
    
    func calls() -> [Call] {
        []
    }
    
    func calls(user: User) -> [Call] {
        []
    }
    
    func call(id: CallID) -> Call? {
        nil
    }
    
    func currentCall(user: User) -> Call? {
        nil
    }
}
