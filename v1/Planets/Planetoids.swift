//
//  Planetoids.swift
//  Planets
//
//  Created by Nico Hämäläinen on 16/03/15.
//  Copyright (c) 2015 sizeof.io. All rights reserved.
//

import Foundation

// MARK: Planetoids

/// The types of planetoids available
enum PlanetoidType: Int, Printable {
	case Earth = 0
	
	/// String representation of the type
	var description: String {
		var value: String = ""
		
		switch self {
		case .Earth: value = "Earth"
		default:     value = "Unknown"
		}
		
		return value
	}
}

/// Main Planetoid representation
class Planetoid: Printable {
	/// The displayed name of the planetoid
	var name: String
	/// The type of this planetoid
	var type: PlanetoidType
	/// The building zone of the planetoid, what the structures will be laid on
	var sectors: [PlanetoidSector]
	
	/// Designated initializer for the Planetoid class
	init(name: String, type: PlanetoidType = .Earth, sectorCount: Int = 6) {
		self.name = name
		self.type = type
		
		// Initialize empty sectors
		self.sectors = []
		for i in 0..<sectorCount {
			self.sectors.append(PlanetoidSector(type: .Empty, structure: nil))
		}
	}
	
	// MARK: Structure handling
	
	func setStructure(structure: PlanetoidStructure, atSector sector: Int) {
		assert(sector < sectors.count, "Invalid sector index")
		self.sectors[sector].structure = structure
	}
	
	/// String representation
	var description: String {
		return "\"\(name)\" - \(type) Planetoid - \(sectors.count) Sectors"
	}
}

// MARK: Sectors

/// Available types for sectors on a planet
enum PlanetoidSectorType: Int {
	/// Empty and can be built on
	case Empty = 0
	/// Full and has to be cleared
	case Reserved
}

/// Represents a single slot on the surface of a planet
class PlanetoidSector: Printable {
	
	/// The type of the sector
	var type: PlanetoidSectorType
	/// The structure on this sector, if any
	var structure: PlanetoidStructure? {
		didSet {
			self.type = (structure == nil) ? .Empty : .Reserved
		}
	}
	
	/// Designated initializer
	init(type: PlanetoidSectorType = .Empty, structure: PlanetoidStructure? = nil) {
		self.type = type
		self.structure = structure
	}
	
	/// String representation
	var description: String {
		var value = "\(type) Sector - "
		if let structure = self.structure {
			value += "\(structure)"
		}
		else {
			value += "No Structure"
		}
		return value
	}
}

// MARK: Structures

/// The types available for structures
enum PlanetoidStructureType: Int, Printable {
	/// A raw mineral or goods supply
	case Reserve = 0
	/// A refinery or raw minerals
	case Refinery
	/// A city or place with population
	case Settlement
	/// A structure producing units, ships or other things
	case Production
	
	/// String representation
	var description: String {
		var value = ""
		
		switch self {
		case .Reserve:    value = "Reserve"
		case .Refinery:   value = "Refinery"
		case .Settlement: value = "Settlement"
		case .Production: value = "Production"
		}
		
		return value
	}
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
	
	/// String representation
	var description: String {
		return "\(name) - Grade \(grade) \(type) Structure"
	}
}