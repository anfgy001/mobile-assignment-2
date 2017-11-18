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
    
    
    
    @IBOutlet weak var numberOfProductsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.configureView();
        let cartListNumber:Int = model.cartList.count;
        numberOfProductsLabel.text = numberOfProductsLabel.text! + " \(cartListNumber)";
        reviewCart();
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func configureView()
    {
        
    }
    
    func reviewCart()
    {
        
    }
}
