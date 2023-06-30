struct APIResponse: Codable {
    let facilities: [Property]
    let exclusions: [[Exclusion]]
}

struct Property: Codable {
    let facilityId: String
    let name: String
    var options: [Option]
}

struct Option: Codable {
    let optionId: String
    let name: String
    let icon: String
    let exclusions: [String: [String]]
}

struct Exclusion: Codable {
    let facilityId: String
    let optionId: String
}
