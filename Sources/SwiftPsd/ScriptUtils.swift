//
//  File.swift
//  
//
//  Created by Yuqi Jin on 2023/10/5.
//

import Foundation
 

class ScriptUtils {
 
	static func runShell(command: String) throws -> String {
		let task = Process()
		let pipe = Pipe()

		task.standardOutput = pipe
		task.standardError = pipe
		task.arguments = ["-c", command]
		task.executableURL = URL(fileURLWithPath: "/bin/zsh")  
		
		do {
			try task.run()
			task.waitUntilExit()
		}
		catch{
			print("Running shell command failed. \(error)")
			throw error
		}
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8) ?? ""
		return output
	}

}
