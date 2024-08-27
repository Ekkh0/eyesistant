//
//  AnalysisResultViewController.swift
//  Eyesistant
//
//  Created by vin chen on 21/08/24.
//

import UIKit

class AnalysisResultViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var season = Season(seasonName: "", seasonImage: "", seasonCharacter: "", seasonDescription: "", seasonColors: [], backgroundColor: .clear)
    var viewState = Int()
    
    @IBOutlet weak var undertoneLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stackText: UIStackView!
    @IBOutlet weak var colorStackView: UIStackView!
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var imageView7: UIImageView!
    @IBOutlet weak var imageView8: UIImageView!
    @IBOutlet weak var curvedBackground: UIImageView!
    
    var seasonBanner: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = season.backgroundColor
        
        if viewState == 0 {
            backButton.addTarget(self, action: #selector(goBackToDetector), for: .touchUpInside)
        }else{
            backButton.addTarget(self, action: #selector(goToMain), for: .touchUpInside)
        }
        backButton.layer.cornerRadius = backButton.frame.size.width / 2
        backButton.layer.masksToBounds = true
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSizeMake(0.2, 0.2)
        backButton.layer.shadowOpacity = 0.5
        backButton.layer.shadowRadius = 0.0
        
        undertoneLabel.text = season.seasonName
        
        characterLabel.text = season.seasonCharacter
        
        descriptionLabel.text = season.seasonDescription
        
        let imageViews = [imageView1, imageView2, imageView3, imageView4, imageView5, imageView6, imageView7, imageView8]

        let colors: [UIColor] = season.seasonColors

        guard colors.count == imageViews.count else {
            print("Error: The number of colors (\(colors.count)) does not match the number of image views (\(imageViews.count)).")
            return
        }

        for (index, imageView) in imageViews.enumerated() {
            guard let imageView = imageView else { continue }

            // Set background color
            imageView.backgroundColor = colors[index]

            // Style the imageView
            imageView.layer.cornerRadius = imageView.frame.size.width / 2
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 6
            imageView.layer.borderColor = UIColor.white.cgColor

            // Add long press gesture recognizer
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            imageView.addGestureRecognizer(longPressRecognizer)
            imageView.isUserInteractionEnabled = true // Make sure the imageView is interactable
        }

        var buttonConfiguration = startButton.configuration
        buttonConfiguration?.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 100, bottom: 16, trailing: 100)
        buttonConfiguration?.cornerStyle = .large
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 337),
            startButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        startButton.configuration = buttonConfiguration
        if viewState == 0 {
            startButton.backgroundColor = .buttonBlue
            startButton.setTitleColor(.white, for: .normal)
            startButton.layer.cornerRadius = 14
            startButton.addTarget(self, action: #selector(goToMain), for: .touchUpInside)
        }else{
            startButton.setTitle("Retake The Test", for: .normal)
            startButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
            startButton.setTitleColor(.buttonBlue, for: .normal)
            startButton.backgroundColor = .white
            startButton.layer.borderColor = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
            startButton.layer.borderWidth = 2
            startButton.layer.cornerRadius = 14
            startButton.addTarget(self, action: #selector(goBackToDetector), for: .touchUpInside)
        }
        
        let seasonImage = UIImage(named: season.seasonImage)
        seasonBanner = UIImageView(image: seasonImage)
        seasonBanner.frame = CGRect(x: 0, y: curvedBackground.bounds.minX+50, width: view.frame.width, height: 300)
        view.insertSubview(seasonBanner, at: 1)
        curvedBackground.layer.zPosition = 2
        stackText.layer.zPosition = 3
        startButton.layer.zPosition = 3
        colorStackView.layer.zPosition = 3
    }
    
    // Property to hold a reference to the current popover view
    var currentPopoverView: UIView?

    func showPopover(from sourceView: UIView, with text: String) {
        // Remove any existing popover view
        currentPopoverView?.removeFromSuperview()
        
        // Create and configure the popover view
        let popoverView = UIView()
        popoverView.backgroundColor = .white
        popoverView.layer.cornerRadius = 8
        popoverView.layer.borderWidth = 1
        popoverView.layer.borderColor = UIColor.black.cgColor
        
        // Create and configure the label
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 40) // Adjust size as needed
        popoverView.addSubview(label)
        
        // Set popover view frame
        popoverView.frame = CGRect(x: 0, y: 0, width: 100, height: 40) // Adjust size as needed
        
        // Add popover view to the main view
        self.view.addSubview(popoverView)
        
        // Calculate the position
        let sourceRect = sourceView.convert(sourceView.bounds, to: self.view)
        let popoverX = sourceRect.midX - popoverView.bounds.width / 2
        let popoverY = sourceRect.minY - popoverView.bounds.height - 10 // Adjust spacing from the image view
        
        popoverView.frame.origin = CGPoint(x: popoverX, y: popoverY)
        
        // Optionally, you can add an animation for showing the popover
        popoverView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            popoverView.alpha = 1
        }
        
        // Store a reference to the popover view
        currentPopoverView = popoverView
    }

    func dismissPopover() {
        guard let popoverView = currentPopoverView else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            popoverView.alpha = 0
        }) { _ in
            popoverView.removeFromSuperview()
        }
        
        // Clear the reference
        currentPopoverView = nil
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let imageView = gestureRecognizer.view as? UIImageView else { return }
        
        switch gestureRecognizer.state {
        case .began:
            guard let color = imageView.backgroundColor else { return }
            let hexValue = color.toHexString() // Convert color to hex string
            showPopover(from: imageView, with: hexValue)
        case .ended, .cancelled:
            dismissPopover()
        default:
            break
        }
    }

    @objc func goToMain(){
        performSegue(withIdentifier: "goToMain", sender: self)
    }
    
    @objc func goBackToDetector(){
        performSegue(withIdentifier: "goBackToDetector", sender: self)
    }
}
