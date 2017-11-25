//
//  CheckoutViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import Foundation
import UIKit

class SearchViewController : DetailViewController {
    
    let model = SingletonManager.model
    
    @IBOutlet weak var searchImageView: UIImageView!
    
    @IBOutlet weak var searchTitleLabel: UILabel!
    
    @IBOutlet weak var searchResultsLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        self.configureView();
        searchImageView.image = UIImage(named: "search.png");
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let centreWidth = screenWidth / 2;
        
        searchTitleLabel.center.x = centreWidth;
        
        searchResultsLabel.center.x = centreWidth;
        
        searchButton.center.x = centreWidth;
        
    }
    
    override func configureView()
    {
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any)
    {
        let searchText:String = searchTextField.text!;
        
        // Did not search for anything
        if (searchText.characters.count < 1)
        {
            searchResultsLabel.text = "Please input a search"
            searchResultsLabel.isHidden = false;
            self.view.endEditing(true)
            return;
        }
        
        var searchQuery:String = searchTextField.text!;
        
        var combinedString:String = "Search Results: \n";
        
        for item in 0...model.Products.count-1
        {
            
            var theProduct = model.Products[item];
            
            if (theProduct.name.lowercased().range(of: searchQuery.lowercased()) != nil)
            {
                combinedString = combinedString + "----------";
                combinedString = combinedString + "\nName: " + theProduct.name;
                combinedString = combinedString + "\nPrice: " + theProduct.price;
                combinedString = combinedString + "\nID: " + theProduct.uid;
                combinedString = combinedString + "\n";
            }
        }
        
        searchResultsLabel.isHidden = false;
        searchResultsLabel.text = combinedString
        self.view.endEditing(true)

        
    }
    

}
