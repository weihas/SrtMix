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
        let engString = String(data: English, encoding: String.Encoding.utf8)
        let chaString = String(data: Chinese, encoding: String.Encoding.utf8)

        
        self.C_E_Srt = deal(en: engString ?? "", ch: chaString ?? "")
        showSavePanel()
        
    }
    
    

    func deal(en: String, ch: String) -> String{
        var result = ""
        
        let engs = en.split(separator: "\n")
        let chas = ch.split(separator: "\n")
        
        var point = 0
        
        
        for index in 0..<engs.count{
            let Sen = String(engs[index])
            
            switch kind(of: Sen) {
            case 0:
                result += Sen+"\n"
                point += 1
                break
            case 1:
                result += Sen+"\n"
                point += 1
                break
            case 2:
                result += Sen+"\n"
                if index+1 < engs.count && kind(of: String(engs[index+1])) != 2 {
                    if point<chas.count {
                        while kind(of: String(chas[point])) != 0 && kind(of: String(chas[point])) != 1 {
                            result += chas[point]+"\n"
                            point+=1
                        }
                        result += "\n"
                    }
                }else if index+1 == engs.count {
                    if point<chas.count {
                        result += chas[point]
                    }
                }
                break
            default:
                break
            }
            
            
        }
        
        print(result)
        return result
    }



    func kind(of str: String)-> Int{
        let patterns: [String] = ["^[0-9]*$", "^[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3} --> [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}+$", "^[^\u{4e00}-\u{9fa5}]+$"]
        
        for (index,pattern) in patterns.enumerated() {
            let pre = NSPredicate(format: "SELF MATCHES %@", pattern)
            if pre.evaluate(with: str) {
                return index
            }
        }
        return -1
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

