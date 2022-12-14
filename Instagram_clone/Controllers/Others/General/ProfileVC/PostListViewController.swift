
import UIKit

class PostListViewController: HomeViewController {
    
    var indexpathRow = 0
    var titleText = ""
    private var isScrolled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureNaviBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        if isScrolled == false {
            scrollMoveToCertainCell()
            isScrolled = true
        }
    }
    
    override func assignFrames() {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let totalHeight = self.view.height - (statusHeight + navigationBarHeight)
        tableView?.frame = CGRect(x: 0, y: statusHeight + navigationBarHeight, width: self.view.width, height: totalHeight)
    }
    
    private func configureNaviBar() {
        let titleText = titleText
        let title = UILabel()
        title.textColor = .black
        title.text = titleText
        title.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: title)
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func setFollowingList() {
        tableView?.reloadData()
    }
    
    override func scrollToFirstRow() {
        return
    }
    
    private func scrollMoveToCertainCell() {
        let indexpath = IndexPath(row: indexpathRow * 4, section: 0)
        tableView?.scrollToRow(at: indexpath, at: .top, animated: true)
    }

    override func tapDoneButton(_ indexpathRow: Int, _ post: Post) {
        let index = indexpathRow / 4
        super.posts.remove(at: index)
        var emptyPostList = [Post]()
        emptyPostList.append(contentsOf: super.posts)
        super.posts.removeAll()
        super.posts.append(post)
        super.posts.append(contentsOf: emptyPostList)
        tableView?.reloadData()
        tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
