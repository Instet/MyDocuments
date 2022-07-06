//
//  Extensions.swift
//  MyDocuments
//
//  Created by Руслан Магомедов on 06.07.2022.
//

import Foundation
import UIKit

extension Date {
    
    static func formatedDate(_ dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/yyyy"

        let date: Date? = dateFormatterGet.date(from: dateString)
        print(dateFormatterPrint.string(from: date ?? Date()))
        return dateFormatterPrint.string(from: date ?? Date())
    }
}

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
}
