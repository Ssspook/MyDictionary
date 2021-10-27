import Foundation

class NetworManager {
    private let key = "dict.1.1.20211006T155015Z.cb32fdc7c215e8e7.5908017f7e12552493958db228b3ee082cdfc2fd"
    private let languages = Languages()
    
    func getWordInfo(word: String, languagePair: (String, String), completionHandler: @escaping (Word) -> ()) {

        guard let myWord = word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url =
                URL(string: "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=\(key)&lang=\(languagePair.0)-\(languagePair.1)&text=\(myWord)&ui=\(languagePair.0)")
              else { return }
        print(languagePair)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            if let word = self.JSONparser(withData: data) {
                completionHandler(word)
            }
        }.resume()
    }
    
    func getLanguagesDict(completionHandler: @escaping ([String: String]) -> ()) {
        
        guard let url = URL(string: "https://dictionary.yandex.net/api/v1/dicservice.json/getLangs?key=\(key)") else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
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
        }.resume()
       
    }
    
    private func JSONparser(withData data: Data) -> Word? {
        let decoder = JSONDecoder()
        do {
            let wordInfo = try decoder.decode(WordInfo.self, from: data)
             guard let word = Word(wordInfo: wordInfo) else { return nil }

            return word
        } catch let error as NSError {
            print(error)
        }

        return nil
    }
    
    private func JSONLangParser(withData data: Data) -> LanguageInfo? {
        let decoder = JSONDecoder()
        do {
            let languagesInfo = try decoder.decode(LanguageInfo.self, from: data)
            
            return languagesInfo
        } catch let error as NSError {
            print(error)
        }

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
