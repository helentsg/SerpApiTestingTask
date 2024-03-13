
import UIKit

enum FetchError:Error {
    case badID
    case badImage
    case badURL
}

protocol ImageLoaderProtocol {
    func image(from url: URL) async throws -> UIImage? 
}

actor ImageLoader : ImageLoaderProtocol {
    
    private enum CacheEntry {
        case inProgress(Task<UIImage, Error>)
        case ready(UIImage)
    }
    
    private var cache: [URL: CacheEntry] = [:]
    
    func image(from url: URL) async throws -> UIImage? {
        if let cached = cache[url] {
            switch cached {
                case .ready(let image):
                    return image
                case .inProgress(let handle):
                    return try await handle.value
            }
        }
        
        let handle = Task {
            try await downloadImage(from: url)
        }
        
        cache[url] = .inProgress(handle)
        
        do {
            let image = try await handle.value
            cache[url] = .ready(image)
            return image
        } catch {
            cache[url] = nil
            throw error
        }
    }
    
    func downloadImage(from url:URL) async throws -> UIImage{
        let request = URLRequest(url:url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badID }
        guard let image = UIImage(data: data) else { throw FetchError.badImage }
        return image
    }
    
}
