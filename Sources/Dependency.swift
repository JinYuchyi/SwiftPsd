//
//  File.swift
//  
//
//  Created by Yuqi Jin on 2023/10/5.
//

import Foundation

class Dependency {
	
	init() {
		do {
			try Dependency().check()
		} catch DependencyError.NoPipInstalled {
			print("Error: Pip not installed.")
		} catch DependencyError.NoPsdToolInstalled {
			print("Error: Psd Tool not installed.")
		} catch {
			print("Error: \(error)")
		}
	}
	
	func check() throws {
		let pipInstalled = checkPip()
		let psdToolInstalled = checkPsdTool()
		if pipInstalled == false {
			throw DependencyError.NoPipInstalled
		}
		if psdToolInstalled == false {
			throw DependencyError.NoPsdToolInstalled
		}
	}

	private func checkPip() -> Bool {
		let result = try! ScriptUtils.runShell(command: "python3 -m pip --version")
		if result.contains("No module named") {
			return false
		}
		return true
	}
	
	private func checkPsdTool() -> Bool {
		let result = try! ScriptUtils.runShell(command: "pip list")
		if result.contains("psd-tools") {
			return true
		}
		return false
	}
	
}

enum DependencyError: Error {
	case NoPipInstalled
	case NoPsdToolInstalled
}
