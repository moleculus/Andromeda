import SDWebImage

public class ImageLoader {

    // MARK: - Properties.

    private var operation: SDWebImageOperation?

    // MARK: - Initialization.
    
    public init() {}
    
    // MARK: - Public.
    
    public func fetch(from url: URL?, then completion: @escaping (Result) -> Void) {
        guard let url = url else {
            completion(.failure)
            return
        }
        
        operation = SDWebImageManager.shared.loadImage(with: url, options: .retryFailed, progress: { receivedSize, expectedSize, _ in
            let progress = Double(receivedSize) / Double(expectedSize)
            completion(.progress(progress))
        }, completed: { image, _, _, _, _, _ in
            if let image = image {
                completion(.success(image))
            }
            else {
                completion(.failure)
            }
        })
    }
    
    public func prefetchImage(from url: URL?) {
        guard let url = url else {
            return
        }
        
        SDWebImagePrefetcher.shared.prefetchURLs([url])
    }
    
    public func cancel() {
        operation?.cancel()
    }

}
