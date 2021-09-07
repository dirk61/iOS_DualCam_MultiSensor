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
    case LED_Stationary_220
    case LED_Stationary_110
    case LED_Stationary_55
    case Incandescent_Stationary_220
    case Incandescent_Stationary_110
    case Incandescent_Stationary_55
    case Natural_Stationary
    case Natural_Typing
    case Randomly
    case Left_Right
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
                Group{
                Text("Playground").tag(Experiments.Playground)
                Text("LED Stationary 220").tag(Experiments.LED_Stationary_220)
                Text("LED Stationary 110").tag(Experiments.LED_Stationary_110)
                Text("LED Stationary 55").tag(Experiments.LED_Stationary_55)
                Text("Incandescent Stationary 220").tag(Experiments.Incandescent_Stationary_220)
                }
                Text("Incandescent Stationary 110").tag(Experiments.Incandescent_Stationary_110)
                Text("Incandescent Stationary 55").tag(Experiments.Incandescent_Stationary_55)
                Text("Natural Stationary").tag(Experiments.Natural_Stationary)
                Text("Natural Typing").tag(Experiments.Natural_Typing)
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
