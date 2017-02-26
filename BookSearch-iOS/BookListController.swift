import UIKit

class BookListController: UIViewController {
    
    lazy var cvBooks: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .lightGray
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let minSpacing: CGFloat = 1
    var books: [Book]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchBooks()
    }
    
}

extension BookListController {
    func setupViews() {
        navigationItem.title = "BookSearch"
        view.addSubview(cvBooks)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvBooks]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvBooks]))
        
        cvBooks.register(BookCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func fetchBooks() {
        books = [Book]()
        let bookClient = BookClient()
        bookClient.getBooks(query: "oscar Wilde") { (data, response, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let docs = (json as! [String: AnyObject])["docs"] {
                    for document in docs as! [[String: AnyObject]] {
                        let book = Book()
                        if let editionKey = document["cover_edition_key"] {
                            book.openLibraryId = editionKey as? String
                        } else if let editionKey = document["edition_key"] {
                            let ids = editionKey as! [String]
                            book.openLibraryId = ids[0]
                        }
                        
                        if let title = document["title_suggest"] {
                            book.title = title as? String
                        } else {
                            book.title = ""
                        }
                        
                        if let authors = document["author_name"] {
                            for author in authors as! [String] {
                                if book.author != nil {
                                    book.author = "\(book.author), \(author)"
                                } else {
                                    book.author = "\(author)"
                                }
                            }
                        }
                        self.books?.append(book)
                    }
                    
                    DispatchQueue.main.async {
                        self.cvBooks.reloadData()
                    }
                }
            } catch let jsonError{
                print(jsonError)
            }
        }
    }
}

extension BookListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookCell
        cell.book = books?[indexPath.item]
        return cell
    }
}

extension BookListController: UICollectionViewDelegate {
}

extension BookListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 73)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minSpacing
    }
}
