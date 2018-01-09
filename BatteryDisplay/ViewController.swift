//
//  ViewController.swift
//  BatteryDisplay
//
//  Created by Mark Lyen on 1/3/18.
//  Copyright © 2018 _MarkLyen_. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var BatteryPercentage: UILabel!

    override func viewDidLoad() {
        let nc = NotificationCenter.default;

        super.viewDidLoad()

        UIDevice.current.isBatteryMonitoringEnabled = true
        nc.addObserver(forName: .UIDeviceBatteryStateDidChange, object: nil, queue: nil, using: batteryStateDidChange)
        nc.addObserver(forName: .UIDeviceBatteryLevelDidChange, object: nil, queue: nil, using: batteryLevelDidChange)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.checkAction(sender:)))
        self.view.addGestureRecognizer(gesture)


        BatteryPercentage.text = GetBatteryLevel()
        moveBatteryText()
    }

    @objc func checkAction(sender: UITapGestureRecognizer)
    {
        moveBatteryText()
    }

    private func moveBatteryText() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        //Temporary code to draw a box to help determine the proper margins to use for now.
        //let d = Draw(frame: CGRect(x: 5, y: 35, width: screenWidth-10, height: screenHeight-70))
        //self.view.addSubview(d)

        let HeightMargin: UInt32 = 35
        let WidthMargin: UInt32 = 5

        let bHeight = BatteryPercentage.frame.height
        let bWidth = BatteryPercentage.frame.width

        let maxHeight = UInt32(screenHeight - bHeight) - (HeightMargin * 2)
        let maxWidth = UInt32(screenWidth - bWidth) - (WidthMargin * 2)

        let newY = UInt32(arc4random_uniform(maxHeight)) + HeightMargin
        let newX = UInt32(arc4random_uniform(maxWidth)) + WidthMargin

        BatteryPercentage.frame.origin.x = CGFloat(newX)
        BatteryPercentage.frame.origin.y = CGFloat(newY)
    }

    func batteryStateDidChange(notification: Notification) {
        BatteryPercentage.text = GetBatteryLevel()
        moveBatteryText()
    }

    func batteryLevelDidChange(notification: Notification) {
        BatteryPercentage.text = GetBatteryLevel()
        moveBatteryText()
    }

    private func GetBatteryLevel() -> String {
        var returnString: String

        switch UIDevice.current.batteryState {
        case .charging:
            returnString = "Charging: "
        case .full:
            returnString = "Full: "
        case .unplugged:
            returnString = "Unplugged: "
        case .unknown:
            returnString = "Unknown: "
        }

        return returnString + String(format: "%.0f%%", UIDevice.current.batteryLevel * 100)
    }

    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// Tempoary class to support drawing a rectangle on screen.
class Draw: UIView {
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect)
    {
        let color:UIColor = UIColor.yellow
        let bpath:UIBezierPath = UIBezierPath(rect: rect)

        color.set()
        bpath.stroke()
    }
}