//
//  SkinToneDetectorView.swift
//  Eyesistant
//
//  Created by Dharmawan Ruslan on 19/08/24.
//


import UIKit
import AVFoundation
import CoreImage.CIFilterBuiltins

class SkinToneDetectorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    let skinToneDetection = SkinToneDetection()
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    let context = CIContext()
    var videoOutput: AVCaptureVideoDataOutput!
    
    var capturedImage: UIImage?
    var savedImage: UIImage?
    var overlayHint: UIView!
    var notice: UIStackView!
    var captureButton: UIImageView!
    var proceedButtons: UIStackView!
    var currentCamera: AVCaptureDevice.Position = .front
    var noticeType: [Int] = [] {
        didSet{
            if overlayHint.isHidden{
                if savedImage == nil{
                    if noticeType == [] && notice != nil{
                        notice.removeFromSuperview()
                        self.setupNotice(error: false, types: [0, 1])
                        captureButton.isUserInteractionEnabled = true
                        captureButton.layer.opacity = 1
                    }else if notice != nil{
                        notice.removeFromSuperview()
                        self.setupNotice(error: true, types: noticeType)
                        captureButton.isUserInteractionEnabled = false
                        captureButton.layer.opacity = 0.3
                    }else if noticeType == [] && notice == nil{
                        self.setupNotice(error: false, types: [0, 1])
                        captureButton.isUserInteractionEnabled = true
                        captureButton.layer.opacity = 1
                    }else if notice == nil{
                        self.setupNotice(error: true, types: noticeType)
                        captureButton.isUserInteractionEnabled = false
                        captureButton.layer.opacity = 0.3
                    }
                }else{
                    notice.removeFromSuperview()
                }
            }
        }
    }
    var luxLevel: Double? = 0{
        didSet {
            if luxLevel! < 10.0 && !noticeType.contains(1){
                noticeType.append(1)
            }else if luxLevel! > 10.0 && noticeType.contains(1){
                noticeType.remove(at: noticeType.firstIndex(of: 1)!)
            }
        }
    }
    var faceDetected: Bool = false{
        didSet{
            if !faceDetected && !noticeType.contains(0){
                noticeType.append(0)
            }else if faceDetected && noticeType.contains(0){
                noticeType.remove(at: noticeType.firstIndex(of: 0)!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "personalColor")
        //         Set up the capture session
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd4K3840x2160
        
        setupCamera(position: currentCamera)
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = self.view.layer.bounds
        self.view.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
        
        captureButton = UIImageView(image: UIImage(named: "CaptureButton"))
        captureButton.frame = CGRect(x: self.view.frame.midX-50, y: self.view.frame.height - 200, width: 100, height: 100)
        captureButton.contentMode = .scaleAspectFit
        captureButton.isUserInteractionEnabled = true
        let cameraTap = UITapGestureRecognizer(target: self, action: #selector(captureTapped))
        captureButton.addGestureRecognizer(cameraTap)
        self.view.addSubview(captureButton)
        
        overlayHint = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        overlayHint.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        overlayHint.layer.zPosition = 3
        self.view.addSubview(overlayHint)
        
        let hint = UIStackView()
        hint.axis = .vertical
        hint.spacing = 50
        hint.translatesAutoresizingMaskIntoConstraints = false
        hint.alignment = .center
        hint.distribution = .equalSpacing
        overlayHint.addSubview(hint)
        
        NSLayoutConstraint.activate([
            hint.centerXAnchor.constraint(equalTo: overlayHint.centerXAnchor),
            hint.centerYAnchor.constraint(equalTo: overlayHint.centerYAnchor),
        ])
        
        for num in [1, 2, 3]{
            let hintRow = UIStackView()
            hintRow.axis = .horizontal
            hintRow.alignment = .fill
            hintRow.distribution = .fillEqually
            
            let circle = UIView(frame: CGRect(x: 2.5, y: 2.5, width: 25, height: 25))
            circle.backgroundColor = .white
            circle.layer.cornerRadius = 25/2
            hintRow.addSubview(circle)
            
            let number = UILabel()
            number.text = String(num)
            number.textColor = .hintBlue
            number.textAlignment = .center
            number.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            number.translatesAutoresizingMaskIntoConstraints = false
            circle.addSubview(number)
            
            let hintRowBackground = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 30))
            hintRowBackground.backgroundColor = .hintBlue
            hintRowBackground.layer.cornerRadius = 15
            hintRow.addSubview(hintRowBackground)
            
            let text = UILabel()
            if num == 1 {
                text.text = "Move somewhere to a well-lit area"
            }else if num == 2 {
                text.text = "Align your face direclty with the screen"
            }else if num == 3 {
                text.text = "Press the capture button down below!"
            }
            text.textColor = .white
            text.textAlignment = .left
            text.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            text.translatesAutoresizingMaskIntoConstraints = false
            hintRowBackground.addSubview(text)
            
            circle.layer.zPosition = 2
            
            //            hintRow.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hintRow.widthAnchor.constraint(equalToConstant: 350)
            ])
            hint.addArrangedSubview(hintRow)
            NSLayoutConstraint.activate([
                number.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
                number.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
                text.centerXAnchor.constraint(equalTo: hintRowBackground.centerXAnchor),
                text.centerYAnchor.constraint(equalTo: hintRowBackground.centerYAnchor),
            ])
        }
        
        // Add the image view
        let imageView = UIImageView(image: UIImage(named: "hintBird"))
        imageView.contentMode = .scaleAspectFit
        hint.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 220), // Adjust as needed
            imageView.heightAnchor.constraint(equalToConstant: 220), // Adjust as needed
        ])
        
        // Add the button
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(removeHint), for: .touchUpInside)
        button.setTitle("Next >", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(white: 0, alpha: 0.001)
        button.translatesAutoresizingMaskIntoConstraints = false
        hint.addArrangedSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150), // Adjust as needed
            button.heightAnchor.constraint(equalToConstant: 50)  // Adjust as needed
        ])
        
//        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
//        var flipCam = UIImage(systemName: "camera.rotate.fill", withConfiguration: boldConfig)
//        flipCam = flipCam?.withTintColor(.white, renderingMode: .alwaysOriginal)
//        let flipCamView = UIImageView(image: flipCam)
//        flipCamView.frame = CGRect(x: self.view.frame.maxX-80, y: 80, width: 30, height: 30)
//        flipCamView.contentMode = .scaleAspectFit
//        flipCamView.isUserInteractionEnabled = true
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flipCamera))
//        flipCamView.addGestureRecognizer(gestureRecognizer)
//        view.addSubview(flipCamView)
    }
    
    @objc func flipCamera() {
        currentCamera = (currentCamera == .back) ? .front : .back
        setupCamera(position: currentCamera)
    }
    
    @objc func removeHint(){
        overlayHint.isHidden = true
        refreshNotice()
    }
    
    func refreshNotice(){
        if noticeType == []{
            setupNotice(error: false, types: [0, 1])
            captureButton.isUserInteractionEnabled = true
            captureButton.layer.opacity = 1
        }else{
            setupNotice(error: true, types: noticeType)
            captureButton.isUserInteractionEnabled = false
            captureButton.layer.opacity = 0.3
        }
    }
    
    @objc func captureTapped(){
        self.savedImage = capturedImage
        videoPreviewLayer.connection?.isEnabled = false
        captureButton.isHidden = true
        notice.removeFromSuperview()
        
        if proceedButtons == nil{
            setupProceedButtons()
        }else{
            proceedButtons.isHidden = false
        }
    }
    
    @objc func retakePicture(){
        videoPreviewLayer.connection?.isEnabled = true
        captureButton.isHidden = false
        proceedButtons.isHidden = true
        savedImage = nil
        refreshNotice()
    }
    
    @objc func proceedWithPicture(){
        let defaults = UserDefaults.standard
        defaults.set(skinToneDetection.detectSkinTone(in: savedImage!), forKey: "skinTone")
        
        let imageData = savedImage!.jpegData(compressionQuality: 1)
        let relativePath = "image_user.jpg"
        let fileURL = getDocumentsDirectory().appendingPathComponent(relativePath)
        do {
            try imageData!.write(to: fileURL)
            print("Image saved successfully")
        } catch {
            print("Error saving image: \(error)")
        }
        defaults.set(relativePath, forKey: "userImagePath")
        defaults.synchronize()

        performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult"{
            var selectedSeason: Season!
            let seasons = SeasonSeeder.seed()
            switch skinToneDetection.detectSkinTone(in: savedImage!){
            case 1:
                selectedSeason = seasons.first { $0.seasonName == "Spring" }!
            case 2:
                selectedSeason = seasons.first { $0.seasonName == "Autumn" }!
            case 3:
                selectedSeason = seasons.first { $0.seasonName == "Summer" }!
            case 4:
                selectedSeason = seasons.first { $0.seasonName == "Winter" }!
            default:
                selectedSeason = nil
            }
            
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! AnalysisResultViewController
            destinationVC.season = selectedSeason
            destinationVC.viewState = 0
        }
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func loadImage(fileName: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func setupProceedButtons(){
        let proceed = UIButton(type: .custom)
        proceed.setTitle("Use This Picture", for: .normal)
        proceed.setTitleColor(.white, for: .normal)
        proceed.titleLabel?.font = .boldSystemFont(ofSize: 20)
        proceed.backgroundColor = .hintBlue
        proceed.layer.cornerRadius = 15
        proceed.addTarget(self, action: #selector(proceedWithPicture), for: .touchUpInside)
        proceed.translatesAutoresizingMaskIntoConstraints = false
        
        let retake = UIButton(type: .custom)
        retake.setTitle("Retake", for: .normal)
        retake.setTitleColor(.hintBlue, for: .normal)
        retake.titleLabel?.font = .boldSystemFont(ofSize: 20)
        retake.backgroundColor = .white
        retake.layer.cornerRadius = 15
        retake.addTarget(self, action: #selector(retakePicture), for: .touchUpInside)
        retake.translatesAutoresizingMaskIntoConstraints = false
        
        proceedButtons = UIStackView()
        proceedButtons.axis = .vertical
        proceedButtons.alignment = .center
        proceedButtons.spacing = 20
        proceedButtons.translatesAutoresizingMaskIntoConstraints = false
        proceedButtons.addArrangedSubview(proceed)
        proceedButtons.addArrangedSubview(retake)
        self.view.addSubview(proceedButtons)
        
        NSLayoutConstraint.activate([
            proceed.widthAnchor.constraint(equalToConstant: 330), // Adjust as needed
            proceed.heightAnchor.constraint(equalToConstant: 50)  // Adjust as needed
        ])
        
        NSLayoutConstraint.activate([
            retake.widthAnchor.constraint(equalToConstant: 330), // Adjust as needed
            retake.heightAnchor.constraint(equalToConstant: 50)  // Adjust as needed
        ])
        
        NSLayoutConstraint.activate([
            proceedButtons.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            proceedButtons.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100)
        ])
    }
    
    func setupMessage(error: Bool, type: Int) -> UIView{
        let notice = UIStackView()
        notice.translatesAutoresizingMaskIntoConstraints = false
        
        var symbol:UIImageView!
        if error{
            symbol = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
        }else{
            symbol = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        }
        symbol.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            symbol.widthAnchor.constraint(equalToConstant: 30), // Adjust as needed
            symbol.heightAnchor.constraint(equalToConstant: 30), // Adjust as needed
        ])
        symbol.tintColor = .white
        symbol.translatesAutoresizingMaskIntoConstraints = false
        notice.addArrangedSubview(symbol)
        
        let noticeText = UILabel()
        if error{
            noticeText.text = type == 0 ? "No Face Detected" : "Insufficient Lighting"
        }else{
            noticeText.text = type == 0 ? "Face Detected" : "Sufficient Lighting"
        }
        noticeText.textColor = .white
        noticeText.textAlignment = .center
        noticeText.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        noticeText.translatesAutoresizingMaskIntoConstraints = false
        notice.addArrangedSubview(noticeText)
        
        let noticeContainer = UIView()
        noticeContainer.backgroundColor = error ? .badRed : .goodGreen
        noticeContainer.addSubview(notice)
        noticeContainer.layer.cornerRadius = 7
        noticeContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notice.leadingAnchor.constraint(equalTo: noticeContainer.leadingAnchor, constant: 10),
            notice.topAnchor.constraint(equalTo: noticeContainer.topAnchor, constant: 5),
            notice.bottomAnchor.constraint(equalTo: noticeContainer.bottomAnchor, constant: -5),
            notice.trailingAnchor.constraint(equalTo: noticeContainer.trailingAnchor, constant: -10),
            symbol.trailingAnchor.constraint(equalTo: noticeText.leadingAnchor, constant: -10),
            //            noticeText.centerXAnchor.constraint(equalTo: notice.centerXAnchor),
        ])
        return noticeContainer
    }
    
    func setupNotice(error: Bool, types: [Int]){
        notice = UIStackView()
        notice.axis = .vertical
        notice.translatesAutoresizingMaskIntoConstraints = false
        notice.alignment = .center
        notice.spacing = 30
        
        if error{
            let image = UIImageView(image: UIImage(named: "noticeBird"))
            image.contentMode = .scaleAspectFit
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalToConstant: 220), // Adjust as needed
                image.heightAnchor.constraint(equalToConstant: 220), // Adjust as needed
            ])
            
            notice.addArrangedSubview(image)
        }
        
        for type in types{
            let noticeMessage = setupMessage(error: error, type: type)
            notice.addArrangedSubview(noticeMessage)
            NSLayoutConstraint.activate([
                noticeMessage.centerXAnchor.constraint(equalTo: notice.centerXAnchor),
            ])
        }
        self.view.insertSubview(notice, at: 1)
        
        NSLayoutConstraint.activate([
            notice.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            notice.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -20),
        ])
    }
    
    func setupCamera(position: AVCaptureDevice.Position) {
        // Clear existing inputs
        captureSession.beginConfiguration()
        captureSession.inputs.forEach { input in
            captureSession.removeInput(input)
        }
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            print("Unable to access camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession.addInput(input)
        } catch {
            print("Error Unable to initialize camera: \(error.localizedDescription)")
        }
        
        // Set up video output
        if videoOutput == nil {
            videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(videoOutput)
        }
        
        if let connection = videoOutput.connection(with: .video) {
            connection.videoOrientation = .portrait
        }
        
        captureSession.commitConfiguration()
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        DispatchQueue.main.async{ [self] in
            luxLevel = skinToneDetection.getLuminosity(sampleBuffer: sampleBuffer)
        }
        
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            DispatchQueue.main.async {
                self.faceDetected = self.skinToneDetection.detectFace(in: uiImage)
                self.capturedImage = uiImage
            }
        }
    }
}
