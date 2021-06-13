import UIKit
import AVFoundation
import Vision
import CoreHaptics

final class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVSpeechSynthesizerDelegate {
    
    // MARK: - Properties
    
    private let context = CIContext(options: nil)
    private var session: AVCaptureSession!
    private var device: AVCaptureDevice!
    
    private var isTalking: Bool = false
    private var isFlashlightOn = false
    
    var shouldEmmitHaptic = true
    
    weak var viewModel: ContentViewModel?
    
    var currentFrame: UIImage?
    var currentReadText: String?
    var currentPrecision: Float?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCaptureSession()
        configureFlashlight()
    }
    
    // MARK: - SwiftUI Communication
    
    func handleButtonTapped() {
        self.session.stopRunning()
        if var text = currentReadText {
            if currentPrecision ?? 0 < 0.5 {
                text = "Aviso! A precisão está a baixo de 50%.\n\n\n" + text
            }
            viewModel?.presentTranscribedView(using: text)
        }
    }
    
    func startSession() {
        session.startRunning()
    }
    
    func toggleFlashlight() {
        isFlashlightOn.toggle()
        try? device.lockForConfiguration()
        device.torchMode = isFlashlightOn ? .on : .off
        device.unlockForConfiguration()
    }
    
    // MARK: - Delegates
    
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
        let readText = observedResults.map { $0.string }.joined(separator: "\n")
        
        currentPrecision = averageConfidence
        currentReadText = readText
        generateImpact(basedOn: averageConfidence)
    }
    
    private func generateImpact(basedOn confidence: Float) {
        guard shouldEmmitHaptic else { return }
            switch confidence {
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
    }
    
    private func handleNewFrame(using buffer: CMSampleBuffer) {
        let imageBuffer = CMSampleBufferGetImageBuffer(buffer)!
        let ciimage = CIImage(cvPixelBuffer: imageBuffer).oriented(.right)
        let cgImage = context.createCGImage(ciimage, from: ciimage.extent)!
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: handleRecognitionResult)
        
        request.usesLanguageCorrection = true
        request.recognitionLevel = .accurate
        
        currentFrame = UIImage(cgImage: cgImage)
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    private func configureFlashlight() {
        try? device.lockForConfiguration()
        try? device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
        device.torchMode = .off
        device.unlockForConfiguration()
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
        
        let view = (view as? PreviewView)
        view?.sessionLayer?.session = session
        view?.sessionLayer?.videoGravity = .resizeAspectFill
        session.startRunning()
    }
}


final class PreviewView: UIView {
    
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    
    var sessionLayer: AVCaptureVideoPreviewLayer? { layer as? AVCaptureVideoPreviewLayer }
}
