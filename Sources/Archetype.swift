import Foundation

final class Archetype {
    var components: [ComponentSignature: ComponentList] = [:]
    var entities: [Entity] = []
    
    private var _name: String

    init(_ entity: Entity, list componentsList: [Component]) {
        for component in componentsList {
            let signature = component.signature
            var componentList = ComponentList()
            componentList.addComponent(component)
            self.components[signature] = componentList
        }

        let entityHash = entity.signature
        var entityComponentList = ComponentList()
        entityComponentList.addComponent(entity)
        self.components[entityHash] = entityComponentList

        self.entities.append(entity)
        
        _name = componentsList.map{
            String(describing: Mirror(reflecting: $0).description)
        }.joined(separator: ",")
    }

    public static func hash(in name: String) -> Int {
        return name.hashValue
    }
    
    public func addEntity(entity: Entity, components: [Component]) {
        for component in components {
            
            if var componentList =  self.components[component.signature] {
                componentList.addComponent(component)
                self.components[component.signature] = componentList
            } else {
                var componentList = ComponentList()
                componentList.addComponent(component)
                self.components[component.signature] = componentList
            }
        }

        self.components[entity.signature]?.addComponent(entity)
        self.entities.append(entity)
    }

    public func addComponent<T>(_ component: T) throws(ArchetypeError) where T: Component {
        if var componentList = self.components[component.signature] {
            componentList.addComponent(component)
        } else {
            throw ArchetypeError.componentNotFound
        }
    }

    public func removeComponent<T: Component>(_ index: Int) throws(ArchetypeError) -> T? {
        if var componentList = self.components[T.signature] {
            return componentList.removeComponent(index)
        } else {
            throw ArchetypeError.componentNotFound
        }
    }

    public func getComponent<T: Component>(_ index: Int, of type: T.Type) throws(ArchetypeError) -> T where T : Component {
        if let componentList = self.components[T.signature] {
            return componentList.getComponent(index)
        } else {
            throw ArchetypeError.componentNotFound
        }
    }

    public func printComponents() {
        for componentList in self.components.values {
            for component in componentList.getComponents() {
                print(component)
            }
        }
    }

    public func getTypes() -> [ComponentSignature] {
        return Array(self.components.keys)
    }
    
    public var name: String {
        return _name
     }
    
    
    public func debugArchetype() {
        print("----------------------")
        print(components)
        print(name)
        print("______________________")
    }
    
}
