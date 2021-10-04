import Foundation

class NetworManager {
    
    func getWordInfo(word: String, completionHandler: @escaping (Word) -> ()) {
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            if let word = self.JSONparser(withData: data) {
                completionHandler(word)
            }
        }.resume()
    }
    
    private func JSONparser(withData data: Data) -> Word? {
        let decoder = JSONDecoder()
        do {
            let wordInfo = try decoder.decode(WordInfoElement.self, from: data)
            // guard let word = Word(wordInfo: wordInfo) else { return nil }
            
            // return word
        } catch let error as NSError {
            print(error)
        }
        
        return nil
    }
}
