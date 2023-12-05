//
//  File.swift
//  
//
//  Created by Yuqi Jin on 2023/10/5.
//

import Foundation
import PythonKit

public class PsdUtils {
	private init(){}
	public static let shared = PsdUtils()

	public func getLayerData(psdFile: String) -> [LayerData] {
		var result: [LayerData] = []
		let psd_tools = Python.import("psd_tools")
		let psdData = psd_tools.PSDImage.open("\(psdFile)")
		var index = 0
		for layer in psdData.descendants() {
            var _name = ""
            var _text = ""

            let bboxTop = CGFloat(Int(layer.top) ?? 0)
            let bboxBottom = CGFloat(Int(layer.bottom) ?? 0)
            let bboxLeft = CGFloat(Int(layer.left) ?? 0)
            let bboxRight = CGFloat(Int(layer.right) ?? 0)
            let rect = CGRect(x: bboxLeft, y: bboxTop, width: bboxRight - bboxLeft, height: bboxBottom - bboxTop)

            if  layer.kind == "type" {

                if  (String(layer.name) != nil) {
                    _name = String(layer.name)!
                } else if (String(layer.engine_dict["Editor"]["Text"]) != nil) {
                    _name = String(layer.engine_dict["Editor"]["Text"])!
                } else {
                    _name = layer.engine_dict["Editor"]["Text"].description.replacingOccurrences(of: "\'", with: "")
                }

                if  (String(layer.text) != nil) {

                    _text = String(layer.text)!
                } else if (String(layer.engine_dict["Editor"]["Text"]) != nil) {
                    _text = String(layer.engine_dict["Editor"]["Text"])!
                } else {
                    _text = layer.engine_dict["Editor"]["Text"].description.replacingOccurrences(of: "\'", with: "")
                }


                let layerData = LayerData(index: index, type: LayerType(rawValue: String(layer.kind)!)!, name: _name, text: _text, bound: rect)
                result.append(layerData)
                index += 1
                continue
            }

            else { // if layer.kind == "smartobject"
                if  (String(layer.name) != nil) {
                    _name = String(layer.name)!
                }
                else {
                    let matchedStrList = layer.description.regex(pattern: "(\\\').+(\\\')")
                    if matchedStrList.count > 0 {
                        _name = matchedStrList[0].replacingOccurrences(of: "\\'", with: "'")
                    }
                }
                let layerData = LayerData(index: index, type: LayerType(rawValue: String(layer.kind)!)!, name: _name, text: nil, bound: rect)
                result.append(layerData)
                index += 1
                continue
            }
		}
		return result
	}

	
    func setTextContent(psdIndexContentDict: [String: [Int: String]]) {
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
