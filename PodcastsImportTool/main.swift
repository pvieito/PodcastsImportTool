//
//  main.swift
//  PodcastsImportTool
//
//  Created by Pedro José Pereira Vieito on 06/04/2020.
//  Copyright © 2020 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import FoundationKit
import LoggerKit
import PodcastsImportKit
import ArgumentParser

struct PodcastsImportTool: ParsableCommand {
    static var configuration: CommandConfiguration {
        return CommandConfiguration(commandName: String(describing: Self.self))
    }
    
    @Option(name: .shortAndLong, help: "Input OPML file.")
    var input: String?
    
    @Option(name: .shortAndLong, parsing: .upToNextOption, help: "Input feeds.")
    var feeds: Array<String>

    @Option(name: .shortAndLong, help: "Import target service.")
    var service: PodcastsImporter.Service?

    @Flag(name: .shortAndLong, help: "Verbose mode.")
    var verbose: Bool
    
    func validate() throws {
        if self.input == nil && self.feeds.validURLs.isEmpty {
            throw ValidationError("No input specified.")
        }
    }
    
    func run() throws {
        Logger.logMode = .commandLine
        Logger.logLevel = self.verbose ? .debug : .info
        
        do {
            let podcastsOPML: PodcastsOPML
            
            if let inputURL = self.input?.pathURL {
                podcastsOPML = try PodcastsOPML(contentsOf: inputURL)
            }
            else {
                let feedItems = self.feeds.validURLs.map { PodcastsOPML.Item(feedURL: $0) }
                podcastsOPML = PodcastsOPML(items: feedItems)
            }
            
            let podcastsOPMLTitle = podcastsOPML.title ?? self.input?.pathURL.deletingPathExtension().lastPathComponent ?? "Feeds"
            Logger.log(important: "\(podcastsOPMLTitle) (\(podcastsOPML.items.count))")
            
            for podcastsOPMLItem in podcastsOPML.items {
                if let feedURL = podcastsOPMLItem.feedURL {
                    let feedTitle = podcastsOPMLItem.title ?? feedURL.absoluteString
                    
                    do {
                        Logger.log(success: feedTitle)
                        Logger.log(info: "Feed URL: \(feedURL.absoluteString)")
                        
                        if let service = self.service {
                            let podcastsImport = PodcastsImporter(feeds: [feedURL])
                            Logger.log(notice: "Importing feed “\(feedURL.absoluteString)” into service “\(service)”…")
                            try podcastsImport.importFeeds(to: service)
                        }
                    }
                    catch {
                        Logger.log(warning: "Error importing feed “\(feedTitle)” at “\(feedURL.absoluteString)”.")
                    }
                }
            }
        }
        catch {
            Logger.log(fatalError: error)
        }
    }
}

PodcastsImportTool.main()
