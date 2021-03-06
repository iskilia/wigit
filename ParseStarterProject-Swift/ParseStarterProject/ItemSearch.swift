/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import ParseUI
import Bolts

class ItemSearch: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout, UINavigationBarDelegate {
    let api: WigitAPI = WigitAPI()
    var collectionView: UICollectionView?
    var objects: [PFObject] = [PFObject]()
    let CELL_IDENTIFIER = "waterfallCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView
        let layout = CHTCollectionViewWaterfallLayout()
        self.collectionView!.collectionViewLayout = layout
        //collectionView!.registerClass(WigitCollectionViewCell.self, forCellWithReuseIdentifier: CELL_IDENTIFIER)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        api.nearbyItems({ (let objects, let error) -> Void in
            if objects != nil {
                print("COUNT: \(objects!.count) OBJECTS: \(objects)")
                self.objects = objects!
                self.collectionView!.reloadData()
            }

            }, error: 0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("trying to make cell #\(indexPath.row)")
        let cell: WigitCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_IDENTIFIER, forIndexPath: indexPath) as! WigitCollectionViewCell
        
        cell.itemName!.text = "\(self.objects[indexPath.row]["name"])"
        if let price = self.objects[indexPath.row]["rental_price_daily"] as? Int
        {
            if price != 0{
                cell.itemPrice!.text = "$\(self.objects[indexPath.row]["rental_price_daily"])/Day"
            } else if self.objects[indexPath.row].objectForKey("rental_price_onetime")  != nil {
                cell.itemPrice!.text = "$\(self.objects[indexPath.row]["rental_price_onetime"])"
            } else {
                cell.itemPrice!.text = "$$$?"
            }
        }
        if cell.image.image != nil { cell.image.image = nil }
        if let file = self.objects[indexPath.row]["thumbnail"] as? PFFile
        {
            cell.image.file = file
            cell.image.loadInBackground()
        } else {
            cell.image.image = nil
        }
        return cell

    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailView = self.storyboard!.instantiateViewControllerWithIdentifier("itemDetails") as! ItemDetails
        detailView.item = self.objects[indexPath.row]
        self.presentViewController(detailView, animated: true, completion: nil)
    }
    
    
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width / 2) - 8, height: 280.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumColumnSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
