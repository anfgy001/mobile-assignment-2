//
//  CheckoutViewController.swift
//  CookingApp
//
//  Created by Anfiteatro, Gianni - anfgy001 on 18/11/17.
//  Copyright © 2017 Adam Jenkins. All rights reserved.
//

import Foundation
import UIKit

class CheckoutViewController : DetailViewController {
    
    let model = SingletonManager.model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        //print("You have  \(model.cartList.count) items");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func configureView()
    {
        
    }
}
