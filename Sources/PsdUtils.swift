//
//  File.swift
//  
//
//  Created by Yuqi Jin on 2023/10/5.
//

import Foundation
import PythonKit

class PsdUtils {
	private init(){}
	static let shared = PsdUtils()

	func getLayerData(psdFile: String) -> [LayerData] {
		var result: [LayerData] = []
		let psd_tools = Python.import("psd_tools")
		let psdData = psd_tools.PSDImage.open("\(psdFile)")
		var index = 0
		for layer in psdData.descendants() {
			let layerData = LayerData(index: index, type: LayerType(rawValue: String(layer.kind)!)!, name: String(layer.name)! , text: layer.kind == "type" ? String(layer.text)! : nil)
			result.append(layerData)
			index += 1
		}
		return result
	}
	
	func setTextContent(indexContenDict: [Int: String], psd: String) {
		let layers = getLayerData(psdFile: psd)
		let maxLayerIndex = layers.map({$0.index}).max() ?? 0

		for index in indexContenDict.keys {
			if index > maxLayerIndex {
				print("Error: The index is larger than the layer count.")
				return
			}
			if let ly = layers.first(where: {$0.index == index}) {
				if ly.type != .type {
					print("Error: Cannot set text for layer \(index), it's not a text layer.")
					return
				}
			}
		}
	}
}
