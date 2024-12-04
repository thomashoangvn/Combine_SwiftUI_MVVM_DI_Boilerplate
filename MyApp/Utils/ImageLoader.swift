//
//  ImageLoader.swift
//  MyApp
//
//  Created by Thomas on 12/4/24.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellables = Set<AnyCancellable>()
    private static let cache = URLCache(
        memoryCapacity: 50 * 1024 * 1024, // 50 MB memory cache
        diskCapacity: 100 * 1024 * 1024, // 100 MB disk cache
        diskPath: "imageCache"
    )
    
    func loadImage(from url: URL) {
        if let cachedResponse = ImageLoader.cache.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return nil
                }
                let cachedData = CachedURLResponse(response: response, data: data)
                ImageLoader.cache.storeCachedResponse(cachedData, for: URLRequest(url: url))
                return UIImage(data: data)
            }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
            .store(in: &cancellables)
    }
}

struct CachedAsyncImage: View {
    @StateObject private var imageLoader = ImageLoader()
    @State private var isShowingFullScreen = false
    let url: URL?
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .onTapGesture {
                        isShowingFullScreen.toggle()
                    }
                    .fullScreenCover(isPresented: $isShowingFullScreen) {
                        FullScreenImageView(image: image, isPresented: $isShowingFullScreen)
                    }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if let url = url {
                imageLoader.loadImage(from: url)
            }
        }
    }
}

struct FullScreenImageView: View {
    let image: UIImage
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
            
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

