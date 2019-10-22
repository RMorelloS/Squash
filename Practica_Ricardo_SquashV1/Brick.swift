//
//  Brick.swift
//  Practica_Ricardo_SquashV1
//
//  Created by Morello Santos Ricardo on 10/18/19.
//  Copyright © 2019 Morello Santos Ricardo. All rights reserved.
//

import Foundation
//
//  Brick.swift
//  Practica_Ricardo_SquashV1
//
//  Created by Morello Santos Ricardo on 10/18/19.
//  Copyright © 2019 Morello Santos Ricardo. All rights reserved.
//

import Foundation
import UIKit

class Brick : UIImageView{
    
    
    
    override init(frame : CGRect){
        super.init(frame: frame)
        image = UIImage(named: "brick")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
