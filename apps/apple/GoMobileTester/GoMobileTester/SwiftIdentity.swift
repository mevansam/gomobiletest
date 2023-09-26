//
//  SwiftIdentity.swift
//  GoMobileTester
//
//  Created by Mevan Samaratunga on 9/22/23.
//

import Foundation
import User

class SwiftIdentity: NSObject, PersonIdentityProtocol {
    
    var userName: String
    
    init(_ userName: String) {
        self.userName = userName
    }
    
    func username() -> String {
        return userName
    }
}
