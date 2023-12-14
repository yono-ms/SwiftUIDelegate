//
//  ContentView.swift
//  SwiftUIDelegate
//
//  Created by no name on 2023/11/05.
//  
//

import SwiftUI

struct ContentView: View {
    
    @State var isLoading = false
    @State var location = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("get location") {
                Task {
                    do {
                        let result = try await AppLocation.shared.getLocation()
                        let latitude = result.coordinate.latitude
                        let longitude = result.coordinate.longitude
                        location = "\(latitude), \(longitude)"
                    } catch {
                        debugPrint("error")
                    }
                }
            }
            Text(location)
            ZStack {
                WebView(isLoading: $isLoading)
                if isLoading {
                    ProgressView()
                }
            }
        }
        .padding()
        .onAppear {
            print("onAppear")
        }
        .onDisappear {
            print("onDisappear")
        }
        .task {
            print("task start")
        }
    }
}

#Preview {
    ContentView()
}
