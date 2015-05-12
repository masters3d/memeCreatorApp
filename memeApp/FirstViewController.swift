//
//  FirstViewController.swift
//  memeApp
//
//  Created by masters3d on 5/12/15.
//  Copyright (c) 2015 masters3d. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet var cameraButtonOutlet: UIButton!
    

    func showCameraPicker(){
        println("need camera picker")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBarHidden = true

        let heightOfToolBar = self.navigationController?.toolbar.frame.height
        
        let imageForSmallCameraButton = RBResizeImage(cameraButtonOutlet.imageView!.image!, CGSize(width: heightOfToolBar!, height: heightOfToolBar!))
        

    
        let cameraButton = UIBarButtonItem(image:
            imageForSmallCameraButton!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            , style: UIBarButtonItemStyle.Plain, target: self, action: "showCameraPicker")
        cameraButton
//       let cameraButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "showCameraPicker")
        


        //self.navigationItem.leftBarButtonItem = cameraButton
        
        self.setToolbarItems([cameraButton], animated: false)
                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
