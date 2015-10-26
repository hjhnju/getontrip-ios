//
//  SearchBaseViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/8/5.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import FFAutoLayout
import CoreLocation

class SearchResultsViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    var resultData = NSMutableDictionary() {
        didSet {
            self.tableView.hidden = false
            self.tableView.reloadData()
        }
    }
    
    var sectionTitle = [String]()
    
    var titleMap = ["sight":"景点", "city":"城市", "content":"内容"]
        
    var page    : String = "1"
    var pageSize: String = "6"
    
    /// 搜索提示
    var searchResult: UILabel = UILabel(color: UIColor(hex: 0xFFFFFF, alpha: 0.6), title: "当前搜索无内容", fontSize: 14, mutiLines: true)
    /// 定位城市
    var locationCity: UIButton = UIButton(image: "location_Yellow", title: " 即刻定位当前城市", fontSize: 12, titleColor: UIColor(hex: 0xF3FD54, alpha: 1.0))
    
    var scrollLock:Bool = false
    
    var tableView = UITableView()
    
    //位置管理器
    lazy var locationManager: CLLocationManager = CLLocationManager()
    
    var filterString: String = "" {
        didSet {
            if filterString == "" { return }
            
            SearchResultsRequest.sharedSearchResultRection.fetchSearchResultsModels(page, pageSize: pageSize, filterString: filterString) { (rows) -> Void in
                if self.filterString != "" {
                    self.resultData = rows as! NSMutableDictionary
                }
            }
        }
    }
    
    //MARK: View Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddProperty()
        setupAutoLayout()
        
        
    }
    
    func startUpdatingLocations(btn: UIButton) {
        // 应用程序使用期间允许定位
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }
    
    private func setupAddProperty() {
        
        view.addSubview(tableView)
        view.addSubview(searchResult)
        view.addSubview(locationCity)
        
        locationCity.addTarget(self, action: "startUpdatingLocations:", forControlEvents: UIControlEvents.TouchUpInside)
        searchResult.sendSubviewToBack(view)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorColor  = UIColor.grayColor()
        tableView.rowHeight = 60
        tableView.backgroundView = UIImageView(image: UIImage(named: "search-bg0")!)
        tableView.registerClass(SearchResultsCell.self, forCellReuseIdentifier: "SearchResults_Cell")
    }
    
    private func setupAutoLayout() {
        
        tableView.ff_AlignInner(ff_AlignType.TopLeft, referView: view, size: UIScreen.mainScreen().bounds.size)
        locationCity.ff_AlignInner(ff_AlignType.TopCenter, referView: view, size: nil, offset: CGPointMake(0, 92))
        searchResult.ff_AlignInner(ff_AlignType.BottomCenter, referView: locationCity, size: nil, offset: CGPointMake(0, 81))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    
    // MARK: - 地理定位代理方法
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("开始定位")
        
        locationManager.stopUpdatingLocation()
        
        // 获取位置信息
        let coordinate = locations.first?.coordinate
        // 反地理编码
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) -> Void in
            if let locality = placemarks?.first?.locality {
                let firstPlacemark: NSString = NSString(string: " 当前城市\(locality)")
//                self?.city = firstPlacemark.substringToIndex(firstPlacemark.length - 1)
                
                print(self?.parentViewController)
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return resultData.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            if resultData.objectForKey("searchCitys")?.count == 0 { return "" }
            return "城市"
        case 1:
            if resultData.objectForKey("searchSights")?.count == 0 { return "" }
            return "景点"
        default:
            if resultData.objectForKey("searchContent")?.count == 0 { return "" }
            return "内容"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if let searchCity = resultData.objectForKey("searchCitys") {
                
                let vc = CityViewController()
                let searchC = searchCity[indexPath.row] as! SearchCity
                vc.cityId = searchC.id!
                let nav = UINavigationController(rootViewController: vc)
                vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .Plain, target: vc, action: "dismissViewController")
                presentViewController(nav, animated: true, completion: nil)
            }
        case 1:
            if let searchSight = resultData.objectForKey("searchSights") {
                
                let vc = SightViewController()
                let searchC = searchSight[indexPath.row] as! SearchSight
                vc.sightId = searchC.id
                let nav = UINavigationController(rootViewController: vc)
                vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .Plain, target: vc, action: "dismissViewController")
                presentViewController(nav, animated: true, completion: nil)
                
            }
        default:
            if let searchContent = resultData.objectForKey("searchContent") {
                
                let searchC = searchContent[indexPath.row]
                
                if searchC.isKindOfClass(NSClassFromString("GetOnTrip.SearchContentTopic")!) {
                    let topic = searchC as! SearchContentTopic
                    let vc = TopicDetailController()
                    vc.topicId = topic.id!
                    let nav = UINavigationController(rootViewController: vc)
                    vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .Plain, target: vc, action: "dismissViewController")
                    presentViewController(nav, animated: true, completion: nil)
                } else if (searchC.isKindOfClass(NSClassFromString("GetOnTrip.SearchContentBook")!)) {
                    
                    let book = searchC as! SearchContentBook
                    let vc = SightBookDetailController()
                    vc.bookId = book.id!
                    let nav = UINavigationController(rootViewController: vc)
                    vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .Plain, target: vc, action: "dismissViewController")
                    presentViewController(nav, animated: true, completion: nil)
                } else if (searchC.isKindOfClass(NSClassFromString("GetOnTrip.SearchContentVideo")!)) {
                    
                    let video = searchC as! SearchContentVideo
                    let vc = DetailWebViewController()
                    vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .Plain, target: vc, action: "dismissViewController")
                    vc.url = video.url
                    let nav = UINavigationController(rootViewController: vc)
                    presentViewController(nav, animated: true, completion: nil)
                } else {
                    let wiki = searchC as! SearchContentWiki
                    let vc = DetailWebViewController()
                    vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .Plain, target: vc, action: "dismissViewController")
                    vc.url = wiki.url
                    let nav = UINavigationController(rootViewController: vc)
                    presentViewController(nav, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clearColor()
//        let frame = CGRectMake(0, view.frame.size.height-1, view.frame.width, 0.5)
//        let line  = UIView(frame: frame)
//        line.backgroundColor = UIColor.grayColor()
//        view.addSubview(line)
        
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.lightGrayColor()
        headerView.textLabel!.font = UIFont.systemFontOfSize(11)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return (resultData.objectForKey("searchCitys")?.count)!
        case 1:
            return (resultData.objectForKey("searchSights")?.count)!
        default:
            return (resultData.objectForKey("searchContent")?.count)!
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResults_Cell", forIndexPath: indexPath) as! SearchResultsCell
            cell.searchCruxCharacter = filterString
        switch indexPath.section {
        case 0:
            let data = resultData.objectForKey("searchCitys") as! [SearchCity]
            cell.searchCity = data[indexPath.row]
        case 1:
            let data = resultData.objectForKey("searchSights") as! [SearchSight]
            cell.searchSight = data[indexPath.row]
        case 2:
            let Contentdata = resultData.objectForKey("searchContent") as! NSArray

            let ContentType = Contentdata[indexPath.row]
            if ContentType.isKindOfClass(NSClassFromString("GetOnTrip.SearchContentTopic")!) {
                cell.searchContentTopic = ContentType as? SearchContentTopic
            } else if (ContentType.isKindOfClass(NSClassFromString("GetOnTrip.SearchContentBook")!)) {
                cell.searchContentBook = ContentType as? SearchContentBook
            } else if (ContentType.isKindOfClass(NSClassFromString("GetOnTrip.SearchContentVideo")!)) {
                cell.searchContentVideo = ContentType as? SearchContentVideo
            } else {
                cell.searchContentWiki = ContentType as? SearchContentWiki
            }

        default:
            break
        }

        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let searchResultsCell = cell as! SearchResultsCell
        
        //Apperance of cell
        searchResultsCell.separatorInset = UIEdgeInsetsZero
        searchResultsCell.preservesSuperviewLayoutMargins = false
        searchResultsCell.layoutMargins = UIEdgeInsetsZero
        searchResultsCell.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        tableView.hidden = true
        if !searchController.active { return }
        print(searchController.searchBar.text)
        if searchController.searchBar.text != "" {
            searchResult.hidden = true
            locationCity.hidden = true
            filterString = searchController.searchBar.text!

        } else {
            searchResult.hidden = false
            locationCity.hidden = false
        }
    }
}

class SearchSectionTitle: UIView {
    
}
