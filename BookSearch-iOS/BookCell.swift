import UIKit

class BookCell: UICollectionViewCell {
    
    var book: Book? {
        didSet {
            lblTitle.text = book?.title
            lblAuthor.text = book?.author
            
            let urlString = book?.getCoverUrl()
            if urlString != "" {
                let url = URL(string: urlString!)
                if let url = url {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if error != nil {
                            print(error ?? "")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.ivBookCover.image = UIImage(data: data!)
                        }
                    }.resume()
                } else {
                    self.ivBookCover.image = UIImage(named: "ic_nocover")
                }
            } else {
                self.ivBookCover.image = UIImage(named: "ic_nocover")
            }
        }
    }
    
    let ivBookCover: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let lblTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let lblAuthor: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Author"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BookCell {
    func setupViews() {
        addSubview(seperatorView)
        addSubview(ivBookCover)
        addSubview(lblAuthor)
        addSubview(lblTitle)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0(56)]-8-[v1]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : ivBookCover, "v1" : lblTitle]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(56)]-8-[v1(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : ivBookCover, "v1" : seperatorView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(24)]-8-[v1(24)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : lblTitle, "v1" : lblAuthor]))
        addConstraint(NSLayoutConstraint(item: lblAuthor, attribute: .width, relatedBy: .equal, toItem: lblTitle, attribute: .width, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: lblAuthor, attribute: .leading, relatedBy: .equal, toItem: lblTitle, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: seperatorView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0))
    }
}
