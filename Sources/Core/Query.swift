import Foundation


@available(macOS 14.0, *)
typealias Query<each Comps: Component> = QueryWithFilter<QueryBuilder<repeat each Comps>, NoExclusions>


final class QueryWithFilter<T: QueryFactory, F: QueryExcludeFactory>{
    typealias ComponentTypes = T.Components

    private unowned var _world: World
    fileprivate var _components: [T.Components] = []
    
    
    init(_ world: World) {
        _world = world
    }
    

    
    @discardableResult
    func execute() -> [T.Components]{
        var components: [T.Components] = []
        
        
        for archetype in _world.archetypes {
            let tSignature = T.getComponentsSignature()
            let contains = tSignature.allSatisfy(archetype.getTypes().contains)
            if contains                {
                for (index, _) in archetype.entities.enumerated() {
                    let comps = T.components(archetype: archetype, entityId: index)
                    components.append(comps)
                }
            }
            
        }
        
        _components = components
        return components
    }
}

extension QueryWithFilter: Sequence  {
    func makeIterator() -> QueryIterator {
        QueryIterator(query: self)
    }
}

extension QueryWithFilter: SystemParams {
    static func getParam(_ world: World) -> Self? {
        .init(world)
    }
}




extension QueryWithFilter {
    class QueryIterator: IteratorProtocol {
        typealias Element = QueryWithFilter.ComponentTypes
        private var _query: QueryWithFilter
        private var _index: Int = 0
    
        init(query: QueryWithFilter) {
            _query = query
            let _ = _query.execute()
        }
        
        
        func next() -> QueryWithFilter.ComponentTypes? {
            let component = _query._components[safe: _index]
            _index += 1
            return component
        }
    }
}





