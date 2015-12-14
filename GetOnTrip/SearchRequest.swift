//
//  SearchResultsModel.swift
//  GetOnTrip
//
//  Created by 王振坤 on 15/10/25.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import UIKit

class SearchRequest: NSObject {
    
    static let sharedInstance = SearchRequest()
    
    var sectionTypes = ["city", "sight", "content","landscape", "book", "video"]
    
    var page    : Int = 1
    var pageSize: Int = 4
    
    func fetchFirstPageModels(filter: String, handler: (SearchInitData, Int) -> Void) {
        return fetchModels(String(page), pageSize: String(pageSize), filterString: filter, handler: handler)
    }
    
    ///  搜索方法
    ///
    ///  - parameter page:         页面
    ///  - parameter pageSize:     页面大小
    ///  - parameter filterString: 搜索内容
    ///  - parameter handler:      回调
    func fetchModels(page: String, pageSize: String, filterString: String, handler: (SearchInitData, Int) -> Void) {
        if filterString == "" {
            return
        }
        var post         = [String: String]()
        post["query"]    = String(filterString)
        post["page"]     = String(page)
        post["pageSize"] = String(pageSize)
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/search", post: post) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                print(result)
                let data = result.dictionaryValue
                let rows = SearchInitData()
                var typeCount = [[String : Int]]()
                var groupNum = 0
                for section in self.sectionTypes {
                    switch section {
                    case "city":
                        var searchCitys = [SearchContentResult]()
                        if let citys = data["city"]?.arrayValue {
                            for item in citys {
                                if let item = item.dictionaryObject {
                                    let typeData = SearchContentResult(dict: item)
                                    typeData.search_type = ContentType.city
                                    searchCitys.append(typeData)
                                }
                            }
                        }
                        if searchCitys.count > 0 {
                            typeCount.append([ContentType.city : searchCitys.count])
                            rows.searchCitys = searchCitys
                            rows.city_num    = data["city_num"]?.intValue ?? 0
                            if data["city_num"]?.intValue > 0 {
                                rows.groupTitleName.append("城市")
                                rows.sectionRows.append(data["city_num"]?.intValue ?? 0)
                                groupNum++
                            }
                        }
                    case "sight":
                        var searchSights = [SearchContentResult]()
                        if let sights = data["sight"]?.arrayValue {
                            for item in sights {
                                if let item = item.dictionaryObject {
                                    let typeData = SearchContentResult(dict: item)
                                    typeData.search_type = ContentType.sight
                                    searchSights.append(typeData)
                                }
                            }
                        }
                        if searchSights.count > 0 {
                            typeCount.append([ContentType.sight : searchSights.count])
                            rows.searchSights = searchSights
                            rows.sight_num    = data["sight_num"]?.intValue ?? 0
                            if data["sight_num"]?.intValue > 0 {
                                rows.groupTitleName.append("景点")
                                rows.sectionRows.append(data["sight_num"]?.intValue ?? 0)
                                groupNum++
                            }
                        }
                    case "content":
                        var searchContent = [SearchContentResult]()
                        if let cons = data["content"]?.arrayValue {
                            for item in cons {
                                if let item = item.dictionaryObject {
                                    searchContent.append(SearchContentResult(dict: item))
                                }
                            }
                        }
                        if searchContent.count > 0 {
                            typeCount.append([ContentType.Topic : searchContent.count])
                            rows.searchContent = searchContent
                            rows.content_num   = data["content_num"]?.intValue ?? 0
                            if data["content_num"]?.intValue > 0 {
                                rows.groupTitleName.append("内容")
                                rows.sectionRows.append(data["content_num"]?.intValue ?? 0)
                                groupNum++
                            }
                        }
                    case "landscape":
                        var searchLandscape = [SearchContentResult]()
                        if let cons = data["landscape"]?.arrayValue {
                            for item in cons {
                                if let item = item.dictionaryObject {
                                    let typeData = SearchContentResult(dict: item)
                                    typeData.search_type = ContentType.Landscape
                                    searchLandscape.append(typeData)
                                }
                            }
                        }
                        if searchLandscape.count > 0 {
                            typeCount.append([ContentType.Landscape : searchLandscape.count])
                            rows.searchLandscape = searchLandscape
                            rows.landscape_num   = data["landscape_num"]?.intValue ?? 0
                            if data["landscape_num"]?.intValue > 0 {
                                rows.groupTitleName.append("景观")
                                rows.sectionRows.append(data["landscape_num"]?.intValue ?? 0)
                                groupNum++
                            }
                        }
                    case "book":
                        var searchBook = [SearchContentResult]()
                        if let cons = data["book"]?.arrayValue {
                            for item in cons {
                                if let item = item.dictionaryObject {
                                    searchBook.append(SearchContentResult(dict: item))
                                }
                            }
                        }
                        if searchBook.count > 0 {
                            typeCount.append([ContentType.Book : searchBook.count])
                            rows.searchBook = searchBook
                            rows.book_num   = data["book_num"]?.intValue ?? 0
                            if data["book_num"]?.intValue > 0 {
                                rows.groupTitleName.append("书籍")
                                rows.sectionRows.append(data["book_num"]?.intValue ?? 0)
                                groupNum++
                            }
                        }
                    case "video":
                        var searchVideo = [SearchContentResult]()
                        if let cons = data["video"]?.arrayValue {
                            for item in cons {
                                if let item = item.dictionaryObject {
                                    searchVideo.append(SearchContentResult(dict: item))
                                }
                            }
                        }
                        if searchVideo.count > 0 {
                            typeCount.append([ContentType.Video : searchVideo.count])
                            rows.searchVideo = searchVideo
                            rows.video_num   = data["video_num"]?.intValue ?? 0
                            if data["video_num"]?.intValue > 0 {
                                rows.groupTitleName.append("视频")
                                rows.sectionRows.append(data["video_num"]?.intValue ?? 0)
                                groupNum++
                            }
                        }
                    default:
                        break
                    }
                }
                rows.typeCount = typeCount
                rows.groupNum = groupNum
                handler(rows, status)
            }
        }
    }
    
    /**
    * 接口3：/api/search/hotWord
    * 热门搜索词接口
    * @param integer size,条数，默认是10
    */
    func fetchHotWords(handler: ([String]?, Int) -> Void){
        HttpRequest.ajax2(AppIni.BaseUri, path: "/api/search/hotWord", post: [String: String]()) { (result, status) -> () in
            if status == RetCode.SUCCESS {
                var data = [String]()
                for it in result.arrayValue {
                    data.append(it.stringValue)
                }
                handler(data, status)
                return
            }
            handler(nil, status)
        }
    }
}

/// 搜索初始数据模型
class SearchInitData: NSObject {
    
    /// 标题名
    var groupTitleName = [String]()
    
    /// 每行组个数
    var sectionRows = [Int]()
    
    /// 记录临时多的个数
    var tempCount = [Int]()
    
    /// 标明是哪个
    var typeCount = [[String : Int]]()
    
    /// 是否展开
    var iSunfold = [false, false, false, false, false, false]
    
    /// 需要改变行数的组
    var sectionTag: Int = -1
    
    /// 组个数
    var groupNum = 0
    
    /// 搜索城市
    var searchCitys = [SearchContentResult]()
    
    /// 搜索城市数量
    var city_num = 0
    
    /// 搜索景点
    var searchSights = [SearchContentResult]()
    
    /// 景点数量
    var sight_num = 0
    
    /// 内容
    var searchContent = [SearchContentResult]()
    
    /// 内容数量
    var content_num = 0
    
    /// 景观
    var searchLandscape = [SearchContentResult]()
    
    /// 景观数量
    var landscape_num = 0
    
    /// 书籍
    var searchBook = [SearchContentResult]()
    
    /// 书籍数量
    var book_num = 0
    
    /// 视频
    var searchVideo = [SearchContentResult]()
    
    /// 视频数量
    var video_num = 0
}