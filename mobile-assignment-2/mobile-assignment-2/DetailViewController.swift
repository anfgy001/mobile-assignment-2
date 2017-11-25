//
//  DetailViewController.swift
//  Mobile Application Enterprise Development Assignment 2
//
//  Created by Gianni Anfiteatro
//

import UIKit

/**
 
 The DetailViewController is used for the Home Page of the application as it's main view controller
 */
class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var titleImage: UIImageView!
    
    var detailItem: AnyObject? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = (detail.value(forKey: "timeStamp")! as AnyObject).description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

