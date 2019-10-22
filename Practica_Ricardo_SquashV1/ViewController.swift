//
//  ViewController.swift
//  Practica_Ricardo_SquashV1
//
//  Created by Morello Santos Ricardo on 10/8/19.
//  Copyright © 2019 Morello Santos Ricardo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let miRect = CGRect(x: self.view.bounds.maxX/2 - 280, y: 30, width: 580, height: 580)
        let vista1 = UIView(frame: miRect)
        vista1.backgroundColor = UIColor(white:1,alpha:0.3);
        
        
        self.view.addSubview(vista1);
        self.view.sendSubviewToBack(vista1)
        let gradient = CAGradientLayer()
        gradient.frame = vista1.bounds
        let gradientColorFinal = UIColor(red: 0/255, green: 134/255, blue: 244/255, alpha: 1.0)
        let gradientColorInitial = UIColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 0.6).cgColor
        
        gradient.colors = [gradientColorInitial, gradientColorFinal]
        vista1.layer.insertSublayer(gradient, at: 0)
        // Do any additional setup after loading the view.
         assignbackground()
        
        MusicPlayer.shared.startBackgroundMusic(musicToPlay: "notimeforcaution")
        MusicPlayer.shared.audioPlayer?.play()
        buttonPlay.titleLabel?.minimumScaleFactor = 0.5
        buttonPlay.titleLabel?.adjustsFontSizeToFitWidth = true
        
        buttonScoreboard.titleLabel?.minimumScaleFactor = 0.5
        buttonScoreboard.titleLabel?.adjustsFontSizeToFitWidth = true
        
        buttonInstructions.titleLabel?.minimumScaleFactor = 0.5
        buttonInstructions.titleLabel?.adjustsFontSizeToFitWidth = true
        
        labelTitle.minimumScaleFactor = 0.5
        labelTitle.adjustsFontSizeToFitWidth = true
    }
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var buttonScoreboard: UIButton!
    @IBOutlet weak var buttonInstructions: UIButton!

    func assignbackground(){
        let background = UIImage(named: "background_logscreen")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    override func viewWillDisappear(_ animated: Bool) {
        //MusicPlayer.shared.stopBackgroundMusic()
    }
    
}

