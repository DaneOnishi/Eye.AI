import SwiftUI
import Vision

struct LanguagesView: View {
    let languages = (try? VNRecognizeTextRequest().supportedRecognitionLanguages()) ?? []
    var body: some View {
        List {
            ForEach(languages, id: \.self) { language in
                Button(action: {}, label: {
                    Text(Locale(identifier: language).localizedString(forLanguageCode: language)!.capitalized)
                })
                
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct LanguagesView_Previews: PreviewProvider {
    static var previews: some View {
        LanguagesView()
    }
}
