import SwiftUI

struct ContentView: View {
    @State private var query: String = ""
    @State private var result: String = "Enter a car number to see the results."

    var body: some View {
        VStack {
            TextField("Enter car number ", text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                fetchCarInfo(query: query) { fetchedResult in
                    result = fetchedResult
                }
            }) {
                Text("Search")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()

            ScrollView {
                Text(result)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }

    func fetchCarInfo(query: String, completion: @escaping (String) -> Void) {
        guard let q_value = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion("Invalid query")
            return
        }
        let urlString = "https://data.gov.il/api/3/action/datastore_search?resource_id=053cea08-09bc-40ec-8f7a-156f0677aff3&q=\(q_value)"
        guard let url = URL(string: urlString) else {
            completion("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion("Error: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion("No data found")
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = json["result"] as? [String: Any],
                   let records = result["records"] as? [[String: Any]] {

                    if records.isEmpty {
                        // Show a message when no records are found
                        DispatchQueue.main.async {
                            completion("No records found for the given query.")
                        }
                    } else {
                        let displayNames: [(String, String)] = [
                            ("mispar_rechev", "Car Number"),
                            ("degem_nm", "Model Name"),
                            ("tozeret_nm", "Manufacturer"),
                            ("shnat_yitzur", "Year of Manufacture"),
                            ("sug_delek_nm", "Fuel Type"),
                            ("tzeva_rechev", "Vehicle Color"),
                            ("degem_manoa", "Engine Model"),
                            ("mivchan_acharon_dt", "Last Inspection Date"),
                            ("tokef_dt", "Expiration Date"),
                            ("baalut", "Ownership"),
                            ("misgeret", "Chassis Number"),
                            ("zmig_kidmi", "Front Tire"),
                            ("zmig_ahori", "Rear Tire"),
                            ("kvutzat_zihum", "Pollution Group"),
                            ("ramat_eivzur_betihuty", "Safety Rating"),
                            ("kinuy_mishari", "Usage Name"),
                            ("rank", "Rank")
                        ]

                        let formattedResult = records.map { record in
                            let prioritizedResult = displayNames.compactMap { key, displayName in
                                if let value = record[key] {
                                    return "\(displayName): \(value)"
                                }
                                return nil
                            }.joined(separator: "\n")

                            return prioritizedResult
                        }.joined(separator: "\n\n-------------------------\n\n")

                        DispatchQueue.main.async {
                            completion(formattedResult)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion("No records found for the given query.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion("Error parsing data: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
