//
//  Entity+Manager.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 23/12/24.
//


public final class EntityManager {
    private unowned var _world: World
    private var _archetypes: [Archetype] = []
    private var _entities: [Entity] = []
    
    
    public var archetypes: [Archetype] {
        _archetypes
    }
    
    public var entities: [Entity] {
        _entities
    }
    
    public init(world: World) {
        _world = world
    }
    
    public func addEntity(componentList components: [Component]) throws (ArchetypeError) {
        var types = components.map(\.signature)
        var seen = Set<ComponentSignature>()
        if types.contains(where: { !seen.insert($0).inserted }) {
            throw ArchetypeError.componentAlreadyRegistered
        }
        
        
        types.append(Entity.signature)
        if let founded = findArchetype(in: types) {
            let location = founded.1
            let archetype = founded.0
            let entity = Entity(id: _entities.count, location: location)
            archetype.addEntity(entity: entity, components: components)
        } else {
            let location = _archetypes.count + 1
            let entity = Entity(id: _entities.count, location: location)
            _entities.append(entity)
            let archetype = Archetype(entity, list: components)
            _archetypes.append(archetype)
        }
    }
    
    public func addEntity(components: Component...) throws (ArchetypeError) {
        try addEntity(componentList: components)
    }

    private func findArchetype(in types: [ComponentSignature]) -> (Archetype, Int)? {
        for (index, archetype) in _archetypes.enumerated() {
            let archetypeTypes = archetype.getTypes()
            if archetypeTypes.allSatisfy(types.contains) && archetypeTypes.count == types.count {
                return (archetype, index)
            }
        }
        return nil
    }
}



extension EntityManager: SystemParams {
    public static func getParam(_ world: World) -> EntityManager? {
        world.entityManager
    }
}
