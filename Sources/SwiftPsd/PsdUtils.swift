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

	
    func setTextContent(psdIndexContentDict: [String: [Int: String]]) {
//        let pathList = psdIndexContentDict.keys
//        let startEditedTimeList = pathList.map({FileUtils.getDirectoryEditedTime(path: $0)})

        var dictList: [String] = []
        for path in psdIndexContentDict.keys {
            if let layerStrDict = psdIndexContentDict[path] {
                let dictStr = "{" + layerStrDict.map({"\"\($0.key)\": \"\($0.value)\""}).joined(separator: ", ") + "}"
                let pathDictStr = "\"\(path)\": \(dictStr)"
                dictList.append(pathDictStr)
            }

        }
        let finalStr = "{" + dictList.joined(separator: ", ") + "}"

        let script = """
app.displayDialogs = DialogModes.NO

var _data = \(finalStr)

var fileSet = []
for(var key in _data) fileSet.push( key );

for (i = 0; i < fileSet.length; i++) {
    var filePath = fileSet[i]
    var doc = app.open(new File(filePath));
    var layerObj = _data[filePath]

    for (var key in layerObj) {
      if (layerObj.hasOwnProperty(key)) {
          if (doc.layers[key].kind == LayerKind.TEXT) {
              doc.layers[key].textItem.contents = layerObj[key]
          }
      }
    }
    doc.close(SaveOptions.SAVECHANGES)
}
"""
        if #available(macOS 13.0, *) {
            let url = FileManager.default.temporaryDirectory.appending(component: "SetTextLayerString.js")
            
            do {
                try script.write(to: url, atomically: false, encoding: String.Encoding.utf8)
                _ = try? ScriptUtils.runShell(command: "open -b \"com.adobe.Photoshop\" \"\(url.path)\"")

            } catch {
                print("Error: \(error)")
            }
        } else {
            // Fallback on earlier versions
        }


	}
}
