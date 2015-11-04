//
//  HttpRequestProtocol.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/11/4.
//  Copyright © 2015年 Joshua. All rights reserved.
//

import Foundation

protocol HttpRequestProtocol {
    
    // 下一页数据
    func fetchNextPageModels(handler: (Sight?, Int) -> Void)
    
    // 第一页数据
    func fetchFirstPageModels(handler: (Sight?, Int) -> Void)
    
    // 将数据回调外界
    func fetchModels(handler: (Sight?, Int) -> Void)
}