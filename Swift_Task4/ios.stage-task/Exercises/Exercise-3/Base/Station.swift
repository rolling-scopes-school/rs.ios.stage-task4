import Foundation

protocol Station {
    func users() -> [User] // All added users
    func add(user: User)
    func remove(user: User)

    func execute(action: CallAction) -> CallID?

    func calls() -> [Call] // All calls
    func calls(user: User) -> [Call]

    func call(id: CallID) -> Call?
    func currentCall(user: User) -> Call? // .calling or .talk call
}

enum CallAction {
    case start(from: User, to: User)
    case answer(from: User)
    case end(from: User)
}
