//
//  CustomHeaderFooterView.swift
//  Note
//
//  Created by Kirill  Kostenko  on 09.02.2023.
//

import UIKit

class CustomHeaderFooterView: UITableViewHeaderFooterView {

struct ViewModel {
    let text: String
}

private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.textColor = .black
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
}()

override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    self.setupView()
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

func setup(with viewModel: ViewModel) {
    self.titleLabel.text = viewModel.text
}

private func setupView() {
    self.addSubview(self.titleLabel)
    
    NSLayoutConstraint.activate([
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
        self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
        self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        self.titleLabel.heightAnchor.constraint(equalToConstant: 50)
    ])
}
}
