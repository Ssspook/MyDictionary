//
//  ViewController.swift
//  MyDictionary
//
//  Created by Meritocrat on 10/2/21.
//

import UIKit

class ViewController: UIViewController {

    let networkManager = NetworManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getWordInfo(word: "hello") { word in
            word.printData()
        }
    }


}

