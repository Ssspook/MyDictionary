//
//  ViewController.swift
//  MyDictionary
//
//  Created by Meritocrat on 10/2/21.
//

import UIKit

class DictionaryController: UIViewController {

    @IBOutlet weak var translateTextField: UITextField!
    
    @IBOutlet weak var partOfSpeachLabel: UILabel!
    
    @IBOutlet weak var mainTranslationLabel: UILabel!
    
    @IBOutlet weak var lookUpButton: UIButton!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var languageToTranslateFrom: UIButton!
    
    @IBOutlet weak var languageToTranslateTo: UIButton!

    private let networkManager = NetworManager()
    
    private var languages = Languages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateTextField.delegate = self
        textView.delegate = self
        
        configureButtons()
        configureTapGesture()
        
        networkManager.getLanguagesDict { [weak self] gotLanguagesDict in
            self?.languages.addLanguages(newLanguages: gotLanguagesDict)
        }
    }

    private func configureButtons() {
        textView.font = UIFont.init(name: "Rockwell", size:  CGFloat(18.0))
        translateTextField.font = UIFont.init(name: "Rockwell", size:  CGFloat(18.0))
        
        mainTranslationLabel.font = UIFont.init(name: "Rockwell", size:  CGFloat(20.0))
        genderLabel.font = UIFont.init(name: "Rockwell", size:  CGFloat(20.0))
        partOfSpeachLabel.font = UIFont.init(name: "Rockwell", size:  CGFloat(20.0))
        lookUpButton!.layer.cornerRadius = (lookUpButton?.frame.height)! / 2
        
        languageToTranslateFrom.sizeToFit()
        languageToTranslateFrom.layer.cornerRadius = 7
        languageToTranslateTo.sizeToFit()
        languageToTranslateTo.layer.cornerRadius = 7

        languageToTranslateFrom.setTitle("English", for: .normal)
        languageToTranslateTo.setTitle("Russian", for: .normal)
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DictionaryController.handleTap))
        view.addGestureRecognizer(tapGesture)
        textView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap() {
        view.endEditing(true)
    }
    
    private func getValueToTranslate() -> String? {
        return translateTextField.text ?? nil
    }
    
    private func updateView() {
        guard let valueToTranslate = getValueToTranslate() else { return }
        
        let firstLangCode: String
        let secondLangCode: String
        
        if let languageToTranslateFrom = languageToTranslateFrom.currentTitle,
           let languageToTranslateTo = languageToTranslateTo.currentTitle {
            
            firstLangCode = languages.getLanguagesDict()[languageToTranslateFrom]!
            secondLangCode = languages.getLanguagesDict()[languageToTranslateTo]!
        } else {
            return
        }

        networkManager.getWordInfo(word: valueToTranslate, languagePair: (firstLangCode, secondLangCode)) { word in
            DispatchQueue.main.async {
                self.textView.text = nil
                word.getTranslations { translations in
                    var translationsCount = 1
                
                    for translation in translations {
                        if let gen = translation.gen {
                            self.textView.text += "\(translationsCount)) \(translation.text), \(translation.pos ?? ""), \(gen) \n"
                        } else {
                            self.textView.text += "\(translationsCount)) \(translation.text), \(translation.pos ?? "") \n"
                        }
                
                        self.textView.text += "\(translation.ex?[0].text ?? "") \n \n"
                        translationsCount += 1
                    }
               
                }
            self.mainTranslationLabel.text = word.Translations[0].text
            self.partOfSpeachLabel.text = word.PartOfSpeach
            self.genderLabel.text = word.Gender
            }
        }
    }
    
    @IBAction func goToLanguagePickFromCurrentLang(sender: UIButton) {
        let langSelectionVC = storyboard?.instantiateViewController(withIdentifier: "LanguageController") as! LanguageController
        langSelectionVC.addButton(buttonClicked: sender)
        langSelectionVC.addLanguages(languages_: languages)
        
        langSelectionVC.languageDelegate = self
        present(langSelectionVC, animated: true, completion: nil)
    }
    
    @IBAction func lookUpButtonTouched(_ sender: Any) {
        updateView()
    }
    
}

extension DictionaryController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateView()
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
}

extension DictionaryController: LanguageDelegate {
    func didChooseLanguage(language: String, _ sender: UIButton?) {
        sender?.setTitle("\(language)", for: .normal)
    }
}
