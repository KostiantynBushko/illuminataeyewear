//
//  HomeTableViewController.swift
//  illuminataeyewear
//
//  Created by Bushko Konstantyn on 1/25/16.
//  Copyright © 2016 illuminataeyewear. All rights reserved.
//

import UIKit
import Foundation
import Kanna

class HomeTableViewController: UITableViewController {
    
    var newsPostItems = [NewsPost]()
    var simpleNewsPostItems = [SimpleNewsPost]()
    var imageCache = [String:UIImage]()
    
    let cellIdentifier = "NewsPostViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad();
        NewsPost.getNewsPost({(newsPostItems) in
            self.newsPostItems = newsPostItems
            for news in self.newsPostItems {
                if let doc = Kanna.HTML(html: news.text.htmlDecoded(), encoding: NSUTF8StringEncoding) {
                    let simpleNewsPost = SimpleNewsPost()
                    simpleNewsPost.text = doc.text!
                    
                    for img in doc.xpath("//img | //src") {
                        simpleNewsPost.imageLink = Constant.URL_BASE + img["src"]!
                    }
                    
                    for iframe in doc.xpath("//iframe | //src") {
                        simpleNewsPost.iframe = iframe["src"]!
                    }
                    
                    simpleNewsPost.title = news.title
                    self.simpleNewsPostItems.append(simpleNewsPost)
                }
            }
            self.RefreshTable()
        })
        
        //self.tabBarController?.tabBar.items![2].badgeValue = String(OrderController.sharedInstance().getCurrentOrder()!.productItems.count)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simpleNewsPostItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsPostViewCell
        
        let newsPost = simpleNewsPostItems[indexPath.row]
        cell.title.text = newsPost.title
        cell.shortDescription.text = newsPost.text
        (cell.readMore as! RoundRectButton).id = indexPath.row

        
        if !(newsPost.imageLink as NSString).isEqualToString("") {

            if let img = imageCache[newsPost.imageLink] {
                cell.photo.image = img
            } else {
                cell.photo.image = nil
                if !(newsPost.imageLink as NSString).isEqualToString("") {
                    let url:NSURL =  NSURL(string: newsPost.imageLink)!
                    let session = NSURLSession.sharedSession()
                    let request = NSMutableURLRequest(URL: url)
                    request.HTTPMethod = "GET"
                    request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
                    
                    let task = session.dataTaskWithRequest(request) { (let data, let response, let error) in
                        guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                            return
                        }
                        let image = UIImage(data: data!)
                        self.imageCache[newsPost.imageLink] = image
                        dispatch_async(dispatch_get_main_queue(), {
                            let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! NewsPostViewCell
                            cell.photo.image = image
                            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                        })
                    }
                    task.resume()
                }
            }
            cell.iFrame.hidden = true
            cell.photo.hidden = false
        } else if !(newsPost.iframe as NSString).isEqualToString(""){
            cell.photo.hidden = true
            cell.iFrame.hidden = false
            let html = "<iframe src=\"" + newsPost.iframe + "\" width=\"300\" height=\"150\" frameborder=\"0\"></iframe>"
            cell.iFrame.loadHTMLString(html, baseURL: nil)
            cell.iFrame.scrollView.scrollEnabled = false
            cell.iFrame.scrollView.bounces = false
        }
        
        /*let fixedWidth = cell.shortDescription.frame.size.width
        cell.shortDescription.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = cell.shortDescription.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = cell.shortDescription.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        cell.shortDescription.frame = newFrame;*/
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "NewsDetails") {
            let newsDetailViewController = segue.destinationViewController as! NewsDetailsViewController
            if let indexPath : Int = (sender as! RoundRectButton).id {
                if !(simpleNewsPostItems[indexPath].imageLink as NSString).isEqualToString("") {
                    newsDetailViewController.image = self.imageCache[simpleNewsPostItems[indexPath].imageLink]!
                    var moreText = newsPostItems[indexPath].moreText;
                    moreText = moreText.htmlDecoded()
                    var text = newsPostItems[indexPath].text;
                    text = text.htmlDecoded()
                    text = text.stringByReplacingOccurrencesOfString("<img\\s+[^>]*src=\"([^\"]*)\"[^>]*>", withString: "", options: .RegularExpressionSearch, range: nil)
                    newsDetailViewController.textHtml = text + "<p>" + moreText + "</p>"
                } else if !(simpleNewsPostItems[indexPath].iframe as NSString).isEqualToString("") {
                    newsDetailViewController.frameHtml = "<iframe src=\"" + simpleNewsPostItems[indexPath].iframe + "\" width=\"300\" height=\"170\" frameborder=\"0\"></iframe>"
                    var moreText = newsPostItems[indexPath].moreText;
                    moreText = moreText.htmlDecoded()
                    var text = newsPostItems[indexPath].text;
                    text = text.htmlDecoded()
                    text = moreText.stringByReplacingOccurrencesOfString("<iframe\\s+[^>]*src=\"([^\"]*)\"[^>]*>", withString: "", options: .RegularExpressionSearch, range: nil)
                    newsDetailViewController.textHtml = text + "<p>" + moreText + "</p>"
                }
            }
        }
    }
    
    func RefreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
}
