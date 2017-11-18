//
//  ProductViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit

class ProductItemViewController: DetailViewController, UIPickerViewDataSource, UIPickerViewDelegate
    {
    
    let model = SingletonManager.model
    
    @IBOutlet weak var ProductImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var PickerView: UIPickerView!
    
    @IBOutlet weak var AddToCartButton: UIButton!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var paintingButton: UIButton!
    
    var changedToABS:Bool = false;
    
    var paintingAdded:Bool = false;
    
    var ABSPrice:Double = -1;
    
    var originalPLAPrice:Double = -1;
    
    var ProductItem: Product? {
        didSet {
            // Update the view.
        }
    }
    
    
    
    @IBAction func paintingStatusChange(_ sender: Any)
    {
        // painting price is in effect, turn it off
        if (paintingAdded)
        {
            
        }
        else // painting price is not in effect yet
        {
            addPaintingCost();
            paintingButton.setTitle("Remove Painting", for: .normal)
            configureView();
        }
        
    }
    
    // add the cost of painting +55%
    func addPaintingCost()
    {
        if let Product = self.ProductItem
        {
            // get double of current price
            let priceConverted = NumberFormatter().number(from: Product.price)?.doubleValue;
            
            let priceAfterPaintingAdded = priceConverted! * 1.55;
            
            let withPaintingStringVersion:String = "\(priceAfterPaintingAdded)";
            // painting price converts successfully
            print("newest cost w/ painting = \(withPaintingStringVersion)");
            
            // change the new price back
            
            Product.price = withPaintingStringVersion;

        }
        
    }
    
    // reset the cost without having the painting charge -55%
    func resetPaintingCharge()
    {
        // manual removal
        
        if let Product = self.ProductItem
        {
            
        }
    }
    
    let printTypes = ["PLA", "ABS"];
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return printTypes[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return printTypes.count;
    }
    
    // To enable pickerview changing
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // Changing from PLA to ABS or ABS to ABS
        if (printTypes[row] == "ABS")
        {
            // Only change the price to ABS if it hasn't been done before
            // This means it hasn't been changed before
            // (ABSPrice initialized to -1)
            if (ABSPrice < 0)
            {
                convertToABS();
            }
            else //ABSPrice is already stored, refer to it
            {
                print("Converting again to ABS...");
                convertABSPrice();
            }
            
            configureView();
            
            print("Changed to ABS");
        }
        else // Changed to PLA?
        {
            
            if(originalPLAPrice < 0)
            {
                print("OriginalPLAPrice hasn't been already converted... should be")
                initiatePrice();
            }
            else
            {
                print("Converting back to PLA...");
                convertPLAPrice();
                
            }
            
            configureView();
            
            print("Changed to PLA");
        }
        
    }
    
    func convertABSPrice()
    {
        if let Product = self.ProductItem
        {
            let absStringVersion:String = "\(ABSPrice)";
            Product.price = absStringVersion;
        }
    }
    
    func convertPLAPrice()
    {
        if let Product = self.ProductItem
        {
            let plaStringVersion:String = "\(originalPLAPrice)";
            Product.price = plaStringVersion;
        }
    }
    
    // for converting to ABS and finding the correct ABS printing price
    func convertToABS()
    {
        if let Product = self.ProductItem
        {
            let priceConverted = NumberFormatter().number(from: Product.price)?.doubleValue;
            let newPrice = priceConverted! * 1.1;
            ABSPrice = newPrice;
            let stringVersion:String = "\(newPrice)";
            Product.price = stringVersion;
            // when you set it back it will go over must be careful
            print("Initially converted to ABS...");
            // converts to ABS correctly!
        }
    }
    
    // initiate the PLA price at the beginning
    func initiatePrice()
    {
        if let Product = self.ProductItem
        {
            let PLAConverted = NumberFormatter().number(from: Product.price)?.doubleValue;
            originalPLAPrice = PLAConverted!;
            
        }
    }
        
    //func setFavouriteButton() {
    //    favouriteButton.setTitle("+", for: UIControlState())
    //    if (self.ProductItem!.favourite) {
    //        favouriteButton.setTitle("-", for: UIControlState())
    //    }
    //}
    
    override func configureView() {
        // Update the user interface for the detail item.
        if let Product = self.ProductItem {
            self.ProductImage.image = Product.image
            self.titleLabel.text = Product.name + "\n Product ID: " + Product.uid + "\n Price: " + Product.price;
            //self.setFavouriteButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        initiatePrice();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favouriteSelected(_ sender: AnyObject) {
        
        self.ProductItem!.addedToCart = true
        print("\(self.ProductItem!.name!) has been added to your cart");

        self.model.updateProduct(self.ProductItem)
        
    }
}
