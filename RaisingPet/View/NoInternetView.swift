import SwiftUI
import DotLottie

struct NoInternetView: View {
    var body: some View {
        ZStack {
            Color("AppBackgroundColor") // Projendeki genel arka plan rengi varsa onu kullanabilirsin
                .ignoresSafeArea()

            VStack(spacing: 25) {
                DotLottieAnimation(fileName: "noInternetAnimation", config: AnimationConfig(autoplay: true, loop: true))
                    .view()
                    .frame(width: 200, height: 200)

                Text("no_internet_title")
                    .font(.nunito(.bold, .title222))
                    .foregroundStyle(.black)

                Text("no_internet_message")
                    .font(.nunito(.regular, .body16))
                    .foregroundStyle(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding()
        }
    }
}
