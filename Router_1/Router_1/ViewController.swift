//
//  ViewController.swift
//  Router
//
//  Created by Bhanu Pratap Singh Thapliyal on 07/07/18.
//  Copyright © 2018 Bhanu Pratap Singh Thapliyal. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UIGestureRecognizerDelegate, GETPLACESDelegate{
    func abc(places: String, COrdinates: CLLocationCoordinate2D) {
        if activeAddress == "Pick"
        {
            pickLabel.text = places
            PickMarker.position = COrdinates
            PickMarker.map = mapView
            isp = true
            mapView.animate(toLocation : COrdinates)
            
        }
        else if activeAddress == "Drop"
        {
            dropLabel.text = places
            DropMarker.position = COrdinates
            DropMarker.map = mapView
            isd = true
            mapView.animate(toLocation : COrdinates)
        }
        if isd == true && isd == true
        {
            //path draw
            getpath()
        }
     
    }
    
 
    //==========================================================================================
    
   var isp = false
    var isd = false
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pickLabel: UILabel!
    @IBOutlet weak var dropLabel: UILabel!
    var activeAddress = ""
    
    var PickMarker = GMSMarker.init()
    var DropMarker = GMSMarker.init()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickTap  = UITapGestureRecognizer.init(target: self, action: #selector(PickTapped))
        let dropTap  = UITapGestureRecognizer.init(target: self, action: #selector(DropTapped))
        
        dropTap.delegate = self
        pickTap.delegate = self
        
        pickLabel.addGestureRecognizer(pickTap)
        dropLabel.addGestureRecognizer(dropTap)
        
        
        
    }
    
    @objc func PickTapped()
    {   activeAddress = "Pick"
        print("Picktap")
        let suggestionVC = self.storyboard?.instantiateViewController(withIdentifier: "placeSuggestionViewControllerID") as! placeSuggestionViewController
        suggestionVC.delegate = self
        self.navigationController?.pushViewController(suggestionVC, animated: true)
    }
    
    @objc func DropTapped()
    {   activeAddress = "Drop"
       print("Droptap")
        let suggestionVC = self.storyboard?.instantiateViewController(withIdentifier: "placeSuggestionViewControllerID") as! placeSuggestionViewController
        suggestionVC.delegate = self
        
        self.navigationController?.pushViewController(suggestionVC, animated: true)
    }
    





func getpath(){
    let origin = "\((PickMarker.position.latitude)),\((PickMarker.position.longitude))"
    let destination = "\((DropMarker.position.latitude)),\((DropMarker.position.longitude))"
    
    let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAFaGamqy4YYKKQ1yU0LH7LA_7ltKdUH9s"
    
    Alamofire.request(url).responseJSON{(responseData) -> Void in
        print(responseData.request!)  // original URL request
        print(responseData.response!) // HTTP URL response
        print(responseData.data!)     // server data
        print(responseData.result.value)
        if((responseData.result.value) != nil) {
            /* read the result value */
            let swiftyJsonVar = JSON(responseData.result.value!)
            
            /* only get the routes object */
            
            
            if let resData = swiftyJsonVar["routes"].arrayObject {
                let routes = resData as! [[String: AnyObject]]
                /* loop the routes */
                if routes.count > 0 {
                    
                    
                    for rts in routes {
                        /* get the point */
                        let overViewPolyLine = rts["overview_polyline"]?["points"]
                        let path = GMSMutablePath(fromEncodedPath: overViewPolyLine as! String)
                        /* set up poly line */
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeColor = UIColor.brown
                        polyline.strokeWidth = 2
                        polyline.map = self.mapView
                        
                    }
                }
            }
        }
    }

}
}

