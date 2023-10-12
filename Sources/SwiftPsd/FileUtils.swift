//
//  File.swift
//  
//
//  Created by Yuqi Jin on 10/11/23.
//

import Foundation

class FileUtils {
    static func getDirectoryEditedTime(path: String) -> Date? {
        do {
               let attributes:[FileAttributeKey:Any] = try FileManager.default.attributesOfItem(atPath: path)
               let modificationDate = attributes[FileAttributeKey.modificationDate] as? Date
//               let creationDate = attributes[FileAttributeKey.creationDate] as? Date
               return modificationDate
           }catch{
               print("Error getting attributes of file: \(path). Check if file exists and that the system can access its attributes.")
               return nil
           }
    }

    static func filesEdited(fileList: [String], previousEditedTimeList: [Date]) -> Bool {
        if fileList.count != previousEditedTimeList.count {
            return false
        }
        for index in 0..<fileList.count {
            guard let currentEditTime = FileUtils.getDirectoryEditedTime(path: fileList[index]) else {return false}
            if currentEditTime <= previousEditedTimeList[index] {
                return false
            }
        }
        return true
    }
}
