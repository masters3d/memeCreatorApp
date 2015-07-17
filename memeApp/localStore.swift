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
    var date:NSDate
    var image:UIImage
    var imageURL:String
    var imageName:String
    var editedImage:UIImage?
    
    init(topLabel:String, bottomLabel:String, image:UIImage, editedImage:UIImage? ){
        let nameAndUrl = saveImageToUserFolder(image)
        self.topLabel = topLabel
        self.bottomLabel = bottomLabel
        self.date = NSDate()
        self.image = image
        self.imageURL  = nameAndUrl.imageURL
        self.imageName  = nameAndUrl.name
        self.editedImage = editedImage
    }
}


func saveImageToUserFolder(image:UIImage) -> (imageURL:String, name:String )  {
    
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    let currentDateTime = NSDate()
    let formatter = NSDateFormatter()
    formatter.dateFormat = "ddMMyyyy-HHmmss"
    
    let dataToSave = UIImageJPEGRepresentation(image, 0.70)
    
    let recordingName = formatter.stringFromDate(currentDateTime) + ".jpeg"
    let pathArray = [dirPath, "memes", recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    let filePathString = filePath?.path ?? "" //dirPath + "/" + recordingName

//    let imageDestination = CGImageDestinationCreateWithURL(NSURL.fileURLWithPath(dirPath), "kUTTypeJPEG", 1, nil)
//    CGImageDestinationAddImage(imageDestination, image.CGImage, nil)
//    CGImageDestinationFinalize(imageDestination)
    
    let newSaver = NSData(data: dataToSave)
    
    newSaver.writeToFile(filePathString, atomically: true)
    return (filePathString, recordingName)

    
    
  //  let pathArray = [dirPath, recordingName]
    
       //UIImage//UIImageJPEGRepresentation(image: UIImage!, compressionQuality: CGFloat) -> NSData!

  
//        - (void) writeCGImage: (CGImageRef) image toURL: (NSURL*) url withType: (CFStringRef) imageType andOptions: (CFDictionaryRef) options
//    {
//        CGImageDestinationRef myImageDest = CGImageDestinationCreateWithURL((CFURLRef)url, imageType, 1, nil);
//        CGImageDestinationAddImage(myImageDest, image, options);
//        CGImageDestinationFinalize(myImageDest);
//        CFRelease(myImageDest);
//    }
//    
    
    
}

