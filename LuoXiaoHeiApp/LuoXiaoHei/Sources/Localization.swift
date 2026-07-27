import Foundation

// MARK: - 语言管理
public final class Localization {
    public static let shared = Localization()

    private var table: [String: String] = [:]

    private init() {
        load(language: ConfigManager.shared.config.language)
    }

    public func load(language code: String) {
        let filename = code
        // 同时尝试 url 与 path 方式（Playground 环境更兼容）
        var url: URL? = Bundle.main.url(forResource: filename, withExtension: "json")
        if url == nil, let p = Bundle.main.path(forResource: filename, ofType: "json") {
            url = URL(fileURLWithPath: p)
        }
        guard let finalURL = url,
              let data = try? Data(contentsOf: finalURL),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: String]
        else {
            table = fallbackTable()
            return
        }
        table = json
    }

    private func fallbackTable() -> [String: String] {
        return [
            "app_title": "罗小黑战记辟谣查询",
            "category_button": "分类",
            "hide_category": "隐藏分类",
            "search_button": "搜索",
            "export_content": "导出内容",
            "no_results": "未找到 '{keyword}' 相关的内容",
            "back_to_home": "返回首页",
            "copy_text": "复制文本",
            "back": "返回",
            "copied_to_clipboard": "已复制到剪贴板",
            "settings_page": "设置",
            "back_button": "返回",
            "language": "语言",
            "simplified_chinese": "简体中文",
            "traditional_chinese": "繁体中文",
            "english_uk": "英语（英国）",
            "japanese": "日语",
            "korean": "韩语",
            "russian": "俄语",
            "dark_mode": "深色模式",
            "light_mode": "浅色模式",
            "export_location": "导出位置",
            "clear_history": "清空历史记录",
            "history_cleared": "历史记录已清空",
            "export_format": "选择导出格式",
            "export_txt": "导出为 TXT",
            "export_failed": "导出失败",
            "export_time": "导出时间",
            "rumor_detail": "辟谣详情",
            "search_results": "搜索结果",
            "no_content_to_export": "没有可导出的内容",
            "export_success": "导出成功",
            "about_software": "关于本软件",
            "current_version": "当前版本",
            "user_agreement_text_start": "使用本软件默认同意我们的",
            "user_agreement_title": "《用户协议》",
            "and": "和",
            "privacy_policy_title": "《隐私政策》",
            "browse": "浏览",
            "animation_rendering": "动画渲染",
            "disable_animation": "关闭动画渲染",
            "close": "关闭",
            "home_text": "选择一个分类或输入关键词",
            "search_placeholder": "输入关键词搜索",
            "search_history": "搜索历史",
            "user_agreement": "用户协议",
            "privacy_policy": "隐私政策",
            "tip": "提示",
            "success": "成功",
            "error": "错误",
            "view_images": "查看相关图片",
            "no_related_images": "当前内容没有相关图片",
            "related_images": "相关图片 ({count})",
            "prev_image": "上一张",
            "next_image": "下一张",
            "clear_history_confirm": "确定要清空所有搜索历史吗？",
            "cancel": "取消",
            "confirm": "确定"
        ]
    }

    public func string(_ key: String, _ replacements: [String: String] = [:]) -> String {
        var template = table[key] ?? fallbackTable()[key] ?? key
        for (k, v) in replacements {
            template = template.replacingOccurrences(of: "{\(k)}", with: v)
        }
        return template
    }

    public subscript(key: String) -> String {
        return table[key] ?? fallbackTable()[key] ?? key
    }
}

// 便捷方法
public func loc(_ key: String, _ replacements: [String: String] = [:]) -> String {
    return Localization.shared.string(key, replacements)
}

// 兼容：支持单个关键词参数（最常见的搜索场景）
public func loc(_ key: String, keyword: String) -> String {
    return Localization.shared.string(key, ["keyword": keyword])
}
