//
//  CollectionViewController.swift
//  memeApp
//
//  Created by masters3d on 7/23/15.
//  Copyright (c) 2015 masters3d. All rights reserved.
//

import UIKit


class CollectionViewController: UICollectionViewController {
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) { }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = collectionView!.frame.width / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    
    // Uncomment the following line to preserve selection between presentations
    //         clearsSelectionOnViewWillAppear = false
    
    // Register cell classes
    //        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    //                collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    
    
    // Do any additional setup after loading the view.
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView!.reloadData()
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Return the number of items in the section
        
        return (UIApplication.shared.delegate as! AppDelegate).memes.count
    }
    
    // MARK: - Segues
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            guard let indexPathItems = collectionView?.indexPathsForSelectedItems,
                  let indexPath = indexPathItems.first
                else  { return }
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let object = appDelegate.memes[(indexPath as NSIndexPath).item]
                (segue.destination as! DetailViewController).configureView(object)
                (segue.destination as! DetailViewController).setIndexToDelete((indexPath as NSIndexPath).item)
                //println("indexPath Collection \(indexPath.item)\(indexPath.item.getMirror())")

                
                
            }}
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as! CollectionViewCell)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let object  = appDelegate.memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = object.editedImage
        return cell
    }
    
    

    
    // MARK: UICollectionViewDelegate
    
    //    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    //        <#code#>
    //    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    
    
}
