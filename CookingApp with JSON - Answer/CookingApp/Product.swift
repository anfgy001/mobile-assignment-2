//
//  Product.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit

/*
 The Product swift class contains all the data abstractions for the Product
 This includes all of its details and its app specific variables like whether its particular instance was painted, whether it is using ABS etc
 
 */
class Product: NSObject {
    var image: UIImage?
    //var details: String! = ""
    var desc: String! = ""
    var name: String! = ""
    //var favourite = false
    var uid: String!
    var category: String!
    var price: String!
    var addedToCart = false;
    var ABSPrinting:Bool = false;
    var ABSPrintedCharge:Double = -1;
    var painted:Bool = false;
    var quantity:Int = -1;
    var successfullyPurchased:Bool = false;
    
    override init() {
    }
    
    init(uid: String, name: String, image: UIImage) {
        self.uid = uid
        self.name = name
        //self.details = details
        self.image = image
        //self.favourite = favourite
    }
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
        //self.details = details
        //self.favourite = false
    }
    
    init(uid: String, name: String, image: UIImage, price: String)
    {
        self.uid = uid;
        self.name = name;
        self.image = image;
        self.price = price;
    }
    
    init(uid: String, name: String, image: UIImage, price: String, category: String)
    {
        self.uid = uid;
        self.name = name;
        self.image = image;
        self.price = price;
        self.category = category;
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let otherProduct = object as? Product {
            if self.uid == otherProduct.uid && self.name == otherProduct.name && self.image!.isEqual(otherProduct.image) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
 }
