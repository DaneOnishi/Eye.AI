import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            cameraView
            hudView
        }
    }
    
    private var cameraView: some View {
        Rectangle()
                .fill(Color.orange)
    }
    
    private var hudView: some View {
        VStack {
            toolbar
                .background(Color.black.opacity(0.3))
            Spacer()
        
            HStack {
                Image(systemName: "photo.fill")
                    .resizable()
                    .aspectRatio(3/4, contentMode: .fit)
                    .frame(width: 44)
                Spacer()
                Button(action: {}, label: { Image("camerabutton") } )
                    .frame(width: 75, height: 75)
                Spacer()
                Image(systemName: "bolt.fill")
                    .resizable()
                    .frame(height: 44)
                    .aspectRatio(30/16.87, contentMode: .fit)
            }
            .padding(.horizontal, 54)
            .padding(.vertical, 48)
            .background(Color.black.opacity(0.3))
        }
    }
    
    private var toolbar: some View {
            HStack {
                Image("eyeailogo")
                    .frame(width: 32, height: 32)
                Spacer()
                RoundedButton(action: {}, imageName: "moon.fill")
                RoundedButton(action: {}, imageName: "moon")
                RoundedButton(action: {}, imageName: "moon")
                Spacer()
                Button(action: {}, label: { Image(systemName: "gearshape.fill") } )
            }
            .padding(.horizontal, 32)
    }
}
struct RoundedButton: View {
    
    var action: () -> Void
    var imageName: String
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
        }
        .frame(width: 32, height: 32)
        .background(backgroundView)
    }
    
    private var backgroundView: some View {
        Circle()
            .fill(Color(white: 1).opacity(0.2))
    }
}
