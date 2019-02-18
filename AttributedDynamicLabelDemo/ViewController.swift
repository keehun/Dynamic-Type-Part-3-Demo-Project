import UIKit

class ViewController: UIViewController {

    lazy var display: AttributedStringView = {
        let view = AttributedStringView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(display)
        NSLayoutConstraint.activate([
            display.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            display.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            display.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            display.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            ])
    }
}
