//
//  File.swift
//  
//
//  Created by Joseph Van Boxtel on 6/17/19.
//

import Foundation
//import GenericJSON
//
//public struct Webhook<Payload>: ResourceDecodable where Payload: ResourceDecodable {
//    public static var resourceType: String { return "EventDelivery" }
//    
//    public var id: ResourceIdentifier<Webhook<Payload>>
//    public var name: String
//    public var attemptNumber: Int
//    public var payload: Payload
//    
//    public init(resource: Resource) throws {
//        id = try resource.identifer.specialize()
//        name = try resource.attribute(for: "name").asString()
//        attemptNumber = try resource.attribute(for: "attempt").asInt()
//        let payloadString = try resource.attribute(for: "payload").asString()
//        payload = try Self.decodePayload(payloadString)
//    }
//    
//    private static func decodePayload(_ payloadString: String) throws -> Payload {
//        print("Plan payload: \(payloadString)")
//        let payloadData = payloadString.data(using: .utf8)!
//        
//        let json = try JSONDecoder().decode(JSON.self, from: payloadData)
//        let doc = try Document(json: json)
//        
//        guard let resource = doc.data?.asSingle else {
//            throw ResourceDecodeError.incorrectStructure(reason: "Expected a single resouce object in the payload.")
//        }
//        return try Payload.init(resource: resource)
//    }
//    
//    public static func parsePayload(from data: Data) throws -> Payload {
//        let jsonResponse = try JSONDecoder().decode(JSON.self, from: data)
//        let doc = try Document(json: jsonResponse)
//        let resource = doc.data!.asMultiple!.first!
//        return try Webhook(resource: resource).payload
//    }
//}
