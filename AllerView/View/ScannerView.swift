//
//  ScannerView.swift
//  AllerView
//
//  Created by 관식 on 2023/07/19.
//

import SwiftUI

struct ScannerView: View {
    
    @State private var showScannerSheet: Bool = false
    @State private var texts: [ScanData] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(texts) { text in
                        NavigationLink {
                            ScrollView {
                                Text(text.content)
                            }
                        } label: {
                            Text(text.content)
                                .lineLimit(1)
                        }
                        
                    }
                }
                Button("Scan Image") {
                    showScannerSheet.toggle()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.tint)
                .cornerRadius(12)
                .padding()
            }
            .navigationTitle("Scanner View")
        }
        .sheet(isPresented: $showScannerSheet) {
            makeScanningView()
        }
    }
    
    private func makeScanningView() -> ScanningView {
        ScanningView { textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(content: outputText)
                self.texts.append(newScanData)
            }
            self.showScannerSheet = false
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
