//
//  File.swift
//  
//
//  Created by Yuqi Jin on 2023/10/5.
//

import Foundation

public struct LayerData: Codable {
	public let index: Int
	let type: LayerType
	let name: String
	public let text: String?
    public let bound: CGRect
	
	func findOverlapIndex(from targetLayers: [LayerData], overlapRate: CGFloat) -> [Int] {
		let indexList = self.bound.findOverlapIndex(from: targetLayers.map({$0.bound}), overlapRate: overlapRate)
		return indexList
	}
}

enum LayerType: String, CaseIterable, Codable {
	case type
	case smartobject
	case shape
	case pixel
	case group
	case artboard
	case solidcolorfill
	case brightnesscontrast
    case invert
}
