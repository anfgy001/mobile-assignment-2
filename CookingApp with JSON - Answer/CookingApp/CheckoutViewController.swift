//
//  CheckoutViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import Foundation
import UIKit

class CheckoutViewController : DetailViewController {
    
    let model = SingletonManager.model
    
    //checkout JSON Implementation

    
    @IBOutlet weak var numberOfProductsLabel: UILabel!
    
    @IBOutlet weak var cartDescriptionLabel: UILabel!
    
    var globalTotal:Double = 0;
    
    var globalItemNumber:Int = 0;
    
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
            let productQuantity = item.quantity;
            
            globalItemNumber = globalItemNumber + productQuantity;
            
            
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
            
            var thePriceDoubled = convertToDouble(theString: productPrice);
 
            cartDescriptionLabel.text = cartDescriptionLabel.text! + "\nProduct Price: \(productPrice)";
            
            cartDescriptionLabel.text = cartDescriptionLabel.text! + "\nQuantity: \(productQuantity)";
            
            var productPriceByQuantity:Double = productQuantityTotal(productPrice: thePriceDoubled, quantity: productQuantity);
            
            cartDescriptionLabel.text = cartDescriptionLabel.text! + "\nTotal Product Price: \(productPriceByQuantity)";
            
            
            addToTotal(theDouble: productPriceByQuantity);
            
        }
         // work out totals
        var theTotal = totalToString();
        cartDescriptionLabel.text = cartDescriptionLabel.text! + "\n--------------------------------------------------\nTotal Price of Cart: \(theTotal)"
        cartDescriptionLabel.text = cartDescriptionLabel.text! + "\nNumber of Total Items: \(globalItemNumber)";
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
    
    func productQuantityTotal(productPrice: Double, quantity: Int) -> Double
    {
        let theResult = Double(quantity) * productPrice;
        return theResult;
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
