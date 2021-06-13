import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            cameraView
            hudView
        }
        .edgesIgnoringSafeArea([.top, .bottom])
    }
    
    private var cameraView: some View {
        Rectangle()
                .fill(Color.orange)
    }
    
    private var hudView: some View {
        VStack {
            toolbar
                .frame(height: 100, alignment: .bottom)
                .background(Color.black.opacity(0.3))
            Spacer()
        
            HStack {
                Button(action: {}) {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(4/3, contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action: {}, label: { Image("camerabutton") } )
                    .frame(width: 75, height: 75)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "bolt.fill")
                        .resizable()
                        .aspectRatio(16.87/30, contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 48)
            .background(Color.black.opacity(0.3))
        }
    }
    
    private var toolbar: some View {
        HStack {
            Image("eyeailogo")
                .frame(width: 32, height: 32)
            Spacer()
            RoundedButton(action: {}, imageName: "play.fill")
                .padding(.leading)
                .disabled(true)
            RoundedButton(action: {}, imageName: "square.and.arrow.up")
                .padding(.leading)
                .disabled(true)
            Spacer()
            Button(action: {}, label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
            } )
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 13)
    }
}
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
