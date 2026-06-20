import UIKit

// MARK: - 主页视图控制器
public final class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    private let titleLabel = UILabel()
    private let searchBar = UISearchBar()
    private let historyLabel = UILabel()
    private let historyStack = UIStackView()
    private let homeTextLabel = UILabel()
    private let categoryTable = UITableView(frame: .zero, style: .insetGrouped)

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        applyAppearance()
        reloadData()

        NotificationCenter.default.addObserver(self,
            selector: #selector(onThemeOrLanguageChange),
            name: .themeDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(onThemeOrLanguageChange),
            name: .languageDidChange, object: nil)
    }

    @objc private func onThemeOrLanguageChange() {
        applyAppearance()
        titleLabel.text = loc("app_title")
        searchBar.placeholder = loc("search_placeholder")
        homeTextLabel.text = loc("home_text") ?? "选择一个分类或输入关键词"
        historyLabel.text = loc("search_history")
        categoryTable.reloadData()
        refreshHistory()
    }

    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)

        titleLabel.text = loc("app_title")
        titleLabel.textColor = UIColor(red: 0.13, green: 0.13, blue: 0.15, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        searchBar.placeholder = loc("search_placeholder")
        searchBar.searchBarStyle = .default
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        searchBar.tintColor = UIColor.systemOrange
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        historyLabel.text = loc("search_history")
        historyLabel.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.45, alpha: 1.0)
        historyLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        historyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyLabel)

        historyStack.axis = .horizontal
        historyStack.alignment = .leading
        historyStack.spacing = 8
        historyStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyStack)

        homeTextLabel.text = loc("home_text") ?? "选择一个分类或输入关键词"
        homeTextLabel.textColor = UIColor(red: 0.13, green: 0.13, blue: 0.15, alpha: 1.0)
        homeTextLabel.font = UIFont.systemFont(ofSize: 15)
        homeTextLabel.textAlignment = .center
        homeTextLabel.numberOfLines = 0
        homeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeTextLabel)

        categoryTable.dataSource = self
        categoryTable.delegate = self
        categoryTable.rowHeight = UITableView.automaticDimension
        categoryTable.estimatedRowHeight = 56
        categoryTable.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
        categoryTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryTable)

        // 导航栏按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: loc("export_content"),
            style: .plain,
            target: self, action: #selector(exportTapped))
        let settingsButton: UIBarButtonItem
        if let gear = UIImage(systemName: "gearshape") {
            settingsButton = UIBarButtonItem(image: gear, style: .plain,
                                              target: self, action: #selector(settingsTapped))
        } else {
            settingsButton = UIBarButtonItem(title: "⚙", style: .plain,
                                              target: self, action: #selector(settingsTapped))
        }
        navigationItem.leftBarButtonItem = settingsButton
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            historyLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            historyStack.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 8),
            historyStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            historyStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            homeTextLabel.topAnchor.constraint(equalTo: historyStack.bottomAnchor, constant: 16),
            homeTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            homeTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            categoryTable.topAnchor.constraint(equalTo: homeTextLabel.bottomAnchor, constant: 16),
            categoryTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func applyAppearance() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
        titleLabel.textColor = UIColor(red: 0.13, green: 0.13, blue: 0.15, alpha: 1.0)
        homeTextLabel.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.45, alpha: 1.0)
        historyLabel.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.45, alpha: 1.0)
        searchBar.tintColor = UIColor.systemOrange
        searchBar.barStyle = .default
        categoryTable.reloadData()
        refreshHistory()
    }

    public func reloadData() {
        categoryTable.reloadData()
        refreshHistory()
    }

    private func refreshHistory() {
        for sub in historyStack.arrangedSubviews {
            historyStack.removeArrangedSubview(sub)
            sub.removeFromSuperview()
        }
        let history = ConfigManager.shared.config.searchHistory
        guard !history.isEmpty else { return }
        for keyword in history {
            let btn = UIButton(type: .system)
            btn.setTitle(keyword, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            btn.backgroundColor = ThemeManager.shared.surface
            btn.layer.cornerRadius = 8
            btn.tintColor = ThemeManager.shared.text
            btn.addAction(UIAction { [weak self] _ in
                self?.performSearch(keyword)
            }, for: .touchUpInside)
            historyStack.addArrangedSubview(btn)
        }
        let spacer = UIView()
        spacer.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        historyStack.addArrangedSubview(spacer)
    }

    // MARK: - Search Bar
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let keyword = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !keyword.isEmpty else { return }
        performSearch(keyword)
    }

    private func performSearch(_ keyword: String) {
        ConfigManager.shared.addSearchHistory(keyword)
        let results = RumorDataStore.shared.search(keyword: keyword)
        let vc = SearchResultsViewController(keyword: keyword, results: results)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func settingsTapped() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

    @objc private func exportTapped() {
        let alert = UIAlertController(title: loc("export_content"),
                                      message: loc("export_format"),
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: loc("export_txt"), style: .default, handler: { [weak self] _ in
            self?.exportAllAsText()
        }))
        alert.addAction(UIAlertAction(title: loc("back"), style: .cancel))
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }

    private func exportAllAsText() {
        let store = RumorDataStore.shared
        var text = "=== \(loc("app_title")) - \(loc("export_time")): \(Date()) ===\n\n"
        for cat in store.categories {
            text += "【\(cat)】\n"
            for item in store.items(in: cat) {
                text += "\n■ \(item.title)\n\(item.content)\n"
            }
            text += "\n"
        }
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activity.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activity, animated: true)
    }

    // MARK: - Table View
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RumorDataStore.shared.categories.count
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return loc("category_button")
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reused = tableView.dequeueReusableCell(withIdentifier: "CatCell")
        let cell = reused ?? UITableViewCell(style: .subtitle, reuseIdentifier: "CatCell")
        let cat = RumorDataStore.shared.categories[indexPath.row]
        cell.textLabel?.text = cat
        cell.textLabel?.textColor = UIColor(red: 0.13, green: 0.13, blue: 0.15, alpha: 1.0)
        cell.detailTextLabel?.text = "\(RumorDataStore.shared.items(in: cat).count) \(loc("rumor_detail"))"
        cell.detailTextLabel?.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.45, alpha: 1.0)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.white
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cat = RumorDataStore.shared.categories[indexPath.row]
        let vc = CategoryListViewController(category: cat)
        navigationController?.pushViewController(vc, animated: true)
    }
}
