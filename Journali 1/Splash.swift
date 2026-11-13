
import SwiftUI

struct SplashView: View {

    @State private var showJournal = false

    var body: some View {

        Group {
            if showJournal {
                ContentView()
            } else {
                VStack(spacing: 20) {

                    Image("1")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)

                    Text("Journali")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    Text("Your thoughts, your story")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))

            withAnimation {
                showJournal = true
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    SplashView()
}

