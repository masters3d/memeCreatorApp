//
//  MasterViewController.swift
//  memeApp
//
//  Created by masters3d on 5/12/15.
//  Copyright (c) 2015 masters3d. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) { }
    
    let backButtonTittle = "Delete"

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        navigationItem.leftBarButtonItem = {
            let editButton = self.editButtonItem
            editButton.title = self.backButtonTittle
            return editButton
            }()
        
        
        //navigationItem.leftItemsSupplementBackButton = true
        
        if (UIApplication.shared.delegate as! AppDelegate).memes.isEmpty {
            performSegue(withIdentifier: "presentCamera", sender: self)
            
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        if !editing {
            navigationItem.leftBarButtonItem?.title = backButtonTittle}
        if editing {
            if (UIApplication.shared.delegate as! AppDelegate).memes.isEmpty{
                
                setEditing(false, animated: false)
                
            let alert = UIAlertController(title: "No Memes", message: "Nothing to Delete", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
            
          }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    
    func insertNewObject(_ meme: MemePicText) {
        
        (UIApplication.shared.delegate as! AppDelegate).memes.insert(meme, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        //println((UIApplication.sharedApplication().delegate as! AppDelegate).memes)
    }
    
    // MARK: - Segues
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
                let object = (UIApplication.shared.delegate as! AppDelegate).memes[(indexPath as NSIndexPath).row]
                (segue.destination as! DetailViewController).configureView(object)
                (segue.destination as! DetailViewController).setIndexToDelete((indexPath as NSIndexPath).row)

                //println("indexRow Table \(indexPath.row)\(indexPath.row.getMirror())")
                
            
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate as! AppDelegate).memes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCustom = tableView.dequeueReusableCell(withIdentifier: "CellCustom", for: indexPath) 
        
        let object = (UIApplication.shared.delegate as! AppDelegate).memes[(indexPath as NSIndexPath).row]
        
        let labelTop = cellCustom.viewWithTag(1) as! UILabel
        let labelBottom = cellCustom.viewWithTag(2) as! UILabel
        
        
        labelTop.text = object.topLabel
        labelBottom.text = object.bottomLabel
        cellCustom.imageView?.image = object.editedImage ?? object.image
        
        return cellCustom
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}

