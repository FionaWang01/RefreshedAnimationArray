//
//  ViewController.swift
//  RefreshAnimition
//
//  Created by babykang on 16/4/22.
//  Copyright © 2016年 babykang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var refreshTabelView: UITableView!
    var refreshController: UIRefreshControl!
    var currentColorIndex = 0
    var currentLabelIndex = 0
    var refreshView : UIView!
    var labelArray = [UILabel]()
    var isAnimation = false
    var timer : NSTimer?
    var dataArray = ["😀","😬","😁","😘","😍","😜","😎"]

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTabelView.delegate = self
        refreshTabelView.dataSource = self
        refreshController = UIRefreshControl()
        refreshController.backgroundColor = UIColor.clearColor()
        refreshController.tintColor = UIColor.clearColor()
        refreshTabelView.addSubview(refreshController)
        loadCustomRefreshContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = dataArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Apple Color Emoji", size: 40)
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func loadCustomRefreshContents(){
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshContentsViewController", owner: self, options: nil)
        refreshView = refreshContents[0] as! UIView
        refreshView.frame = refreshController.bounds
        
        for var i=0; i < refreshView.subviews.count; ++i{
            labelArray.append(refreshView.viewWithTag(i + 1) as! UILabel)
        }
        refreshController.addSubview(refreshView)
    }
    
    func animationRefreshedStep1(){
        
        isAnimation = true

        
        UIView.animateWithDuration(0.1, delay: 0.0, options:UIViewAnimationOptions.CurveLinear, animations: {
            () -> Void in
            self.labelArray[self.currentLabelIndex].transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            self.labelArray[self.currentColorIndex].textColor = self.getNextColor()
            },completion:{ (finished) -> Void in
                UIView.animateWithDuration(0.05, delay:0.0 , options: UIViewAnimationOptions.CurveLinear, animations: {() -> Void in
                    self.labelArray[self.currentLabelIndex].transform = CGAffineTransformIdentity
                    self.labelArray[self.currentColorIndex].textColor = UIColor.blackColor()
                    }, completion: {(finished) -> Void in
                    self.currentLabelIndex += 1
                        if self.currentLabelIndex < self.labelArray.count{
                            self.animationRefreshedStep1()
                        }else{
                            self.animationRefreshedStep2()
                        }
                })
        })
        
    }
    
    func animationRefreshedStep2(){
        
        UIView.animateWithDuration(0.40, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {() -> Void in
            self.labelArray[0].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelArray[1].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelArray[2].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelArray[3].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelArray[4].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelArray[5].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelArray[6].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelArray[7].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelArray[8].transform = CGAffineTransformMakeScale(1.5, 1.5)
            
            }, completion: {(finished)-> Void in
                UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {()-> Void in
                    self.labelArray[0].transform = CGAffineTransformIdentity
                    self.labelArray[1].transform = CGAffineTransformIdentity
                    self.labelArray[2].transform = CGAffineTransformIdentity
                    self.labelArray[3].transform = CGAffineTransformIdentity
                    self.labelArray[4].transform = CGAffineTransformIdentity
                    self.labelArray[5].transform = CGAffineTransformIdentity
                    self.labelArray[6].transform = CGAffineTransformIdentity
                    self.labelArray[7].transform = CGAffineTransformIdentity
                    self.labelArray[8].transform = CGAffineTransformIdentity
                    
                    }, completion: {(finished) -> Void in
                        if self.refreshController.refreshing{
                            self.currentLabelIndex = 0
                            self.animationRefreshedStep1()
                        }else{
                            self.isAnimation = false
                            self.currentLabelIndex = 0
                            for i in 0  ..< self.labelArray.count {
                                self.labelArray[i].textColor = UIColor.blackColor()
                                self.labelArray[i].transform = CGAffineTransformIdentity
                            }
                        }
                })
        })
    }
    
    func getNextColor() -> UIColor{
        var colorArray :Array<UIColor> = [UIColor.yellowColor(), UIColor.brownColor(), UIColor.redColor(), UIColor.blueColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.brownColor(), UIColor.yellowColor(), UIColor.grayColor()]
        if currentColorIndex == colorArray.count{
            currentColorIndex = 0
        }
        
        let returnColor = colorArray[currentColorIndex]
        currentColorIndex += 1
        return returnColor
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        if refreshController.refreshing{
            if !isAnimation{
                doSomething()
                animationRefreshedStep1()
            }
        }
    }
    
    func doSomething (){
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector: #selector(ViewController.endedOfWork), userInfo: nil, repeats: true)
    }
    
    func endedOfWork(){
        refreshController.endRefreshing()
        timer?.invalidate()
        timer = nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

