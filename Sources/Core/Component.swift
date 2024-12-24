public protocol Component: AnyObject {
    /// Unique, immutable identifier of this component type.
    static var signature: ComponentSignature { get }

    /// Unique, immutable identifier of this component type.
    var signature: ComponentSignature { get }
}

public struct ComponentSignature{
    private let _id : Identifier
    
    public var id: Identifier { _id }
    
    @usableFromInline init(_ componentType: (some Component).Type) {
        _id = ObjectIdentifier(componentType).hashValue
    }
}

extension ComponentSignature : Hashable {}
extension ComponentSignature : Equatable {}
extension ComponentSignature: CustomStringConvertible {
    public var description: String { "\(id)" }
}



extension Component {
    public static var signature: ComponentSignature { ComponentSignature(Self.self) }
    @inline(__always)
    public var signature: ComponentSignature { Self.signature }
}




struct ComponentList {
    public var components: [AnyObject] = []
}


extension ComponentList {
    public mutating func addComponent<T> (_ component: T) where T: AnyObject{
        components.append(component)
    }
    public mutating func removeComponent<T>(_ index: Int) -> T? {
        return components.remove(at: index) as? T
    }

    public func getComponent<T: Component>(_ index: Int) -> T {
        return unsafeDowncast(components[index], to: T.self)
    }

    public func getComponents() -> [Any] {
        return components
    }
}
