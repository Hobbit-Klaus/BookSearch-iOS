import UIKit

extension UIImageView {
    func loadImageUrl(urlString: String) {
        let url = URL(string: urlString)
        
        image = nil
        
        if let url = url {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
                }.resume()
        } else {
            self.image = UIImage(named: "ic_nocover")
        }
    }
}
