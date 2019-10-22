//
//  ScoreboardViewController.swift
//  Practica_Ricardo_SquashV1
//
//  Created by Morello Santos Ricardo on 10/18/19.
//  Copyright © 2019 Morello Santos Ricardo. All rights reserved.
//

import UIKit

class ScoreboardViewController: UIViewController {
    let defaults = UserDefaults.standard
    @IBOutlet weak var labelScores: UILabel!
    
    
    @IBOutlet weak var labelOn: UILabel!
    @IBOutlet weak var labelHighScore: UILabel!
    
    @IBOutlet weak var buttonDeleteRecords: UIButton!
    @IBOutlet weak var txtRecentScores: UILabel!
    @IBOutlet weak var txtHighScoreDate: UILabel!
    @IBOutlet weak var txtHighScore: UILabel!
    @IBOutlet weak var scoreboardLabel: UILabel!
    @IBAction func deleteScoreRecords(_ sender: Any) {
        let emptyScoreRecords = [String:[String]]()
        defaults.set(emptyScoreRecords, forKey: "recordScores")
        txtRecentScores.text = ""
        txtHighScoreDate.text = ""
        labelScores.text = ""
        labelOn.text = ""
        txtHighScore.text = ""
    }
    var oldScoreRecords = [String:[String]]()
    var recordIDs = [Int]()
    override func viewWillDisappear(_ animated: Bool) {
        //MusicPlayer.shared.stopBackgroundMusic()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicPlayer.shared.startBackgroundMusic(musicToPlay: "defeat")
        MusicPlayer.shared.audioPlayer?.play()
        assignbackground()
        scoreboardLabel.minimumScaleFactor = 0.5
        scoreboardLabel.adjustsFontSizeToFitWidth = true
        txtRecentScores.minimumScaleFactor = 0.3
        txtRecentScores.adjustsFontSizeToFitWidth = true
        txtHighScore.minimumScaleFactor = 0.5
        txtHighScore.adjustsFontSizeToFitWidth = true
        txtHighScoreDate.minimumScaleFactor = 0.3
        txtHighScoreDate.adjustsFontSizeToFitWidth = true
        buttonDeleteRecords.titleLabel?.minimumScaleFactor = 0.3
        buttonDeleteRecords.titleLabel?.adjustsFontSizeToFitWidth = true
        labelOn.minimumScaleFactor = 0.3
        labelOn.adjustsFontSizeToFitWidth = true
        labelHighScore.minimumScaleFactor = 0.3
        labelHighScore.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
        //_ = defaults.object(forKey: "SavedArray") as? [String] ??  [String]()
        oldScoreRecords = UserDefaults.standard.value(forKey: "recordScores") as! [String : [String]]
       
        var highScore = 0
        var highScoreDate = ""
        for (id, records) in oldScoreRecords{
            recordIDs.append(Int(id)!)
            if Int(records[0])! > highScore{
                highScore = Int(records[0])!
                highScoreDate = records[1]
            }
        }
        recordIDs = recordIDs.sorted(by: {$0 > $1})
        print(recordIDs)
        txtRecentScores.numberOfLines = 0
        var maxRecords = 0
        if recordIDs.count > 5{
            maxRecords = 5
            
        }else{
            maxRecords = recordIDs.count
        }
        for _ in 0..<maxRecords{
            if let first = recordIDs.first {
                let records = oldScoreRecords[String(first)]
                let scores = records![0]
                let date = records![1]
                txtRecentScores.text = txtRecentScores.text! + scores
                txtRecentScores.text = txtRecentScores.text! + " ON" + date + "\n"
            }
            recordIDs.remove(at: 0)
        }
        txtHighScore.text = String(highScore)
        txtHighScoreDate.text = highScoreDate
    }
    
    
    func assignbackground(){
        let background = UIImage(named: "background_scoreboard")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
