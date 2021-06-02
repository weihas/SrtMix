//
//  Mix.swift
//  SrtMixOld
//
//  Created by WeIHa'S on 2021/5/30.
//

import Foundation
import SwiftUI

class Mix: ObservableObject {
    @Published var fileName1 = ""
    @Published var fileName2 = ""
    @Published var progress: Double = 0.0
    
    var Chinese: Data = Data()
    var English: Data = Data()
    
    var C_E_Srt = ""
    
    
    
    func Mix() {
        let chaString = String(data: Chinese, encoding: String.Encoding.utf8)
        let engString = String(data: English, encoding: String.Encoding.utf8)
        
        self.C_E_Srt = match(strC: chaString ?? "", strE: engString ?? "")
        showSavePanel()
        
    }
    
    

    
    
    func match(strC: String,strE: String) -> String {
        var result: String = ""
        
        let CStr = strC.split(separator: "\n")
        let EStr = strE.split(separator: "\n")
        var flag:Bool = true
        
        var point = 0
        
        for i in 0..<EStr.count {
            progress = Double(i)/Double(EStr.count)
            if  i < EStr.count-1 && point < CStr.count-1 && flag && EStr[i+1] == CStr[point+1] {
                result += "\n"
            }
            
            result += EStr[i]+"\n"
            
            if EStr[i] == CStr[point] {
                flag = false
            }
            if flag {
                continue
            }
            if EStr[i] == CStr[point] {
                point+=1
            }else{
                result += CStr[point]+"\n"
                point+=1
                flag = true
            }
            
            if point==CStr.count {
                break
            }
            
        }
        return result
    }
    
    func showChoosePanel(isTheFirstFile: Bool) {
        progress = 0
        let choosePanel = NSOpenPanel()
        choosePanel.title = "Choose File"
        if isTheFirstFile {
            choosePanel.message = "Choose a Chinese file"
        }else{
            choosePanel.message = "Choose an English file"
        }
        choosePanel.showsResizeIndicator = true
        choosePanel.showsHiddenFiles = false
        choosePanel.allowsMultipleSelection = false
        choosePanel.canChooseDirectories = false
        choosePanel.allowedFileTypes = ["txt","srt"]
        
        if (choosePanel.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = choosePanel.url // Pathname of the file
            
            if (result != nil) {
                if isTheFirstFile {
                    fileName1 = result!.path
                    readfile(url: result!,isTheFirstFile: true)
                }else{
                    fileName2 = result!.path
                    readfile(url: result!,isTheFirstFile: false)
                }
            }
            
        } else {
            //Cancel
            return
        }
    }
    
    func showSavePanel() {
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["srt"]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save your text"
        savePanel.message = "Choose a folder and a name to store your text."
        savePanel.nameFieldLabel = "File name:"
        
        
        if (savePanel.runModal() ==  NSApplication.ModalResponse.OK) {
            if let result = savePanel.url{
                writefile(url: result)
            }
        } else {
            return
        }
    }
    
    func readfile(url: URL,isTheFirstFile: Bool) {
        let readHandler = try! FileHandle(forReadingFrom: url)
        let data = readHandler.readDataToEndOfFile()
        if isTheFirstFile {
            Chinese = data
        }else{
            English = data
        }
        //        let readString = String(data: data, encoding: String.Encoding.utf8)
        //        print("文件内容: \(readString ?? "")")
    }
    
    func writefile(url: URL) {
        let manager = FileManager.default
        
        let file = url
        print("文件: \(file)")
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            let data = Data(base64Encoded: C_E_Srt)
            let createSuccess = manager.createFile(atPath: file.path,contents:data,attributes:nil)
            print("文件创建结果: \(createSuccess)")
        }
        
        let appendedData = self.C_E_Srt.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let writeHandler = try? FileHandle(forWritingTo:file)
        writeHandler!.seekToEndOfFile()
        writeHandler!.write(appendedData!)
    }
    
}

let previewmodel = Mix()

