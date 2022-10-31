
import UIKit

class HashtagDisplayViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
    var data: [Post]?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = self.view.bounds
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        let size = (view.width - 4) / 3
        layout.itemSize = CGSize(width: size, height: size)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let hasCollectionView = collectionView else {
            return
        }
        
        view.addSubview(hasCollectionView)
    }
    
    public func reloadCollectionView() {
        guard let hasCollectionView = collectionView else {
            return
        }
        hasCollectionView.reloadData()
    }


}

extension HashtagDisplayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        guard let hasData = self.data else {
            return cell
        }
        let username = hasData[indexPath.row].username
        let postId = hasData[indexPath.row].id
        cell.imageView.setPostImage(username: username, postId: postId)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let postListVC = PostListViewController()
        postListVC.titleText = self.title ?? ""
        guard let hasData = self.data else {
            return
        }
        postListVC.posts = hasData
        postListVC.indexpathRow = indexPath.row
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.pushViewController(postListVC, animated: true)
    }
}
