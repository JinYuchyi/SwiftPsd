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
        Python.builtins
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
        guard let folderURL = try? FileManager.default.url(for: .downloadsDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false).appending(component: "SO_Source",
                                                                                    directoryHint: .isDirectory) else {
            fatalError("~/Downloads/SO_Source: No such directory")
        }
        let fileList = [
            "SO_Backups-4Z~L_F.psd",
            "SO_BatteryLife-3Z~L_F.psd",
            "SO_FamilySharing-4Z~D_F.psd",
            "SO_MarkMessageUnread-3Z~L_F.psd",
            "SO_MedicalID-1W~L_F.psd",
            "SO_SharedPhotoLibrary-3Z~L_F.psd",
            "SO_WeatherApp-3Z~D_F.psd"
        ]
        for file in fileList {
            let result = PsdUtils.shared.getLayerData(psdFile: folderURL.appending(component: file).path(percentEncoded: false))
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
	
	func testRectOverlap() throws {
		let rect1 = CGRect(x: 270, y: 120, width: 100, height: 100)
		let rectList = [
		CGRect(x: 100, y: 20, width: 50, height: 50),
		CGRect(x: 200, y: 100, width: 100, height: 100),
		CGRect(x: 300, y: 150, width: 100, height: 100),
		CGRect(x: 100, y: 130, width: 500, height: 500),
		CGRect(x: 250, y: 100, width: 120, height: 120),
		]
		let list = rect1.findOverlapIndex(from: rectList, overlapRate: 0.5)
		print(list)
	}
	

}


