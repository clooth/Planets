//
//  Nodes.swift
//  Planets
//
//  Created by Nico Hämäläinen on 16/03/15.
//  Copyright (c) 2015 sizeof.io. All rights reserved.
//

import Foundation
import SpriteKit


class PlanetoidStructureNode: SKShapeNode {
  /// The sturcture this node is rendering
  var structure: PlanetoidStructure! {
    didSet {
      self.updateStyles()
    }
  }
  
  class func withStructure(structure: PlanetoidStructure) -> PlanetoidStructureNode {
    let size = self.nodeSizeForStructureType(structure.type)
    let node = PlanetoidStructureNode(rectOfSize: size)
    node.structure = structure
    node.strokeColor = UIColor.clearColor()
    
    let label = SKLabelNode(text: structure.name)
    label.fontSize = 11.0
    label.fontName = "HelveticaNeue-Bold"
    node.addChild(label)
    
    return node
  }
  
  // MARK: Helpers
  // TODO: Move into separate helper/utility class
  
  class func nodeSizeForStructureType(type: PlanetoidStructureType) -> CGSize {
    return CGSizeMake(30, 30)
    switch type {
    case .Reserve:
      return CGSizeMake(30, 30)
    case .Refinery:
      return CGSizeMake(30, 40)
    case .Production:
      return CGSizeMake(30, 50)
    case .Settlement:
      return CGSizeMake(30, 60)
    }
  }
  
  func updateStyles() {
    /// Update node colors
    switch structure.type {
    case .Reserve:
      self.fillColor = SKColor(netHex: 0x972222)
    case .Refinery:
      self.fillColor = SKColor(netHex: 0xffcb1f)
    case .Production:
      self.fillColor = SKColor(netHex: 0x64a4bc)
    case .Settlement:
      self.fillColor = SKColor(netHex: 0xbde26e)
    }
  }
}



class PlanetoidSectorNode: SKShapeNode {
  /// The sector this node is rendering
  var sector: PlanetoidSector!
  
  /// The sector's rotation angle
  var rotationAngle: CGFloat = 0.0
  
  // MARK: Initializers
  
  class func withPlanetoidSector(sector: PlanetoidSector) -> PlanetoidSectorNode {
    var node = PlanetoidSectorNode(circleOfRadius: 12.0)
    node.sector = sector
    node.strokeColor = SKColor.clearColor()
    node.update(0)
    
    return node
  }
  
  // MARK: Helpers
  var structureNode: PlanetoidStructureNode?
  func updateStructureNode() {
    structureNode?.removeFromParent()
    
    if let structure = sector.structure {
      structureNode = PlanetoidStructureNode.withStructure(structure)
      structureNode?.zRotation = rotationAngle
      addChild(structureNode!)
    }
  }
  
  func updateStyles() {
    // Set appropriate colors for the sector node depending on the sector's availability
    switch sector.type {
    case .Empty:
      self.fillColor = SKColor(netHex: 0x008aff).colorWithAlphaComponent(0.75)
    case .Reserved:
      self.fillColor = SKColor(netHex: 0xf96437).colorWithAlphaComponent(0.50)
    }
  }
  
  // Update method
  
  func update(dt: CFTimeInterval) {
    // Update styles
    self.updateStyles()
    self.updateStructureNode()
  }
  
}


/// The node that represents a single Planetoid object in the game
class PlanetoidNode: SKShapeNode {
  /// The planetoid object this node contains
  var planetoid: Planetoid!
  
  /// The final radius of this planetoid
  var radius: CGFloat = 0.0
  
  // MARK: Initializers
  
  /// Create a new PlanetoidNode with a given Planetoid object
  class func withPlanetoid(planetoid: Planetoid) -> PlanetoidNode {
    var node = PlanetoidNode(circleOfRadius: CGFloat(planetoid.sectors.count * 10))
    node.radius = radiusForSectorSize(planetoid.sectors.count, 60)
    node.lineWidth = 3.0
    node.planetoid = planetoid
    node.createSectorNodes()
    
    return node
  }
  
  // MARK: Helpers
  
  var sectorNodes: [PlanetoidSectorNode] = []
  func createSectorNodes() {
    for (index, sector) in enumerate(planetoid.sectors) {
      var sectorNode = PlanetoidSectorNode.withPlanetoidSector(sector)
      sectorNodes.append(sectorNode)
      addChild(sectorNode)
    }
    needsUpdateSectorPositions = true
  }
  
  var needsUpdateSectorPositions: Bool = false {
    didSet {
      if needsUpdateSectorPositions == true {
        updateSectorPositions()
      }
    }
  }
  
  func updateSectorPositions() {
    if !needsUpdateSectorPositions { return }
    
    let sectorsCount: CGFloat = CGFloat(planetoid.sectors.count)
    let angle = 360 / sectorsCount
    
    for (index, sectorNode) in enumerate(sectorNodes) {
      let radians = (angle * CGFloat(index)) * CGFloat(M_PI) / 180
      var position = CGPointMake((radius * 0.98) * cos(radians), (radius * 0.98) * sin(radians))
      
      if let structure = sectorNode.sector.structure {
        let nodeSize = PlanetoidStructureNode.nodeSizeForStructureType(structure.type)
        position = CGPointMake((radius + (nodeSize.width / 2)) * cos(radians), (radius + (nodeSize.width / 2)) * sin(radians))
      }
      
      sectorNode.position = position
      sectorNode.rotationAngle = radians - (PI / 2)
    }
    
    needsUpdateSectorPositions = false
  }
  
  func updateStyles() {
    // Set proper colors for the sprite depending on the planetoids type
    switch planetoid.type {
    case .Earth:
      self.fillColor = SKColor(netHex: 0x8c6239)
      self.strokeColor = SKColor(netHex: 0xacd373)
    }
  }
  
  func update(dt: CFTimeInterval) {
    self.updateStyles()
    self.updateSectorPositions()
    
    for sectorNode in sectorNodes {
      sectorNode.update(dt)
    }
  }
}
