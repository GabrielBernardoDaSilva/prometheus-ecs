//
//  Entity+Manager.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 23/12/24.
//


public final class EntityManager {
    private unowned var _world: World
    
    let id = 10
    
    public init(world: World) {
        _world = world
    }
    
    public func addEntity(components: Component...) throws (ArchetypeError) {
       try _world.addEntity(componentList: components)
    }
}



extension EntityManager: SystemParams {
    static func getParam(_ world: World) -> EntityManager? {
        world.entityManager
    }
}
