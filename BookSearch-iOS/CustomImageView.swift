import UIKit

class CustomImageView: UIImageView {
    
    let imageCache = NSCache<AnyObject, UIImage>()
    var imageUrl: String?
    
    func loadImageUrl(urlString: String) {
        imageUrl = urlString
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            self.image = imageFromCache
            return
        }
        
        if let url = url {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    if self.imageUrl == urlString {
                        self.image = imageToCache
                    }
                    self.imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                }
            }.resume()
        } else {
            self.image = UIImage(named: "ic_nocover")
        }
    }
}
