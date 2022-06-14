import UIKit

class MeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var schedules = ["점심약속", "시험", "저녁약속", "술약속", "롤약속", "코딩약속"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    @IBOutlet var ScheduleTable: UITableView!
    var selectedDate = Date()
    var totalSquares = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setCellsView()
        setMonthView()
        
        ScheduleTable.dataSource = self
        ScheduleTable.delegate = self
    }
    
    func setCellsView(){
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setMonthView(){ // 달력 나타내기
        totalSquares.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while(count <= 42){
            if(count <= startingSpaces || count - startingSpaces > daysInMonth){
                totalSquares.append(" ")
            }
            else{
                totalSquares.append(String(count - startingSpaces))
            }
            count+=1
        }
        
        monthLabel.text = CalendarHelper().yearString(date: selectedDate) + "년 " + CalendarHelper().monthString(date: selectedDate)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { // 지정된 섹션에 표시할 셀의 개수를 묻는 함수
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { // 컬렉션뷰의 지정된 위치에 표시할 셀을 요청하는 함수
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCell", for: indexPath) as! CalendarCell // 재사용되는 셀의 속성 초기화
        cell.dayLabel.text = totalSquares[indexPath.item]
        
        return cell
    }
    
    @IBAction func previousMonth(_ sender: UIButton) {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    override open var shouldAutorotate: Bool{ // 화면 방향전환여부 x
        return false
    }
    
    /// Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ScheduleTable.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) as! Cells
        cell.Txt.text = schedules[indexPath.row]
        return cell
    }
}
