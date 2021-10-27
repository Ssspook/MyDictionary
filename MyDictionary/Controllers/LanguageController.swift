import Foundation
import UIKit

class LanguageController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    private let networkManager = NetworManager()
    
    private var _buttonClicked: UIButton!
    
    var languageDelegate: LanguageDelegate!
    
    private var languages = Languages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func addButton(buttonClicked: UIButton) {
        _buttonClicked = buttonClicked
    }
    
    public func addLanguages(languages_: Languages) {
        languages.addLanguages(newLanguages: languages_.getLanguagesDict())
    }
}

extension LanguageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenCell = tableView.cellForRow(at: indexPath)!
        languageDelegate.didChooseLanguage(language: chosenCell.textLabel!.text!, _buttonClicked)
        
        dismiss(animated: true)
    } 
}

extension LanguageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return languages.getLanguagesList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "langCell", for: indexPath)
        cell.textLabel?.text = languages.getLanguagesList()[indexPath.row]
        return cell
    }
}
