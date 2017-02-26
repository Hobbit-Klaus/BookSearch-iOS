import Foundation

class BookClient {
    let baseUrl = "http://openlibrary.org/"
    
    fileprivate func getApiUrl(_ relativeUrl: String) -> String {
        return "\(baseUrl)\(relativeUrl)"
    }
    
    func getBooks(query: String, completion: @escaping (Data?, URLResponse?, Error? ) -> Void) {
        let urlString = getApiUrl("search.json?q=\((query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)")
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}
