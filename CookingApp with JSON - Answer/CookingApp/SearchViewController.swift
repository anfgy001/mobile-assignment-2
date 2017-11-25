//
//  SearchViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import Foundation
import UIKit

/*
    The SearchViewController is the main view controller for the Search detail view
    In this view controller the search functionality and implementation is handled including user input validation methods and dealing with the search query
    The search simply states the factual evidence of any products identified from the search.
    No images are shown as due to the complexity of generating multiple UIImageView units, this would consume too much time and resources
 
 */
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
        
        // This section deals with aligning various screen elements to a appropriate x coordinate
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
    
    /*
        When the search button is pressed, do the following functions:
        - Obtain the searchText (query) from the searchTextField
        - Validate input (see if there was any input at all), if there was no input, notify user, return process
        - If input validated, conduct search by finding if the query is contained in any product (including if it is the full product name)
        - Return the details of the search to the screen
    */
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
                combinedString = combinedString + "\nCategory: " + theProduct.category;
                combinedString = combinedString + "\n";
            }
        }
        
        searchResultsLabel.isHidden = false;
        searchResultsLabel.text = combinedString
        self.view.endEditing(true)

        
    }
    

}
