//
//  FavouritesViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit

class FavouritesViewController: DetailViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView!.reloadData()
    }
    
    // Mark: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //print("In the item as it's in cart");
        
        //print("top of the prepare");
        
        //print(segue.identifier);
        
        print("original segue identifier... " + segue.identifier!);
        
        // Find out what row was selected
        let indexPath = self.collectionView?.indexPath(for: sender as! Cell)
        
        //sender as? NSIndexPath
        
        // Grab the detail view
        let detailView = (segue.destination as! UINavigationController).topViewController as! ProductItemViewController
        
        // Get the selected cell's image
        let Product = model.cartList[indexPath!.row]

        
        
        // Pass the content to the detail view
        detailView.ProductItem = Product
        
        // Set up navigation on detail view
        detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        detailView.navigationItem.leftItemsSupplementBackButton = true
        
        
        detailView.restrictedMode = true;
    }
    
    // MARK: UICollectionView Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.cartList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get an instancer of the prototype Cell we created
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        // Set the image in the cell
        cell.cellImageView.image = model.cartList[indexPath.row].image
        
        // Set the text in the cell
        cell.cellLabel.text = model.cartList[indexPath.row].name
        
        // Return the cell
        return cell
    }
    
    // MARK: UICollectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
}
