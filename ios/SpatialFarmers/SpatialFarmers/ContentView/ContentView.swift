import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel = .init()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                cameraView
                hudView
                VStack {
                    Spacer()
                    transcribedText
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea([.top, .bottom])
        }
        .onAppear {
            print("Salve")
        }
        .onDisappear {
            print("qweqew")
        }
        .actionSheet(isPresented: $viewModel.isPickingImage) {
            ActionSheet(title: Text("Select a source to pick an image from"), message: nil, buttons: [
                .default(Text("Gallery")),
                .default(Text("Import Image")),
                .cancel(viewModel.handleCancelImagePick)
            ])
        }
        .sheet(isPresented: $viewModel.isShowingConfig) {
            ConfigView(doneHandler: viewModel.handleDismissSettings)
        }
    }
    
    private var cameraView: some View {
        DetectorView(viewModel: viewModel)
    }
    
    private var hudView: some View {
        VStack {
            toolbar
                .background(.ultraThinMaterial)
            Spacer()
        
            HStack {
                Button(action: viewModel.handlePickImage) {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(4/3, contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action:  viewModel.handleButtonTapped, label: { Image("camerabutton") } )
                    .frame(width: 75, height: 75)
                Spacer()
                Button(action: viewModel.handleFlashlight) {
                    Image(systemName: "bolt.fill")
                        .resizable()
                        .aspectRatio(16.87/30, contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(viewModel.isFlashlightOn ? .yellow : .white)
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 48)
            .background(.ultraThinMaterial)
        }
    }
    
    private var toolbar: some View {
        HStack {
            Image("eyeailogo")
                .frame(width: 32, height: 32)
            Spacer()
            RoundedButton(action: viewModel.handlePlay, imageName: viewModel.isTalking ? "pause.fill" : "play.fill")
                .padding(.leading)
                .disabled(!viewModel.isFrozen)
            RoundedButton(action: viewModel.handleShare, imageName: "square.and.arrow.up")
                .padding(.leading)
                .disabled(!viewModel.isFrozen)
            Spacer()
            Button(action: viewModel.handleOpenSettings) {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    
            }
            .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 32)
        .padding(.top, 52)
        .padding(.bottom, 20)
    }
    
    private var transcribedText: some View {
        HStack {
            Spacer()
            VStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 33, height: 3)
                    .padding(.top, 16)
                ScrollView {
                    Text(viewModel.transcribedText)
                        .foregroundColor(.white)
                        .padding(.top, 16)
                        .padding(.bottom, 40)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxHeight: 500)
            }
            Spacer()
        }
        .background(Color.black.opacity(0.7))
        .offset(viewModel.offset)
        .gesture(DragGesture()
                    .onChanged(viewModel.onDragChanged)
                    .onEnded(viewModel.onDragEnded)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
