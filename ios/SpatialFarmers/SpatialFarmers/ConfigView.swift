import SwiftUI
import Vision

struct ConfigView: View {
    
    @State var qrCodeEnabled: Bool = false
    @State var saveGaleryEnabled: Bool = false
    @State var readAutomaticallyEnabled: Bool = false
    
    var body: some View {
        List {
            Section(header: Text("LANGUAGES")) {
                //NavigationLink(destination: ContentView(), label: {
                //    Text("Preferred languages")
                //})
                let languages = try? VNRecognizeTextRequest().supportedRecognitionLanguages()
                Text(languages![0])
            }
            Section(header: Text("TEXT RECOGNITION")) {
                Toggle(isOn: $readAutomaticallyEnabled, label: {
                    Text("Read text automatically")
                })
            }
            Section(header: Text("PHOTO CONFIGURATIONS")) {
                toggleElement(elementImage: "qrcode", elementText: "QR code detection", elementEnabled: $qrCodeEnabled)
                toggleElement(elementImage: "square.and.arrow.down", elementText: "Save pohotos os galery", elementEnabled: $saveGaleryEnabled)
            }
            Section(header: Text("HELP AND SUPPORT")) {
                buttonElement(elementImage: "questionmark.circle.fill", elementText: "How to use")
                buttonElement(elementImage: "xmark.octagon", elementText: "Error diagnosis")
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct toggleElement: View {
    
    var elementImage: String
    var elementText: String
    
    @Binding var elementEnabled: Bool
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(.blue)
                    .frame(width: 25)
                Image(systemName: elementImage)
                    .resizable()
                    .aspectRatio(17/18.7, contentMode: .fit)
                    .frame(height: 14)
                    .foregroundColor(.white)
            }
            Toggle(isOn: $elementEnabled, label: {
                Text(elementText)
            })
        }
    }
}

struct buttonElement: View {
    
    var elementImage: String
    var elementText: String
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(.blue)
                    .frame(width: 25)
                Image(systemName: elementImage)
                    .resizable()
                    .aspectRatio(17/18.7, contentMode: .fit)
                    .frame(height: 14)
                    .foregroundColor(.white)
            }
            Text(elementText)
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}
