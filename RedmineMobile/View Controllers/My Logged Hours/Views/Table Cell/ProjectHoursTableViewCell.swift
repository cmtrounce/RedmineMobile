//
//  ProjectHoursTableViewCell.swift
//  RedmineMobile
//
//  Created by Callum Trounce on 27/01/2018.
//  Copyright © 2018 DTT. All rights reserved.
//

import UIKit
import SwiftDate

protocol LoggedHoursCellDelegate: class {
    func addHoursTapped(in cell: ProjectHoursTableViewCell)
    func cancelAddTapped(in cell: ProjectHoursTableViewCell)
    func confirmAddTapped(in cell: ProjectHoursTableViewCell)
    func startTimerTapped(in cell: ProjectHoursTableViewCell)
    func itemsForPicker(in cell: ProjectHoursTableViewCell) -> [String]
}

class ProjectHoursTableViewCell: UITableViewCell {

    lazy var activityPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityTextView: UITextField! {
        didSet {
            activityTextView.inputView = activityPicker
            activityTextView.delegate = self
        }
    }
    
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            amountTextField.delegate = self
        }
    }
    @IBOutlet weak var startTimerButton: UIButton! {
        didSet {
            startTimerButton.layer.cornerRadius = 5
            startTimerButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var activityDescriptionTextField: UITextField!
    @IBOutlet weak var descriptionStackView: UIStackView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.layer.cornerRadius = 5
            cancelButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var buttonContainerStackView: UIStackView! {
        didSet {
            buttonContainerStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton.layer.cornerRadius = 5
            confirmButton.clipsToBounds = true
            confirmButton.isEnabled = false
            confirmButton.alpha = 0.3
        }
    }
    @IBOutlet weak var amountStackView: UIStackView!
    
    @IBOutlet weak var logHoursHeadingLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var curvedView: UIView! {
        didSet {
            curvedView.layer.cornerRadius = 6
            curvedView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.layer.shadowColor = UIColor.darkGray.cgColor
            shadowView.layer.shadowOpacity = 0.1
            shadowView.layer.shadowOffset = .init(width: 0, height: 3)
        }
    }
    @IBOutlet weak var addHoursButton: UIButton! {
        didSet {
        
        }
    }
    
    
    weak var delegate: LoggedHoursCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        amountTextField.delegate = self
        activityTextView.delegate = self
        checkFieldsValid()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideLoggingView(hide: true)
        projectNameLabel.text = ""
        hoursLabel.text = ""
        activityTextView.text = ""
        activityDescriptionTextField.text = ""
        amountTextField.text = ""
        confirmButton.isEnabled = false
        confirmButton.alpha = 0.3
        checkFieldsValid()
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        delegate?.cancelAddTapped(in: self)
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        delegate?.confirmAddTapped(in: self)
    }
    
    @IBAction func addButtonTouched(_ sender: UIButton) {
        delegate?.addHoursTapped(in: self)
    }
    @IBAction func startTimerButtonTouched(_ sender: UIButton) {
        delegate?.startTimerTapped(in: self)
    }
}

extension ProjectHoursTableViewCell {
    
    func configure(timeEntry: ProjectTimeEntry, logVisible: Bool, delegate: LoggedHoursCellDelegate?) {
        projectNameLabel.text = timeEntry.project.name
        
        self.delegate = delegate
        hideLoggingView(hide: !logVisible)
        layoutIfNeeded()
        
        let value = Int(timeEntry.hoursLogged)
        let remainder: Double = timeEntry.hoursLogged - Double(value)
        let asMinutes = Int(60 * remainder)
        var hourString: String = ""
        
        if value > 0 {
            hourString.append( "\(value) hr ")
        }
        if asMinutes > 0 {
            hourString.append( "\(asMinutes) min")
        }
        
        hoursLabel.text = hourString
    }
    
    private func hideLoggingView(hide: Bool) {
        logHoursHeadingLabel.isHidden = hide
        buttonContainerStackView.isHidden = hide
        amountStackView.isHidden = hide
        activityDescriptionTextField.isHidden = hide
        addHoursButton.isHidden = !hide
        activityTextView.isHidden = hide
        descriptionStackView.isHidden = hide
        separatorView.isHidden = hide
        startTimerButton.isHidden = hide
        stackViewTopConstraint.constant = hide ? 0 : 30
        layoutIfNeeded()
    }
    
    fileprivate func checkFieldsValid() {
        
        guard let amountText = amountTextField.text, let activityText = activityTextView.text else {
            confirmButton.isEnabled = false
            confirmButton.alpha = 0.3
            return
        }
        
        if let number = NumberFormatter().number(from: amountText),
            number.floatValue > 0,
            activityText.count > 0 {
            confirmButton.isEnabled = true
            confirmButton.alpha = 1
        } else {
            confirmButton.isEnabled = false
            confirmButton.alpha = 0.3
        }
    }
}

extension ProjectHoursTableViewCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return delegate?.itemsForPicker(in: self)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activityTextView.text = delegate?.itemsForPicker(in: self)[row]
    }
}

extension ProjectHoursTableViewCell: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return delegate?.itemsForPicker(in: self).count ?? 0
    }

}

extension ProjectHoursTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
         checkFieldsValid()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFieldsValid()
    }
}
