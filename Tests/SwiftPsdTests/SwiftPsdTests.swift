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
	
	func testTextLayerProperty() throws {
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
        let fileList = [
            "/Users/jin/Downloads/SO_Source/SO_Backups-4Z~L_F.psd",
            "/Users/jin/Downloads/SO_Source/SO_BatteryLife-3Z~L_F.psd",
            "/Users/jin/Downloads/SO_Source/SO_FamilySharing-4Z~D_F.psd",
            "/Users/jin/Downloads/SO_Source/SO_MarkMessageUnread-3Z~L_F.psd",
            "/Users/jin/Downloads/SO_Source/SO_MedicalID-1W~L_F.psd",
            "/Users/jin/Downloads/SO_Source/SO_SharedPhotoLibrary-3Z~L_F.psd",
            "/Users/jin/Downloads/SO_Source/SO_WeatherApp-3Z~D_F.psd"
        ]
        for _file in fileList {
            let result = PsdUtils.shared.getLayerData(psdFile: _file)
            print(result)
        }
	}

    func testDependencies() throws {
        let dependency = Dependency()
        let errorList = dependency.check()
        XCTAssertEqual(errorList.count, 0)
    }
	
	func testFindPhotoshop() throws {
		let list = Dependency().findPhotoshops()
		XCTAssertTrue(list.count != 0)
	}

    func testSetLayerString() throws {
        PsdUtils.shared.setTextContent(psdIndexContentDict: [
            "/Users/jin/Documents/TestData/Photoshop/test1.psd": [0: "newStr1", 2: "newStr1"],
            "/Users/jin/Documents/TestData/Photoshop/test2.psd": [0: "newStr2", 1: "newStr2", 2: "newStr2"]
        ])
    }
	

}


