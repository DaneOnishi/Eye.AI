 //
//  ViewController.swift
//  SpatialFarmers
//
//  Created by Bruno Pastre on 12/06/21.
//

import UIKit
import AVFoundation
import Vision
import CoreHaptics

final class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVSpeechSynthesizerDelegate {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var debugImage: UIImageView!
    @IBOutlet weak var contentLabe: UILabel!
    @IBOutlet weak var confiidenceLabel: UILabel!
    
    // MARK: - Properties
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private let context = CIContext(options: nil)
    private var session: AVCaptureSession!
    private var device: AVCaptureDevice!
    
    private var isTalking: Bool = false
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCaptureSession()
    }
    
    // MARK: - Delegates
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isTalking.toggle()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if isTalking { return }
        handleNewFrame(using: sampleBuffer)
    }
    
    // MARK: - Provate methods
    
    private func handleRecognitionResult(request: VNRequest, error: Error?) {
           guard let results = request.results,
                 let observations = results as? [VNRecognizedTextObservation]
           else { return }
           let observedResults = observations.compactMap { $0.topCandidates(1).first }
           
           let averageConfidence = observedResults.map { Float($0.confidence) }.reduce(.zero, +) / Float(observedResults.count)
           let readText = observedResults.map { $0.string }.joined(separator: " ")
           
           DispatchQueue.main.async {
               
               self.confiidenceLabel.text = "\(averageConfidence)"
               self.contentLabe.text = readText
               switch averageConfidence {
               case 0..<0.40:
                   UIImpactFeedbackGenerator(style: .light)
                       .impactOccurred()
               case 0.40..<0.60:
                   UIImpactFeedbackGenerator(style: .soft)
                       .impactOccurred()
               case 0.60..<0.80:
                   UIImpactFeedbackGenerator(style: .medium)
                       .impactOccurred()
               case 0.80..<1:
                   UIImpactFeedbackGenerator(style: .heavy)
                       .impactOccurred()
               default: break
               }
               self.say(sentence: readText)
           }
    }
    
    private func say(sentence: String) {
           let speechUtterance = AVSpeechUtterance(string: sentence)
           self.speechSynthesizer.delegate = self
           speechUtterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
           self.isTalking = true
           self.speechSynthesizer.speak(speechUtterance)
    }
    
    private func handleNewFrame(using buffer: CMSampleBuffer) {
        let imageBuffer = CMSampleBufferGetImageBuffer(buffer)!
        let ciimage = CIImage(cvPixelBuffer: imageBuffer).oriented(.right)
        let cgImage = context.createCGImage(ciimage, from: ciimage.extent)!
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: handleRecognitionResult)
        
        request.usesLanguageCorrection = true
        request.recognitionLevel = .accurate
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    private func configureCaptureSession() {
        session = .init()
        session.beginConfiguration()
        session.sessionPreset = .high
        
        device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input)
        else { return }
        session.addInput(input)
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        
        
        session.commitConfiguration()
        
        (view as? PreviewView)?.sessionLayer?.session = session
        
        session.startRunning()
    }
}


final class PreviewView: UIView {
    
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    
    var sessionLayer: AVCaptureVideoPreviewLayer? { layer as? AVCaptureVideoPreviewLayer }
}
