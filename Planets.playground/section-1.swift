// Playground - noun: a place where people can play

import UIKit

// MARK: Planetoids

/// The types of planetoids available
enum PlanetoidType: Int {
  case Earth = 0
}

/// Default planetoid properties
let PlanetoidDefaulRadius: Int = 16
let PlanetoidDefaultType: PlanetoidType = .Earth

/// Main Planetoid representation
class Planetoid {
  /// The type of this planetoid
  var type: PlanetoidType
  
  /// The radius of the planetoid, defines available building slots
  var radius: Int
  
  /// The building zone of the planetoid, what the structures will be laid on
  var sectors: [PlanetoidSector]
  
  /// Designated initializer for the Planetoid class
  init(type: PlanetoidType = PlanetoidDefaultType, radius: Int = PlanetoidDefaulRadius) {
    self.type = type
    self.radius = radius
    self.sectors = []
  }
}

// MARK: Sectors

/// Available types for sectors on a planet
enum PlanetoidSectorType: Int, Printable {
  /// Empty and can be built on
  case Clear = 0
  /// Has a structure built on it
  case Structure
  /// Needs to be cleared before building
  case Forest
  /// Needs to be cleared before building
  case Rocks
  /// Needs to be filled before building
  case Crevice
  
  /// Returns a random sectory type
  static func random() -> PlanetoidSectorType {
    return PlanetoidSectorType(rawValue: Int(arc4random_uniform(4)))!
  }
  
  /// Printable description
  var description: String {
    switch self {
    case .Clear: return "Clear"
    case .Structure: return "Structure"
    case .Forest: return "Forest"
    case .Rocks: return "Rocks"
    case .Crevice: return "Crevice"
    }
  }
}

/// Represents a single slot on the surface of a planet
class PlanetoidSector {
  /// The type of the sector
  var type: PlanetoidSectorType
  /// The structure on this sector, if any
  var structure: PlanetoidStructure?
  
  /// Designated initializer
  init(type: PlanetoidSectorType, structure: PlanetoidStructure?) {
    self.type = type
    self.structure = structure
  }
}

// MARK: Structures

/// The types available for structures
enum PlanetoidStructureType: Int {
  /// A raw mineral or goods supply
  case Reserve = 0
  /// A refinery or raw minerals
  case Refinery
  /// A city or place with population
  case Settlement
  /// A structure producing units, ships or other things
  case Production
}

/// Represents a single player-built structure on a planetoid
class PlanetoidStructure: Printable {
  /// The displayed name
  var name: String
  /// The structure type
  var type: PlanetoidStructureType
  /// The current upgrade level
  var grade: Int
  
  /// Designated initializer
  init(name: String, type: PlanetoidStructureType) {
    self.name  = name
    self.type  = type
    self.grade = 1
  }
  
  var description: String {
    return "\(type) Structure: Grade \(grade) \(name)"
  }
}


// MARK: Testing
