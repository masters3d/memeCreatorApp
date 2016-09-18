//
//  DetailViewController.swift
//  memeApp
//
//  Created by masters3d on 5/12/15.
//  Copyright (c) 2015 masters3d. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) { }
    
    @IBOutlet var imageView: UIImageView!
    
    var detailItem: MemePicText?
    
    var indexOfItemToDelete:Int?
    
    @IBAction func deteleCurrentMeme(_ sender: UIBarButtonItem) {
        
        if let index = indexOfItemToDelete{
            (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: index)
            navigationController?.popViewController(animated: true)

        }
    }
    
    
    func configureView(_ meme:MemePicText) {
        // Update the user interface for the detail item.
            detailItem = meme
        
    }
    
    func setIndexToDelete(_ index: Int){
        indexOfItemToDelete = index

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let image = detailItem?.editedImage {
        imageView.image = image
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentEdit" {
            if let meme = detailItem {
                let editController = (segue.destination as! FirstViewController)
                editController.editMemeToNewMeme(meme)
           
            }
        }
    }
    
}

