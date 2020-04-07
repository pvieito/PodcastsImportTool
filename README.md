# PodcastsImportTool

Swift framework and tool to automate importing feeds and OPML files into podcast services.


## Target Services

- Apple Podcasts app (macOS 10.15+)

## Usage

```bash
$ swift run PodcastsImportTool -i Podcasts.opml -s apple-podcasts
$ swift run PodcastsImportTool -f "http://www.hellointernet.fm/podcast?format=rss" -s apple-podcasts
```

## Dependencies

- Swift 5.2+
