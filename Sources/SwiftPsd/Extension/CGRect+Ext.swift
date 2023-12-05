//
//  File.swift
//  
//
//  Created by Yuqi Jin on 12/5/23.
//

import Foundation

extension CGRect {
	func area() -> Double {
		return self.width * self.height
	}
	
	func findOverlapIndex(from rects: [CGRect], overlapRate: CGFloat) -> [Int] {
		var result: [Int] = []
		for index in 0..<rects.count {
			let interRect = self.intersection(rects[index])
			if CGFloat(interRect.area()) / CGFloat(self.area()) > overlapRate || CGFloat(interRect.area()) / CGFloat(rects[index].area()) > overlapRate {
				result.append(index)
			}
		}
		return result
	}
}
