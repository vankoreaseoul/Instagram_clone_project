
import UIKit
import CoreImage

class ImageFilterView: UIView {
    
    var image: UIImage?
    
    private let context = CIContext()
    
    private let filternameList = ["CIPhotoEffectProcess", "CIPhotoEffectMono", "CISepiaTone", "CIColorClamp", "CIColorInvert", "CIColorMap", "CIColorMonochrome", "CIColorPosterize", "CIFalseColor", "CIVignette"]
    
    private var filterList = [CIFilter]()
    
    private var filteredImageList: [UIImage]?
    
    private var collectionView: UICollectionView?

    override init(frame: CGRect) {
        super.init(frame: frame)
//        configureFilterList()
//        applyFilter()
//        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureFilterList()
        applyFilter()
        configureCollectionView()
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
        
        for filter in filterList {
            filter.setValue(originalCIImage, forKey: kCIInputImageKey)
            // filter.setValue(0.9, forKey: kCIInputIntensityKey)
            let changedCIImage = filter.outputImage ?? CIImage()
            let changedUIImage = UIImage(ciImage: changedCIImage)
            imageList.append(changedUIImage)
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
        let size = (self.width - 3) / 4
        layout.itemSize = CGSize(width: size, height: size)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let hasCollectionView = collectionView else {
            return
        }
        self.addSubview(hasCollectionView)
        hasCollectionView.frame = CGRect(x: 0, y: 30, width: self.width, height: 60)
    }
    
}

extension ImageFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImageList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
       
        if let filteredImageListExists = filteredImageList {
            cell.imageView.image = filteredImageListExists[indexPath.row]
        }

        return cell
    }
    
    
}
