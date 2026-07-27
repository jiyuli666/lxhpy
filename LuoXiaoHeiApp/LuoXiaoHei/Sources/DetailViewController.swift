import UIKit

// MARK: - 辟谣详情（支持图片缩略图与全屏查看，竖屏优化）
public final class DetailViewController: UIViewController,
                                          UITableViewDataSource,
                                          UITableViewDelegate {
    private let item: RumorItem
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let toolbarView = UIView()

    /// 当前标题关联的图片（按文件名）
    private var imageNames: [String] = []
    /// 已加载的图片
    private var images: [UIImage] = []

    private enum Row: Int, CaseIterable {
        case title = 0
        case category = 1
        case imageSectionHeader = 2
        case images = 3
        case content = 4
    }

    public init(item: RumorItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - 生命周期
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("rumor_detail")
        view.backgroundColor = ThemeManager.shared.background
        overrideUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light

        // 加载图片
        imageNames = ImageAssetStore.shared.imageNames(for: item.title)
        images = imageNames.compactMap { ImageAssetStore.shared.image(named: $0) }

        setupTableView()
        setupToolbar()
        setupConstraints()
        applyAppearance()
    }

    // MARK: - UI
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }

    private func setupToolbar() {
        toolbarView.backgroundColor = ThemeManager.shared.surface
        toolbarView.layer.borderWidth = 0.5
        toolbarView.layer.borderColor = ThemeManager.shared.separator.cgColor
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbarView)

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.addSubview(stack)

        let copyBtn = UIButton(type: .system)
        copyBtn.setTitle(loc("copy_text"), for: .normal)
        copyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        copyBtn.backgroundColor = ThemeManager.shared.success
        copyBtn.setTitleColor(.white, for: .normal)
        copyBtn.layer.cornerRadius = 10
        copyBtn.addTarget(self, action: #selector(copyTapped), for: .touchUpInside)

        let exportBtn = UIButton(type: .system)
        exportBtn.setTitle(loc("export_content"), for: .normal)
        exportBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        exportBtn.backgroundColor = ThemeManager.shared.primaryButton
        exportBtn.setTitleColor(.white, for: .normal)
        exportBtn.layer.cornerRadius = 10
        exportBtn.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)

        stack.addArrangedSubview(copyBtn)
        stack.addArrangedSubview(exportBtn)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: toolbarView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: toolbarView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: toolbarView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: toolbarView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stack.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbarView.topAnchor),

            toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbarView.heightAnchor.constraint(equalToConstant: 88)
        ])
    }

    private func applyAppearance() {
        tableView.backgroundColor = .clear
        tableView.reloadData()
    }

    // MARK: - Table View
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 如果没有图片，则跳过 imageSectionHeader 与 images 两行
        return images.isEmpty ? 3 : Row.allCases.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 计算逻辑 row（考虑图片缺失时的折叠）
        let logicalRow: Row
        if images.isEmpty {
            logicalRow = [Row.title, Row.category, Row.content][indexPath.row]
        } else {
            logicalRow = Row(rawValue: indexPath.row) ?? Row.content
        }

        switch logicalRow {
        case .title:
            let cell = dequeueOrCreate("titleCell")
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            let lbl = cell.contentView.subviews.first as? UILabel ?? {
                let l = UILabel()
                l.numberOfLines = 0
                l.font = UIFont.systemFont(ofSize: 20, weight: .bold)
                l.textColor = ThemeManager.shared.text
                l.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(l)
                NSLayoutConstraint.activate([
                    l.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
                    l.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                    l.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
                    l.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
                ])
                return l
            }()
            lbl.text = item.title
            lbl.textColor = ThemeManager.shared.text
            return cell

        case .category:
            let cell = dequeueOrCreate("categoryCell")
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            let lbl = cell.contentView.subviews.first as? UILabel ?? {
                let l = UILabel()
                l.numberOfLines = 0
                l.font = UIFont.systemFont(ofSize: 14, weight: .medium)
                l.textColor = ThemeManager.shared.secondaryText
                l.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(l)
                NSLayoutConstraint.activate([
                    l.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 4),
                    l.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                    l.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
                    l.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8)
                ])
                return l
            }()
            lbl.text = item.category
            lbl.textColor = ThemeManager.shared.secondaryText
            return cell

        case .imageSectionHeader:
            let cell = dequeueOrCreate("imageHeader")
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            let lbl = cell.contentView.subviews.first as? UILabel ?? {
                let l = UILabel()
                l.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                l.textColor = ThemeManager.shared.text
                l.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(l)
                NSLayoutConstraint.activate([
                    l.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 14),
                    l.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                    l.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
                    l.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -4)
                ])
                return l
            }()
            lbl.text = loc("related_images", ["count": String(images.count)])
            lbl.textColor = ThemeManager.shared.text
            return cell

        case .images:
            let cell = dequeueOrCreate("imagesCell") as? ImageGridCell ?? ImageGridCell(style: .default, reuseIdentifier: "imagesCell")
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.configure(with: images) { [weak self] index in
                guard let self = self, index < self.images.count else { return }
                let viewer = ImageViewerViewController(images: self.images, startIndex: index, title: self.item.title)
                self.navigationController?.pushViewController(viewer, animated: true)
            }
            return cell

        case .content:
            let cell = dequeueOrCreate("contentCell")
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            let tv = cell.contentView.subviews.first as? UITextView ?? {
                let t = UITextView()
                t.isEditable = false
                t.isSelectable = true
                t.isScrollEnabled = false
                t.backgroundColor = .clear
                t.font = UIFont.systemFont(ofSize: 16)
                t.textColor = ThemeManager.shared.text
                t.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
                t.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(t)
                NSLayoutConstraint.activate([
                    t.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                    t.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 12),
                    t.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -12),
                    t.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20)
                ])
                return t
            }()
            tv.text = item.content
            tv.textColor = ThemeManager.shared.text
            return cell
        }
    }

    private func dequeueOrCreate(_ identifier: String) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: identifier)
    }

    // MARK: - 动作
    @objc private func copyTapped() {
        UIPasteboard.general.string = item.content
        showToast(message: loc("copied_to_clipboard"))
    }

    @objc private func shareTapped() {
        var items: [Any] = ["【\(item.title)】\n\(item.content)"]
        items.append(contentsOf: images)
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = view
        vc.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY - 80, width: 0, height: 0)
        present(vc, animated: true)
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

// MARK: - 图片网格单元格（内联 UICollectionView）
public final class ImageGridCell: UITableViewCell,
                                   UICollectionViewDataSource,
                                   UICollectionViewDelegate,
                                   UICollectionViewDelegateFlowLayout {
    public let collectionView: UICollectionView
    private var images: [UIImage] = []
    private var onTap: ((Int) -> Void)?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 4, left: 16, bottom: 12, right: 16)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: ThumbnailCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    public func configure(with images: [UIImage], onTap: @escaping (Int) -> Void) {
        self.images = images
        self.onTap = onTap
        // 根据图片数量动态调整高度（竖屏适配：每行2张图片）
        let perRow: CGFloat = 2
        let rows = max(1, ceil(CGFloat(images.count) / perRow))
        let cellWidth = (UIScreen.main.bounds.width - 16*2 - 8) / perRow
        let cellHeight: CGFloat = cellWidth * 0.75 // 4:3 比例
        let lineSpacing: CGFloat = 8
        let insetTop: CGFloat = 4, insetBottom: CGFloat = 12
        let total = insetTop + rows * cellHeight + (rows - 1) * lineSpacing + insetBottom
        // 更新 height 约束
        collectionView.constraints.filter { $0.firstAttribute == .height }.forEach { $0.isActive = false }
        collectionView.heightAnchor.constraint(equalToConstant: total).isActive = true
        collectionView.reloadData()
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.reuseID, for: indexPath) as! ThumbnailCell
        cell.configure(with: images[indexPath.item])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTap?(indexPath.item)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let total = collectionView.bounds.width - 16 * 2 - 8
        let w = max(80, floor(total / 2))
        return CGSize(width: w, height: w * 0.75)
    }
}
