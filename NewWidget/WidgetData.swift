//
//  WidgetData.swift
//  WidgetDemo
//
//  Created by admin on 2020/9/29.
//

import Foundation
import UIKit

let widgetTargetWidth: CGFloat = 329
let iPhoneHeight = UIScreen.main.bounds.size.height

struct WidgetData {
  let allTitie: String
  let titie   : String
  let desc    : String
  let count   : String
  let image   : UIImage
}

struct WidgetDataLoader {

  static func getWidgetData() -> WidgetData {
    // 获取plist路径
    let plistPath = Bundle.main.path(forResource: "WidgetInfo", ofType: "plist")
    // 拿到plist对应的字典
    let staticDic = NSMutableDictionary(contentsOfFile: plistPath!)!
    // 下载图片 一定要先下载
    var iconImage: UIImage?
    if let url = URL(string: staticDic["imageUrl"] as! String){
      do {
        let data = try Data(contentsOf: url)
        iconImage = UIImage(data: data)
      } catch let error {
        print(error)
      }
    }
    if iconImage == nil {
      iconImage = UIImage(named: "temp")
    }
    
    return WidgetData(allTitie : staticDic["allTitie"] as! String,
                      titie    : staticDic["title"] as! String,
                      desc     : staticDic["desc"] as! String,
                      count    : staticDic["count"] as! String,
                      image    : iconImage!
                      )
  }
}


func RatioLen(_ length: CGFloat) -> CGFloat {
  if iPhoneHeight == 812 {
    return length
  }
  else if iPhoneHeight == 896 {
    return (length * 360 / widgetTargetWidth)
  }
  else if iPhoneHeight == 736 {
    return (length * 348 / widgetTargetWidth)
  }
  else if iPhoneHeight == 667 {
    return (length * 321 / widgetTargetWidth)
  }
  else if iPhoneHeight == 568 {
    return (length * 292 / widgetTargetWidth)
  }
  return length
}
