//
//  File.swift
//  
//
//  Created by Yuqi Jin on 2023/10/5.
//

import Foundation
import PythonKit

class Dependency {
    var packages: [String] = []
    var python3: String = "python3"
    var pip3: String = "pip3"

    init() {
        python3 = getPython3() ?? "python3"
        pip3 = getPip3() ?? "pip3"
        if !checkPsdTool() {
            print("Installing psd tools...")
            installPsdTool()
        }
    }

    private func getPython3() -> String? {
        if let pip = getPip3() {
            return pip.replacingOccurrences(of: "pip3", with: "python3")
        }
        return nil
    }

    private func getPip3() -> String? {
        if let pip3 = try? ScriptUtils.runShell(command: "which -a pip3")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines) {
            for pip in pip3 {
                if pip.contains("psd-tool") {
                    return pip
                }
            }
            return pip3[0]
        }
        return nil
    }

    private func installPsdTool() {
        let cmd = "\(pip3) install psd-tools==1.9.31"
        let out = try? ScriptUtils.runShell(command: cmd)
    }

    private func loadPythonEnv() {
        // TODO: This is a temporary workaround for the following issue, which only affects archived(`release`) app.
        // PythonKit/PythonLibrary.swift:59: Fatal error: 'try!' expression unexpectedly raised an error: Python library not found. Set the PYTHON_LIBRARY environment variable with the path to a Python library.
        // private static var librarySearchPaths = ["", "/opt/homebrew/Frameworks/", "/usr/local/Frameworks/"]
        let pythonExecutables = try? ScriptUtils.runShell(command: "which -a python3")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)

        // Install psd_tools

        do {
            try PythonLibrary.loadLibrary()
        } catch {
            print("Load library error: \(error)")
            PythonLibrary.useLibrary(at: pythonExecutables?.first)
        }

        // Some modules may be installed using other versions of Python
        // Fatal error: 'try!' expression unexpectedly raised an error: Python exception: No module named 'psd_tools'
        packages = (pythonExecutables ?? []).reduce(into: [], { partialResult, pythonExecutable in
            guard let lines = try? ScriptUtils.runShell(command: "\(pythonExecutable) -m site").components(separatedBy: .newlines) else { return }
            let paths: [String] = lines.compactMap { line in
                let path = line.trimmingCharacters(in: [" ", "'", ","])
                guard path.hasSuffix("/site-packages") else { return nil }
                return path
            }
            partialResult.append(contentsOf: paths)
        })
    }

	func check() -> [String]  {
		let pipInstalled = checkPip()
        let psdToolInstalled = checkPsdTool()
        var errorList: [String] = []
        let psList = findPhotoshops()
		if pipInstalled == false {
			print("Error: Cannot find pip installed.")
            errorList.append("Error: Cannot find pip installed.")
		}
		if psdToolInstalled == false {
            print("Error: Cannot find psd tool python package installed.")
            errorList.append("Error: Cannot find psd tool python package installed.")
		}

        if psList.count == 0 {
            print("Warning: No Photoshop installed, some functions cannot be used.")
            errorList.append("Warning: No Photoshop installed, some functions cannot be used.")
         }
        return errorList
	}

	private func checkPip() -> Bool {
		let result = try! ScriptUtils.runShell(command: "\(pip3) --version")
		if result.contains("No module named") {
			return false
		}
		return true
	}

	private func checkPsdTool() -> Bool {
		let result = try! ScriptUtils.runShell(command: "\(pip3) list")
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
