//
//  CameraView.swift
//  Trois-cam
//
//  Created by Joss Manger on 1/19/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
  
  let color:Color
  var session: AVCaptureMultiCamSession? = nil
  var index:Int?
  var selectedIndex:Int? = nil
  
  var shouldExpand: Bool {
    if selectedIndex == nil {
      return true
    }
    if let selectedIndex = self.selectedIndex, let index = self.index{
      if selectedIndex == index{
        return true
      }
    }
    return false
  }
  
    var body: some View {
     
      if session != nil && index != nil {
      
        return AnyView(LayerView(session: session!, index: index!).frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: (shouldExpand) ? .infinity : 0, maxHeight: (shouldExpand) ? .infinity : 0))
      }
      print("should expand \(shouldExpand)")
      
      return AnyView(Rectangle().fill(color).frame(minWidth: 0, idealWidth: (shouldExpand) ? .infinity : 0, maxWidth: (shouldExpand) ? .infinity : 0, minHeight: 0, idealHeight: (shouldExpand) ? .infinity : 0, maxHeight: (shouldExpand) ? .infinity : 0))
      
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
      CameraView(color: .black)
    }
}
