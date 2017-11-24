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
    
    //checkout JSON Implementation

    
    @IBOutlet weak var numberOfProductsLabel: UILabel!
    
    @IBOutlet weak var cartDescriptionLabel: UILabel!
    
    var globalTotal:Double = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.configureView();
        
        let cartListNumber:Int = model.cartList.count;
        
        // there are no items in the cart
        if (cartListNumber < 1)
        {
            cartDescriptionLabel.isHidden = true;
        }
        
        numberOfProductsLabel.text = numberOfProductsLabel.text! + " \(cartListNumber)";
        
        // go through cart list
        for item in model.cartList
        {
            let productName = item.name!;
            let productID = item.uid!;
            let productABSPrinting = item.ABSPrinting;
            let productPainting = item.painted;
            let productPrice = item.price!;
            
            print("-----------------------------------------");
            print();
            print("Product has name \(productName)")
            print("Product has ID \(productID)");
            print("Product has ABS printing \(productABSPrinting)");
            print("Product price is  \(productPrice)");
            print();
            
            
            
            cartDescriptionLabel.text = cartDescriptionLabel.text! + "\n--------------------------------------------------\nProduct Name is \(productName)\nProduct ID is \(productID)"
            if (productABSPrinting)
            {
                cartDescriptionLabel.text = cartDescriptionLabel.text! + "\nProduct is using ABS Printing\n(10% extra charge)";
            }
            else
            {
                cartDescriptionLabel.text = cartDescriptionLabel.text! + "\nProduct is using standard PLA Printing\n(no additional charge)";
            }
            
            if (productPainting)
            {
                cartDescriptionLabel.text = cartDescriptionLabel.text! + "\nProduct will be painted\n(55% extra charge)";
            }
            
            cartDescriptionLabel.text = cartDescriptionLabel.text! + "\nProduct Price: \(productPrice)";
            
            //var thePriceDoubled = convertToDouble(theString: productPrice);
            //addToTotal(theDouble: thePriceDoubled);
            
        }
         // work out totals
        //var theTotal = totalToString();
        //cartDescriptionLabel.text = cartDescriptionLabel.text! + "\n--------------------------------------------------\nTotal Price of Cart: \(theTotal)"
        //reviewCart();
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func configureView()
    {
        
    }
    
    func convertToDouble(theString: String) -> Double
    {
        let converted:Double = Double(theString)!;
        return converted;
    }
    
    func addToTotal(theDouble: Double)
    {
        globalTotal = globalTotal + theDouble;
    }
    
    func totalToString() -> String
    {
        let stringTotal:String = "\(globalTotal)";
        return stringTotal;
    }
    
    func reviewCart()
    {
        
    }
}
