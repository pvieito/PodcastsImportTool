//
//  PodcastsImporter.swift
//  PodcastsImportKit
//
//  Created by Pedro José Pereira Vieito on 06/04/2020.
//  Copyright © 2020 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import FoundationKit

#if os(macOS)
import Cocoa
#endif

public struct PodcastsImporter {
    let feeds: [URL]

    public init(feeds: [URL]) {
        self.feeds = feeds
    }
}

extension PodcastsImporter {
    init(contentsOfOPML url: URL) throws {
        let opml = try PodcastsOPML(contentsOf: url)
        self.feeds = opml.items.compactMap(\.feedURL)
    }
}

extension PodcastsImporter {
    public enum Service: String, CaseIterable, CustomStringConvertible {
        case applePodcasts = "apple-podcasts"
                
        var isSupported: Bool {
            switch self {
            case .applePodcasts:
                #if os(macOS)
                return NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.podcasts") != nil
                #else
                return false
                #endif
            }
        }
        
        var unsupportedError: Error {
            return NSError(description: "Service “\(self)” is not supported on the current platform.")
        }
        
        public var description: String {
            switch self {
            case .applePodcasts:
                return "Apple Podcasts"
            }
        }
    }
}

extension PodcastsImporter {
    public func importFeeds(to service: Service) throws {        
        guard service.isSupported else {
            throw service.unsupportedError
        }
        
        switch service {
        case .applePodcasts:
            try self.importFeedsToApplePodcasts()
        }
    }
}

extension PodcastsImporter {
    private func importFeedsToApplePodcasts() throws {
        #if os(macOS)
        for feedURL in self.feeds {
            try self.importFeedToApplePodcasts(feedURL: feedURL)
        }
        #else
        throw Service.applePodcasts.unsupportedError
        #endif
    }
    
    #if os(macOS)
    private static let importFeedToApplePodcastsAppleScriptSourceTemplateURL =
        Bundle.currentModuleBundle().url(forResource: "ApplePodcastsImport", withExtension: "applescript")!
    private static let importFeedAppleScriptSourceTemplate =
        try! String(contentsOf: importFeedToApplePodcastsAppleScriptSourceTemplateURL)
    
    private func composeImportFeedAppleScriptSource(feedURL: URL) -> String {
        return Self.importFeedAppleScriptSourceTemplate.replacingOccurrences(
            of: "${feedURL}", with: feedURL.absoluteString)
    }
    
    private func importFeedToApplePodcasts(feedURL: URL) throws {
        let importFeedAppleScriptSource = self.composeImportFeedAppleScriptSource(feedURL: feedURL)
        guard let importFeedAppleScript = NSAppleScript(source: importFeedAppleScriptSource) else {
            throw NSError(description: "Invalid import feed Apple Script.")
        }
        
        try importFeedAppleScript.execute()
    }
    #endif
}
