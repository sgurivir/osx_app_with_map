//
//  ViewController.swift
//  BagMatcher
//
//  Created by Sridhar on 1/25/16.
//  Copyright © 2016 sridhar.gureen.com. All rights reserved.
//

import Cocoa
import MapKit
import AVKit
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet var pathToCDF: NSTextField!
    @IBOutlet var pathToTrace: NSTextField!
    @IBOutlet var pathToVideo: NSTextField!

    @IBOutlet var VideoViewController: AVPlayerView!
    @IBOutlet var MapViewController: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onFileChooserClick(sender: NSButton) {
    }

    @IBAction func onGo(sender: NSButton) {
        print("CDF = \(pathToCDF.stringValue)")
        print("Trace = \(pathToTrace.stringValue)")
        print("Video = \(pathToVideo.stringValue)")
        
        playVideo()
        updateMap()
    }
    
    func playVideo() {
        //Make a URL from your path
        _ = NSURL.fileURLWithPath(pathToVideo.stringValue)
        let url2 = NSURL.fileURLWithPath("/tmp/im.mp4")
        let player = AVPlayer(URL: url2)
        VideoViewController.player = player
        player.play()
    }
    
    func updateMap() {
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
            MapViewController.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(initialLocation)
    }
}

