import UIKit

// MARK: - 主题管理
@objc public final class ThemeManager: NSObject {
    @objc public static let shared = ThemeManager()

    public var isDark: Bool {
        return ConfigManager.shared.config.darkMode
    }

    // 颜色
    public var background: UIColor {
        return UIColor { trait in
            self.isDark ? UIColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1)
                        : UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1)
        }
    }

    public var surface: UIColor {
        return UIColor { trait in
            self.isDark ? UIColor(red: 0.18, green: 0.18, blue: 0.20, alpha: 1)
                        : UIColor.white
        }
    }

    public var text: UIColor {
        return UIColor { trait in
            self.isDark ? UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1)
                        : UIColor(red: 0.13, green: 0.13, blue: 0.15, alpha: 1)
        }
    }

    public var secondaryText: UIColor {
        return UIColor { trait in
            self.isDark ? UIColor(red: 0.60, green: 0.60, blue: 0.65, alpha: 1)
                        : UIColor(red: 0.40, green: 0.40, blue: 0.45, alpha: 1)
        }
    }

    public var separator: UIColor {
        return UIColor { trait in
            self.isDark ? UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1)
                        : UIColor(red: 0.88, green: 0.88, blue: 0.90, alpha: 1)
        }
    }

    public var accent: UIColor {
        return UIColor.systemOrange
    }

    public var primaryButton: UIColor {
        return UIColor.systemBlue
    }

    public var destructive: UIColor {
        return UIColor.systemRed
    }

    public var success: UIColor {
        return UIColor.systemGreen
    }

    private override init() {}
}

// 通知：主题变化
public extension Notification.Name {
    static let themeDidChange = Notification.Name("lxhpy.themeDidChange")
    static let languageDidChange = Notification.Name("lxhpy.languageDidChange")
}
