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
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
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
