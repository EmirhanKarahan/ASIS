//
//  NFCHelper.swift
//  ASIS
//
//  Created by Emirhan KARAHAN on 28.06.2022.
//

import UIKit
import CoreNFC

enum NFCError: Error {
    case deviceNotSupported
}

class NFCHelper: NSObject, NFCNDEFReaderSessionDelegate {
    var onNFCResult: ((Bool, String) -> ())?
    
    func restartSession() throws {
        
        guard NFCNDEFReaderSession.readingAvailable else {
            throw NFCError.deviceNotSupported
        }
        
        let session = NFCNDEFReaderSession(delegate: self,
                                           queue: nil,
                                           invalidateAfterFirstRead: true)
        session.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("NFC invalidated \(error)")
        guard let onNFCResult = onNFCResult else { return }
        onNFCResult(false, error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("NFC detected")
        guard let onNFCResult = onNFCResult else { return }
        for message in messages {
            for record in message.records {
                if let resultString = String(data: record.payload, encoding: .utf8) {
                    onNFCResult(true, resultString)
                }
            }
        }
    }
    
    
    
    
}
