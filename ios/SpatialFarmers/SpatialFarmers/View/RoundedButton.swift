import SwiftUI

struct RoundedButton: View {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var action: () -> Void
    var imageName: String
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(12.55/14.12, contentMode: .fit)
                .frame(height: 20)
        }
        .frame(width: 52, height: 52)
        .background(backgroundView)
        .foregroundColor(isEnabled ? .white : .white.opacity(0.5))
    }
    
    private var backgroundView: some View {
        Circle()
            .fill(Color(white: 1).opacity(0.2))
    }
}
