//
//  Event+Manager.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 24/12/24.
//

public typealias EventFunction = (World, Event) -> Void

public final class EventManager {
    private var _subscribedFunctions: [EventSignature: [EventFunction]]
    private unowned var _world: World
    
    public init(world: World) {
        _world = world
        _subscribedFunctions = [:]
    }
    
    public func subscribe<Ev: Event>(ev: Ev.Type, _ function: @escaping EventFunction) {
        let signature = ev.signature
        if var item = _subscribedFunctions[signature]{
            item.append(function)
        }else {
            _subscribedFunctions[signature] = [function]
        }
      
    }
    
    public func publish<Ev: Event>(ev: Ev) {
        _subscribedFunctions[ev.signature]?.forEach { $0(_world, ev) }
    }
    
    public func unsubscribe<Ev: Event>(ev: Ev.Type) {
        _subscribedFunctions[ev.signature]?.removeAll()
    }
}


extension EventManager: SystemParams {
    public static func getParam(_ world: World) -> EventManager? {
        world.eventManager
    }
    
    
}
