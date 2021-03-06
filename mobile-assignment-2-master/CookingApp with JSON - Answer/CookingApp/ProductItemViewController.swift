//
//  ProductItemViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit

class ProductItemViewController: DetailViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate
    {
    
    let model = SingletonManager.model
    
    @IBOutlet weak var ProductImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var PickerView: UIPickerView!
    
    @IBOutlet weak var AddToCartButton: UIButton!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var paintingButton: UIButton!
    
    @IBOutlet weak var qtyLabel: UILabel!
    
    @IBOutlet weak var QtyStepper: UIStepper!
    
    var red:Bool = false;
        
    var changedToABS:Bool = false;
    
    var paintingAdded:Bool = false;
    
    var ABSPrice:Double = -1;
    
    var restrictedMode:Bool = false;
    
    var originalPLAPrice:Double = -1;
    
    var quantity:Int = -1;
    
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var ProductItem: Product? {
        didSet {
            // Update the view.
        }
    }
    
    @IBAction func stepperAction(_ sender: Any)
    {
        qtyLabel.text = "Qty: ";
        let theVal = Int(QtyStepper.value);
        qtyLabel.text = qtyLabel.text! + " \(theVal)";
        if (theVal == 0)
        {
            favouriteButton.isHidden = true;
            paintingButton.isHidden = true;
            return;
        }
        favouriteButton.isHidden = false;
        paintingButton.isHidden = false;
        quantity = theVal;
    }
    
    
    @IBAction func paintingStatusChange(_ sender: Any)
    {
        // painting price is in effect, turn it off
        if (paintingAdded)
        {
            resetPaintingCharge();
            paintingButton.setTitle("Add Painting", for: .normal);
            configureView();
            paintingAdded = false;
            PickerView.isHidden = false;
            
        }
        else // painting price is not in effect yet,
        {
            addPaintingCost();
            paintingButton.setTitle("Remove Painting", for: .normal)
            configureView();
            paintingAdded = true;
            // turn off the picker until this is off
            PickerView.isHidden = true;
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
            let paintingPriceConverted = NumberFormatter().number(from: Product.price)?.doubleValue;
            
            let paintingPriceOriginal = paintingPriceConverted! / 1.55; // / 1.55
            
            print()
            print("Original price was ... \(paintingPriceOriginal)");
            
            let originalStringVersion:String = "\(paintingPriceOriginal)";
            
            Product.price = originalStringVersion;
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
        // hide the buttons during the transition, make them appear after it..
        paintingButton.isUserInteractionEnabled = false;
        // Changing from PLA to ABS or ABS to ABS
        if (printTypes[row] == "ABS" && (ProductItem?.ABSPrinting == false))
        {
            // Only change the price to ABS if it hasn't been done before
            // This means it hasn't been changed before
            // (ABSPrice initialized to -1)
            if (ABSPrice < 0 && ProductItem?.ABSPrintedCharge == -1)
            {
                print("CONVERTING ABS AGAIN");
                print("ABS PRICE IS LESS THAN 0")
                convertToABS();
            }
            else //ABSPrice is already stored, refer to it
            {
                print()
                print("Converting again to ABS...");
                convertABSPrice();
            }
            
            configureView();
            
            ProductItem?.ABSPrinting = true;
            
            //print("Changed to ABS");
        }
        else if (printTypes[row] == "PLA" && (ProductItem?.ABSPrinting == true)) // Changed to PLA
        {
            print()
            print("originalPLAPrice is \(originalPLAPrice)");
            if (originalPLAPrice == ProductItem?.ABSPrintedCharge)
            {
                originalPLAPrice = originalPLAPrice / 1.10;
                convertPLAPrice();
            }
            else if(originalPLAPrice < 0)
            {
                print()
                print("OriginalPLAPrice hasn't been already converted... should be")
                initiatePrice();
            }
            else
            {
                print()
                print("Converting back to PLA...");
                convertPLAPrice();
                
            }
            
            configureView();
            
            //print("Changed to PLA");
            ProductItem?.ABSPrinting = false;
        }
        
        //after computations are done, make it available again
        // Testing on actual iPhone!
        paintingButton.isUserInteractionEnabled = true;
        
    }
    
    func convertABSPrice()
    {
        if let Product = self.ProductItem
        {
            let absStringVersion:String = "\(Product.ABSPrintedCharge)";
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
            ProductItem?.ABSPrintedCharge = newPrice;
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
            self.titleLabel.text = Product.name + "\n Product Category: " + Product.category + "\n Product ID: " + Product.uid  + "\n Price: " + Product.price ;
            //self.setFavouriteButton()
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        initiatePrice();
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let centreWidth = screenWidth / 2;
        print();
        print("The category of the product is:")
        print(ProductItem?.category);
        
        errorMessageLabel.center.x = centreWidth + 7;
        
        let titleLabelX = titleLabel.center.x;
        paintingButton.center.x = (screenWidth - 50);
        
        if (restrictedMode) // this is being viewed by the cart
        {
            PickerView.isUserInteractionEnabled = false;
            favouriteButton.isHidden = true;
            paintingButton.isHidden = true;
            QtyStepper.isHidden = true;
            qtyLabel.text = qtyLabel.text! +  " \(ProductItem!.quantity)";
            //self.picker.selectRow(8, inComponent: 0, animated: false) at component 8
            
            if(ProductItem?.ABSPrinting)!
            {
                self.PickerView.selectRow(1, inComponent: 0, animated: false)
            }
            else
            {
                self.PickerView.selectRow(0, inComponent: 0, animated: false);
            }
            
        }
        else
        {
            // previously chosen quantity item
            if (ProductItem?.quantity != -1)
            {
                QtyStepper.value = Double(ProductItem!.quantity);
                qtyLabel.text = qtyLabel.text! + "  \(ProductItem!.quantity)";
            }
            favouriteButton.isHidden = true;
            paintingButton.isHidden = true;
        }
        
        if(ProductItem?.ABSPrinting)!
        {
            self.PickerView.selectRow(1, inComponent: 0, animated: false);
        }
        else
        {
            self.PickerView.selectRow(0, inComponent: 0, animated: false);
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favouriteSelected(_ sender: AnyObject)
    {
        if (!restrictedMode) // when choosing
        {
            self.ProductItem!.quantity = quantity;
            self.ProductItem!.painted = paintingAdded;
        }
        
        urlConfig();
        
        sleep(1); // the sleep is added so the app has time to communicate with the web server to report it's findings.
        
        if (self.ProductItem!.successfullyPurchased)
        {
            
            self.ProductItem!.addedToCart = true
            self.model.updateProduct(self.ProductItem)
            if (red)
            {
                errorMessageLabel.textColor! = UIColor.black;
                red = false;
            }
            else
            {
                errorMessageLabel.textColor! = UIColor.red;
                red = true;
            }
            errorMessageLabel.isHidden = false;
            errorMessageLabel.text = "Product Added To Cart"
        }
        else // it was not correct with the server...
        {
            // inform user that the product was not added to the server.
            errorMessageLabel.isHidden = false;
            errorMessageLabel.text = "Warning: An error occurred\nSystem could not process request";
        }
    }
    
    func productQuantityTotal(productPrice: Double, quantity: Int) -> Double
    {
        let theResult = Double(quantity) * productPrice;
        return theResult;
    }
    
    func urlConfig()
    {
        var urlString = "http://partiklezoo.com/3dprinting/?action=purchase";
        
        urlString = urlString + "&\(ProductItem!.uid!)=\(ProductItem!.quantity)";
        
        var theProductTotal = productQuantityTotal(productPrice: Double(ProductItem!.price)!, quantity: ProductItem!.quantity);
        
        urlString = urlString + "&total=\(theProductTotal)";
        
        if (ProductItem!.ABSPrinting)
        {
            urlString = urlString + "&material=abs";
        }
        else
        {
            urlString = urlString + "&material=pla";
        }
        
        urlString = urlString + "&painting=\(ProductItem!.painted)";
        
        var url = NSURL(string: urlString);
        let config = URLSessionConfiguration.default;
        config.isDiscretionary = true;
        let session = URLSession(configuration: config);
        //let session = URLSession.sharedSession();
        let task = session.dataTask(with: url! as URL, completionHandler:
            {(data, response, error) in
            do {
                let json = try JSON(data: data!)
                if (json["success"].string! == "true")
                {
                    print();
                    print("The product has successfully added to the cart.");
                    print();
                    self.ProductItem!.successfullyPurchased = true;
                }
                //print(json["success"].string!)
            }
            catch let error as NSError
            {
                print("Could not convert. \(error), \(error.userInfo)");
            }
            // ... Work with data....
        })
        task.resume()
    }
}
