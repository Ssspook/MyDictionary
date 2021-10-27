import Foundation

// MARK: - WordInfo
struct WordInfo: Codable {
    let def: [Def]
}

// MARK: - Def
struct Def: Codable {
    let text: String
    let ts: String? // ts -- transcription
    let pos: String?
    let tr: [Tr]
}

// MARK: - Tr
struct Tr: Codable {
    let text: String
    let pos: String?
    let gen: String?
    let fr: Int // слоги
    let syn: [Syn]?
    let mean: [Mean]?
    let ex: [Ex]?
    let asp: String?
}

// MARK: - Ex
struct Ex: Codable {
    let text: String
    let tr: [Mean]
}

// MARK: - Mean
struct Mean: Codable {
    let text: String
}

// MARK: - Syn
struct Syn: Codable {
    let text: String
    let pos: String?
    let fr: Int
    let gen: String?
}

