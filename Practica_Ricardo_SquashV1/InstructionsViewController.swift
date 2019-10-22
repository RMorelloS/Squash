//
//  InstructionsViewController.swift
//  Practica_Ricardo_SquashV1
//
//  Created by Morello Santos Ricardo on 10/19/19.
//  Copyright © 2019 Morello Santos Ricardo. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assignbackground()
    }
    
    
    func assignbackground(){
        let background = UIImage(named: "background_instructions")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.alpha = 1
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
