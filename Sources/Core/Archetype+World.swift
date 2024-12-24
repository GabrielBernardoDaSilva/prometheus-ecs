//
//  Archetype+World.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 23/12/24.
//

extension World {
    public func  addEntity(componentList components: [Component]) throws (ArchetypeError) {
        try entityManager.addEntity(componentList: components)
    }
    
    public func addEntity(components: Component...) throws (ArchetypeError) {
        try addEntity(componentList: components)
    }
    

   
}
