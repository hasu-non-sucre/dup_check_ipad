//
//  NWConnectionManager.swift
//  UDP
//
//  Created by User on 2023/07/22.
//

import Foundation
import Network

class UDPManager{
    func send(connection: NWConnection) {
        /* 送信データ生成 */
        let message = "example\n"
        let data = message.data(using: .utf8)!
        let semaphore = DispatchSemaphore(value: 0)

        /* データ送信 */
        connection.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                NSLog("\(#function), \(error)")
            } else {
                semaphore.signal()
            }
        })
        /* 送信完了待ち */
        semaphore.wait()
    }
    
    func recv(connection: NWConnection) {
        let semaphore = DispatchSemaphore(value: 0)
        /* データ受信 */
        connection.receive(minimumIncompleteLength: 0,
                           maximumLength: 65535,
                           completion:{(data, context, flag, error) in
            if let error = error {
                NSLog("\(#function), \(error)")
            } else {
                if let data = data {
                    /* 受信データのデシリアライズ */
                    semaphore.signal()
                }
                else {
                    NSLog("receiveMessage data nil")
                }
            }
        })
        /* 受信完了待ち */
        semaphore.wait()
    }
    
    func disconnect(connection: NWConnection)
    {
        /* コネクション切断 */
        connection.cancel()
    }
    
    func connect(host: String, port: String) -> NWConnection
    {
        let t_host = NWEndpoint.Host(host)
        let t_port = NWEndpoint.Port(port)
        let connection : NWConnection
        let semaphore = DispatchSemaphore(value: 0)

        /* コネクションの初期化 */
        connection = NWConnection(host: t_host, port: t_port!, using: .tcp)

        /* コネクションのStateハンドラ設定 */
        connection.stateUpdateHandler = { (newState) in
            switch newState {
                case .ready:
                    NSLog("Ready to send")
                    semaphore.signal()
                case .waiting(let error):
                    NSLog("\(#function), \(error)")
                case .failed(let error):
                    NSLog("\(#function), \(error)")
                case .setup: break
                case .cancelled: break
                case .preparing: break
                @unknown default:
                    fatalError("Illegal state")
            }
        }
        
        /* コネクション開始 */
        let queue = DispatchQueue(label: "example")
        connection.start(queue:queue)

        /* コネクション完了待ち */
        semaphore.wait()
        return connection
    }
    
    func example()
    {
        let connection : NWConnection
        let host = "192.168.1.40"
        let port = "50000"
        
        /* コネクション開始 */
        connection = connect(host: host, port: port)
        /* データ送信 */
        send(connection: connection)
        /* データ受信 */
        recv(connection: connection)
        /* コネクション切断 */
        disconnect(connection: connection)
    }
}
