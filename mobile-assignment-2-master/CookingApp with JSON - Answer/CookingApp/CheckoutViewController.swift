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
    

    
    @IBOutlet weak var numberOfProductsLabel: UILabel!
    
    @IBOutlet weak var cartDescriptionLabel: UILabel!
    
    var storedReceipt:String = "";
    
    var globalTotal:Double = 0;
    
    var globalItemNumber:Int = 0;
    
    var inputs = [UITextField!]();
    
    @IBOutlet weak var CVVField: UITextField!
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    @IBOutlet weak var ownerLabel: UILabel!
    
    @IBOutlet weak var ccLabel: UILabel!
    @IBOutlet weak var ccField1: UITextField!
    @IBOutlet weak var ccField2: UITextField!
    @IBOutlet weak var ccField3: UITextField!
    @IBOutlet weak var ccField4: UITextField!
    @IBOutlet weak var OwnerField: UITextField!
    
    
    
    var checkoutComplete:Bool = false;
    
    @IBOutlet weak var cvvLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad();
        self.configureView();
        
        let cartListNumber:Int = model.cartList.count;
        
        // there are no items in the cart
        if (cartListNumber < 1)
        {
            cartDescriptionLabel.isHidden = true;
        }
        else //In checkout mode, items in the cart
        {
            ccField1.isHidden = false;
            ccField2.isHidden = false;
            ccField3.isHidden = false;
            ccField4.isHidden = false;
            CVVField.isHidden = false;
            purchaseButton.isHidden = false;
            OwnerField.isHidden = false;
            cvvLabel.isHidden = false;
            ownerLabel.isHidden = false;
            ccLabel.isHidden = false;
            
            inputs.append(ccField1);
            inputs.append(ccField2);
            inputs.append(ccField3);
            inputs.append(ccField4);
            inputs.append(OwnerField);
            inputs.append(CVVField);
            
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
        
        storedReceipt = cartDescriptionLabel.text!;
        //reviewCart();
    }
    
    @IBAction func purchase(_ sender: Any)
    {
        self.view.endEditing(true)

        cartDescriptionLabel.text = storedReceipt
        
        for field in 0...inputs.count-1
        {
            if (field < 4) //making sure all credit card numbers are accurate
            {
                if (inputs[field].text!.characters.count != 4)
                {
                    cartDescriptionLabel.textColor = UIColor.red;
                    cartDescriptionLabel.text = cartDescriptionLabel.text! + "\nWARNING: Please input a valid credit card number";
                    //ccErrorPreviously = true;
                    return;
                }
            }
            else if (field == 5) //dealing with CVV
            {
                if(inputs[field].text!.characters.count != 3)
                {
                    cartDescriptionLabel.textColor = UIColor.red;
                    cartDescriptionLabel.text = cartDescriptionLabel.text! + "\nWARNING: Please input a valid CVV";
                    //cvvErrorPreviously = true;
                    return;
                }
            }
            
        }
        
        cartDescriptionLabel.textColor = UIColor.green;
        cartDescriptionLabel.text = cartDescriptionLabel.text! + "\nYour purchase has completed";
        checkoutComplete = true;
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
/*
    This code is used to give input fields a max length
 */
private var __maxLengths = [UITextField: Int]()

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        let c = self.characters
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
}
