//
//  ContentView.swift
//  Trois-cam
//
//  Created by Joss Manger on 1/19/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

import SwiftUI
import AVFoundation
import UIKit
import CoreLocation
import Photos
import CoreMotion
import SensorKit

var ExperimentStr = ""

enum Experiments: String, CaseIterable, Identifiable{
    case Playground
    case Natural_Stationary
    case LED_Stationary
    case Incandescent_Stationary
    case Left_Right
    case Randomly
    case Talking
    case Running
    
    var id: String{ self.rawValue}
}

extension View{
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
            NavigationView {
                ZStack {
                    self
                        .navigationBarTitle("")
                        .navigationBarHidden(true)

                    NavigationLink(
                        destination: view
                            .navigationBarTitle("")
                            .navigationBarHidden(false),
                        isActive: binding
                    ) {
                        EmptyView()
                    }
                }
            }
        }
}

struct ContentView: View{
    
    @State private var selectedExperiment = Experiments.Playground

    @State var selectedIndex:Int? = nil
    @State var move = false
    var body: some View {
        VStack{
            Picker("Experiment", selection:$selectedExperiment){
                Text("Playground").tag(Experiments.Playground)
                Text("Natural Stationary").tag(Experiments.Natural_Stationary)
                Text("LED Stationary").tag(Experiments.LED_Stationary)
                Text("Incandescent Stationary").tag(Experiments.Incandescent_Stationary)
                Text("Randomly").tag(Experiments.Randomly)
                Text("Left Right").tag(Experiments.Left_Right)
                Text("Talking").tag(Experiments.Talking)
                Text("Running").tag(Experiments.Running)
            }
            Text("Selected:\(selectedExperiment.rawValue)")

            Button(action: {ExperimentStr = enum2String(e: selectedExperiment);move = true},label:{Text("Start")})
            
        }.navigate(to: MultiView(), when: $move)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
