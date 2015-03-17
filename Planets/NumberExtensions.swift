//
//  NumberExtensions.swift
//  Planets
//
//  Created by Nico Hämäläinen on 16/03/15.
//  Copyright (c) 2015 sizeof.io. All rights reserved.
//

import Foundation
import SpriteKit

extension Int {
  /// Loop a certain block given times with an index parameter
  func times(block: (index: Int) -> ()) {
    for index in 0..<self {
      block(index: index)
    }
  }
}


let PI = CGFloat(M_PI)
let DegreesToRadians = PI / 180.0
let RadiansToDegrees = 180.0 / PI

func radius(theta: CGFloat, distance: CGFloat) -> CGFloat {
  return distance / (2 * sin(theta/2))
}

func radiusForSectorSize(size: Int, distance: CGFloat) -> CGFloat {
  let theta: CGFloat = (2*PI)/CGFloat(size)
  return radius(min(theta, PI), distance)
}