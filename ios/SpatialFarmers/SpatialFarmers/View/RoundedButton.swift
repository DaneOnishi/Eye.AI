import SwiftUI

struct RoundedButton: View {
    
    var action: () -> Void
    var imageName: String
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(12.55/14.12, contentMode: .fit)
                .frame(height: 20)
        }
        .frame(width: 44, height: 44)
        .background(backgroundView)
    }
    
    private var backgroundView: some View {
        Circle()
            .fill(Color(white: 1).opacity(0.2))
    }
}
