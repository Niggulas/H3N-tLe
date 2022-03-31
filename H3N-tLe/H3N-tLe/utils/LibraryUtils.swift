func getSeriesInfo(path: String) -> [String: String] {
    // Parse info.json from path
    let infoPath = path + "/info.json"
    let infoData = try! Data(contentsOf: URL(fileURLWithPath: infoPath))
    let info = try! JSONSerialization.jsonObject(with: infoData, options: []) as! [String: String]

    return info
}

func getAllSeries() -> [[String: Any]] {
    let fileManager = FileManager.default
    let directories = fileManager.subpathsOfDirectory(atPath: .documentsDirectory)
    var series: [[String: Any]] = []
    for directory in directories {
        let seriesPath = .documentsDirectory + directory
        let seriesInfo = getSeriesInfo(from: seriesPath)
        series.append(seriesInfo)
    }
}