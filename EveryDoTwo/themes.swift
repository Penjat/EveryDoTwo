//
//  themes.swift
//  EveryDoTwo
//
//  Created by Spencer Symington on 2019-02-13.
//  Copyright © 2019 Spencer Symington. All rights reserved.
//

import Foundation
import UIKit

//specifies the different UITypes and how they are affected by themes
enum UIType{
  case Cell,Background,Text
}

enum Theme {
  case Dark,Light,Brown,Rainbow
  
  func toInt()->Int{
    switch (self){
    case .Dark:
      return 0
    case .Light:
      return 1
    case .Rainbow:
      return 2
    case .Brown:
      return 3
    }
  }
  
  
  func getColor(uiType:UIType) -> UIColor{
    let myTuple = (theme:self , uiType:uiType)
    
    switch(myTuple){
      
    case (.Dark,UIType.Cell):
      return UIColor.darkGray
    case (.Dark,UIType.Background):
      return UIColor.black
    case (.Dark,UIType.Text):
      return UIColor.lightGray
      
    case (.Light,UIType.Cell):
      return UIColor.white
    case (.Light,UIType.Background):
      return UIColor.lightGray
    case (.Light,UIType.Text):
      return UIColor.gray
      
    case (.Brown,UIType.Cell):
      return UIColor.init(red: 183/255, green: 110/255, blue: 7/255, alpha: 1.0)
    case (.Brown,UIType.Background):
      return UIColor.init(red: 219/255, green: 167/255, blue: 94/255, alpha: 1.0)
    case (.Brown,UIType.Text):
      return UIColor.init(red: 94/255, green: 56/255, blue: 2/255, alpha: 1.0)
      
    case (.Rainbow,UIType.Cell):
      let r = CGFloat(integerLiteral: Int.random(in: 0...255))/255
      let b = CGFloat(integerLiteral: Int.random(in: 0...255))/255
      let g = CGFloat(integerLiteral: Int.random(in: 0...255))/255
      return UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
    case (.Rainbow,UIType.Background):
      let r = CGFloat(integerLiteral: Int.random(in: 0...255))/255
      let b = CGFloat(integerLiteral: Int.random(in: 0...255))/255
      let g = CGFloat(integerLiteral: Int.random(in: 0...255))/255
      return UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
    case (.Rainbow,UIType.Text):
      return UIColor.white
      
      
    default:
      return UIColor.gray
      
    }
  }
}
