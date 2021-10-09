import Foundation

class NetworManager {
    private let key = "dict.1.1.20211006T155015Z.cb32fdc7c215e8e7.5908017f7e12552493958db228b3ee082cdfc2fd"
    
    func getWordInfo(word: String, completionHandler: @escaping (Word) -> ()) {
        guard let url = URL(string: "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=\(key)&lang=en-ru&text=\(word)&ui=ru") else { return }
        
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
}
