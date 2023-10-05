//
//  File.swift
//  
//
//  Created by Yuqi Jin on 2023/10/5.
//

import Foundation

private class BundleFinder {}
extension Foundation.Bundle {
	/// Returns the resource bundle associated with the current Swift module.
	static let resource: Bundle = {
		let bundleName = "SwiftPsd_SwiftPsdTests"

		let overrides: [URL]
		#if DEBUG
		if let override = ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_PATH"]
					   ?? ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_URL"] {
			overrides = [URL(fileURLWithPath: override)]
		} else {
			overrides = []
		}
		#else
		overrides = []
		#endif

		let candidates = overrides + [
			// Bundle should be present here when the package is linked into an App.
			Bundle.main.resourceURL,

			// Bundle should be present here when the package is linked into a framework.
			Bundle(for: BundleFinder.self).resourceURL,

			// For command-line tools.
			Bundle.main.bundleURL,
		]

		for candidate in candidates {
			let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
			if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
				return bundle
			}
		}
		fatalError("unable to find bundle named PhotoshopReader_PhotoshopReaderTests")
	}()
}
