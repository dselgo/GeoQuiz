//
//  ResultViewController.swift
//  GeoQuiz
//
//  Created by Deforation on 7/22/15.
//  Copyright (c) 2015 Team F. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, XYPieChartDelegate, XYPieChartDataSource {
    
    @IBOutlet var pieChartView: UIView!
    // Pie Chart Properties
    var slices:NSMutableArray = NSMutableArray(capacity: 10)
    var sliceColors:NSArray!
    var myPieChart:XYPieChart!
    var indexOfSlices:UInt!
    var numSlices:UInt = 0
    var valueAtSlice:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializePieChart()
        myPieChart.setPieBackgroundColor(UIColor(red: 0.251, green: 0.251, blue: 0.251, alpha: 1.0))
        myPieChart.startPieAngle = CGFloat(M_PI_2)
        myPieChart.animationSpeed = 2.0
        
        self.pieChartView.setTranslatesAutoresizingMaskIntoConstraints(false)
        myPieChart.reloadData()
        self.pieChartView.addSubview(myPieChart)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializePieChart(){
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.mainScreen().applicationFrame.size)
        let midPointx = UIScreen.mainScreen().applicationFrame.width/2
        var midPointy:CGFloat = 0
        var rad:CGFloat = 0
        let point = CGPoint(x: midPointx, y: midPointy)
        let aPieChart:XYPieChart = XYPieChart(frame: rect, center: point, radius: rad)
        self.myPieChart = aPieChart
        myPieChart.dataSource = self
        myPieChart.delegate = self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    /*func pieChart(pieChart:XYPieChart!,index:Int!) ->CGFloat
    {
        let value:NSNumber = self.values[index] as NSNumber
        return value.doubleValue
    }*/
    
    func pieChart(pieChart: XYPieChart!, valueForSliceAtIndex index: UInt) -> CGFloat {
        
        return CGFloat(self.slices[Int(index)] as! NSNumber)
        
    }
    
    func numberOfSlicesInPieChart(pieChart: XYPieChart!) -> UInt {
        
        return UInt(self.slices.count)
    }
    
    
    func pieChart(pieChart: XYPieChart!, colorForSliceAtIndex index: UInt) -> UIColor! {
        return self.sliceColors[Int(index)] as! UIColor
    }

}
