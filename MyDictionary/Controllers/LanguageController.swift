import Foundation
import UIKit

class LanguageController: UIViewController {
    @IBOutlet var tableView: UITableView!

    private var _buttonClicked: UIButton!
    var languageDelegate: LanguageDelegate!
    private var languages = Languages()
    
    // MARK: View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if languages.getLanguagesList().isEmpty {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: "Languages cannot be loaded", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)

                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Delegation handling
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
