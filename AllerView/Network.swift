//
//  Network.swift
//  AllerView
//
//  Created by 관식 on 2023/07/13.
//

import SwiftUI
import Combine

class Network: ObservableObject {
    
    @Published var information: ItemItem?
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getData()
    }
    
    func getData() {
        
        let urlStr = "https://apis.data.go.kr/B553748/CertImgListService/getCertImgListService?serviceKey=OkdpfYdcxbH8%2FGq93l86K5GdE1mJWHRWAXFHzqcZXNlaSAEnRVkuuGdHwdJWma%2FmhorLI4GSBrAjY%2BOYdYfLMA%3D%3D&prdlstNm=자가비 짭짤한 맛&returnType=json"
        let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: encodedStr) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Welcome.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("Completion : \(completion)")
            } receiveValue: { [weak self] response in
                let item = response.body.items[0].item
                print(item)
                self?.information = item
            }
            .store(in: &cancellables)
    }
}
