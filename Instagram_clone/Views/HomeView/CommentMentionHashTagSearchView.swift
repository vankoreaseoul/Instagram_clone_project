
import UIKit

protocol CommentMentionHashTagSearchViewDelegate {
    func selectCell(_ index: Int, _ text: String)
}

class CommentMentionHashTagSearchView: UIView {
    
    var index = 0 // 0: mention, 1: hashTag
    
    var delegate: CommentMentionHashTagSearchViewDelegate?
    
    private var collectionView: UICollectionView?
    
    var data: [String]?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        let size = (self.width - 4) / 3
        layout.itemSize = CGSize(width: size, height: 30)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(TextLabelCollectionViewCell.self, forCellWithReuseIdentifier: TextLabelCollectionViewCell.identifier)
        collectionView?.isUserInteractionEnabled = true
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let hasCollectionView = collectionView else {
            return
        }
        
        self.addSubview(hasCollectionView)
        hasCollectionView.frame = self.bounds
        hasCollectionView.backgroundColor = .systemGray5
    }
    
    public func reloadCollectionView() {
        self.collectionView?.reloadData()
    }

}

extension CommentMentionHashTagSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextLabelCollectionViewCell.identifier, for: indexPath) as! TextLabelCollectionViewCell
        guard let hasData = data else {
            return cell
        }
        let text = hasData[indexPath.row]
        cell.configureTextLabel(text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hasData = data else {
            return
        }
        let text = hasData[indexPath.row]
        delegate?.selectCell(index, text)
    }
}
