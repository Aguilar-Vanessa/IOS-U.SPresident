//
//  DetailViewController.swift
//  U.S Presidents App
//
//  Created by Vanessa Aguilar on 10/28/20.
//  Copyright © 2020 Personal Team. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var presidentNum: UILabel!
    @IBOutlet weak var termStart: UILabel!
    @IBOutlet weak var termEnd: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var politicalParty: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageStore: ImageStore?     //optional image store
    
    func configureView() {
        
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .ordinal
        
        // Update the user interface for the detail item.
        if let detail = detailItem {
            ///downloading the image from the network, or cache or passing in a default image
            if let imageView = imageView, let imageStore = imageStore {
                imageStore.downloadImage(with: detail.imageUrlString, completion: {
                    (image: UIImage?) in
                    imageView.image = image
                })
            }
            if let label = namelabel {
                label.text = detail.name
            }
            if let label = presidentNum{
                //What changes our # from 'nd' 'st' ...
                label.text = numberformatter.string(from: NSNumber(value: detail.number))
    
            }
            if let label = termStart{
                label.text = detail.startDate
            }
            if let label = termEnd{
                label.text = detail.endDate
            }
            if let label = nickname{
                label.text = detail.nickname
            }
            if let label = politicalParty{
                label.text = detail.politicalParty
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: presidentInfo? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}


