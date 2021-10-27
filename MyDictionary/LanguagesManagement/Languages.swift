import Foundation

class Languages {
    private var languages = [String: String]()
    
    public func addLanguages(newLanguages: [String: String]) {
        for languagePair in newLanguages {
            languages[languagePair.key] = languagePair.value
        }
    }
    
    public func getLanguagesList() -> [String] {
        return Array(languages.keys).sorted()
    }
    
    public func getLanguagesDict() -> [String: String] {
        return languages
    }
}
