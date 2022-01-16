//
//  ViewController.swift
//  FMWithXML
//
//  Created by Ankit on 14/01/22.
//

import UIKit

class ViewController: UIViewController {

    lazy var textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please enter url here"
        textField.text = "http://phorus.vtuner.com/setupapp/phorus/asp/browsexml/navXML.asp?gofile=LocationLevelFourCityUS-North%20America-New%20York-ExtraDir-1-Inner-14&bkLvl=9237&mac=a8f58cd9758b710c43a7a63762e755947f83f0ad9194aa294bbaee55e0509e02&dlang=eng&fver=1.4.4.2299%20(20150604)&hw=CAP:%201.4.0.075%20MCU:%201.032%20BT:%200.002"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.keyboardType = .URL
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    
    lazy var button : UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config, primaryAction: searchAction)
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var searchAction = UIAction(title: "Submit") { (action) in
        guard let text = self.textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty, let url = URL(string: text) else {
            print("blank")
            return
        }
        
        let controller = ListViewController(url: url)
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textField)
        view.addConstraints([textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20), textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20), textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)])
        
        view.addSubview(button)
        view.addConstraints([button.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 20), button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)])
    }
   
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        button.sendAction(searchAction)
        return true
    }
}

