import Foundation

class PropertyViewModel: ObservableObject {
    @Published var facilities: [Facility] = []
    private var exclusions: [[Exclusion]] = []
    private var selectedOptions: [Facility: Option] = [:]
    
    func fetchData() {
        guard let url = URL(string: "https://my-json-server.typicode.com/iranjith4/ad-assignment/db") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async {
                    self?.facilities = response.facilities
                    self?.exclusions = response.exclusions
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func selectOption(_ option: Option, for facility: Facility) {
        selectedOptions[facility] = option
    }
    
    func isOptionSelected(_ option: Option, for facility: Facility) -> Bool {
        return selectedOptions[facility] == option
    }
    
    func isOptionExcluded(_ option: Option, for facility: Facility) -> Bool {
        let selectedOption = selectedOptions[facility]
        let facilityIndex = facilities.firstIndex(of: facility) ?? 0
        let exclusionSet = exclusions.filter { $0.contains(where: { $0.facilityId == facility.facilityId }) }
        
        for exclusion in exclusionSet {
            let optionIds = exclusion.map { $0.optionId }
            
            if optionIds.contains(option.optionId) && selectedOption != nil && !optionIds.contains(selectedOption!.optionId) {
                return true
            }
        }
        
        if selectedOption != nil && selectedOption!.optionId == option.optionId {
            for exclusion in exclusions {
                if exclusion.contains(where: { $0.optionId == option.optionId }) {
                    let excludedFacilities = exclusion.compactMap { exclusionItem -> Facility? in
                        let facilityIndex = facilities.firstIndex(where: { $0.facilityId == exclusionItem.facilityId })
                        return facilityIndex != nil ? facilities[facilityIndex!] : nil
                    }
                    
                    for excludedFacility in excludedFacilities {
                        if excludedFacility != facility && selectedOptions[excludedFacility] != nil {
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
}

struct Facility: Codable, Identifiable, Equatable {
    let facilityId: String
    let name: String
    let options: [Option]
    
    enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case name, options
    }
}

struct Option: Codable, Identifiable, Equatable {
    let name: String
    let icon: String
    let optionId: String
    
    enum CodingKeys: String, CodingKey {
        case name, icon
        case optionId = "id"
    }
}

struct Exclusion: Codable, Equatable {
    let facilityId: String
    let optionId: String
    
    enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case optionId = "options_id"
    }
}

struct Response: Codable {
    let facilities: [Facility]
    let exclusions: [[Exclusion]]
}
