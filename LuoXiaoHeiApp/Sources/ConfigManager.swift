import Foundation
import UIKit

// MARK: - 配置管理
public struct AppConfig: Codable {
    public var language: String
    public var darkMode: Bool
    public var exportLocation: String
    public var animationEnabled: Bool
    public var autoCheckUpdate: Bool
    public var startupCount: Int
    public var searchHistory: [String]

    public static let `default` = AppConfig(
        language: "zh_cn",
        darkMode: false,
        exportLocation: "",
        animationEnabled: true,
        autoCheckUpdate: true,
        startupCount: 0,
        searchHistory: []
    )
}

public final class ConfigManager {
    public static let shared = ConfigManager()

    private let defaultsKey = "lxhpy_config_v1"
    private let historyKey = "lxhpy_history_v1"

    public private(set) var config: AppConfig

    private init() {
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
           let decoded = try? JSONDecoder().decode(AppConfig.self, from: data) {
            self.config = decoded
        } else {
            self.config = .default
        }
        // 每次启动自增启动次数
        self.config.startupCount += 1
        self.save()
    }

    public func save() {
        if let data = try? JSONEncoder().encode(config) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    public func setLanguage(_ code: String) {
        config.language = code
        save()
    }

    public func setDarkMode(_ on: Bool) {
        config.darkMode = on
        save()
    }

    public func setExportLocation(_ path: String) {
        config.exportLocation = path
        save()
    }

    public func setAnimationEnabled(_ on: Bool) {
        config.animationEnabled = on
        save()
    }

    public func setAutoCheckUpdate(_ on: Bool) {
        config.autoCheckUpdate = on
        save()
    }

    public func addSearchHistory(_ keyword: String) {
        if let idx = config.searchHistory.firstIndex(of: keyword) {
            config.searchHistory.remove(at: idx)
        }
        config.searchHistory.insert(keyword, at: 0)
        if config.searchHistory.count > 3 {
            config.searchHistory = Array(config.searchHistory.prefix(3))
        }
        save()
    }

    public func clearSearchHistory() {
        config.searchHistory.removeAll()
        save()
    }
}
