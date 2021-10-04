//
//  NSMutableAttributedString+Extensions.swift
//  AirVetMacy
//
//  Created by John Macy on 10/3/21.
//

// https://stackoverflow.com/questions/28496093/making-text-bold-using-attributed-string-in-swift

import Foundation
import UIKit

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func colorHighlight(_ value:String, foregroundColor: UIColor, backgroundColor: UIColor) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  boldFont,
            .foregroundColor : foregroundColor,
            .backgroundColor : backgroundColor
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
