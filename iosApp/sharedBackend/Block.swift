//
//  Block.swift
//  checkin
//
//  Created by Justin Carstens on 4/22/20.
//  Copyright © 2020 cvent. All rights reserved.
//

import UIKit

@objcMembers
class Block : NSObject {
    
    /**
     Perform a block of code on the Background Thread.
     
     - parameter block: Block of code to execute.
     */
    class func performInBackground(_ block: @escaping ()->()) {
        DispatchQueue.global(qos: .background).async(execute: block)
    }
    
    /**
     Perform a block of code on a Background Thread and optionally block the current thread until execution completes.
     
     - parameter wait:  'Bool' as to wether the current thread should wait for the block of code to finish.
     - parameter block: Block of code to execute.
     */
    class func performInBackgroundWaitUntilDone(_ wait: Bool = true, block: @escaping ()->()) {
        if wait {
            DispatchQueue.global(qos: .background).sync(execute: block)
        } else {
            self.performInBackground(block)
        }
    }
    
    /**
     Perform a block of code on a Background Thread after a specified amount of time.
     
     - parameter delayTime: 'NSTimeInterval' of how long to wait before executing the block.
     - parameter block:     Block of code to execute.
     */
    class func performInBackgroundAfterDelay(_ delayTime: TimeInterval, block: @escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64(delayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: popTime, execute: block)
    }
    
    /**
     Perform a block of code on the Main Thread.
     
     - parameter block: Block of code to execute.
     */
    class func performOnMainThread(_ block: @escaping ()->()) {
        DispatchQueue.main.async(execute: block)
    }
    
    /**
     Perform a block of code on the Main Thread.
     If it is already on the main thread execute now otherwise put at back of the main thread queue.
     
     - parameter block: Block of code to execute.
     */
    class func performOnMainThreadInBlockOrNowIfMainThread(_ block: @escaping ()->()) {
        if Thread.isMainThread {
            block()
        } else {
            performOnMainThread(block)
        }
    }
    
    /**
     Perform a block of code on the Main Thread and wait for it to complete
     
     - parameter wait:  'Bool' as to wether the current thread should wait for the block of code to finish.
     - parameter block: Block of code to execute.
     */
    class func performOnMainThreadWaitUntilDone(_ wait: Bool = true, block: @escaping ()->()) {
        if wait {
            if Thread.isMainThread {
                // We are already on the main thread and if we don't want to get in a deadlock just execute since the user is waiting on this anyways.
                block()
            } else {
                DispatchQueue.main.sync(execute: block)
            }
        } else {
            self.performOnMainThread(block)
        }
    }
    
    /**
     Perform a block of code on the Main Thread after a specified amount of time.
     
     - parameter delayTime: 'NSTimeInterval' of how long to wait before executing the block.
     - parameter block:     Block of code to execute.
     */
    class func performOnMainThreadAfterDelay(_ delayTime: TimeInterval, block: @escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64(delayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime, execute: block)
    }
    
}
