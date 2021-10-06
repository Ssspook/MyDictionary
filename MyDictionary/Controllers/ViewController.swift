//
//  ViewController.swift
//  MyDictionary
//
//  Created by Meritocrat on 10/2/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var translateTextField: UITextField!
    
    @IBOutlet weak var partOfSpeachLabel: UILabel!
    
    @IBOutlet weak var mainTranslationLabel: UILabel!
    
    private let networkManager = NetworManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translateTextField.delegate = self
        translateTextField.font = UIFont.init(name: "Rockwell", size:  CGFloat(18.0))
        configureTapGesture()
    }

    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap() {
        view.endEditing(true)
    }
    
    private func getValueToTranslate() -> String? {
        return translateTextField.text ?? nil
    }
    
    private func updateView() {
        guard let valueToTranslate = getValueToTranslate() else { return }
        
        networkManager.getWordInfo(word: valueToTranslate) { word in
            DispatchQueue.main.async {
                self.mainTranslationLabel.text = word.Translations[0]
                self.partOfSpeachLabel.text = word.PartOfSpeach
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateView()
        return true
    }
}
