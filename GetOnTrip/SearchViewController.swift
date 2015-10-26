//
//  SearchViewController.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchViewController: UISearchController {

    let searchResult = SearchResultsViewController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    init() {
        super.init(searchResultsController: searchResult)
        searchResultsUpdater = searchResult

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResult.view)
        hidesNavigationBarDuringPresentation = false
        view.backgroundColor = UIColor(patternImage: UIImage(named: "search-bg0")!)
//        view.backgroundColor = UIColor.orangeColor()
        searchBar.barStyle = UIBarStyle.Black
        searchBar.tintColor = UIColor.grayColor()
        searchBar.becomeFirstResponder()
        searchBar.keyboardAppearance = UIKeyboardAppearance.Default
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
