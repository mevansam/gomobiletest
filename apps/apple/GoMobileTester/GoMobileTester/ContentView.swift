//
//  ContentView.swift
//  GoMobileTester
//
//  Created by Mevan Samaratunga on 9/20/23.
//

import SwiftUI
import User

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
    
    var greeter: GreeterGreeter
    
    init() {
        let identity = SwiftIdentity("kazi")
        let person = PersonNewPerson(identity)
        
        let printer = SwiftPrinter()
        let greeter = GreeterNewGreeter(printer)
        
        self.greeter = greeter!
        self.greeter.greet(person)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
