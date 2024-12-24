//
//  Coroutine+World.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 23/12/24.
//

extension World {
    
    public func addCoroutine(name: String, action coroutine: Action) -> CoroutineSignature{
        let timedCoroutine = TimedCoroutine(name, coroutine, self)
        coroutines[timedCoroutine.signature] = timedCoroutine
        return timedCoroutine.signature
    }
    
    public func removeCoroutine(signature: SignatureType) throws(CoroutineError) {
        switch signature {
        case .coroutine(let signature):
            guard coroutines[signature] != nil else {
                throw CoroutineError.coroutineNotFounded
            }
            coroutines[signature] = nil
        case .named(let name):
            guard let coroutine = coroutines.first(where: { $0.value.name == name }) else {
                throw CoroutineError.coroutineNotFounded
            }
            coroutines[coroutine.key] = nil
        }
        
        
    }
    
    public func excuteCoroutines() {
        for coroutine in coroutines.values {
            coroutine.next() == .finished ? coroutines[coroutine.signature] = nil : ()
        }
    }
    
    public func stopCoroutines(signature: SignatureType) throws (CoroutineError){
        guard let coroutine = searchCoroutine(signature: signature) else { throw CoroutineError.coroutineNotFounded }
        coroutine.isRunning = false
        
    }
    
    private func searchCoroutine(signature: SignatureType) -> TimedCoroutine? {
        switch signature {
        case .coroutine(let signature):
            return coroutines[signature]
        case .named(let name):
            return coroutines.first(where: { $0.value.name == name })?.value
        }
    }
}
