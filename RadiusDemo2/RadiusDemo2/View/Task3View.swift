import SwiftUI

struct Task3View: View {
    @StateObject private var propertyViewModel = PropertyViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Task 3")
                    .font(.headline)
                    .padding()
                
                List(propertyViewModel.facilities) { facility in
                    VStack(alignment: .leading) {
                        Text(facility.name)
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(facility.options) { option in
                                    Button(action: {
                                        propertyViewModel.selectOption(option, for: facility)
                                    }) {
                                        VStack {
                                            Image(systemName: option.icon)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30, height: 30)
                                            Text(option.name)
                                                .font(.caption)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.gray.opacity(propertyViewModel.isOptionSelected(option, for: facility) ? 0.5 : 0))
                                        .cornerRadius(10)
                                    }
                                    .disabled(propertyViewModel.isOptionExcluded(option, for: facility))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .navigationTitle("Task 3")
            }
            .onAppear {
                propertyViewModel.fetchData()
            }
        }
    }
}

struct Task3View_Previews: PreviewProvider {
    static var previews: some View {
        Task3View()
    }
}
