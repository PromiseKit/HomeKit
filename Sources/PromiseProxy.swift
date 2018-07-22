//
//  PromiseProxy.swift
//  HDSDK
//
//  Created by Chris Chares on 7/16/18.
//  Copyright © 2018 Hunter Douglas. All rights reserved.
//

import PromiseKit

/**
    Commonly used functionality when promisifying a delegate pattern
*/
internal class PromiseProxy<T>: NSObject {
    internal let (promise, seal) = Promise<T>.pending();
    
    private var retainCycle: PromiseProxy?

    override init() {
        super.init()
        // Create the retain cycle
        self.retainCycle = self
        // And ensure we break it
        _ = promise.ensure { self.retainCycle = nil }
    }
    
    /// These functions ensure we only resolve the promise once
    func fulfill(_ value: T) {
        guard self.promise.isResolved == false else { return }
        seal.fulfill(value)
    }
    func reject(_ error: Error) {
        guard self.promise.isResolved == false else { return }
        seal.reject(error)
    }
    
    func cancel() {
        self.reject(PMKError.cancelled)
    }
}

/*
    Commonly used intervals for scanning
*/
public enum ScanInterval {
    // Return after our first item with an optional time limit
    case returnFirst(timeout: TimeInterval?)
    // Scan for this duration before returning all
    case returnAll(interval: TimeInterval)
}
