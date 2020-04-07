//
//  LottoManagerTests.swift
//  LottoKitTests
//
//  Created by Pedro José Pereira Vieito on 06/04/2020.
//  Copyright © 2020 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import FoundationKit
import XCTest
@testable import PodcastsImportKit

class PodcastsImporterKitTests: XCTestCase {
    static let opmlResourceURL = Bundle.currentModuleBundle().url(forResource: "Podcasts", withExtension: "opml")!
    
    func testPodcastsOPMLDecoder() throws {
        let opml = try PodcastsOPML(contentsOf: Self.opmlResourceURL)
        XCTAssertEqual(opml.items.count, 22)
        XCTAssertEqual(opml.items.first?.title, "Connected")
        XCTAssertEqual(opml.items.first?.feedURL?.absoluteString, "https://www.relay.fm/connected/feed")
        XCTAssertEqual(opml.items.last?.title, "Error de Conexión")
        XCTAssertEqual(opml.items.last?.feedURL?.absoluteString, "http://feeds.feedburner.com/edcpodcast")
    }
    
    func testPodcastsImporter() throws {
        let podcastsImporter = try PodcastsImporter(contentsOfOPML: Self.opmlResourceURL)
        XCTAssertEqual(podcastsImporter.feeds.count, 22)
    }
}
