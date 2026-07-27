import UIKit

// MARK: - 设置视图（已移除软件更新等iOS不可用功能）
public final class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let languageNames = [
        "zh_cn": "简体中文",
        "zh_tw": "繁體中文",
        "en_gb": "English (UK)",
        "ja": "日本語",
        "ko": "한국어",
        "ru": "Русский"
    ]
    private let languageCodes = ["zh_cn", "zh_tw", "en_gb", "ja", "ko", "ru"]

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("settings_page")
        view.backgroundColor = ThemeManager.shared.background
        overrideUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Table
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // 语言、外观、动画、历史记录、关于
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return languageCodes.count
        case 1: return 1
        case 2: return 1
        case 3: return 1 // 清空历史
        case 4: return 3 // 关于 + 用户协议 + 隐私政策
        default: return 0
        }
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return loc("language")
        case 1: return loc("dark_mode")
        case 2: return loc("animation_rendering")
        case 3: return loc("search_history")
        case 4: return loc("about_software")
        default: return nil
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let reused = tableView.dequeueReusableCell(withIdentifier: "LangCell")
            let cell = reused ?? UITableViewCell(style: .default, reuseIdentifier: "LangCell")
            let code = languageCodes[indexPath.row]
            cell.textLabel?.text = languageNames[code] ?? code
            cell.textLabel?.textColor = ThemeManager.shared.text
            cell.accessoryType = ConfigManager.shared.config.language == code ? .checkmark : .none
            cell.backgroundColor = ThemeManager.shared.surface
            return cell
        case 1:
            let reused = tableView.dequeueReusableCell(withIdentifier: "SwitchCell")
            let cell = reused ?? SwitchCell(style: .default, reuseIdentifier: "SwitchCell")
            if let switchCell = cell as? SwitchCell {
                switchCell.configure(title: loc("dark_mode"),
                                     isOn: ConfigManager.shared.config.darkMode,
                                     handler: { [weak self] isOn in
                    ConfigManager.shared.setDarkMode(isOn)
                    self?.applyThemeGlobally()
                })
            }
            cell.backgroundColor = ThemeManager.shared.surface
            return cell
        case 2:
            let reused = tableView.dequeueReusableCell(withIdentifier: "SwitchCell")
            let cell = reused ?? SwitchCell(style: .default, reuseIdentifier: "SwitchCell")
            if let switchCell = cell as? SwitchCell {
                switchCell.configure(title: loc("animation_rendering"),
                                     isOn: ConfigManager.shared.config.animationEnabled,
                                     handler: { isOn in
                    ConfigManager.shared.setAnimationEnabled(isOn)
                })
            }
            cell.backgroundColor = ThemeManager.shared.surface
            return cell
        case 3:
            let reused = tableView.dequeueReusableCell(withIdentifier: "ActionCell")
            let cell = reused ?? UITableViewCell(style: .default, reuseIdentifier: "ActionCell")
            cell.textLabel?.text = loc("clear_history")
            cell.textLabel?.textColor = ThemeManager.shared.destructive
            cell.backgroundColor = ThemeManager.shared.surface
            return cell
        case 4:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "AboutCell")
            if indexPath.row == 0 {
                cell.textLabel?.text = loc("current_version")
                cell.detailTextLabel?.text = "v1.5.1"
                cell.selectionStyle = .none
            } else if indexPath.row == 1 {
                cell.textLabel?.text = loc("user_agreement")
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.textLabel?.text = loc("privacy_policy")
                cell.accessoryType = .disclosureIndicator
            }
            cell.textLabel?.textColor = ThemeManager.shared.text
            cell.detailTextLabel?.textColor = ThemeManager.shared.secondaryText
            cell.backgroundColor = ThemeManager.shared.surface
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "FallbackCell")
            cell.backgroundColor = ThemeManager.shared.surface
            return cell
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let code = languageCodes[indexPath.row]
            ConfigManager.shared.setLanguage(code)
            Localization.shared.load(language: code)
            RumorDataStore.shared.reload()
            NotificationCenter.default.post(name: .languageDidChange, object: nil)
            tableView.reloadData()
            navigationController?.popToRootViewController(animated: true)
        case 3:
            let alert = UIAlertController(title: loc("tip"), message: loc("clear_history_confirm"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: loc("cancel"), style: .cancel))
            alert.addAction(UIAlertAction(title: loc("confirm"), style: .destructive, handler: { [weak self] _ in
                ConfigManager.shared.clearSearchHistory()
                self?.showToast(message: loc("history_cleared"))
                NotificationCenter.default.post(name: .themeDidChange, object: nil)
            }))
            present(alert, animated: true)
        case 4:
            if indexPath.row == 1 {
                let vc = TextDocumentViewController(filename: "user_agreement.md",
                                                     displayTitle: loc("user_agreement"))
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 2 {
                let vc = TextDocumentViewController(filename: "privacy_policy.md",
                                                     displayTitle: loc("privacy_policy"))
                navigationController?.pushViewController(vc, animated: true)
            }
        default: break
        }
    }

    private func applyThemeGlobally() {
        let style: UIUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light
        navigationController?.overrideUserInterfaceStyle = style
        view.window?.overrideUserInterfaceStyle = style
        view.backgroundColor = ThemeManager.shared.background
        tableView.reloadData()
        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }

    private func showToast(message: String) {
        let toast = UILabel()
        toast.text = message
        toast.textColor = .white
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toast.textAlignment = .center
        toast.font = UIFont.systemFont(ofSize: 14)
        toast.layer.cornerRadius = 12
        toast.clipsToBounds = true
        toast.numberOfLines = 0
        toast.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            toast.widthAnchor.constraint(lessThanOrEqualToConstant: 280),
            toast.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) { toast.removeFromSuperview() }
    }
}

// MARK: - 开关单元格
public final class SwitchCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let toggle = UISwitch()
    private var handler: ((Bool) -> Void)?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggle)
        toggle.addTarget(self, action: #selector(onToggleChanged), for: .valueChanged)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -8),
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func onToggleChanged() {
        handler?(toggle.isOn)
    }

    public func configure(title: String, isOn: Bool, handler: @escaping (Bool) -> Void) {
        titleLabel.text = title
        titleLabel.textColor = ThemeManager.shared.text
        toggle.isOn = isOn
        toggle.onTintColor = ThemeManager.shared.accent
        self.handler = handler
    }
}
