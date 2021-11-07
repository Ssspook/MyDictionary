import Foundation

class Word {
    private var name = ""
    private var partOfSpeach = ""
    private var translations = [Tr]()
    private var gender = ""
    
    init?(wordInfo: WordInfo) {
        guard wordInfo.def.count != 0 else { return nil }
        name = wordInfo.def[0].text
        gender = wordInfo.def[0].tr[0].gen ?? ""
        partOfSpeach = wordInfo.def[0].pos ?? ""
       
        for translation in wordInfo.def[0].tr {
            translations.append(translation)
        }
        
    }
    
    public var Name: String { name }
    public var PartOfSpeach: String? { partOfSpeach }
    public var Translations: [Tr] { Array<Tr>(translations) }
    public var Gender: String? { gender }
    
    public func getTranslations(completionHandler: ([Tr]) -> ()) {
      completionHandler(Translations)
    }
}
