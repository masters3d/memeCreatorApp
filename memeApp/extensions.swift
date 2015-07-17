//
//  extensions.swift
//  memeApp
//
//  Created by masters3d on 7/16/15.
//  Copyright (c) 2015 masters3d. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func jj_takeSnapshotOfCurrentFrame() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}