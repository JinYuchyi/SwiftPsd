//
//  File.swift
//  
//
//  Created by Yuqi Jin on 2023/10/5.
//

import Foundation

class Dependency {
	
	init() {
//		do {
//			try Dependency().check()
//		} catch DependencyError.NoPipInstalled {
//			print("Error: Pip not installed.")
//		} catch DependencyError.NoPsdToolInstalled {
//			print("Error: Psd Tool not installed.")
//		} catch {
//			print("Error: \(error)")
//		}
        check()
	}
	
	func check()  {
		let pipInstalled = checkPip()
        let psdToolInstalled = checkPsdTool()
//        let appScriptInstalled = checkAppscript()
		let psList = findPhotoshops()
		if pipInstalled == false {
			print("Error: Cannot find pip installed.")
		}
		if psdToolInstalled == false {
            print("Error: Cannot find psd tool python package installed.")
		}
//        if appScriptInstalled == false {
//            print("Error: Cannot find appScript python package installed.")
//        }
        if psList.count == 0 {
            print("Warning: No Photoshop installed, some functions cannot be used.")
         }
	}

	private func checkPip() -> Bool {
		let result = try! ScriptUtils.runShell(command: "python3 -m pip --version")
		if result.contains("No module named") {
			return false
		}
		return true
	}

//    private func checkAppscript() -> Bool {
//        let result = try! ScriptUtils.runShell(command: "pip list")
//        if result.contains("appscript") {
//            return true
//        }
//        return false
//    }
	
	private func checkPsdTool() -> Bool {
		let result = try! ScriptUtils.runShell(command: "pip list")
		if result.contains("psd-tools") {
			return true
		}
		return false
	}
	
	func findPhotoshops() -> [String] {
		let result = try! ScriptUtils.runShell(command: "mdfind -name 'Photoshop' -onlyin /Applications -onlyin ~/Applications -onlyin /System/Applications")
		let list = result.components(separatedBy: "\n").filter({$0.isEmpty == false && $0.components(separatedBy: "/").last!.contains("Photoshop") && $0.components(separatedBy: "/").last!.contains(".app")})
		return list
	}
	
}
