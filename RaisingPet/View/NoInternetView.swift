import SwiftUI

struct NoInternetView: View {
    var body: some View {
        ZStack {
            Color("AppBackgroundColor") // Projendeki genel arka plan rengi varsa onu kullanabilirsin
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Image(systemName: "wifi.exclamationmark.circle.fill") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray.opacity(0.2))

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
