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
    
    @IBAction func cameraButton(_ sender: AnyObject) {
        presentPhotoPicker(.camera)
    }
    
    @IBOutlet var cameraLabel: UIBarButtonItem!
    
    
    @IBAction func albumButton(_ sender: AnyObject) {
        presentPhotoPicker(.photoLibrary)
    }
    
    @IBOutlet var navigationTitle: UINavigationItem!
    
    @IBOutlet var albumLabel: UIBarButtonItem!
    
    @IBOutlet var viewComposite: UIView!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var topText: UITextField!
    
    @IBOutlet var bottomText: UITextField!
    
    var cameraUI = UIImagePickerController()
    
    @IBAction func share(_ sender: AnyObject) {
        let image2share = viewComposite.jj_takeSnapshotOfCurrentFrame()
        shareImage(image2share)
    }
    
    @IBOutlet var shareLabel: UIBarButtonItem!
    
    
    @IBOutlet var cancelLabel: UIBarButtonItem!
    
    @IBAction func cancelButton(_ sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //enables tap to exit keyboard
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.handleSingleTap(_:)))
        tapRecognizer?.numberOfTapsRequired = 1
        
        //hides camera when running in simulator
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            cameraLabel.isEnabled = false
        }
        
        navigationTitle.title = "New Meme"
        
        shareLabel.isEnabled = false
//        cameraLabel.enabled = true
//        albumLabel.enabled = true
        
        /// Checks to see if font exist
        assert((UIFont.familyNames ).contains("Impact"), "Impact font does not exist")
        
        // Sets custom font
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        
        func setTextAttibutes(_ input:UITextField){
            input.defaultTextAttributes = convertToNSAttributedStringKeyDictionary([
                NSAttributedString.Key.strokeColor.rawValue : UIColor.black,
                NSAttributedString.Key.foregroundColor.rawValue : UIColor.white,
                NSAttributedString.Key.font.rawValue : UIFont(name: "Impact", size: 38)!,
                NSAttributedString.Key.strokeWidth.rawValue : -2 ])
            input.textAlignment  = .center
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        //navigationController?.navigationBarHidden = true
        
        /* Add tap recognizer to dismiss keyboard */
        addKeyboardDismissRecognizer()
        
        /* Subscribe to keyboard events so we can adjust the view to show hidden controls */
        subscribeTokeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        //navigationController?.navigationBarHidden = false
    }
    
    
    //MARK: - Image Saving
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        let image = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage)
        
        shareLabel.isEnabled = true
        imageView.image = image
        
        imagePickerControllerDidCancel(cameraUI)
    }
    
    //MARK: - Setup controller for editing of Meme
    
    func editMemeToNewMeme(_ meme:MemePicText){
        memeToEdit = meme
        
    }
    
    func setupEditController(_ meme:MemePicText){
        bottomText?.text = meme.bottomLabel
        imageView.image = meme.image
        topText?.text = meme.topLabel
        shareLabel.isEnabled = true
        cameraLabel.isEnabled = false
        albumLabel.isEnabled = false
        navigationTitle.title = "Edit Meme"
    }

    
    
    //MARK: - Sharing Feature
    
    func imageToShare() -> Void{
        
        performSegue(withIdentifier: "imageToTable", sender: self)
    }
    
    func shareImage(_ image:UIImage){
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // Signature of the completionWithItemsHandler
        //typealias UIActivityViewControllerCompletionWithItemsHandler = (String!, Bool, [AnyObject]!, NSError!) -> Void
        
        activityVC.completionWithItemsHandler = {
            (_ , success , _ , _ ) in
            
            if success {
                self.imageToShare()}}
        
        present(activityVC, animated: true, completion: nil)
    }
    
    //MARK: - Camera and Album picker
    
    func presentPhotoPicker(_ pickerSourceType:UIImagePickerController.SourceType = .camera){
        cameraUI.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(pickerSourceType) {
            cameraUI.sourceType = pickerSourceType
        } else {
            cameraUI.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        }
//        cameraUI.mediaTypes = ["kUTTypeImage"] // This is the default
        cameraUI.allowsEditing = true
        
        present(cameraUI, animated: true, completion: {})
    }
    
    
    
    //MARK: - Cancel
    
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageToTable" {
            if let image = imageView.image {
                let newMeme = MemePicText(topLabel: topText.text ?? "", bottomLabel: bottomText.text ?? "", image: image, editedImage: viewComposite.jj_takeSnapshotOfCurrentFrame())
                
                
                (segue.destination as! MasterViewController).insertNewObject(newMeme)
                
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    
    // Subscribe to keyboard show/hide notification.
    // This is needed so that we know when to slide the view upwards.
    func subscribeTokeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Unsubscribe the notifications.
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Keyboard will show and hide
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize =
        userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomText.isFirstResponder {
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
    
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
