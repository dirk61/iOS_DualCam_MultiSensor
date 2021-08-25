//
//  ContentView.swift
//  Rppg
//
//  Created by GIX on 2021/7/3.
//

import SwiftUI

struct MainView: View {
    @State private var Name = ""
    @State private var Gender = ""
    @State private var Age = ""
    

    
    var body: some View {
       
        NavigationView{
            VStack(alignment: .leading, spacing: 7.0) {
//                Text("Your ID")
//                    .multilineTextAlignment(.leading)
//                TextField("ID", text:$Name)
//
//                Text("Age")
//                    .multilineTextAlignment(.leading)
//                TextField("Age", text:$Age)
//
//                Text("Gender")
//                    .multilineTextAlignment(.leading)
//                TextField("Gender", text:$Gender)
            
//                NavigationLink(
//                    destination: ContentView(),
//                    label: {
//                        Text("Start Survey")
//                    })
//                Spacer()
                ContentView()
            }
        }

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
