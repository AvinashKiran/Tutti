//
//  Hint.swift
//  Tutti
//
//  Created by Daniel Saidi on 2017-12-03.
//  Copyright © 2017 Daniel Saidi. All rights reserved.
//

/*
 
 A hint is a simple message that is intended to be displayed
 once. It's perfect for quick onboarding, like showing users
 how certain parts of a UI works.
 
 */

import Foundation

public protocol Hint: Displayable {
    
    var text: String { get }
}
