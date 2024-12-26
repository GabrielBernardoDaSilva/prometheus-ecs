// The Swift Programming Language
// https://docs.swift.org/swift-book

final class Health: Component {
    var health: Int = 0
    init(health: Int) {
        self.health = health
    }
}

extension Health : CustomStringConvertible {
    var description: String {
        "Health: \(health)"
    }
}

class Position: Component {
    var x: Int = 0
    var y: Int = 0
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Position: CustomStringConvertible{
    var description: String {
        "Position: (\(x),\(y))"
    }
}


class Velocity: Component {
    var dx: Int = 0
    var dy: Int = 0
    
    init(dx: Int, dy: Int) {
        self.dx = dx
        self.dy = dy
    }
}

class GameState : Component{
    public enum State {
        case playing
        case paused
    }
    
    var state: State = .playing
}


class SpawnEvent : Event {
    public let entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
}

extension Velocity: CustomStringConvertible {
    var description: String {
        "Velocity: (\(dx),\(dy))"
    }
}



//var entity = Entity(id: 0, location: 0)

//var archetype = Archetype(
//    &entity, list: Health(health: 100), Position(x: 0, y: 0), Velocity(dx: 0, dy: 0))
//archetype.printComponents()



var world = World()
try world.addEntity(components:  Health(health: 100), Position(x: 0, y: 0))
try world.addEntity(components:  Health(health: 200))
try world.addEntity(components:  Velocity(dx: 20, dy: 0), Health(health: 70))
//try world.addEntity(components:  Health(health: 300))
//try world.addEntity(components:  Health(health: 500))



//
//let result = q.execute()
//for (h, p) in result {
//    print(h.health, p.x, p.y)
//}
//

// let q1 = Query<Health>()
// let res1 = q1.findAll(in: &world)
// print("Query result:")
// for r in res1 {
//     print(r)
// }



let q = world.query(requiredAll: Health.self, Position.self)
for (e, p) in q {
    print(p, e.health)
}

func spawn(entityManager: EntityManager,eventManager: EventManager, query: Query<Entity, Health, Position>) {
    print("Spawn")
    for q in query{
        try? entityManager.addComponentToEntity(entity: q.0, component: Velocity(dx: 0, dy: 0))
        print(q.0)
        
    }
    
    eventManager.subscribe(SpawnEvent.self) { (world: World, ev: SpawnEvent) in
        
        print("Ev: \(ev.entity)")
    }
    
}

func checkWithAddComponent(entityManager: EntityManager,eventManager: EventManager, query: Query<Entity, Health, Position, Velocity>) {
    print("Check")
    for q in query{
        _ = try? entityManager.removeComponentFromEntity(entity: q.0) as Velocity.Type
        print("Second \(q.0)")
        eventManager.publish( SpawnEvent(entity: q.0))
        
    }
}

func removeEntity(entityManager: EntityManager, query: QueryWithFilter<QueryBuilder<Entity, Health>, QueryBuilderExclude<Position>>) {
    for (entity,_ ) in query {
        try? entityManager.removeEntity(entity)
        print("Remove entity \(entity)")
    }
}

func initResource(resourceManager: ResourceManager) {
    resourceManager.createResource(GameState())
}

func getResource(gameState: Resource<GameState>) {
    print(gameState.data.state)
}

func coroutineManagerTest(coroutineManager: CoroutineManager){
    coroutineManager.addCoroutine(name: "CoroutineTest", action: [
        (10.0, {(World) in print("CoroutineTest is playing1")}),
        (10.0, {(World) in print("CoroutineTest is playing2")})
    ])
}

_ = Query<Health, Position>.getParam(world)

world.addSystemFunction(schedule: .start, spawn)

world.addSystemFunction(schedule: .start, checkWithAddComponent)

world.addSystemFunction(schedule: .start, removeEntity)

world.addSystemFunction(schedule: .start, initResource)

world.addSystemFunction(schedule: .start, getResource)

world.addSystemFunction(schedule: .start, coroutineManagerTest)


world.executeSystems()
world.entityManager.printAllArchetypes()


//struct NewPosition: Positionable {
//    var x: Int
//    var y: Int
//}
//



//var contigeusList = ContiguousList<NewPosition>()
//contigeusList.append(NewPosition(x: 1, y: 2))
//contigeusList.append(NewPosition(x: 3, y: 4))
//contigeusList.append(NewPosition(x: 5, y: 6))
//contigeusList.append(NewPosition(x: 7, y: 8))
//contigeusList.append(NewPosition(x: 9, y: 10))
//contigeusList.append(NewPosition(x: 11, y: 12))
//
//contigeusList.printList()
//
//let position = try contigeusList.getElementMutate(at: 2)
//position.pointee!.x = 20
//print( " Retrive pointer \(position.pointee!.x)")
//
//let lastItem = try contigeusList.pop()
//print("Remove \(lastItem!.x)")
//
//contigeusList.printList()
//let removeItem = try contigeusList.removeAt(index: 2)
//print("RemoveAt \( removeItem!.x)")
//contigeusList.printList()
