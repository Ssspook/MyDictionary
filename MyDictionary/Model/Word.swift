import Foundation

class Word {
    private let name: String
    private let partOfSpeach: String?
    private var translations = [String]()
    
    init?(wordInfo: WordInfo) {
        name = wordInfo.def[0].text
        if let pos = wordInfo.def[0].pos { partOfSpeach = pos }
        else { partOfSpeach = "" }
        
        for translationBlock in wordInfo.def[0].tr {
            translations.append(translationBlock.text)
        }
    }
    public var Name: String { get { name } }
    public var PartOfSpeach: String? { get { partOfSpeach } }
    public var Translations: [String] { get { Array<String>(translations) } }
    
}
