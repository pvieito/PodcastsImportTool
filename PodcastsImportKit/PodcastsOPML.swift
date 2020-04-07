//
//  PodcastsOPML.swift
//  PodcastsImportKit
//
//  Created by Pedro José Pereira Vieito on 06/04/2020.
//  Copyright © 2020 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import XMLCoder

public struct PodcastsOPML: Codable {
    private struct Head: Codable {
        var title: String?
    }
    
    private struct Body: Codable {
        private var outline: [Item]
        
        public var items: [Item] {
            return self.outline
        }
        
        public init(items: [Item]) {
            self.outline = items
        }
    }
    
    public struct Item: Codable {
        public var title: String?
        private var type: String?
        private var xmlUrl: String?
        private var htmlUrl: String?
        
        public var feedURL: URL? {
            guard let feedURLString = self.xmlUrl else { return nil }
            return URL(string: feedURLString)
        }
        
        public init(title: String? = nil, feedURL: URL) {
            self.title = title
            self.xmlUrl = feedURL.absoluteString
        }
    }
    
    private var head: Head?
    private var body: Body
    
    public var title: String? {
        return self.head?.title
    }
    
    public var items: [Item] {
        return self.body.items
    }
    
    public init(items: [Item]) {
        self.body = Body(items: items)
    }
}

extension PodcastsOPML {
    public init(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try XMLDecoder().decode(Self.self, from: data)
    }
}
