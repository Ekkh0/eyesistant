//
//  TutorialPageViewController.swift
//  Eyesistant
//
//  Created by vin chen on 22/08/24.
//
import UIKit

class TutorialPageViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var buttonConfiguration = startButton.configuration
        buttonConfiguration?.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 100, bottom: 16, trailing: 100)
        buttonConfiguration?.cornerStyle = .capsule
        startButton.configuration = buttonConfiguration
    }
    @IBAction func nextPage(_ sender:UIButton){
        performSegue(withIdentifier: "nextPage", sender: self)
    }

}
