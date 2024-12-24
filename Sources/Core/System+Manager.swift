//
//  SystemManager.swift
//  SwifiECS
//
//  Created by Gabriel Bernardo on 24/12/24.
//

public class SystemManager {
    private var _systems: [System] = []
    private var _systemsFunctional: [SystemFunctionExecution:[SystemExecutable]] = [:]
}

// MARK: System Class
extension SystemManager {
    public func addSystem(_ system: System) {
        _systems.append(system)
    }
    
    public func start() {
        _systems.forEach { $0.start() }
    }
    
    public func update() {
        _systems.forEach { $0.update() }
    }
    
    public func dispose() {
        _systems.forEach { $0.dispose() }
    }
}

// MARK: System Functional
extension SystemManager {
    public func addSystemFunctional(schedule: SystemFunctionExecution, action systemFunctional: SystemExecutable) {
        if let systemFunctional = _systemsFunctional[schedule] {
            _systemsFunctional[schedule]?.append(contentsOf: systemFunctional)
        } else {
            _systemsFunctional[schedule] = [systemFunctional]
        }
    }
    
    private func executeSystemFunctional(schedule: SystemFunctionExecution) {
        _systemsFunctional[schedule]?.forEach { $0.run() }
    }
    
    public func startFunctional() {
        executeSystemFunctional(schedule: .start)
    }
    
    public func updateFunctional() {
        executeSystemFunctional(schedule: .update)
    }
    
    public func disposeFunctional() {
        executeSystemFunctional(schedule: .dispose)
    }
}


// MARK: Run all systems

extension SystemManager {
    public func runAllSystems() {
        start()
        startFunctional()
        update()
        updateFunctional()
        dispose()
        disposeFunctional()
    }
    
    
    public func runAllForegroundSystems(isRunning: Bool) {
        while isRunning {
            update()
            updateFunctional()
        }
       
    }
}

