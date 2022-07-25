//
//  String+Extensions.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 28.06.2022.
//

import Swift
import Foundation

public extension String {

    var localized: String {
           if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
               UserDefaults.standard.set("tr", forKey: "i18n_language")
               UserDefaults.standard.synchronize()
           }

           let lang = UserDefaults.standard.string(forKey: "i18n_language")

           let path = Bundle.main.path(forResource: lang, ofType: "lproj")
           let bundle = Bundle(path: path!)

           return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
       }
    
}
