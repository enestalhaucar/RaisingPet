import Foundation
import Network // NWPathMonitor için gerekli

@MainActor // @Published değişkenleri UI thread'inde güncellensin
class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    @Published var isConnected: Bool = true // Başlangıçta internet var gibi varsayalım

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async { // @Published değişkeni ana thread'den güncellenmeli
                if path.status == .satisfied {
                    self?.isConnected = true
                } else {
                    self?.isConnected = false
                }
            }
        }
        monitor.start(queue: queue)
    }

    // İsteğe bağlı: Gözetlemeyi durdurmak için bir metod eklenebilir,
    // ancak genellikle `NWPathMonitor` kendi yaşam döngüsünü yönetir
    // ve uygulama kapanırken otomatik olarak durur.
    // deinit {
    //     monitor.cancel()
    // }
}
