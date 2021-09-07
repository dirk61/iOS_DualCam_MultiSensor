//
//  CameraController.swift
//  Trois-cam
//
//  Created by Joss Manger on 1/19/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

import UIKit
import AVFoundation
import Combine
import Photos
import Accelerate
import ARKit

class CameraController:NSObject, AVCaptureFileOutputRecordingDelegate, AVCaptureDepthDataOutputDelegate, AVAudioRecorderDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("finishrecording")
        //        // Check the authorization status.
        //        PHPhotoLibrary.requestAuthorization { status in
        //            if status == .authorized {
        //                // Save the movie file to the photo library and cleanup.
        //                PHPhotoLibrary.shared().performChanges({
        //                    let options = PHAssetResourceCreationOptions()
        //                    options.shouldMoveFile = true
        //                    let creationRequest = PHAssetCreationRequest.forAsset()
        //                    creationRequest.addResource(with: .video, fileURL: outputFileURL, options: options)
        //
        //                }
        //                )
        //            }
        //        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("StartRecording")
    }
    
    func depthDataOutput(_ output: AVCaptureDepthDataOutput, didOutput depthData: AVDepthData, timestamp: CMTime, connection: AVCaptureConnection) {

        if(self.recording) {
            
            let ddm = depthData.depthDataMap
            
            depthCapture.addPixelBuffers(pixelBuffer: ddm)
        }
    }
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    private var session: AVCaptureMultiCamSession!
    var startRecording = false
    private let sessionQueue = DispatchQueue(label: "session queue")
    
    var captureSession: AVCaptureMultiCamSession? {
        return self.session
    }
    private let depthCapture = DepthCapture()
    private var movieFileOutput: AVCaptureMovieFileOutput?
    private var movieFileOutput2: AVCaptureMovieFileOutput?
    private var depthOutput: AVCaptureDepthDataOutput?
    private var recording = false
    private let dataOutputQueue = DispatchQueue(label: "dataOutputQueue")
    
    static func addConnection(session: AVCaptureMultiCamSession,layer: AVCaptureVideoPreviewLayer, index: Int){
        
        layer.videoGravity = .resizeAspectFill
        layer.setSessionWithNoConnection(session)
        
        let videoPort = session.inputs[index].ports.first!
        
        let connection = MyConnection(inputPort: videoPort, videoPreviewLayer: layer)
        
        session.addConnection(connection)
        
    }
    
    var anyCan:AnyCancellable!
    
    func startRecord(){
        recording = true
        sessionQueue.async {
            
            
            //        print(movieFileOutput?.isRecording)
            
            if self.movieFileOutput?.isRecording == false{
                let lowerbound = String.Index(encodedOffset: 1)
                let outputFileName = ExperimentStr[lowerbound...] +  "_Front"
                //                let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
                
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let fileUrl = paths[0].appendingPathComponent(outputFileName + ".mov")
                print(fileUrl.absoluteString)
                self.movieFileOutput?.startRecording(to: frontURL, recordingDelegate: self)
                
                //            print(movieFileOutput?.isRecording)
            }}
        
    }
    
    func stopRecord(){
        self.recording = false
        
        sessionQueue.async {
            
            //        print(movieFileOutput?.isRecording)
            self.movieFileOutput?.stopRecording()
            //        print(movieFileOutput?.isRecording)
        
            
        }
        do {
            try depthCapture.finishRecording(success: { (url: URL) -> Void in
                print(url.absoluteString)
            })
        } catch {
            print("Error while finishing depth capture.")
        }
    }
    
    func startRecord2(){
        sessionQueue.async {
            
            
            if self.movieFileOutput2?.isRecording == false{
                let lowerbound = String.Index(encodedOffset: 1)
                let outputFileName = ExperimentStr[lowerbound...] + "_finger"
                //                let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
                
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let fileUrl = paths[0].appendingPathComponent(outputFileName + ".mov")
                
                self.movieFileOutput2?.startRecording(to: fingerURL, recordingDelegate: self)
                
            }}}
    
    func stopRecord2(){
        sessionQueue.async {
            
            self.movieFileOutput2?.stopRecording()
        }
    }
    
    func prepareDepth(){
        depthCapture.prepareForRecording()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func startAudio() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            
        } catch {
            finishAudio(success: false)
        }
    }
    
    func finishAudio(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            
        } else {
            
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
                finishAudio(success: false)
            }
    }
    
    override init() {
        super.init()
        #if !targetEnvironment(simulator)
        
        guard AVCaptureMultiCamSession.isMultiCamSupported else {
            print("unsupported")
            return
        }
        //Audio
        recordingSession = AVAudioSession.sharedInstance()
//        depthCapture.prepareForRecording()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                     
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
        
        session = AVCaptureMultiCamSession()
        session.beginConfiguration()
        //
        let device2 = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front)!
        
        let input2 = try! AVCaptureDeviceInput(device: device2)
        session.addInputWithNoConnections(input2)
        
        let device1 = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!
        let input1 = try! AVCaptureDeviceInput(device: device1)
        session.addInputWithNoConnections(input1)
        
        let dOutput = AVCaptureDepthDataOutput()
        dOutput.isFilteringEnabled = false
        dOutput.setDelegate(self, callbackQueue: dataOutputQueue)
        self.depthOutput = dOutput
        
        let output = AVCaptureMovieFileOutput()
        self.movieFileOutput = output
        
        let output2 = AVCaptureMovieFileOutput()
        self.movieFileOutput2 = output2
        //        session.sessionPreset = .high
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        
        
//        for i in 0..<device2.formats.count{
//            print(String(i) + ": " + device2.formats[i].description)
//        }
//
        for i in 0..<device1.formats.count{
            print(String(i) + ": " + device1.formats[i].description)
        }

//
        do {
            try device2.lockForConfiguration()
           
            device2.activeFormat = device2.formats[22]
            
            let fps60 = CMTimeMake(value: 1, timescale: 60)
            device2.activeVideoMinFrameDuration = fps60;
            device2.activeVideoMaxFrameDuration = fps60;
            
            device2.unlockForConfiguration()
            
        } catch {
            print("Could not lock device for configuration: \(error)")
            
        }
        
//        do {
//            try device1.lockForConfiguration()
//
//            device1.activeFormat = device1.formats[18]
//            let fps60 = CMTimeMake(value: 1, timescale: 60)
//            device1.activeVideoMinFrameDuration = fps60;
//            device1.activeVideoMaxFrameDuration = fps60;
//            device1.unlockForConfiguration()
//        } catch {
//            print("Could not lock device for configuration: \(error)")
//
//        }
        print(device1.activeFormat)
        print(device2.activeFormat)
        session.addOutput(output)
        session.addOutput(output2)
        session.addOutput(dOutput)
        
        if let connection = dOutput.connection(with: .depthData) {
            connection.isEnabled = true
            dOutput.isFilteringEnabled = false
            dOutput.setDelegate(self, callbackQueue: dataOutputQueue)
        } else {
            print("No AVCaptureConnection")
        }
        
        session.commitConfiguration()
        
        session.startRunning()
        
        
        //      func angleOffsetFromPortraitOrientation(at position: AVCaptureDevice.Position) -> Double {
        //        switch self {
        //        case .portrait:
        //          return position == .front ? .pi : 0
        //        case .portraitUpsideDown:
        //          return position == .front ? 0 : .pi
        //        case .landscapeRight:
        //          return -.pi / 2.0
        //        case .landscapeLeft:
        //          return .pi / 2.0
        //        default:
        //          return 0
        //        }
        //      }
        
        
        #endif
        
    }
    
    
    
}


class MyConnection : AVCaptureConnection {
    
    override var videoMaxScaleAndCropFactor: CGFloat {
        return 2.0
    }
    
}


