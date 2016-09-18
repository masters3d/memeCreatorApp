//
//  localStore.swift
//  memeApp
//
//  Created by masters3d on 5/14/15.
//  Copyright (c) 2015 masters3d. All rights reserved.
//

import Foundation
import UIKit
import ImageIO

struct MemePicText{
    var topLabel:String
    var bottomLabel:String
    var date:Date
    var image:UIImage
    var imageURL:String
    var imageName:String
    var editedImage:UIImage?
    
    // Custom init to handle edited image ??
    // I need this because I want to have edited image to fall back to image if nill
    // struct default init is limiting
    
    init(topLabel:String, bottomLabel:String, image:UIImage, editedImage:UIImage? ){
        let nameAndUrl = saveImageToUserFolder(image)
        self.topLabel = topLabel
        self.bottomLabel = bottomLabel
        self.date = Date()
        self.image = image 
        self.imageURL  = nameAndUrl.imageURL
        self.imageName  = nameAndUrl.name
        self.editedImage = editedImage ?? image
    }
}


func saveImageToUserFolder(_ image:UIImage) -> (imageURL:String, name:String )  {
    
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] 
    let currentDateTime = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "ddMMyyyy-HHmmss"
    
    
    let recordingName = formatter.string(from: currentDateTime) + ".jpeg"
    let pathArray:[String] = [dirPath, "memes", recordingName]
    
    let filePath =   NSURL.fileURL(withPathComponents : pathArray )
    let filePathString = filePath?.path ?? ""
    
    //TODO: - Implement file storage to presist between launches
//    let dataToSave = UIImageJPEGRepresentation(image, 0.70)
//    let newSaver = NSData(data: dataToSave)
//    newSaver.writeToFile(filePathString, atomically: true)
    
    return (filePathString, recordingName)

    
    
    
}

