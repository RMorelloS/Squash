//
//  Satellite.swift
//  Practica_Ricardo_SquashV1
//
//  Created by Morello Santos Ricardo on 10/11/19.
//  Copyright © 2019 Morello Santos Ricardo. All rights reserved.
//

import Foundation
import UIKit

class Satellite : UIImageView{

    init(frame : CGRect, imageName : String){
        super.init(frame: frame)
        layer.cornerRadius = frame.width / 2.0
        image = UIImage(named: imageName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
