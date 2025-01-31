import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ContentView() // Your main content view
        } else {
            VStack {
                Spacer()
                Text("מוסך המרכז")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                Image("logo") // Your app logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Spacer()

                Text("Made by Mohamad Abu Ahmad")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 40) // Adjust the padding as needed
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea()
            .onAppear {
                // Delay the transition to the main content
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
