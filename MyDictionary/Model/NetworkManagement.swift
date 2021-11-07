import Foundation
import Alamofire

class NetworManager {
    // MARK: Properties
    private let key = "dict.1.1.20211006T155015Z.cb32fdc7c215e8e7.5908017f7e12552493958db228b3ee082cdfc2fd"
    private let languages = Languages()
    
    // MARK: Get word information
    public func fetchWordInfo(word: String, languagePair: (String, String), completionHandler: @escaping (Word?, Error?) -> ()
        ) {
        
        guard let myWord = word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let requestString = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=\(key)&lang=\(languagePair.0)-\(languagePair.1)&text=\(myWord)&ui=\(languagePair.0)"
       
        AF.request(requestString, method: .get).validate().responseData { response in
            guard let data = response.data else {
                
                if let error = response.error {
                    completionHandler(nil, error as Error)
                }
                return
            }
                       
            if let word = self.JSONparser(withData: data) {
                completionHandler(word, nil)
            } else {
                completionHandler(nil, nil)
            }
        }
    }
    
    // MARK: Get Languages Dictionary
    public func fetchLanguagesDict(completionHandler: @escaping ([String: String]) -> ()) {
        let requestString = "https://dictionary.yandex.net/api/v1/dicservice.json/getLangs?key=\(key)"
        
        AF.request(requestString, method: .get).validate().responseData { response in
            
            guard let data = response.data else { return }
            
            let locale = NSLocale(localeIdentifier: "en_US")
            
            var localLangDict = [String: String]()
            
            if let languageInfo = self.JSONLangParser(withData: data) {
                
                for pair in languageInfo {
                    
                    let langCode = pair.components(separatedBy: "-")[0]
                    let fullLangName = locale.localizedString(forLanguageCode: langCode)
                    
                    if let fullLangName = fullLangName {
                        
                        localLangDict[fullLangName.capitalizingFirstLetter()] = langCode
                    }
                }
                
                completionHandler(localLangDict)
            }
        }
    }
    
    // MARK: Private functions
    private func JSONparser(withData data: Data) -> Word? {
        let decoder = JSONDecoder()
        do {
            let wordInfo = try decoder.decode(WordInfo.self, from: data)
             guard let word = Word(wordInfo: wordInfo) else { return nil }

            return word
        } catch _ as NSError { }

        return nil
    }
    
    private func JSONLangParser(withData data: Data) -> LanguageInfo? {
        let decoder = JSONDecoder()
        do {
            let languagesInfo = try decoder.decode(LanguageInfo.self, from: data)
            
            return languagesInfo
        } catch  _ as NSError { }

        return nil
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    func capitalizeFirstLetter() -> String {
        return self.capitalizingFirstLetter()
    }
}
