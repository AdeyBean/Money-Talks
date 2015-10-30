//
//  ViewController.swift
//  Money Talks
//
//  Created by Ramin Saee-Oskuee on 30/10/2015.
//  Copyright © 2015 AppOne. All rights reserved.
//

import UIKit

class NewsFeed: UICollectionViewController, MWFeedParserDelegate {

    var newsItems = [MWFeedItem]()
    var spacing = CGFloat(10)
    var cornerRadius = CGFloat(5)
    var companyString = ""
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var infoFeedTitle = ""
    var regexFinal = NSRegularExpression()
    
    override func viewDidLoad() {
        
        setupUI()
        getData()
    }
    
    func setupUI () {
        
        layout.sectionInset = UIEdgeInsets(top: spacing + 5 + spacing, left: 0, bottom: spacing, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = spacing
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.collectionView?.delegate = self
        self.collectionView?.collectionViewLayout = layout
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
    }
    
    func getData() {
        let feeds = [
            "https://qz.com/feed/",
            "https://www.economist.com/feeds/print-sections/77/business.xml",
            "https://www.businessweek.com/feeds/homepage.rss",
            "https://blog.priceonomics.com/rss",
            "https://feeds.feedburner.com/zerohedge/feed",
            "https://marginalrevolution.com/feed",
            "https://rss.cnn.com/rss/money_topstories.rss",
            "https://feeds.reuters.com/counterparties",
            "https://feeds2.feedburner.com/businessinsider",
        ]
        for i in feeds {
            let url = NSURL(string: i)
            let parser = MWFeedParser(feedURL: url)
            parser.delegate = self
            parser.parse()
            
        }
    }
    
    func feedParserDidStart(parser: MWFeedParser!) {
        newsItems = [MWFeedItem]()
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        self.collectionView?.reloadData()
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        newsItems.append(item)
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        infoFeedTitle = info.title
    }
    
    func formatCell(cell: UICollectionViewCell) {
        
        cell.contentView.layer.masksToBounds = false
        cell.contentView.layer.cornerRadius = cornerRadius
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = cornerRadius
        cell.contentView.layer.borderWidth = 0
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(0, 0.5)
        cell.layer.shadowRadius = 1
        cell.layer.shadowOpacity = 0.25
        cell.layer.masksToBounds = false

    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let index = indexPath.row
        
        switch index {
            
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("newsFeedTitleCell", forIndexPath: indexPath) as! TitleCell
            cell.titleLabel.text = "N E W S   F E E D"
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("feedCell", forIndexPath: indexPath) as! NewsFeedCell
            
            formatCell(cell)
            
            cell.titleLabel.text = newsItems[index].title
            let newsInfo = "\(infoFeedTitle) • \(newsItems[index].author)"
            let newsInfoRefined = newsInfo.stringByReplacingOccurrencesOfString("nil", withString: "Author Unknown")
            cell.infoLabel.text = newsInfoRefined
            return cell

        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newsItems.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //let link = newsItems[indexPath.row].link
        //newsWebViewControllerURL = NSURL(string: link)
        //newsArticleTitle = newsItems[indexPath.row].title
        self.performSegueWithIdentifier("showNewsArticle", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout:UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        
        let height = CGRectGetHeight(self.view.frame)
        let width = CGRectGetWidth(self.view.frame)
        
        let index = indexPath.row
        
        switch index {
            case 0:
                return CGSize(width: width - spacing * 2, height: height * 0.1)
            
            default:
                return CGSize(width: width - spacing * 2, height: height * 0.35)
        }
    }
}



