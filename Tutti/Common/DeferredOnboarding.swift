//
//  DeferredOnboarding.swift
//  Tutti
//
//  Created by Daniel Saidi on 2018-06-18.
//  Copyright © 2018 Daniel Saidi. All rights reserved.
//

/*
 
 This protocol extends `Onboarding` and can be used when the
 item should require several presentation attempts before it
 is presented. One example could be a hint that shouldn't be
 presented until the 5th time you ask it to.
 
 */

import Foundation

public protocol DeferredOnboarding: Onboarding {

    var requiredPresentationAttempts: Int { get }
}


// MARK: - Internal Properties

private extension DeferredOnboarding {
    
    var registeredPresentationAttempts: Int {
        get { return persistence.integer(forKey: registeredPresentationAttemptsKey) }
        set { persistence.set(newValue, forKey: registeredPresentationAttemptsKey) }
    }
    
    var registeredPresentationAttemptsKey: String {
        return persistence.key(for: self, objectKey: "presentationAttempts", userId: userId)
    }
}


// MARK: - Public Properties

public extension DeferredOnboarding {
    
    var remainingPresentationAttempts: Int {
        return requiredPresentationAttempts - registeredPresentationAttempts
    }
    
    var shouldBePresented: Bool {
        return !hasBeenDisplayed && requiredPresentationAttempts == 0
    }
}


// MARK: - Public Functions

public extension DeferredOnboarding {
    
    func registerPresentationAttempt() {
        if remainingPresentationAttempts == 0 { return }
        registeredPresentationAttempts += 1
    }
}
