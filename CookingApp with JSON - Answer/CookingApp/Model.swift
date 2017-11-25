//
//  Model.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit
import CoreData

/**
 The Model class abstracts all of the data processing in terms of the core aspects of the system including 
    Refreshing products
    Adding menus
    Loading Products
    Keeping track of the cart list
    Image loading etc.
 */
class Model {
    
    var segueArray = [String]()
    var segueDictionary = Dictionary<String, UIImage>()
    
    var Products = [Product]()
    var storedProducts = [NSManagedObject]()
    
    init() {
        segueArray.append("Home");
        segueArray.append("Products");
        segueArray.append("Cart");
        segueArray.append("Checkout");
        segueArray.append("Finder");
        segueArray.append("Search");
        
        //segueArray.append("Favourites")
        
        segueDictionary["Home"] = UIImage(named: "home");
        segueDictionary["Products"] = UIImage(named: "products");
        segueDictionary["Cart"] = UIImage(named: "cart");
        segueDictionary["Checkout"] = UIImage(named: "checkout");
        segueDictionary["Finder"] = UIImage(named: "finder");
        segueDictionary["Search"] = UIImage(named: "search");
        
        self.refreshProducts()
        
        self.loadProducts()
    }
    
    // This is the container for all items that get added to the cart
    var cartList: [Product] { 
        get {
            var selectedProducts = [Product]()
            
            if (Products.count > 0)
            {
                for count in 0...Products.count - 1
                {
                    if Products[count].addedToCart
                    {
                        selectedProducts.append(Products[count])
                    }
                }
            }
            
            return selectedProducts
        }
    }
    
    /*
     refreshProducts obtains all items from the server adn assigns them to a Product
 
     */
    func refreshProducts()
    {
        let url = NSURL(string: "http://partiklezoo.com/3dprinting/")
        let config = URLSessionConfiguration.default
        config.isDiscretionary = true
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url! as URL, completionHandler:
            {(data, response, error) in
                do {
                    let json = try JSON(data: data!)
                
                    for count in 0...json.count - 1
                    {
                        let newProduct = Product()
                        newProduct.name = json[count]["name"].string
                        //newProduct.details = json[count]["Product"].string
                        newProduct.uid = json[count]["uid"].string
                        newProduct.price = json[count]["price"].string;
                        newProduct.category = json[count]["category"].string;
                        let imgURL = json[count]["image"].string!
                        
                        self.addItemToProducts(newProduct, imageURL: imgURL)
                    }
                }
                catch let error as NSError
                {
                    print("Could not convert. \(error), \(error.userInfo)")
                }
                
        })
        task.resume()
    }
    
    /**
 
     loadProducts obtains products from the current state and integrates them into a storedProducts array
     
     */
    func loadProducts() {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
    
            storedProducts = results as! [NSManagedObject]
            
            if (storedProducts.count > 0) {
                for index in 0 ... storedProducts.count - 1 {
                    let binaryData = storedProducts[index].value(forKey: "image") as! Data
                    
                    let image = UIImage(data: binaryData)
                    //let details = storedProducts[index].value(forKey: "details") as! String
                    let name = storedProducts[index].value(forKey: "name") as! String
                    let uid = storedProducts[index].value(forKey: "uid") as! String
                    let price = storedProducts[index].value(forKey: "price") as! String
                    let category = storedProducts[index].value(forKey: "category") as! String;
                    
                    //let favourite = storedProducts[index].value(forKey: "favourite") as! Bool
                    
                    
                    
                    let loadedProduct = Product(uid: uid, name: name, image: image!, price: price, category: category);
                    
                    Products.append(loadedProduct)
                }
            }
        }
        catch let error as NSError
        {
            print("Could not load. \(error), \(error.userInfo)")
        }
    }
    
    /*
 
     checkForProduct deals with product equality checking
     
    */
    func checkForProduct(_ searchItem: Product) -> Int {
        var targetIndex = -1
        
        if (Products.count > 0) {
            for index in 0 ... Products.count - 1 {
                if (Products[index].uid.isEqual(searchItem.uid)) {
                    targetIndex = index
                }
            }
        }
        
        return targetIndex
    }
    
    
    /*
     addItemToProducts is another function that aids with transferring products from the server to the application
 
    */
    func addItemToProducts(_ newProduct: Product!, imageURL: String) {
        if (checkForProduct(newProduct) == -1)
        {
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            print("additemtoproducts1");
            let picture = UIImageJPEGRepresentation(loadImage(imageURL), 1)
            print("additemtoproducts2");
            let entity =  NSEntityDescription.entity(forEntityName: "Products", in:managedContext)
            
            let ProductToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            ProductToAdd.setValue(picture, forKey: "image")
            ProductToAdd.setValue(newProduct.name, forKey: "name")
            //ProductToAdd.setValue(newProduct.details, forKey: "details")
            ProductToAdd.setValue(newProduct.uid, forKey: "uid")
            ProductToAdd.setValue(newProduct.price, forKey: "price");
            ProductToAdd.setValue(newProduct.category, forKey: "category");
            //ProductToAdd.setValue(newProduct.favourite, forKey: "favourite")
            
            do
            {
                try managedContext.save()
            }
            catch let error as NSError
            {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            storedProducts.append(ProductToAdd)
            Products.append(newProduct)
        }
    }
    
    /*
     loadImage deals with transferring the image URL from the server to an actual image on the application
 
    */
    func loadImage(_ imageURL: String) -> UIImage
    {
        var image: UIImage!
        
        if let url = NSURL(string: imageURL) {
            print(url);
            if let data = NSData(contentsOf: url as URL){
                image = UIImage(data: data as Data)
                print("done");
            }
        }
        
        //if (image == nil)
        //{
        //    print("gets here 2");
         //   let failImage = UIImage(named: "home")
        //    return failImage!;
        //}
        
        //print(image);
        
        return image!
    }
    
    /*
     updateProduct daels with when a product gets transferred to its own page and how the data from the server gets transferred also
 
     */
    func updateProduct(_ newProduct: Product!) {
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        fetchRequest.predicate = NSPredicate(format: "uid = %@", newProduct.uid)
        
        do {
            if let fetchResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
            
                if fetchResults.count != 0 {
                
                    let managedObject = fetchResults[0]
                
                   // managedObject.setValue(newProduct.details, forKey: "details")
                    do
                    {
                        try managedContext.save()
                        print("Updated product (in model)....");
                    }
                    catch let error as NSError
                    {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
