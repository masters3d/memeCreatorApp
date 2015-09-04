//
//  DetailViewController.swift
//  memeApp
//
//  Created by masters3d on 5/12/15.
//  Copyright (c) 2015 masters3d. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) { }
    
    @IBOutlet var imageView: UIImageView!
    
    var detailItem: MemePicText?
    
    var indexOfItemToDelete:Int?
    
    @IBAction func deteleCurrentMeme(sender: UIBarButtonItem) {
        
        if let index = indexOfItemToDelete{
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(index)
            navigationController?.popViewControllerAnimated(true)

        }
    }
    
    
    func configureView(meme:MemePicText) {
        // Update the user interface for the detail item.
            detailItem = meme
        
    }
    
    func setIndexToDelete(index: Int){
        indexOfItemToDelete = index

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let image = detailItem?.editedImage {
        imageView.image = image
        }

        
    }
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentEdit" {
            if let meme = detailItem {
                var editController = (segue.destinationViewController as! FirstViewController)
                editController.editMemeToNewMeme(meme)
           
            }
        }
    }
    
}

