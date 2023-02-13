//
//  CustomTableViewCell.swift
//  Note
//
//  Created by Kirill  Kostenko  on 09.02.2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    struct ViewModel {
        let image: UIImage?
        let text: String
       
        
    }

    private lazy var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sometext"
        return label
    }()
 
    
    private var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.myImageView.image = nil

    }
    
    func setup(with datas: Notes?) {
        self.myImageView.image = UIImage(systemName: "pencil")
        noteLabel.text = datas?.text ?? ""
    }
    
    
    private func setupView() {
        self.addSubview(self.myImageView)
        self.addSubview(noteLabel)
    
        
        NSLayoutConstraint.activate([
            self.myImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.myImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.myImageView.widthAnchor.constraint(equalTo: self.myImageView.heightAnchor, multiplier: 1.0),
            self.noteLabel.leadingAnchor.constraint(equalTo: self.myImageView.trailingAnchor, constant: 16),
            self.noteLabel.centerYAnchor.constraint(equalTo: self.myImageView.centerYAnchor),
            self.noteLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 48),
            
        ])
    }

}
