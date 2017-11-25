//
//  ProductListViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit

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
    
    // MARK: UICollectionView Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.Products.count
    }
    
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
    
    // MARK: UICollectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
}
