import Foundation
import HomeKit
#if !PMKCocoaPods
import PromiseKit
#endif

#if !os(tvOS) && !os(watchOS)

@available(iOS 9.0, *)
extension HMEventTrigger {

    @available(iOS 11.0, *)
    public func updateExecuteOnce(_ executeOnce: Bool) -> Promise<Void> {
        return Promise { seal in
            self.updateExecuteOnce(executeOnce, completionHandler: seal.resolve)
        }
    }
    
    @available(iOS 11.0, *)
    public func updateEvents(_ events: [HMEvent]) -> Promise<Void> {
        return Promise { seal in
            self.updateEvents(events, completionHandler: seal.resolve)
        }
    }
    
    @available(iOS 11.0, *)
    public func updateEndEvents(_ events: [HMEvent]) -> Promise<Void> {
        return Promise { seal in
            self.updateEndEvents(events, completionHandler: seal.resolve)
        }
    }
    
    @available(iOS 9.0, *)
    public func updatePredicate(_ predicate: NSPredicate?) -> Promise<Void> {
        return Promise { seal in
            self.updatePredicate(predicate, completionHandler: seal.resolve)
        }
    }
    
    @available(iOS 11.0, *)
    public func updateRecurrences(_ recurrences: [DateComponents]?) -> Promise<Void> {
        return Promise { seal in
            self.updateRecurrences(recurrences, completionHandler: seal.resolve)
        }
    }

}

#endif
