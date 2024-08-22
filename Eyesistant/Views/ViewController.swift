//
//  ViewController.swift
//  Eyesistant
//
//  Created by Dharmawan Ruslan on 19/08/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var NavigateButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func navigateToNewPage(_ sender:UIButton){
        performSegue(withIdentifier: "goToNewPage", sender: self)
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

//// Vincent's main viewcontroller
///
//import UIKit
//
//class ViewController: UIViewController {
//    
//    let seasons = SeasonSeeder.seed()
//    
//    
//
//    @IBOutlet weak var seasonLabel: UILabel!
//    
//    @IBOutlet var SpringButton:UIButton!
//    @IBOutlet var SummerButton:UIButton!
//    @IBOutlet var AutumnButton:UIButton!
//    @IBOutlet var WinterButton:UIButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    @IBAction func navigateToNewPage(_ sender:UIButton){
//        performSegue(withIdentifier: "goToNewPage", sender: sender)
//    }
//    private func determineSeason(for button: UIButton) -> Season? {
//        let selectedSeason: Season?
//        switch button {
//        case SpringButton:
//            selectedSeason = seasons.first { $0.seasonName == "Spring" }
//        case SummerButton:
//            selectedSeason = seasons.first { $0.seasonName == "Summer" }
//        case AutumnButton:
//            selectedSeason = seasons.first { $0.seasonName == "Autumn" }
//        case WinterButton:
//            selectedSeason = seasons.first { $0.seasonName == "Winter" }
//        default:
//            selectedSeason = nil
//        }
//        print("Button pressed: \(button.currentTitle ?? "") -> Season: \(selectedSeason?.seasonName ?? "None")")
//        return selectedSeason
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("Preparing for segue with identifier: \(segue.identifier ?? "")")
//        guard segue.identifier == "goToNewPage",
//              let destinationVC = segue.destination as? AnalysisResultViewController,
//              let button = sender as? UIButton else { return }
//
//        let season = determineSeason(for: button)
//        print("Passing season: \(season?.seasonName ?? "None")")
//        destinationVC.season = season
//    }
//
//}
