import Foundation
import PromiseKit
import HomeKit

@available(iOS 8.0, tvOS 10.0, *)
public enum HomeKitError: Error {
    case permissionDeined
}

@available(iOS 8.0, tvOS 10.0, *)
extension HMHomeManager {
    /// - Note: cancelling this promise will cancel the underlying task
    /// - SeeAlso: [Cancellation](http://promisekit.org/docs/)
    public func homes() -> Promise<[HMHome]> {
        return HMHomeManagerProxy().promise
    }
    
    #if !os(tvOS) && !os(watchOS)

    @available(iOS 8.0, *)
    public func addHome(withName name: String) -> Promise<HMHome> {
        return Promise { seal in
            self.addHome(withName: name, completionHandler: seal.resolve)
        }
    }
    
    @available(iOS 8.0, *)
    public func removeHome(_ home: HMHome) -> Promise<Void> {
        return Promise { seal in
            self.removeHome(home, completionHandler: seal.resolve)
        }
    }
    
    @available(iOS 8.0, *)
    public func updatePrimaryHome(_ home: HMHome) -> Promise<Void> {
        return Promise { seal in
            self.updatePrimaryHome(home, completionHandler: seal.resolve)
        }
    }
    
    #endif
}

@available(iOS 8.0, tvOS 10.0, *)
internal class HMHomeManagerProxy: PromiseProxy<[HMHome]>, HMHomeManagerDelegate {
    
    fileprivate let manager: HMHomeManager
    private var task: DispatchWorkItem!

    override init() {
        self.manager = HMHomeManager()
        super.init()
        self.manager.delegate = self
        
        self.task = DispatchWorkItem { [weak self] in
            self?.reject(HomeKitError.permissionDeined)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0, execute: self.task)
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        fulfill(manager.homes)
    }

    override func cancel() {
        self.task.cancel()
        super.cancel()
    }
}
