 //
//  ViewController.swift
//  SpatialFarmers
//
//  Created by Bruno Pastre on 12/06/21.
//

import UIKit
import AVFoundation
import Vision

final class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var debugImage: UIImageView!
    @IBOutlet weak var contentLabe: UILabel!
    @IBOutlet weak var confiidenceLabel: UILabel!
    
    private let context = CIContext(options: nil)
    private var session: AVCaptureSession!
    private var device: AVCaptureDevice!
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        handleNewFrame(using: sampleBuffer)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    
    private func handleNewFrame(using buffer: CMSampleBuffer) {
        let imageBuffer = CMSampleBufferGetImageBuffer(buffer)!
        let ciimage = CIImage(cvPixelBuffer: imageBuffer)t.oriented(.right)
        let cgImage = context.createCGImage(ciimage, from: ciimage.extent)!
        let debugImage = UIImage(cgImage: cgImage)
        
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { (request, error) in
            print("request")
            guard let results = request.results,
                  let observations = results as? [VNRecognizedTextObservation]
            else { return }
            let observedResults = observations.compactMap { $0.topCandidates(1).first }
            
            let averageConfidence = observedResults.map { Float($0.confidence) }.reduce(.zero, +) / Float(observedResults.count)
            let readText = observedResults.map { $0.string }.joined(separator: " ")
            
//            guard averageConfidence > 0.8 else { return }
            DispatchQueue.main.async {
                
                self.confiidenceLabel.text = "\(averageConfidence)"
                self.contentLabe.text = readText
                self.debugImage.image = debugImage
            }
            
        }
        
        request.usesLanguageCorrection = true
        request.recognitionLevel = .fast
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
}


final class PreviewView: UIView {
    
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    
    var sessionLayer: AVCaptureVideoPreviewLayer? { layer as? AVCaptureVideoPreviewLayer }
}
