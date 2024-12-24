final public class World {
    internal var archetypes: [Archetype] = []
    internal var entities: [Entity] = []
    internal var plugins: [PluginBuilder] = []
    internal var systems: [System] = []
    internal var coroutines: [CoroutineSignature: TimedCoroutine] = [:]
    
    internal lazy var entityManager: EntityManager = .init(world: self)
    
    
    public var isRunning: Bool = false
}
