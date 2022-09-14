
import UIKit

protocol EditProfileImageMenuViewDelegate: AnyObject {
    func closeMenuSheet()
    func presentLibrary(_ vc: UIViewController)
    func addProfileImage(_ image: UIImage)
}

class EditProfileImageMenuView: UIView, UINavigationControllerDelegate {
    
    struct EditProfileImageMenuCellModel {
        let title: String
        let handler: () -> Void
    }
    
    lazy var data = [EditProfileImageMenuCellModel]()
    
    weak var delegate: EditProfileImageMenuViewDelegate?
    
    private let menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let container: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 24
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.systemGray, for: .normal)
        cancelButton.backgroundColor = .systemBackground
        cancelButton.layer.cornerRadius = 20
        return cancelButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray.withAlphaComponent(0.8)
        addSubview(container)
        addSubview(cancelButton)
        addButtonAction()
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        configureCellModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.frame = CGRect(x: 20, y: self.height * 0.6, width: self.width - 40, height: self.height * 0.3 * 0.9)
        cancelButton.frame = CGRect(x: 20, y: container.bottom + 10, width: self.width - 40, height: container.height / 5)
        
        configureMenuTableView()
    }
    
    private func configureCellModel() {
        data.append(EditProfileImageMenuCellModel(title: "Change Profile Photo", handler: {
            
        }))
        data.append(EditProfileImageMenuCellModel(title: "Remove Current Photo", handler: {
            self.didTapRemoveButton()
        }))
        data.append(EditProfileImageMenuCellModel(title: "Take Photo", handler: {
            self.didTapPhotoButton()
        }))
        data.append(EditProfileImageMenuCellModel(title: "Choose From Library", handler: {
            self.didTapLibraryButton()
        }))
    }
    
    private func configureMenuTableView() {
        container.addSubview(menuTableView)
        menuTableView.frame = container.bounds
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    private func addButtonAction() {
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    @objc func didTapCancelButton() {
        delegate?.closeMenuSheet()
    }
    
    private func didTapRemoveButton() {
        
    }
    
    private func didTapPhotoButton() {
        
    }
    
    private func didTapLibraryButton() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        delegate?.presentLibrary(vc)
        removeFromSuperview()
    }
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)

     @objc func handleDismiss(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.window)

         if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
         } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.frame.size.width, height: self.frame.size.height)
            }
         } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.removeFromSuperview()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                })
            }
        }
     }

    
    

}

extension EditProfileImageMenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].title
        cell.textLabel?.textAlignment = .center
        
        if indexPath.row == 0 {
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            cell.selectionStyle = .none
        } else {
            cell.textLabel?.textColor = .systemGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].handler()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return container.height / 4
    }
    
}

extension EditProfileImageMenuView: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            delegate?.addProfileImage(image)
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
