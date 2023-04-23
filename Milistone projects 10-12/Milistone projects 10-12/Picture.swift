//
//  PictureCell.swift
//  Milistone projects 10-12
//
//  Created by Артем Чжен on 22/04/23.
//

import UIKit

class Image: NSObject, Codable {
    var image = String()
    var caption = String()

    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
}
