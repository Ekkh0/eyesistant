//
//  ViewController.swift
//  Eyesistant
//
//  Created by Dharmawan Ruslan on 19/08/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func navigateToDetector(_ sender:UIButton){
        performSegue(withIdentifier: "goToDetector", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToNewPage"{
//            // Create a variable that you want to send
//            var newProgramVar = 1
//            
//            // Create a new variable to store the instance of PlayerTableViewController
//            let destinationVC = segue.destination as! SkinToneDetectorViewController
//            destinationVC.a = newProgramVar
//        }
//    }
}
