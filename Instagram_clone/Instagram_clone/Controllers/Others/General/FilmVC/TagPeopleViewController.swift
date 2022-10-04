
import UIKit

class TagPeopleViewController: UIViewController {
    
    var image: UIImage?
    
    private var tableView: UITableView?
    
    private var data = [(String, String)]()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let defaultLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap photo to tag people."
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureNaviBar()
        addSubViews()
        addGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignFrames()
    }
    
    private func configureNaviBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
    }
    
    @objc func didTapDoneButton() {
        print(1)
        self.dismiss(animated: true)
    }
    
    private func addSubViews() {
        self.view.addSubview(imageView)
        imageView.image = self.image
        
        self.view.addSubview(defaultLabel)
    }
    
    private func assignFrames() {
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let naviBarHeight = self.navigationController?.navigationBar.height ?? 0
        let viewHeight = self.view.height - (statusHeight + naviBarHeight)
        imageView.frame = CGRect(x: 0, y: statusHeight + naviBarHeight, width: self.view.width, height: viewHeight / 2)
        defaultLabel.frame = CGRect(x: 90, y: imageView.bottom + 100, width: self.view.width - 180, height: 50)
    }

    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc func didTapImageView() {
        let exploreVC = ExploreViewController()
        exploreVC.delegate = self
        let exploreNC = UINavigationController(rootViewController: exploreVC)
        exploreNC.modalPresentationStyle = .fullScreen
        self.present(exploreNC, animated: true)
    }
    
    private func configureHeader() {
        let header = UIButton()
        header.setImage(UIImage(systemName: "plus"), for: .normal)
        header.setTitle("  Tag Another Person", for: .normal)
        header.tintColor = .systemBlue
        header.setTitleColor(.systemBlue, for: .normal)
        self.view.addSubview(header)
        header.frame = CGRect(x: 0, y: imageView.bottom + 20, width: view.width, height: 30)
        self.imageView.isUserInteractionEnabled = false
        header.addTarget(self, action: #selector(didTapImageView), for: .touchUpInside)
    }
    
    private func configureTableView() {
        tableView = UITableView()
        tableView?.register(PeopleTableViewCell.self, forCellReuseIdentifier: PeopleTableViewCell.identifier)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        tableView?.frame = CGRect(x: 0, y: imageView.bottom + 50, width: self.view.width, height: self.view.height - imageView.bottom - 50 - 30)
    }
    
}

extension TagPeopleViewController: ExploreViewControllerDelegate {
    func enrollTaggedPeople(_ person: (String, String)) {
        if defaultLabel.frame.origin.y == imageView.bottom + 100 {
            defaultLabel.frame.size = .zero
            
            configureHeader()
            configureTableView()
        }
        
        for i in 0..<data.count {
            if data[i].0 == person.0 {
                return
            }
        }
        
        data.append(person)
        tableView?.reloadData()
    }
    
}

extension TagPeopleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
        cell.showRemoveButton()
        cell.imageView?.image = UIImage(named: "profileImage2")
        
        let imagePath = data[indexPath.row].1
        if !imagePath.isEmpty {
            StorageManager.shared.download(imagePath) { image in
                DispatchQueue.main.async {
                    cell.imageView?.image = image
                }
            }
        }
      
        cell.textLabel?.text = data[indexPath.row].0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        
//        let cell = tableView.cellForRow(at: indexPath) as! PeopleTableViewCell
//        if cell.isRemoved {
//            print(indexPath.row)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
