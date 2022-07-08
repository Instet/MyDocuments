//
//  FileManagerService.swift
//  MyDocuments
//
//  Created by Руслан Магомедов on 05.07.2022.
//

import Foundation
import UIKit

class FileManagerService {

    private let fileManager = FileManager.default

    /// Обращаемся к стандартной директории, получыем url  папки
     var documentsURL: URL? {
        do {
            return try fileManager.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
        } catch {
            return nil
        }
    }

    /// Поиск содержимого в стандартной директории (используем для обновления данных таблицы и т д)
    func getFiles() -> [URL]? {
        guard let documentsURL = documentsURL else { return nil }

        do {
            return try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

        } catch {
            return nil
        }
    }


    func createFile(_ image: UIImage, callback: @escaping () -> Void ) {
        guard let documentsURL = documentsURL else { return }
        let file = UUID().uuidString
        let imageURL = documentsURL.appendingPathComponent("\(file).jpg")
        let data = image.jpegData(compressionQuality: 1)
        fileManager.createFile(atPath: imageURL.path, contents: data)
        callback()
    }

    func remove(_ file: String, callback: @escaping () -> Void) {
        do {
            try fileManager.removeItem(atPath: file)
            callback()
        } catch {
            print(error.localizedDescription)
        }
    }


}

