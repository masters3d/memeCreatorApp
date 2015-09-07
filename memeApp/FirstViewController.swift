//
//  FirstViewController.swift
//  memeApp
//
//  Created by masters3d on 5/12/15.
//  Copyright (c) 2015 masters3d. All rights reserved.
//

import UIKit
import MobileCoreServices


class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate,
UITextFieldDelegate{
    
    var memeToEdit:MemePicText?
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    @IBAction func cameraButton(sender: AnyObject) {
        presentCamera()
    }
    
    @IBOutlet var cameraLabel: UIBarButtonItem!
    
    
    @IBAction func albumButton(sender: AnyObject) {
        presentCamera(true)
    }
    
    @IBOutlet var navigationTitle: UINavigationItem!
    
    @IBOutlet var albumLabel: UIBarButtonItem!
    
    @IBOutlet var viewComposite: UIView!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var topText: UITextField!
    
    @IBOutlet var bottomText: UITextField!
    
    var cameraUI = UIImagePickerController()
    
    @IBAction func share(sender: AnyObject) {
        let image2share = viewComposite.jj_takeSnapshotOfCurrentFrame()
        shareImage(image2share)
    }
    
    @IBOutlet var shareLabel: UIBarButtonItem!
    
    
    @IBOutlet var cancelLabel: UIBarButtonItem!
    
    @IBAction func cancelButton(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //enables tap to exit keyboard
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
        //hides camera when running in simulator
        if !UIImagePickerController.isSourceTypeAvailable(.Camera){
            cameraLabel.enabled = false
        }
        
        navigationTitle.title = "New Meme"
        
        shareLabel.enabled = false
//        cameraLabel.enabled = true
//        albumLabel.enabled = true
        
        /// Checks to see if font exist
        assert((UIFont.familyNames() ).contains("Impact"), "Impact font does not exist")
        
        // Sets custom font
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        
        func setTextAttibutes(input:UITextField){
            input.defaultTextAttributes = [
                NSStrokeColorAttributeName : UIColor.blackColor(),
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont(name: "Impact", size: 38)!,
                NSStrokeWidthAttributeName : -2 ]
            input.textAlignment  = .Center
            input.delegate = self
            input.placeholder = nil
        }
        
        setTextAttibutes(topText)
        setTextAttibutes(bottomText)
        
        
        //Set up Controller to Edit already save Meme
        if let meme = memeToEdit {
            setupEditController(meme)
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = true
        //navigationController?.navigationBarHidden = true
        
        /* Add tap recognizer to dismiss keyboard */
        addKeyboardDismissRecognizer()
        
        /* Subscribe to keyboard events so we can adjust the view to show hidden controls */
        subscribeTokeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
        //navigationController?.navigationBarHidden = false
    }
    
    
    //MARK: - Image Saving
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        let image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        
        shareLabel.enabled = true
        imageView.image = image
        
        imagePickerControllerDidCancel(cameraUI)
    }
    
    //MARK: - Setup controller for editing of Meme
    
    func editMemeToNewMeme(meme:MemePicText){
        memeToEdit = meme
        
    }
    
    func setupEditController(meme:MemePicText){
        bottomText?.text = meme.bottomLabel
        imageView.image = meme.image
        topText?.text = meme.topLabel
        shareLabel.enabled = true
        cameraLabel.enabled = false
        albumLabel.enabled = false
        navigationTitle.title = "Edit Meme"
    }

    
    
    //MARK: - Sharing Feature
    
    func imageToShare() -> Void{
        
        performSegueWithIdentifier("imageToTable", sender: self)
    }
    
    func shareImage(image:UIImage){
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // Signature of the completionWithItemsHandler
        //typealias UIActivityViewControllerCompletionWithItemsHandler = (String!, Bool, [AnyObject]!, NSError!) -> Void
        
        activityVC.completionWithItemsHandler = {
            (_ , success , _ , _ ) in
            
            if success {
                self.imageToShare()}}
        
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    //MARK: - Camera and Album picker
    
    func presentCamera(photoLibrary:Bool = false){
        cameraUI.delegate = self
        
        if !photoLibrary {
            cameraUI.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        } else {
            
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
            } else {
                cameraUI.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
        }
//        cameraUI.mediaTypes = ["kUTTypeImage"] // This is the default
        cameraUI.allowsEditing = true
        
        presentViewController(cameraUI, animated: true, completion: {})
    }
    
    
    
    //MARK: - Cancel
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "imageToTable" {
            if let image = imageView.image {
                let newMeme = MemePicText(topLabel: topText.text ?? "", bottomLabel: bottomText.text ?? "", image: image, editedImage: viewComposite.jj_takeSnapshotOfCurrentFrame())
                
                
                (segue.destinationViewController as! MasterViewController).insertNewObject(newMeme)
                
                // Adventures with Tab Controler
                //               ((segue.destinationViewController as? UITabBarController)?.viewControllers?.first as? MasterViewController)?.insertNewObject(newMeme)
                
                
            }
        }
        if segue.identifier == "cancelToTable" {
            // Cancel Button code
        }
        
    }
    
    //MARK: - Keyboard Text Field Related
    
    // Hide the keyboard when user hits the return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    
    // Subscribe to keyboard show/hide notification.
    // This is needed so that we know when to slide the view upwards.
    func subscribeTokeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Unsubscribe the notifications.
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Keyboard will show and hide
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize =
        userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomText.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = 0.0
        }
    }
    
    
    //Tap Recognizer
    
    func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
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
