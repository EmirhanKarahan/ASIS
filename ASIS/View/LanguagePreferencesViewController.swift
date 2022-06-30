//
//  LanguagePreferencesViewController.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 27.06.2022.
//

import UIKit

class LanguagePreferencesViewController: UITableViewController {
    var locales = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        locales = getLocales()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "languageCell")
    }

    func configure(){
        title = "Change Language".localized
        view.backgroundColor = .white
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locales.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        cell.textLabel?.text = locales[indexPath.row]
        if locales[indexPath.row] == lang {
            cell.isUserInteractionEnabled = false
            cell.textLabel?.textColor = .gray
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(locales[indexPath.row], forKey: "i18n_language")
        navigationController?.pushViewController(HomepageTabBarController(), animated: true)
    }
    
    func getLocales() -> [String]{
        let langIds = Bundle.main.localizations
        var locales = [String]()
        for langId in langIds {
            let loc = Locale(identifier: langId)
            guard let _ = loc.localizedString(forLanguageCode: langId) else { continue }
            locales.append(langId)
        }
        return locales
    }
    

}
