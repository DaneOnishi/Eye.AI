import SwiftUI
import AVFoundation

final class ContentViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    // MARK: - Constants
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private static let dismissedOffset: CGSize = .init(width: 0, height: 1000)
    
    // MARK: - ViewModel properties
    
    @Published var isFrozen: Bool = false
    @Published var offset: CGSize = ContentViewModel.dismissedOffset
    @Published var transcribedText: String = ""
    @Published var isTalking = false
    @Published var isFlashlightOn = false
    @Published var isPickingImage = false
    @Published var isShowingConfig = false
    
    // MARK: - Properties
    
    var controller: ViewController?
    var shouldEmmitHapitic = true {
        didSet { controller?.shouldEmmitHaptic = shouldEmmitHapitic }
    }
    
    // MARK: - Communication methods
    
    func handleButtonTapped() {
        isFrozen = true
        controller?.handleButtonTapped()
        objectWillChange.send()
    }
    
    func presentTranscribedView(using text: String) {
        transcribedText = text
        withAnimation(.default) { offset = .zero }
        objectWillChange.send()
    }
    
    func onDragChanged(gesture: DragGesture.Value) {
        let yOffset = max(gesture.translation.height, 0)
        offset.height = yOffset
        objectWillChange.send()
    }
    
    func onDragEnded(gesture: DragGesture.Value) {
        let offset: CGSize
        if gesture.translation.height > 100 {
            handleDismissedState()
            offset = ContentViewModel.dismissedOffset
        } else {
            offset = .zero
        }
        
        withAnimation(.default) { self.offset = offset }
        objectWillChange.send()
    }
    
    func handlePlay() {
        guard isFrozen,
              !transcribedText.isEmpty
        else { return }
        if speechSynthesizer.isPaused {
            speechSynthesizer.continueSpeaking()
            isTalking = true
            objectWillChange.send()
            return
        }
        if isTalking {
            speechSynthesizer.pauseSpeaking(at: .immediate)
            isTalking = false
            objectWillChange.send()
        } else {
            say(sentence: transcribedText)
        }
    }
    
    func handleShare() {
        actionSheet()
    }
    
    func handleFlashlight() {
        controller?.toggleFlashlight()
        isFlashlightOn.toggle()
        objectWillChange.send()
    }
    
    func handlePickImage() {
        shouldEmmitHapitic = false
        isPickingImage = true
        objectWillChange.send()
    }
    
    func handleOpenSettings() {
        shouldEmmitHapitic = false
        isShowingConfig = true
        objectWillChange.send()
    }
    
    func handleDismissSettings() {
        shouldEmmitHapitic = true
        isShowingConfig = false
        objectWillChange.send()
    }
    
    func handleCancelImagePick() {
        shouldEmmitHapitic = true
        isPickingImage = false
        objectWillChange.send()
    }
    
    func say(sentence: String) {
        let speechUtterance = AVSpeechUtterance(string: sentence)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        speechSynthesizer.delegate = self
        isTalking = true
        speechSynthesizer.speak(speechUtterance)
        objectWillChange.send()
    }
    
    // MARK: - Delegate methods
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isTalking = false
        objectWillChange.send()
    }
    
    // MARK: - Private functions
    
    private func handleDismissedState() {
        DispatchQueue.global().async { self.controller?.startSession() }
        isFrozen = false
        isTalking = false
        transcribedText = ""
        speechSynthesizer.stopSpeaking(at: .immediate)
        objectWillChange.send()
    }
    
    private func actionSheet() {
        guard let image = controller?.currentFrame,
              let watermark = UIImage(named: "watermark"),
              let watermarked = image.watermarked(watermark)
        else { return }
        let av = UIActivityViewController(activityItems: [watermarked], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

extension UIImage {
    func watermarked(_ watermarkImage: UIImage) -> UIImage? {
        let backgroundImage = self

        let size = backgroundImage.size
        let scale = backgroundImage.scale
        let watermarkScale = 0.5
        let watermarkWidth = watermarkImage.size.width * watermarkScale
        let watermarkHeight = watermarkImage.size.height * watermarkScale
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        backgroundImage.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        watermarkImage.draw(in: CGRect(x: size.width / 2 - watermarkWidth / 2, y: size.height - watermarkHeight - 40, width: watermarkWidth, height: watermarkHeight))

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
