import UIKit

// MARK: - 文本协议/隐私政策文档视图
public final class TextDocumentViewController: UIViewController {
    private let filename: String
    private let displayTitle: String
    private let textView = UITextView()

    public init(filename: String, displayTitle: String) {
        self.filename = filename
        self.displayTitle = displayTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = displayTitle
        view.backgroundColor = ThemeManager.shared.background
        overrideUserInterfaceStyle = ThemeManager.shared.isDark ? .dark : .light

        textView.font = UIFont.systemFont(ofSize: 15)
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.textColor = ThemeManager.shared.text
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        loadContent()
    }

    private func loadContent() {
        var url: URL? = Bundle.main.url(forResource: filename, withExtension: nil)
        if url == nil, let p = Bundle.main.path(forResource: filename, ofType: nil) {
            url = URL(fileURLWithPath: p)
        }
        if let finalURL = url,
           let data = try? Data(contentsOf: finalURL),
           let str = String(data: data, encoding: .utf8) {
            textView.text = str
        } else {
            textView.text = "（文档暂时无法加载）"
        }
    }
}
