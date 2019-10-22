//
//  Racket.swift
//  Practica_Ricardo_SquashV1
//
//  Created by Morello Santos Ricardo on 10/11/19.
//  Copyright © 2019 Morello Santos Ricardo. All rights reserved.
//

import Foundation
import UIKit

class Ball : UIImageView{
    
    var linearVelocity = 0
 
    override init(frame : CGRect){
        
        super.init(frame: frame)
        layer.cornerRadius = frame.width / 2.0
        image = UIImage(named: "asteroid1")
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
}
