//
//  FavouritesViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit

/*
 CartViewController is the main view controller for the Cart detail pane
It deals with presenting all of the products that are in the cart to the screen in a collectionv view
 */
class CartViewController: DetailViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let model = SingletonManager.model
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        //print("You have  \(model.cartList.count) items");
    }
    
    func configureCollectionView() {
        
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView!.reloadData()
    }
    
    /*
     This is to deal with preparing from a previous segue to transfer data to the detail pane
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            
        // Find out what row was selected
        let indexPath = self.collectionView?.indexPath(for: sender as! Cell)
        
        //sender as? NSIndexPath
        
        // Grab the detail view
        let detailView = (segue.destination as! UINavigationController).topViewController as! ProductItemViewController
        
        // Get the selected cell's image
        let Product = model.cartList[indexPath!.row]
        // gets the latest instance, not any old instances

        
        // Pass the content to the detail view
        detailView.ProductItem = Product
        
        // Set up navigation on detail view
        detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        detailView.navigationItem.leftItemsSupplementBackButton = true
        
        // Once the processing is complete, it has been added to cart, it is now in a restricted mode for the cart viewing
        detailView.restrictedMode = true;
    }
    
    /*
        returns 1 for the number of sections in a collection view
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /*
        returns the number of products in the cart for the number of sections in a collection view
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.cartList.count
    }
    
    /*
        This completes processing to present the server data to UI elements of the application (e.g. ImageView etc)
     */
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
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
}
