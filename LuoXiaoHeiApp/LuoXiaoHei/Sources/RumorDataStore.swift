import Foundation

// MARK: - 辟谣数据模型
public struct RumorItem {
    public let category: String
    public let title: String
    public let content: String
}

public final class RumorDataStore {
    public static let shared = RumorDataStore()

    public private(set) var categories: [String] = []
    public private(set) var itemsByCategory: [String: [RumorItem]] = [:]
    public private(set) var allItems: [RumorItem] = []

    private init() {
        load()
    }

    public func reload() {
        categories.removeAll()
        itemsByCategory.removeAll()
        allItems.removeAll()
        load()
    }

    private func load() {
        let language = ConfigManager.shared.config.language
        let filename = language == "zh_cn" ? "rumor_data" : "rumor_data_\(language)"

        // Swift Playgrounds 中有时需使用 path(forResource:ofType:) 作为 fallback
        var url: URL? = Bundle.main.url(forResource: filename, withExtension: "json")
        if url == nil, let p = Bundle.main.path(forResource: filename, ofType: "json") {
            url = URL(fileURLWithPath: p)
        }
        if url == nil, language != "zh_cn" {
            // 回退到中文默认数据
            url = Bundle.main.url(forResource: "rumor_data", withExtension: "json")
            if url == nil, let p = Bundle.main.path(forResource: "rumor_data", ofType: "json") {
                url = URL(fileURLWithPath: p)
            }
        }
        guard let finalURL = url,
              let data = try? Data(contentsOf: finalURL),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: [String: String]]
        else { return }

        for (cat, dict) in json {
            categories.append(cat)
            var list: [RumorItem] = []
            for (title, content) in dict {
                let item = RumorItem(category: cat, title: title, content: content)
                list.append(item)
                allItems.append(item)
            }
            // 按标题稳定排序以便 UI 显示有序
            itemsByCategory[cat] = list.sorted { $0.title < $1.title }
        }
    }

    public func items(in category: String) -> [RumorItem] {
        return itemsByCategory[category] ?? []
    }

    public func search(keyword: String) -> [RumorItem] {
        let kw = keyword.lowercased()
        guard !kw.isEmpty else { return [] }
        return allItems.filter {
            $0.title.lowercased().contains(kw) || $0.content.lowercased().contains(kw)
        }
    }
}
