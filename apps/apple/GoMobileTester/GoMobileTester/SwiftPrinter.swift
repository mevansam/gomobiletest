//
//  SwiftPrinter.swift
//  GoMobileTester
//
//  Created by Mevan Samaratunga on 9/20/23.
//

import Foundation
import User

class SwiftPrinter: NSObject, GreeterPrinterProtocol {
    func printSomething(_ s: String?) {
        print("This just in:", s!)
    }
}
