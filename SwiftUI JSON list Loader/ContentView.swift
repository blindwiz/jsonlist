//
//  ContentView.swift
//  SwiftUI JSON list Loader
//
//  Created by Juan Hernandez on 5/1/21.
//

import SwiftUI

struct ContentView: View {
    @State var drinks:[Drink] = []

    
    var body: some View {
        NavigationView {
            List(self.drinks) { drink in
                Text("\(drink.name)")
            }
            .onAppear {
                let dm = DataModel()
                dm.get_drinks_by_id(for: 1) { (mDrinks) in
                    
                    self.drinks = mDrinks
                    
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
