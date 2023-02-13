//
//  new.swift
//  Note
//
//  Created by Kirill  Kostenko  on 10.02.2023.
//

import UIKit

class CustomViewNote:UIViewController{
    
    var noteText: String?
    var index : Int?
    var id : String?
    private lazy var coreManager = CoreDataManager.shared
    
    private lazy var textField: UITextView = {
        let text = UITextView()
        text.textAlignment = .left
        text.textColor = .black
        text.backgroundColor = .systemGray6
        text.layer.cornerRadius = 20
        text.tag = 0
        text.text = noteText
        text.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
 
    //public var completion: ((String, String) -> Void)?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextfield), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(updateTextfield), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if textField.text == "Новая заметка" {
            textField.text = ""
        }
        setupConstrait()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", image: nil, target: self, action: #selector(didTapSave))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.resignFirstResponder()
    }
    
    @objc private func updateTextfield(parameter:Notification){
        let userInfo = parameter.userInfo
        let keyBoardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyBoardFrame = self.view.convert(keyBoardRect, to: view.window)
        if parameter.name == UIResponder.keyboardWillHideNotification{
            textField.contentInset = UIEdgeInsets.zero
        } else{
            textField.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardFrame.height, right: 0)
            textField.scrollIndicatorInsets = textField.contentInset
        }
        textField.scrollRangeToVisible(textField.selectedRange)
        
    }
    
    
    
    private func setupConstrait(){
        self.view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            self.textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.textField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -350),
            
        ])
        
    }
    @objc func didTapSave(){
        let post = Post(text: textField.text, id: id ?? "")
        coreManager.updateNote(post: post)
        self.navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

    }

    }




