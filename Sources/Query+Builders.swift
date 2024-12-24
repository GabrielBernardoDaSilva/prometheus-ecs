//
//  QueryBuilders.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 22/12/24.
//


@available(macOS 14.0.0, *)
struct QueryBuilder<each Comp>: QueryFactory where repeat each Comp: Component {
   
    
    typealias ComponentTypes = (repeat (each Comp).Type)
    typealias Components = (repeat each Comp)
    
    init() {}
    
    static func getComponentsSignature() -> [ComponentSignature] {
        var signatures: [ComponentSignature] = []
        for type in repeat (each Comp).signature {
            signatures.append(type)
        }
        return signatures
    }
    
    static func components(archetype: Archetype, entityId: Int) -> (repeat each Comp) {
        return (repeat try! archetype.getComponent(entityId, of: (each Comp).self))
    }
}


@available(macOS 14.0.0, *)
struct QueryBuilderExclude<each Comp>: QueryExcludeFactory where repeat each Comp: Component {
 
    typealias ComponentTypes = (repeat (each Comp).Type)
    
    init() {}
  
    static func getExcludedSignatures() -> [ComponentSignature] {
        var signatures: [ComponentSignature] = []
        for type in repeat (each Comp).signature {
            signatures.append(type)
        }
        return signatures
    }
}





struct NoExclusions: QueryExcludeFactory {
    init(){
        
    }
    static func getExcludedSignatures() -> [ComponentSignature] {
        return []
    }
}
