import UIKit

// MARK: - 图片资源管理
public final class ImageAssetStore {
    public static let shared = ImageAssetStore()

    // 标题 -> 图片文件名数组
    public private(set) var imagesByTitle: [String: [String]] = [:]

    private init() {
        loadMapping()
    }

    private func loadMapping() {
        var url: URL? = Bundle.main.url(forResource: "image_mapping", withExtension: "json")
        if url == nil, let p = Bundle.main.path(forResource: "image_mapping", ofType: "json") {
            url = URL(fileURLWithPath: p)
        }
        guard let finalURL = url,
              let data = try? Data(contentsOf: finalURL),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: [String]]
        else { return }
        imagesByTitle = json
    }

    /// 通过标题查询关联的图片文件名
    public func imageNames(for title: String) -> [String] {
        return imagesByTitle[title] ?? []
    }

    /// 按文件名加载图片（从 Bundle 直接读取）
    public func image(named filename: String) -> UIImage? {
        // 先尝试 UIImage(named:) —— Swift Playground 的 Resources 目录可通过这个方式访问
        if let img = UIImage(named: filename) {
            return img
        }
        // 作为回退：按 path(forResource:ofType:) 读取
        // 扩展名可能是 .jpg / .png 等；尝试多种
        let exts = ["jpg", "jpeg", "png", "gif", "bmp"]
        for ext in exts {
            let base = (filename as NSString).deletingPathExtension
            if let p = Bundle.main.path(forResource: base, ofType: ext),
               let data = try? Data(contentsOf: URL(fileURLWithPath: p)) {
                return UIImage(data: data)
            }
        }
        // 再尝试把 filename 当做完整文件名
        if let p = Bundle.main.path(forResource: filename, ofType: nil),
           let data = try? Data(contentsOf: URL(fileURLWithPath: p)) {
            return UIImage(data: data)
        }
        return nil
    }

    /// 按标题加载所有关联图片
    public func images(for title: String) -> [UIImage] {
        var result: [UIImage] = []
        for name in imageNames(for: title) {
            if let img = image(named: name) {
                result.append(img)
            }
        }
        return result
    }
}

// MARK: - 图片缩略图单元格
public final class ThumbnailCell: UICollectionViewCell {
    public static let reuseID = "ThumbnailCell"

    private let imageView = UIImageView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = ThemeManager.shared.surface
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    public func configure(with image: UIImage) {
        imageView.image = image
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

// MARK: - 图片全屏查看控制器
public final class ImageViewerViewController: UIViewController, UIScrollViewDelegate {
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()

    public init(image: UIImage, title: String?) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.title = title
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.shared.background
        overrideUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light

        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])

        // 双击缩放
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self, action: #selector(onShare)
        )
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    @objc private func onDoubleTap(_ g: UITapGestureRecognizer) {
        if scrollView.zoomScale > 1.0 {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let pt = g.location(in: imageView)
            let w = imageView.bounds.width / 2.5
            let h = imageView.bounds.height / 2.5
            scrollView.zoom(to: CGRect(x: pt.x - w/2, y: pt.y - h/2, width: w, height: h), animated: true)
        }
    }

    @objc private func onShare() {
        guard let img = imageView.image else { return }
        let vc = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
