//
//  Recipe.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit

class Product: NSObject {
    var image: UIImage?
    //var details: String! = ""
    var desc: String! = ""
    var name: String! = ""
    //var favourite = false
    var uid: String!
    var addedToCart = false;
    
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
