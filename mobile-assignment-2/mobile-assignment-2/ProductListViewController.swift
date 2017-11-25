//
//  ProductListViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit
/*
 ProductListViewController is the main view controller for the ProductList detail pane
 It deals with presenting the product list in a collection view and integrating product names to the screen also
 
 
 */
class ProductListViewController: DetailViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let model = SingletonManager.model
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        
        
    }
    
    func configureCollectionView() {
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
    }
        // Mark: Segue
    
    /*
     This deals with the incoming segue for the ProductList and presenting the data from that segue
 
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        // Find out what row was selected
        let indexPath = self.collectionView?.indexPath(for: sender as! Cell)
        
        //sender as? NSIndexPath
            
            // Grab the detail view
            let detailView = (segue.destination as! UINavigationController).topViewController as! ProductItemViewController
            
            // Get the selected cell's image
            let Product = model.Products[indexPath!.row]
    
            // Pass the content to the detail view
            detailView.ProductItem = Product
        
            
        
            // Set up navigation on detail view
            detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            detailView.navigationItem.leftItemsSupplementBackButton = true
                
    }
    
    /*
     This returns the number of sections of the collection view
    */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /*
     This returns the number of products in the system in a collection view instance
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.Products.count
    }
    
    /*
        This collectionView instance obtains the data from the server to input onto the page itself e.g. its image and name to their relevant app fields
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get an instancer of the prototype Cell we created
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        // Set the image in the cell
        cell.cellImageView.image = model.Products[indexPath.row].image
        
        // Set the text in the cell
        cell.cellLabel.text = model.Products[indexPath.row].name
        
        // Return the cell
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
}
