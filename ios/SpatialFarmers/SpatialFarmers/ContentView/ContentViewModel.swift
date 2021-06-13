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
    
    // MARK: - Properties
    
    @Published var isTalking = false
    var controller: ViewController?
    
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
    
    func say(sentence: String) {
        let speechUtterance = AVSpeechUtterance(string: sentence)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        speechSynthesizer.delegate = self
        isTalking = true
        speechSynthesizer.speak(speechUtterance)
        objectWillChange.send()
    }
    
    func actionSheet() {
        guard let image = controller?.currentFrame else { return }
        let av = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
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
    
}
