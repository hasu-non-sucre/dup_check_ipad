//
//  ContentView.swift
//  UDP
//
//  Created by User on 2023/07/11.
//

import SwiftUI

struct ContentView: View {
    @State private var receivedMessage: String = ""
    private let udpServer = UDPServer()
    private let udpPort: UInt16 = 8888 // ポート番号をここで指定

    var body: some View {
        VStack {
            Text("速度: \(receivedMessage)")
                .padding()
                .font(.largeTitle)

            Button("Start UDP Server") {
                udpServer.startUDPServer(onPort: udpPort) { message in
                    DispatchQueue.main.async {
                        receivedMessage = message
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
