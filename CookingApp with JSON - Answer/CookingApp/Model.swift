//
//  Model.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit
import CoreData

class Model {
    
    var segueArray = [String]()
    var segueDictionary = Dictionary<String, UIImage>()
    
    var Products = [Product]()
    var storedProducts = [NSManagedObject]()
    
    init() {
        segueArray.append("Home")
        segueArray.append("Products")
        
        segueArray.append("Favourites")
        
        segueDictionary["Home"] = UIImage(named: "home")
        segueDictionary["Products"] = UIImage(named: "products")
        segueDictionary["Favourites"] = UIImage(named: "products")
        
        
        self.refreshProducts()
        
        self.loadProducts()
    }
    
    var favourites: [Product] {
        get {
            var selectedProducts = [Product]()
            
            if (Products.count > 0)
            {
                for count in 0...Products.count - 1
                {
                    //if Products[count].favourite
                    //{
                     //   selectedProducts.append(Products[count])
                    //}
                }
            }
            
            return selectedProducts
        }
    }
    
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
                        print(count);
                        let newProduct = Product()
                        newProduct.name = json[count]["name"].string
                        //newProduct.details = json[count]["Product"].string
                        newProduct.uid = json[count]["uid"].string
                        
                        let imgURL = json[count]["image"].string!
                        print("test");
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
    
    func loadProducts() {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
    
            storedProducts = results as! [NSManagedObject]
            
            if (storedProducts.count > 0) {
                print(storedProducts.count);
                for index in 0 ... storedProducts.count - 1 {
                    let binaryData = storedProducts[index].value(forKey: "image") as! Data
                    
                    let image = UIImage(data: binaryData)
                    //let details = storedProducts[index].value(forKey: "details") as! String
                    let name = storedProducts[index].value(forKey: "name") as! String
                    let uid = storedProducts[index].value(forKey: "uid") as! String
                    //let favourite = storedProducts[index].value(forKey: "favourite") as! Bool
                    
                    
                    
                    let loadedProduct = Product(uid: uid, name: name, image: image!);
                    
                    Products.append(loadedProduct)
                }
            }
        }
        catch let error as NSError
        {
            print("Could not load. \(error), \(error.userInfo)")
        }
    }
    
    func checkForProduct(_ searchItem: Product) -> Int {
        var targetIndex = -1
        print(Products.count);
        if (Products.count > 0) {
            for index in 0 ... Products.count - 1 {
                if (Products[index].uid.isEqual(searchItem.uid)) {
                    targetIndex = index
                }
            }
        }
        
        return targetIndex
    }
    
    func addItemToProducts(_ newProduct: Product!, imageURL: String) {
        //print(checkForProduct(newProduct));
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
    
    func loadImage(_ imageURL: String) -> UIImage
    {
        print("gets here")
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
