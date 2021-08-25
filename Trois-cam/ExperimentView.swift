//
//  ExperimentView.swift
//  Rppg
//
//  Created by GIX on 2021/7/3.
//

import SwiftUI

struct ExperimentView: View {
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(
                    destination: ContentView(),
                    label: {
                        Text("Playground")
                    })
                
            }
        }
        
        
    }
}

struct ExperimentView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentView()
    }
}
