//
//  FinderViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//


import Foundation
import UIKit

/*
 IMPORTANT NOTE: No user validation for inputting symbols or letters were done as:
    - Assumed user input was only via the designated system keyboard for each device
    - Set each user keyboard for each UITextField dependant on it's input required
    For example: Coordinate 1 and Coordinate 2 Text Field Inputs use the Decimal Pad 
    So only integers or decimals can be created from using that specific keyboard.
 
 */
class FinderViewController : DetailViewController {
    
    let model = SingletonManager.model
    
    @IBOutlet weak var finderDetailLabel: UILabel!
    
    @IBOutlet weak var finderButton: UIButton!

    @IBOutlet weak var storeInfoLabel: UILabel!
    
    @IBOutlet weak var coordinate1TextField: UITextField!
    
    @IBOutlet weak var coordinate2TextField: UITextField!
    
    @IBOutlet weak var promptLabel: UILabel!
    
    // closestLocation stores the details of the store location found closest in the following format 
    // street
    // suburb
    // postcode
    // state
    // country code
    var closestLocation = [String]();
    
    
    var closestDistance:Double = -1;
    
    var userCoordinate1:Double = -1;
    
    var userCoordinate2:Double = -1;
    
    var outputString:String = "There is no stores chosen";
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.configureView()
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let centreWidth = screenWidth / 2;
        
        promptLabel.center.x = centreWidth
        
        finderDetailLabel.center.x = centreWidth;
        
        finderButton.center.x = centreWidth;
        
        finderDetailLabel.text = "Please enter your coordinates to find \nyour closest Ultimate Cosplay Store";
        
        
    }
    
    func urlBuilder()
    {
        var urlString:String = "http://partiklezoo.com/3dprinting/?action=locations&coord1=2&coord2=3";
        
        var url = NSURL(string: urlString);
        let config = URLSessionConfiguration.default;
        config.isDiscretionary = true;
        let session = URLSession(configuration: config);
        let task = session.dataTask(with: url! as URL, completionHandler:
            {(data, response, error) in
            do {
                let json = try JSON(data: data!)
                print();
                print("gets here");
                for count in 0...json.count - 1 // for each location see if its the closest
                {
                    var storeCoord1 = Double(json[count]["coord1"].string!);
                    var storeCoord2 = Double(json[count]["coord2"].string!);
                    
                    let theDistance = self.manhattanDistanceConversion(xA: self.userCoordinate1, xB: self.userCoordinate2, yC: storeCoord1, yD: storeCoord2)
                    
                    print("The distance is \(theDistance)");
                    
                    print("the store number is \(count)");
                    
                    
                    // first distance conversion, set it as the closestDistance
                    if (self.closestDistance == -1)
                    {
                        self.closestDistance = theDistance;
                        //sleep(1);
                        
                        self.closestLocation.append(json[count]["street"].string!);
                        self.closestLocation.append(json[count]["suburb"].string!);
                        self.closestLocation.append(json[count]["postcode"].string!);
                        self.closestLocation.append(json[count]["state"].string!);
                        self.closestLocation.append(json[count]["countrycode"].string!);
                        
                    }
                    else
                    {
                        if (theDistance < self.closestDistance)
                        {
                            self.closestDistance = theDistance
                            
                            self.closestLocation[0] = json[count]["street"].string!;
                            self.closestLocation[1] = json[count]["suburb"].string!;
                            self.closestLocation[2] = json[count]["postcode"].string!;
                            self.closestLocation[3] = json[count]["state"].string!;
                            self.closestLocation[4] = json[count]["countrycode"].string!;
                            //sleep(1);
                            //storeName = storeName +
                            
                            print("TEST COUNT IS \(self.closestLocation.count)");
                            
                        }
                    }
                    
                }
                
                var outputStringBuilder:String = "The Closest Location Is:";
                print(self.closestLocation.count);
                for field in 0...self.closestLocation.count-1
                {
                    outputStringBuilder = outputStringBuilder + "\n\(self.closestLocation[field])";
                }
                
                self.outputString = outputStringBuilder;
                
            }
            catch let error as NSError
            {
                    print("Could not convert. \(error), \(error.userInfo)");
            }
        })
        task.resume()
        self.outputString = "Testing";
       
    }
    
    override func configureView()
    {
        
    }
    
    @IBAction func finderButtonPressed(_ sender: Any)
    {
        // input validation check for no values
        
        // convert the coordinates to doubles
        var coord1Double:Double = convertToDouble(theString: coordinate1TextField.text);
        var coord2Double:Double = convertToDouble(theString: coordinate2TextField.text);
        
        // invalid input
        if (coord1Double == -1)
        {
            promptLabel.textColor = UIColor.red;
            promptLabel.isHidden = false;
            if (coord2Double == -1)
            {
                promptLabel.text = "Warning: Please enter a valid coordinate number\nfor both coordinates";
                return;
            }
            promptLabel.text = "Warning: Please enter a valid coordinate number\nfor Coordinate 1";
            return;
        }
        else if (coord2Double == -1) // just coordinate 2 has invalid input
        {
            promptLabel.textColor = UIColor.red;
            promptLabel.isHidden = false;
            promptLabel.text = "Warning: Please enter a valid coordinate number\nfor Coordinate 2";
            return;
        }
        
        // user input has been validated
    
        // check if error message is still appearing on valid input
        if (!promptLabel.isHidden)
        {
            promptLabel.isHidden = true;
        }
        
        self.view.endEditing(true)
        
        userCoordinate1 = coord1Double;
        userCoordinate2 = coord2Double;
        
        urlBuilder()
        
        print("OUTPUT STRING" + outputString);
        sleep(2);
        print("OUTPUT STRING" + outputString)
        storeInfoLabel.isHidden = false;
        storeInfoLabel.text = outputString;
        

        
        
    }
    
    func convertToDouble(theString: String!) -> Double
    {
        var result:Int = 0;
        
        for c in theString.characters
        {
            if (c == ".")
            {
                result = result + 1;
            }
        }
        
        if (theString.characters.count < 1)
        {
            return -1;
        }
        
        if (result < 2)
        {
            
            return Double(theString)!;
        }
        else
        {
            // you have inputted invalid input
            return -1;
        }
        
    }
    
    /*
     Manhattan Distance Conversion method
     This converts the distance between x and y
     x's coordinate 1 is A, coordinate 2 is B
     y's coordinate 1 is C, coordinate 2 is D
    
     To obtain a positive number from a negative number, simply multiply it by -1
 
     */
    func manhattanDistanceConversion(xA: Double!, xB: Double!, yC: Double!, yD: Double!) -> Double
    {
        var aMinusC:Double = xA - yC;
        
        if (aMinusC < 0)
        {
            aMinusC = aMinusC * (-1);
        }
        
        var bMinusD:Double = xB - yD;
        
        if (bMinusD < 0)
        {
            bMinusD = bMinusD * (-1);
        }
        
        var finalResult:Double = aMinusC + bMinusD;
        
        return finalResult;
    }
    
}
