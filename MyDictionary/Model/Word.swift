import Foundation

class Word {
    let word: String
    
    // var definitions = [String]()
    // var synonyms = [String]()
    var phoneticsText = [String]()
    var phoneticsAudio = [String]()
    
    init?(wordInfo: WordInfoElement) {
        word = wordInfo.word
        
        for phonetic in wordInfo.phonetics {
            phoneticsText.append(phonetic.text)
            phoneticsAudio.append(phonetic.audio)
        }
        
    }
    
    func printData() {
        print(word)
       // print(synonyms)
        print(phoneticsText)
        print(phoneticsAudio)
    }
}
