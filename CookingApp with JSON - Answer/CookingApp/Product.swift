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
        if let otherRecipe = object as? Product {
            if self.uid == otherRecipe.uid && self.name == otherRecipe.name && self.image!.isEqual(otherRecipe.image) {
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
