import SwiftUI

struct DetectorView: UIViewControllerRepresentable {
    
    let viewModel: ContentViewModel
    
    func makeUIViewController(context: Context) -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! ViewController
        controller.viewModel = context.coordinator.view.viewModel
        context.coordinator.view.viewModel.controller = controller
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
            .init(using: self)
    }
    
    final class Coordinator {
        let view: DetectorView
        
        init(using view: DetectorView) {
            self.view = view
        }
    }
}
