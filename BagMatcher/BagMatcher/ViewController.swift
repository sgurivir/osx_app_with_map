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
    var player: AVPlayer!
    var _timeObserver:AnyObject?
    private var myContext = 0
    
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
        updateMap(21.282778, long:-157.829444)
    }
    
    // AVplayer
    func playVideo() {
        //Make a URL from your path
        _ = NSURL.fileURLWithPath(pathToVideo.stringValue)
        let url2 = NSURL.fileURLWithPath(pathToVideo.stringValue)
        
        player = AVPlayer(URL: url2)
        VideoViewController.player = player
        startObservers()
        player.play()
    }
    
    // MapView
    func updateMap(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let initialLocation = CLLocation(latitude: lat, longitude: long)
        let regionRadius: CLLocationDistance = 500
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 1.0, regionRadius * 1.0)
            MapViewController.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(initialLocation)
    }
    
    func positionUpdated(seconds: Float64) {
        print(formattedTimeForInterval(seconds))
       // _positionSlider.value = Float(seconds / _currentTrackDuration);
    }
    
    func formattedTimeForInterval(interval: NSTimeInterval) -> String {
        let min = NSInteger(interval / 60)
        let sec = NSInteger(interval % 60)
        
        return NSString(format: "%d:%02d", min, sec) as String
    }
    
    func startObservers() {
        if (_timeObserver == nil) {
            _timeObserver = player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 100), queue: dispatch_get_main_queue(),
                usingBlock: { (time: CMTime) -> Void in
                    let seconds:Float64 = CMTimeGetSeconds(time)
                    if (!isnan(seconds) && !isinf(seconds)) {
                        self.positionUpdated(seconds)
                    }
            })
        }
        //player.addObserver(self, forKeyPath: "status", options: .New, context: &myContext)
        //player.addObserver(self, forKeyPath: "loadedTimeRanges", options: .New, context:  &myContext)
        //player.addObserver(self, forKeyPath: "AVPlayerItemDidPlayToEndTimeNotification", options: .New, context:  &myContext)
        
    }
    
    func stopObservers() {
        if (_timeObserver != nil) {
            player.removeTimeObserver(_timeObserver!)
            _timeObserver = nil
        }
        
        //player.removeObserver(self, forKeyPath: "status", context: &myContext)
        //player.removeObserver(self, forKeyPath: "loadedTimeRanges", context: &myContext)
        //player.removeObserver(self, forKeyPath: "AVPlayerItemDidPlayToEndTimeNotification", context: &myContext)
    }
    
    deinit {
        stopObservers()
    }
}

