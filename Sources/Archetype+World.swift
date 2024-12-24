//
//  Archetype+World.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 23/12/24.
//

extension World {
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
            let entity = Entity(id: entities.count, location: location)
            archetype.addEntity(entity: entity, components: components)
        } else {
            let location = archetypes.count + 1
            let entity = Entity(id: entities.count, location: location)
            entities.append(entity)
            let archetype = Archetype(entity, list: components)
            archetypes.append(archetype)
        }
    }
    
    public func addEntity(components: Component...) throws (ArchetypeError) {
        try addEntity(componentList: components)
    }

    private func findArchetype(in types: [ComponentSignature]) -> (Archetype, Int)? {
        for (index, archetype) in archetypes.enumerated() {
            let archetypeTypes = archetype.getTypes()
            if archetypeTypes.allSatisfy(types.contains) && archetypeTypes.count == types.count {
                return (archetype, index)
            }
        }
        return nil
    }
}
