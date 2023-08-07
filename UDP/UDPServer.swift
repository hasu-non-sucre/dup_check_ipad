//
//  UDPServer.swift
//  UDP
//
//  Created by User on 2023/07/23.
//

import Foundation
import Network

class UDPServer {
    private var udpSocket: NWListener?
    
    func startUDPServer(onPort port: UInt16, receivedMessageHandler: @escaping (String) -> Void) {
        let parameters = NWParameters.udp
        let server = try! NWListener(using: parameters, on: NWEndpoint.Port(rawValue: port)!)
        
        server.newConnectionHandler = { newConnection in
            newConnection.stateUpdateHandler = { newState in
                switch newState {
                case .ready:
                    self.receive(on: newConnection, receivedMessageHandler: receivedMessageHandler)
                default:
                    break
                }
            }
            newConnection.start(queue: .main)
        }
        
        server.start(queue: .main)
    }
    
    private func receive(on connection: NWConnection, receivedMessageHandler: @escaping (String) -> Void) {
        connection.receiveMessage { data, context, isComplete, error in
            if let data = data, let message = String(data: data, encoding: .utf8) {
                receivedMessageHandler(message)
            }
            
            if isComplete {
                connection.cancel()
            } else {
                self.receive(on: connection, receivedMessageHandler: receivedMessageHandler)
            }
        }
    }
}
