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
    
    var ProductItem: Product? {
        didSet {
            // Update the view.
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //titleLabel.text = printTypes[row];
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
            self.titleLabel.text = Product.name + "\n Product ID: " + Product.uid + "\n Product Price: " + Product.price!;
            //self.setFavouriteButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
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
