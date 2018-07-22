//
//  HMAcessoryBrowser+Promise.swift
//  Onboarding
//
//  Created by Chris Chares on 6/29/18.
//  Copyright © 2018 Hunter Douglas. All rights reserved.
//

import Foundation
import HomeKit
import PromiseKit

public enum HMPromiseAccessoryBrowserError: Error {
    case noAccessoryFound
}

public class HMPromiseAccessoryBrowser {
    private var proxy: BrowserProxy?

    public func start(scanInterval: ScanInterval) -> Promise<[HMAccessory]> {
        return BrowserProxy(scanInterval: scanInterval).promise
    }
    
    public func stop() {
        proxy?.cancel()
    }
}

private class BrowserProxy: PromiseProxy<[HMAccessory]>, HMAccessoryBrowserDelegate {
    let browser = HMAccessoryBrowser()
    let scanInterval: ScanInterval
    
    init(scanInterval: ScanInterval) {
        self.scanInterval = scanInterval
        super.init()
        
        browser.delegate = self;
        browser.startSearchingForNewAccessories()
        
        //if we have a timeout, set it up
        var timeout: TimeInterval? = nil
        switch scanInterval {
        case .returnAll(let interval): timeout = interval
        case .returnFirst(let interval): timeout = interval
        }
        
        if let timeout = timeout {
            after(seconds: timeout)
            .done { [weak self] () -> Void in
                guard let _self = self else { return }
                _self.reject(HMPromiseAccessoryBrowserError.noAccessoryFound)
            }
        }
    }
    
    override func fulfill(_ value: [HMAccessory]) {
        browser.stopSearchingForNewAccessories()
        super.fulfill(value)
    }
    
    override func reject(_ error: Error ) {
        browser.stopSearchingForNewAccessories()
        super.reject(error)
    }
    
    override func cancel() {
        browser.stopSearchingForNewAccessories()
        super.cancel()
    }
    
    /**
        HMAccessoryBrowser delegate
    */
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        if case .returnFirst = scanInterval {
            fulfill(browser.discoveredAccessories)
        }
    }
}
