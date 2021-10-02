//
//  UIStoryboard+Extensions.swift
//  AirVetMacy
//
//  Created by John Macy on 10/1/21.
//

import UIKit

extension UIStoryboard {
    
    class var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: .main)
    }

    func getVC<T: UIViewController>() -> T {
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
