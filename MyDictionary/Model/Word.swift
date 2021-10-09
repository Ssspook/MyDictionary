import Foundation

class Word {
    private let name: String
    private let partOfSpeach: String
    private var translations = [Tr]()
    private var gender: String
    
    init?(wordInfo: WordInfo) {
        name = wordInfo.def[0].text
        gender = wordInfo.def[0].tr[0].gen ?? ""
        partOfSpeach = wordInfo.def[0].pos ?? ""
       
        for translation in wordInfo.def[0].tr {
            translations.append(translation)
        }
        
    }
    
    public var Name: String { get { name } }
    public var PartOfSpeach: String? { get { partOfSpeach } }
    public var Translations: [Tr] { get { Array<Tr>(translations) } }
    public var Gender: String? { get { gender } }
    
    public func getTranslations(completionHandler: ([Tr]) -> ()) {
      completionHandler(Translations)
    }
    
    
}
