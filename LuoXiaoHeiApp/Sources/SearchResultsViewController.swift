import UIKit

// MARK: - 搜索结果列表
public final class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let keyword: String
    private let results: [RumorItem]
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    public init(keyword: String, results: [RumorItem]) {
        self.keyword = keyword
        self.results = results
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("search_results")
        view.backgroundColor = ThemeManager.shared.background
        overrideUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        if results.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = loc("no_results", keyword: keyword)
            emptyLabel.textColor = ThemeManager.shared.secondaryText
            emptyLabel.textAlignment = .center
            emptyLabel.numberOfLines = 0
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(emptyLabel)
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
            ])
            tableView.isHidden = true
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reused = tableView.dequeueReusableCell(withIdentifier: "ResultCell")
        let cell = reused ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ResultCell")
        let item = results[indexPath.row]
        cell.textLabel?.text = item.title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = ThemeManager.shared.text
        cell.detailTextLabel?.text = item.category
        cell.detailTextLabel?.textColor = ThemeManager.shared.secondaryText
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = ThemeManager.shared.surface
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(DetailViewController(item: results[indexPath.row]), animated: true)
    }
}
