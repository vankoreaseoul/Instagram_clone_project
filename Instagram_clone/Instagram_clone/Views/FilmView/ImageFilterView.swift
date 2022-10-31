
import UIKit
import CoreImage

protocol ImageFilterViewDelegate {
    func changeImageOnImageView(_ image: UIImage)
}

class ImageFilterView: UIView {
    
    var delegate: ImageFilterViewDelegate?
    
    private var cellList = [Bool]()    // cellState(isChecked) list
    
    private var oldIndexPath: IndexPath?
    
    var image: UIImage?
    
    private let context = CIContext()
    
    private let filternameList = ["CIPhotoEffectProcess", "CIPhotoEffectMono", "CISepiaTone", "CIColorClamp", "CIColorInvert", "CIPhotoEffectInstant", "CIColorMonochrome", "CIColorPosterize", "CIFalseColor", "CIVignette"]
    
    private var filterList = [CIFilter]()
    
    private var filteredImageList: [UIImage]?
    
    private var collectionView: UICollectionView?
    
    private let pageLabel: UILabel = {
       let label = UILabel()
        label.text = "Filter"
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard filteredImageList == nil else {
            return
        }
        configureFilterList()
        applyFilter()
        configureCollectionView()
        setDefault()
        setPageLabel()
    }
    
    private func configureFilterList() {
        for filtername in filternameList {
            let filter = CIFilter(name: filtername)!
            self.filterList.append(filter)
        }
    }
    
    private func applyFilter() {
        guard let hasImage = self.image else {
            return
        }
        let originalCIImage = CIImage(image: hasImage)
        var imageList = [UIImage]()
        imageList.append(hasImage)
        self.cellList.append(false)
        
        for filter in filterList {
            filter.setValue(originalCIImage, forKey: kCIInputImageKey)
            let changedCIImage = filter.outputImage ?? CIImage()
            let changedUIImage = UIImage(ciImage: changedCIImage)
            imageList.append(changedUIImage)
            self.cellList.append(false)
        }
        
        filteredImageList = imageList
        collectionView?.reloadData()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let size = (self.width - 2) / 3
        layout.itemSize = CGSize(width: size, height: size)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let hasCollectionView = collectionView else {
            return
        }
        self.addSubview(hasCollectionView)
        hasCollectionView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height - 50)
        hasCollectionView.backgroundColor = .black
    }
    
    private func setDefault() {
        let indexPath = IndexPath(row: 0, section: 0)
        
        guard let hasCollectionView = collectionView else {
            return
        }
        self.collectionView(hasCollectionView, didSelectItemAt: indexPath)
    }
    
    private func setPageLabel() {
        let tabBarHeight = (self.next?.next as? UIViewController)?.tabBarController?.tabBar.frame.size.height ?? 0
        
        self.addSubview(pageLabel)
        pageLabel.frame = CGRect(x: 0, y: self.height, width: self.width, height: tabBarHeight)
    }
}

extension ImageFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImageList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
       
        if let filteredImageListExists = filteredImageList {
            cell.backgroundColor = .black
            cell.imageView.image = filteredImageListExists[indexPath.row]
            cell.imageView.frame.origin.y = cell.frame.origin.y + 5
            let nameLabel = UILabel()
            nameLabel.textAlignment = .center
            nameLabel.font = nameLabel.font.withSize(12)
            nameLabel.textColor = .systemGray.withAlphaComponent(0.8)
            nameLabel.backgroundColor = .black
            cell.addSubview(nameLabel)
            nameLabel.frame = CGRect(x: 0, y: 0, width: cell.width, height: 30)
            
            if indexPath.row == 0 {
                nameLabel.text = "Normal"
            } else if indexPath.row < 11 {
                let filtername = filternameList[indexPath.row - 1]
                let edittedFiltername = filtername.replacingOccurrences(of: "CI", with: "").replacingOccurrences(of: "PhotoEffect", with: "").replacingOccurrences(of: "Color", with: "")
                nameLabel.text = edittedFiltername
            }
        }
        
        if let value = cellList[indexPath.row] as? Bool {
            if value {
                ((cell.subviews.last ?? UIView()) as? UILabel)?.textColor = .white.withAlphaComponent(1.0)
            } else {
                ((cell.subviews.last ?? UIView()) as? UILabel)?.textColor = .systemGray.withAlphaComponent(0.8)
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let hasOldIndexPath = oldIndexPath {
            cellList[hasOldIndexPath.row] = false
        }
        oldIndexPath = indexPath
        cellList[oldIndexPath!.row] = true
        delegate?.changeImageOnImageView(filteredImageList?[indexPath.row] ?? UIImage())
        collectionView.reloadData()
    }
    
    
}
