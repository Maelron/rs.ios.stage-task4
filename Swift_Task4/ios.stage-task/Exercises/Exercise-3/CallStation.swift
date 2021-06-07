import Foundation

final class CallStation {
    var userList: Set<User> = []
    var callHistory: [CallID: Call] = [:]
    var currentCallHistory: [CallID: Call] = [:]
}

extension CallStation: Station {
    func users() -> [User] {
        return Array(userList)
    }
    
    func add(user: User) {
        userList.insert(user)
    }
    
    func remove(user: User) {
        if let call = currentCall(user: user) {
            let errorCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .error))
            currentCallHistory[call.incomingUser.id] = nil
            currentCallHistory[call.outgoingUser.id] = nil
            callHistory[call.id] = errorCall
        }
        userList.remove(user)
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case let .start(from: user1, to: user2):
            
            if !userList.contains(user1) && !userList.contains(user2) {
                return nil
            }
            
            if userList.contains(user1) {
                if !userList.contains(user2) {
                    let errorCall = Call(id: CallID(), incomingUser: user2, outgoingUser: user1, status: .ended(reason: .error))
                    callHistory[errorCall.id] = errorCall
                    return errorCall.id
                }
            }
            
            if currentCall(user: user1) != nil || currentCall(user: user2) != nil {
                let busyCall = Call(id: CallID(), incomingUser: user2, outgoingUser: user1, status: .ended(reason: .userBusy))
                callHistory[busyCall.id] = busyCall
                return busyCall.id
            }
            
            let call = Call(id: CallID(), incomingUser: user2, outgoingUser: user1, status: .calling)
            callHistory[call.id] = call
            currentCallHistory[user1.id] = call
            currentCallHistory[user2.id] = call
            return call.id
            
        case let .answer(from: user):
            
            if let incomingCall = currentCallHistory[user.id], incomingCall.status == .calling, incomingCall.incomingUser == user {
                let answeredCall = Call(id: incomingCall.id, incomingUser: incomingCall.incomingUser, outgoingUser: incomingCall.outgoingUser, status: .talk)
                callHistory[incomingCall.id] = answeredCall
                currentCallHistory[incomingCall.incomingUser.id] = answeredCall
                currentCallHistory[incomingCall.outgoingUser.id] = answeredCall
                return answeredCall.id
            }
            
        case let .end(from: user):
            
            if let call = currentCallHistory[user.id] {
                currentCallHistory[call.incomingUser.id] = nil
                currentCallHistory[call.outgoingUser.id] = nil
                let status: CallStatus
                if call.status == .talk {
                    status = .ended(reason: .end)
                } else {
                    status = .ended(reason: .cancel)
                }
                let endedCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: status)
                callHistory[call.id] = endedCall
                return endedCall.id
            }
        }
        
        return nil
    }
    
    func calls() -> [Call] {
        return Array(callHistory.values)
    }
    
    func calls(user: User) -> [Call] {
        let userCalls = callHistory.filter { key, value in
            return value.incomingUser == user || value.outgoingUser == user
        }
        
        return Array(userCalls.values)
    }
    
    func call(id: CallID) -> Call? {
        return callHistory[id]
    }
    
    func currentCall(user: User) -> Call? {
        return currentCallHistory[user.id]
    }
}
