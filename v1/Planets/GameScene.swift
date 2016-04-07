//
//  GameScene.swift
//  Planets
//
//  Created by Nico Hämäläinen on 16/03/15.
//  Copyright (c) 2015 sizeof.io. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class GameScene: SKScene {
  
  var earth = Planetoid(name: "Earth", type: .Earth, sectorCount: 8)
  var mars = Planetoid(name: "Mars", type: .Earth, sectorCount: 3)
  var pluto = Planetoid(name: "Pluto", type: .Earth, sectorCount: 2)
  var other = Planetoid(name: "Other", type: .Earth, sectorCount: 3)

  // Earth in the middle
  var earthNode: PlanetoidNode!
  var marsNode: PlanetoidNode!
  var plutoNode: PlanetoidNode!
  var otherNode: PlanetoidNode!
  
  override func didMoveToView(view: SKView) {
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    
    // Earth in the middle
    earthNode = PlanetoidNode.withPlanetoid(earth)
    earthNode.position = view.center
    addChild(earthNode)
    
    // Add some structures
    let iron = PlanetoidStructure(name: "Iron", type: .Reserve)
    earth.setStructure(iron, atSector: 0)
    
    let gold = PlanetoidStructure(name: "Gold", type: .Reserve)
    earth.setStructure(gold, atSector: 1)
    
    let city = PlanetoidStructure(name: "Alen", type: .Settlement)
    earth.setStructure(city, atSector: 2)
    
    let ironRef = PlanetoidStructure(name: "IronRef", type: .Refinery)
    earth.setStructure(ironRef, atSector: 5)

    let goldRef = PlanetoidStructure(name: "GoldRef", type: .Refinery)
    earth.setStructure(goldRef, atSector: 4)

    let fact = PlanetoidStructure(name: "Shipyard", type: .Production)
    earth.setStructure(fact, atSector: 7)

    earthNode.needsUpdateSectorPositions = true
    
    // Mars orbits Earth
    marsNode = PlanetoidNode.withPlanetoid(mars)
    addChild(marsNode)
    
    // Pluto orbits Mars
    plutoNode = PlanetoidNode.withPlanetoid(pluto)
    addChild(plutoNode)
    
    // Other orbits Mars
    otherNode = PlanetoidNode.withPlanetoid(other)
    addChild(otherNode)
    
    // Rotate planetoids forever
    for planetoidNode in [earthNode, marsNode, plutoNode, otherNode] {
      let rotation = SKAction.rotateByAngle(-(PI*2), duration: 0.1)
      let rotationRepeat = SKAction.repeatActionForever(rotation)
      planetoidNode.runAction(rotationRepeat)
    }
  }
  
  var marsAngle: CGFloat = 0.0
  var marsSpeed: CGFloat = 500
  func updateMars(dt: CFTimeInterval) {
    marsAngle = (marsAngle + marsSpeed * CGFloat(dt)) % 360
    
    let d = (earthNode.radius + marsNode.radius + 120)
    let x = cos(marsAngle * DegreesToRadians) * d
    let y = sin(marsAngle * DegreesToRadians) * d
    
    marsNode.position = CGPointMake(earthNode.position.x + x, earthNode.position.y + y)
  }
  
  var plutoAngle: CGFloat = 0.0
  var plutoSpeed: CGFloat = 600
  func updatePluto(dt: CFTimeInterval) {
    plutoAngle = (plutoAngle - plutoSpeed * CGFloat(dt)) % 360
    
    let d = (marsNode.radius + plutoNode.radius + 20)
    let x = cos(plutoAngle * DegreesToRadians) * d
    let y = sin(plutoAngle * DegreesToRadians) * d
    
    plutoNode.position = CGPointMake(marsNode.position.x + x, marsNode.position.y + y)
  }
  
  var otherAngle: CGFloat = 0.0
  var otherSpeed: CGFloat = 900
  func updateOther(dt: CFTimeInterval) {
    otherAngle = (otherAngle - plutoSpeed * CGFloat(dt)) % 360
    
    let d = (earthNode.radius + otherNode.radius + 20)
    let x = cos(otherAngle * DegreesToRadians) * d
    let y = sin(otherAngle * DegreesToRadians) * d
    
    otherNode.position = CGPointMake(earthNode.position.x + x, earthNode.position.y + y)
  }
  
  // MARK: Updates

  var lastUpdateTime: CFTimeInterval = 0
  override func update(currentTime: NSTimeInterval) {
    let deltaTime = max(1.0/30, currentTime - lastUpdateTime)
    lastUpdateTime = currentTime
    
    for planetoidNode in [earthNode, marsNode, plutoNode] {
      planetoidNode.update(deltaTime)
    }

    updateOther(deltaTime)
    updateMars(deltaTime)
    updatePluto(deltaTime)
  }
}
