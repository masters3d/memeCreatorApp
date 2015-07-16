//
//  FirstViewController.swift
//  memeApp
//
//  Created by masters3d on 5/12/15.
//  Copyright (c) 2015 masters3d. All rights reserved.
//

import UIKit
import MobileCoreServices


class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate {
    
    @IBAction func cameraButton(sender: AnyObject) {
        showCameraPicker()
    }
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var topText: UITextField!
    
    @IBOutlet var bottomText: UITextField!
    
     var cameraUI = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Checks to see if font exist
        let temp = (UIFont.familyNames() as! [String]).filter({$0.hasPrefix("Impact")})
        assert(temp == ["Impact"], "Impact font does not exist")
        
        // Sets custom font 
        let impactTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Impact", size: 38)!,
            NSStrokeWidthAttributeName : -2
        ]
         bottomText.defaultTextAttributes = impactTextAttributes
         topText.defaultTextAttributes    = impactTextAttributes
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    func showCameraPicker(){
        self.presentCamera()
    }
    
    //MARK: - Image Saving
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
    
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.imageView.image = image
     
        
        println(saveImageToUserFolder(image))
        
        imagePickerControllerDidCancel(self.cameraUI)
    }
    
    
    //MARK: - Camera
    
     func presentCamera(){
        cameraUI.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            cameraUI.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        cameraUI.mediaTypes = [kUTTypeImage] // This is the default
        cameraUI.allowsEditing = true
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    //MARK: - Cancel
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "imageToTable" {
            if let image = self.imageView.image {
                let newMeme = MemePicText(topLabel: "Heyhey", bottomLabel: "What Bottom", image: image, imageURL: "")
                
    (segue.destinationViewController as! MasterViewController).insertNewObject(newMeme)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
}
