//
//  File.swift
//  
//
//  Created by Yuqi Jin on 2023/10/5.
//

 

import XCTest
@testable import SwiftPsd
import PythonKit

final class PythonTests: XCTestCase {
	let testPsd = Bundle.resource.url(forResource: "test", withExtension: "psd")!

	
	func testPsdTool() throws {

		let psd_tools = Python.import("psd_tools")
		let psdData = psd_tools.PSDImage.open("\(testPsd.path)")
		XCTAssertEqual(psdData.name, "Root")
	}
	
	func testOpenTextLayer() throws {
		let psd_tools = Python.import("psd_tools")
		let psdData = psd_tools.PSDImage.open("\(testPsd.path)")
		var index = 0
		for layer in psdData.descendants() {
			if layer.kind == "type" {
				print("\(index) - \(layer.text)")
			}
			index += 1
		}
	}
	
	func testGetDocData() throws {
		let result = PsdUtils.shared.getLayerData(psdFile: testPsd.path)
		print(result)
	}
	
	func testFindPhotoshop() throws {
		let list = Dependency().findPhotoshop()
		XCTAssertTrue(list.count != 0)
	}
	

}


