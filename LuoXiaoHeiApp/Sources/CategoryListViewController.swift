import UIKit

// MARK: - 分类列表
public final class CategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let category: String
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    public init(category: String) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = category
        view.backgroundColor = ThemeManager.shared.background
        overrideUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light

        tableView.dataSource = self
        tableView.delegate = self
        // 不 register — cellForRowAt 中按需创建 cell
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RumorDataStore.shared.items(in: category).count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reused = tableView.dequeueReusableCell(withIdentifier: "ItemCell")
        let cell = reused ?? UITableViewCell(style: .default, reuseIdentifier: "ItemCell")
        let item = RumorDataStore.shared.items(in: category)[indexPath.row]
        cell.textLabel?.text = item.title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = ThemeManager.shared.text
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = ThemeManager.shared.surface
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = RumorDataStore.shared.items(in: category)[indexPath.row]
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }
}
