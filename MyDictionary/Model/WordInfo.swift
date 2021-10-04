import Foundation

struct WordInfoElement: Decodable {
    let word: String
    let phonetics: [Phonetic]
    let meanings: [Meaning]
}

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
}

struct Definition: Codable {
    let definition, example: String
    let synonyms: [String]?
}

struct Phonetic: Codable {
    let text: String
    let audio: String
}

typealias WordInfo = [WordInfoElement]
