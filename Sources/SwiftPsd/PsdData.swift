//
//  File.swift
//  
//
//  Created by Yuqi Jin on 2023/10/5.
//

import Foundation

public struct LayerData {
	public let index: Int
	let type: LayerType
	let name: String
	public let text: String?
}

enum LayerType: String, CaseIterable {
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