//
//  MainViewController.swift
//  Eyesistant
//
//  Created by Dharmawan Ruslan on 21/08/24.
//

import Foundation
import UIKit
import AVFoundation

class MainViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate{
    var mainViewModel = MainViewModel()
    var captureSession: AVCaptureSession!
    let context = CIContext()
    var videoOutput: AVCaptureVideoDataOutput!
    var imageView: UIImageView!
    var sheetVC: SheetViewController!
    var currentCamera: AVCaptureDevice.Position = .back {
        didSet{
            if currentCamera == .front{
                setupHoodie(selectedColor: selectedColor!)
            }else if sweaterImage != nil{
                sweaterImage.removeFromSuperview()
            }
        }
    }
    var sweaterImage: UIImageView!
    var skinTone:RecommendationColors?{
        switch UserDefaults.standard.integer(forKey: "skinTone"){
        case 1:
            return RecommendationColors.init(label: "Spring")!
        case 2:
            return RecommendationColors.init(label: "Autumn")!
        case 3:
            return RecommendationColors.init(label: "Summer")!
        case 4:
            return RecommendationColors.init(label: "Winter")!
        default:
            return RecommendationColors.init(label: "Spring")
        }
    }
    var selectedColor:UIColor? = .red {
        didSet{
            if currentCamera == .front{
                sweaterImage.removeFromSuperview()
                setupHoodie(selectedColor: selectedColor!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd4K3840x2160
        
        setupCamera(position: .back)
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
        
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        
        let flipButton = UIButton(frame: CGRect(x: view.center.x-50, y: view.center.y+100, width: 100, height: 50))
        flipButton.setTitle("Flip", for: .normal)
        flipButton.backgroundColor = .blue
        flipButton.addTarget(self, action: #selector(flipCamera), for: .touchUpInside)
        view.insertSubview(flipButton, at: 2)
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        var person = UIImage(systemName: "person", withConfiguration: boldConfig)
        person = person?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let personView = UIImageView(image: person)
        personView.frame = CGRect(x: self.view.frame.maxX-80, y: 80, width: 30, height: 30)
        personView.contentMode = .scaleAspectFit
        personView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigateToResult))
        personView.addGestureRecognizer(gestureRecognizer)
        view.addSubview(personView)
        
        var menuButton = UIImage(systemName: "line.3.horizontal.decrease.circle.fill", withConfiguration: boldConfig)
        menuButton = menuButton?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let menuButtonView = UIImageView(image: menuButton)
        menuButtonView.frame = CGRect(x: self.view.frame.maxX-80, y: self.view.frame.maxY-80, width: 30, height: 30)
        menuButtonView.contentMode = .scaleAspectFit
        menuButtonView.isUserInteractionEnabled = true
        let menuGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bringUpColor))
        menuButtonView.addGestureRecognizer(menuGestureRecognizer)
        view.addSubview(menuButtonView)
    }
    
    @objc func bringUpColor(){
        showColorPicker()
    }
    
    @objc func navigateToResult(){
        if let sheetVC = sheetVC {
                    sheetVC.dismiss(animated: true, completion: {
                        self.sheetVC = nil // Clear the reference after dismissal
                    })
                }
        
        performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult"{
            var selectedSeason: Season!
            let seasons = SeasonSeeder.seed()
        let skinTone = UserDefaults.standard.integer(forKey: "skinTone")
        switch skinTone{
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
            print (skinTone)
            destinationVC.season = selectedSeason
            destinationVC.viewState = 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showColorPicker()
    }
    
    @objc func flipCamera() {
        currentCamera = (currentCamera == .back) ? .front : .back
        setupCamera(position: currentCamera)
    }
    
    @objc func showColorPicker() {
        sheetVC = SheetViewController()
        sheetVC.suggestedColor = skinTone!.colorHexes
        sheetVC.suggestedColorDescription = skinTone!.colorDesc
        sheetVC.suggestedColorName = skinTone!.colortitle
        sheetVC.modalPresentationStyle = .pageSheet
        
        sheetVC.onColorSelected = { [weak self] selectedColor in
            self?.selectedColor = selectedColor
        }
        
        if let sheet = sheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                0.25 * context.maximumDetentValue
            }), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .large
        }
        
        present(sheetVC, animated: true, completion: nil)
    }
    
    func setupHoodie(selectedColor: UIColor){
        var sweater = UIImage(named: "Sweater")
        sweater = sweater?.tintPhoto(selectedColor)
        sweaterImage = UIImageView(image: sweater)
        sweaterImage.frame = CGRect(x: self.view.frame.midX-self.view.frame.width*1.125, y: self.view.frame.midY*1.5 - self.view.frame.height, width: self.view.frame.width*2.25, height: self.view.frame.height*2.25)
        sweaterImage.contentMode = .scaleAspectFit
        sweaterImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(sweaterImage, at: 1)
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
        
        if currentCamera == .back{
            if let filteredImage = mainViewModel.applyChromaKeyFilter(to: ciImage, targetRed: selectedColor!.redValue, targetGreen: selectedColor!.greenValue, targetBlue: selectedColor!.blueValue, tolerance: 0.3) {
                // Convert the composited CIImage to CGImage and then UIImage
                if let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) {
                    let uiImage = UIImage(cgImage: cgImage)
                    DispatchQueue.main.async {
                        self.imageView.image = uiImage
                    }
                }
            }
        }else{
            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                let uiImage = UIImage(cgImage: cgImage)
                let finalImage = UIImage(cgImage: uiImage.cgImage!, scale: uiImage.scale, orientation: .upMirrored)
                DispatchQueue.main.async {
                    self.imageView.image = finalImage
                }
            }
        }
        
    }
}
