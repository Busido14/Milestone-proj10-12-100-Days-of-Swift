//
//  DetailViewController.swift
//  Milistone projects 10-12
//
//  Created by Артем Чжен on 22/04/23.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: Image?
        var imageContents: String?
        var path: URL?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if selectedImage != nil {
                imageView.image = UIImage(contentsOfFile: path!.path)
            }
        }
        

    }
