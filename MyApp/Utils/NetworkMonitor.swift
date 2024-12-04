//
//  NetworkMonitor.swift
//  MyApp
//
//  Created by Thomas on 12/3/24.
//

import Network
import Combine

class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true
    @Published var toastMessage: String? {
        didSet {
            if toastMessage != nil {
                isShowingToast = true
            }
        }
    }
    @Published var isShowingToast: Bool = false
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    private var toastCancellable: AnyCancellable?
    
    init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: self.queue)
        
        self.monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                let previousStatus = self.isConnected
                self.isConnected = (path.status == .satisfied)
                
                if previousStatus != self.isConnected {
                    if self.isConnected {
                        self.toastMessage = "Network connected"
                    } else {
                        self.toastMessage = "Network disconnected"
                    }
                    
                    // Automatically clear toast message after a delay
                    self.toastCancellable?.cancel()
                    self.toastCancellable = Just(())
                        .delay(for: .seconds(2), scheduler: DispatchQueue.main)
                        .sink { [weak self] in
                            self?.isShowingToast = false
                        }
                }
            }
        }
    }
}
