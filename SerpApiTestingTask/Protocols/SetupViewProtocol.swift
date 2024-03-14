
import Foundation

protocol SetupViewProtocol {
    func setupView()
    func setupViews()
    func addViews()
    func setupConstraints()
}

extension SetupViewProtocol {
    func setupView() {
        setupViews()
        addViews()
        setupConstraints()
    }
}
