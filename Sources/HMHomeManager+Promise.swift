//
//  HomeKit+Promises.swift
//  Onboarding
//
//  Created by Chris Chares on 6/28/18.
//  Copyright © 2018 Hunter Douglas. All rights reserved.
//

import Foundation
import PromiseKit
import HomeKit

extension HMHomeManager {
    public func homes() -> Promise<[HMHome]> {
        return HMHomeManagerProxy().promise
    }
    
    public func addHome(withName name: String) -> Promise<HMHome> {
        return Promise { seal in
            self.addHome(withName: name, completionHandler: seal.resolve)
        }
    }
    
    public func removeHome(_ home: HMHome) -> Promise<Void> {
        return Promise { seal in
            self.removeHome(home, completionHandler: seal.resolve)
        }
    }
    
    public func updatePrimaryHome(_ home: HMHome) -> Promise<Void> {
        return Promise { seal in
            self.updatePrimaryHome(home, completionHandler: seal.resolve)
        }
    }
}

fileprivate let timeout = 5.0

internal class HMHomeManagerProxy: PromiseProxy<[HMHome]>, HMHomeManagerDelegate {
    
    fileprivate let manager: HMHomeManager

    override init() {
        self.manager = HMHomeManager()
        super.init()
        self.manager.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
            self?.fulfill([])
        }
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        fulfill(manager.homes)
    }
}
