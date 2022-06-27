
import UIKit


class AddScheduleViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let startTimePicker = UIDatePicker()
    private let endTimePicker = UIDatePicker()
    private var startDate: String?
    private var endDate: String?
    private var startTime: String?
    private var endTime: String?
    
    var selectedDate2 = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)
    
    override func viewDidLoad() {
        self.configureStartDatePicker()
        self.configureEndDatePicker()
        self.configureStartTimePicker()
        self.configureEndTimePicker()
        
        super.viewDidLoad()
    }
    
    
    
    private func configureStartDatePicker(){
        self.startDatePicker.datePickerMode = .date
        self.startDatePicker.preferredDatePickerStyle = .wheels
        self.startDatePicker.addTarget(self, action: #selector(startDatePickerValueDidChange(_:)), for: .valueChanged)
        
        self.startDateTextField.text = CalendarHelper().dateToString(date: selectedDate)
        
        self.startDate = CalendarHelper().dateToString(date: selectedDate)
        
        self.startDateTextField.inputView = self.startDatePicker
        
    }
    private func configureEndDatePicker(){
        self.endDatePicker.datePickerMode = .date
        self.endDatePicker.preferredDatePickerStyle = .wheels
        self.endDatePicker.addTarget(self, action: #selector(endDatePickerValueDidChange(_:)), for: .valueChanged)
        self.endDateTextField.text = CalendarHelper().dateToString(date: selectedDate)
        self.endDate = CalendarHelper().dateToString(date: selectedDate)
        self.endDateTextField.inputView = self.endDatePicker
    }
    
    private func configureStartTimePicker(){
        self.startTimePicker.datePickerMode = .time
        self.startTimePicker.preferredDatePickerStyle = .wheels
        self.startTimePicker.addTarget(self, action: #selector(startTimePickerValueDidChange(_:)), for: .valueChanged)
        self.startTimeTextField.text = CalendarHelper().timeToString(date: selectedDate)
        self.startTime = CalendarHelper().timeToString(date: selectedDate)
        
        self.startTimeTextField.inputView = self.startTimePicker
    }
    private func configureEndTimePicker(){
        self.endTimePicker.datePickerMode = .time
        self.endTimePicker.preferredDatePickerStyle = .wheels
        self.endTimePicker.addTarget(self, action: #selector(endTimePickerValueDidChange(_:)), for: .valueChanged)
        self.endTimeTextField.text = CalendarHelper().timeToString(date: selectedDate)
        self.endTime = CalendarHelper().timeToString(date: selectedDate)
        self.endTimeTextField.inputView = self.endTimePicker
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBAction func tapConfirmButton(_ sender: UIButton) {

        let newSchedule = Schedule(title: titleTextField.text!, startDate: startDate!, endDate: endDate!, startTime: startTime!, endTime: endTime!)

        scheduleList.append(newSchedule)
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func startDatePickerValueDidChange(_ datePicker: UIDatePicker){
        let formater = DateFormatter()
        formater.dateFormat = "yyyy년 MM월 dd일"
        formater.locale = Locale(identifier: "ko_KR")
        
        self.startDate = CalendarHelper().dateToString(date: datePicker.date)
        
        self.startDateTextField.text = formater.string(from: datePicker.date)
    }
    @objc private func endDatePickerValueDidChange(_ datePicker: UIDatePicker){
        let formater = DateFormatter()
        formater.dateFormat = "yyyy년 MM월 dd일"
        formater.locale = Locale(identifier: "ko_KR")
        
        self.endDate = CalendarHelper().dateToString(date: datePicker.date)
        
        self.endDateTextField.text = formater.string(from: datePicker.date)
    }
    
    @objc private func startTimePickerValueDidChange(_ datePicker: UIDatePicker){
        let formater = DateFormatter()
        formater.dateFormat = "a hh시 mm분"
        formater.locale = Locale(identifier: "ko_KR")
        self.startTime = CalendarHelper().dateToString(date: datePicker.date)
        self.startTimeTextField.text = formater.string(from: datePicker.date)
    }
    @objc private func endTimePickerValueDidChange(_ datePicker: UIDatePicker){
        let formater = DateFormatter()
        formater.dateFormat = "a hh시 mm분"
        formater.locale = Locale(identifier: "ko_KR")
        self.endTime = CalendarHelper().dateToString(date: datePicker.date)
        self.endTimeTextField.text = formater.string(from: datePicker.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
