
import AVFoundation
import UIKit

class CameraViewController: UIViewController {
    
    private var image: UIImage?
    
    private let changeCameraModeButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.layer.cornerRadius = 25
        button.tintColor = .systemGray
        button.backgroundColor = .systemBackground
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        return button
    }()
    
    private let retakeButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.layer.cornerRadius = 25
        button.tintColor = .systemGray
        button.backgroundColor = .systemBackground
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.layer.cornerRadius = 25
        button.tintColor = .systemGray
        button.backgroundColor = .systemBackground
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        return button
    }()
    
    private let closeButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.layer.cornerRadius = 5
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    var isFront = true
    var device: AVCaptureDevice?
    
    // Capture Session
    var session: AVCaptureSession?
    // Photo Output
    let output = AVCapturePhotoOutput()
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    // Shutter button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(closeButton)
        view.addSubview(changeCameraModeButton)
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        changeCameraModeButton.addTarget(self, action: #selector(didTapChangeCameraModeButton), for: .touchUpInside)
        
        checkCameraPermissions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        
        shutterButton.center = CGPoint(x: view.width / 2, y: view.height - 100)
        closeButton.center = CGPoint(x: 30, y: 60)
        changeCameraModeButton.center = CGPoint(x: view.width - 55, y: 65)
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            // Request
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }

    private func chooseCamera() {
        if isFront {
            if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                    for: .video, position: .front) {
                self.device = device
            } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                           for: .video, position: .front) {
                self.device = device
            } else {
                fatalError("Missing expected back camera device.")
            }
        } else {
            if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                    for: .video, position: .back) {
                self.device = device
            } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                           for: .video, position: .back) {
                self.device = device
            } else {
                fatalError("Missing expected back camera device.")
            }
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        chooseCamera()
        if let hasDevice = self.device {
            do {
                let input = try AVCaptureDeviceInput(device: hasDevice)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                }
                self.session = session
            } catch {
                print(error)
            }
        }
        
        
    }
    
    private func changeCameraMode() {
        session!.beginConfiguration()
        chooseCamera()
        if let hasDevice = self.device {
            for input in session!.inputs {
                session?.removeInput(input as! AVCaptureDeviceInput)
            }
            do {
                let input = try AVCaptureDeviceInput(device: hasDevice)
                if session!.canAddInput(input) {
                    session!.addInput(input)
                }
            } catch {
                print(error)
            }
        }
        session?.commitConfiguration()
    }
    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    private func setButtons() {
        view.addSubview(saveButton)
        view.addSubview(retakeButton)
        saveButton.center = CGPoint(x: 55, y: view.height - 55)
        retakeButton.center = CGPoint(x: view.width - 55, y: view.height - 55)
        
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        retakeButton.addTarget(self, action: #selector(didTapRetakeButton), for: .touchUpInside)
    }
    
    @objc func didTapSaveButton() {
        guard let hasImage = image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(hasImage, nil, nil, nil)
        self.didTapRetakeButton()
        self.showAlertMessage(title: nil, message: "Saved!", completion: nil)
    }
    
    @objc func didTapRetakeButton() {
        guard let subView = view.viewWithTag(6) else {
            return
        }
        subView.removeFromSuperview()
        DispatchQueue.global(qos: .background).async {
            self.session?.startRunning()
        }
        self.retakeButton.removeFromSuperview()
        self.saveButton.removeFromSuperview()
    }
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapChangeCameraModeButton() {
        if isFront {
            isFront = false
        } else {
            isFront = true
        }
        changeCameraMode()
    }
    
    
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        image = UIImage(data: data)
        
        session?.stopRunning()
        
        let imageView = UIImageView(image: image)
        imageView.tag = 6
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
        setButtons()
    }
}
