//
//  System+World.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 23/12/24.
//

extension World {
    private func startSystems() {
        systemManager.start()
        systemManager.startFunctional()
    }
    
    private func updateSystems() {
        systemManager.update()
        systemManager.updateFunctional()
        coroutineManager.updateAllCoroutines()
    }
    
    private func disposeSystems() {
        systemManager.dispose()
        systemManager.disposeFunctional()
    }
    
    public func executeSystems() {
        isRunning = true
        
        startSystems()
        while isRunning {
            updateSystems()
        }
        disposeSystems()
    }
    
    public func singleExecuteSystems() {
        startSystems()
        updateSystems()
        disposeSystems()
    }
}


extension World {
    public func addSystem(_ system: System) {
        systemManager.addSystem(system)
    }
}


extension World {
    @available(macOS 14.0, *)
    func addSystemFunction<each P: SystemParams>(schedule: SystemFunctionExecution, _ systemFunction: @escaping (repeat each P) -> ()) where repeat each P: SystemParams {
        let function = SystemFunction<repeat each P>(execute: systemFunction, world: self)
        systemManager.addSystemFunctional(schedule: schedule, action: function)
    }
}
