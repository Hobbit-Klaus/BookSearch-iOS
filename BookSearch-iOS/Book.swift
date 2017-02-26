import Foundation

class Book {    
    var openLibraryId: String?
    var author: String?
    var title: String?
    
    func getCoverUrl() -> String {
        if let id = openLibraryId {
            return "http://covers.openlibrary.org/b/olid/\(id)-M.jpg?default=true"
        } else {
            return ""
        }
    }
    
    func getLargeCoverUrl() -> String {
        if let id = openLibraryId {
            return "http://covers.openlibrary.org/b/olid/\(id)-L.jpg?default=true"
        } else {
            return ""
        }
    }
}
