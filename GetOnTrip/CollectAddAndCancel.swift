//
//  CollectAddAndCancel.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/24.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class CollectAddAndCancel: NSObject {
    
    static let sharedCollectAddCancel = CollectAddAndCancel()
    
    ///  收藏方法
    ///
    ///  - parameter objid:   收藏对象 内容：1， 景点：2， 城市：3， 话题：4， 书籍：5
    ///  - parameter isAdd:   是否收藏
    ///  - parameter handler: 回调
    func fetchCollectionModels(type: Int, objid: String, isAdd: Bool, handler: AnyObject -> Void) {
        
        var post      = [String: String]()
        post["objid"] = String(objid)
        post["type"]  = String(type)
        let path = isAdd == true ? "/api/collect/add" : "/api/collect/del"
        
        HttpRequest.ajax(AppIni.BaseUri, path: path, post: post) { (result, error) -> () in
            if error == nil {
                handler(result!)
            }
        }
    }

}
