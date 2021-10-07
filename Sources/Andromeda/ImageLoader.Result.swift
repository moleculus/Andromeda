import UIKit

extension ImageLoader {
    public enum Result {
        case progress (Double)
        case success (UIImage)
        case failure
    }
}
