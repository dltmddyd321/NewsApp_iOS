//
//  ViewController.swift
//  SentiTable
//
//  Created by 이승용 on 2021/06/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableMain: UITableView!
    
    var newsData :Array<Dictionary<String, Any>>? //뉴스 제목을 담을 문자형 배열 + ?:값이 비어있을 수도 있다고 명시
    
    //1. http 통신 방법 - urlsession
    //2. JSON 데이터 사용 {"key":"value"} {["1000","100","10000"]}
    //3. 테이블뷰의 데이터 매칭 -> 통보! 그리기!
    //4. background : network
    
    //News API 등록 및 파싱
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=bef70722d1874f65a72dcb962491fc8c")!) { (data, response, error) in
            
            if let dataJson = data {
                //json parsing
                //do~catch : 오류 상황에 대한 코드를 처리하는 문법
                do {
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    //Json 파일의 데이터 내용을 읽어온다.   //Value의 형태를 알 수 없을 때 Any 사용
                    //JSON을 처리할 수 있는 Dicitionary 사용
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    self.newsData = articles
                    
                    DispatchQueue.main.async {
                        //데이터가 오는 즉시 비동기 상태로 화면에 표현
                        self.TableMain.reloadData() // 데이터를 가져왔다고 알림(통보)
                    }
                    
//                    for (idx, value) in  articles.enumerated() { //배열의 값을 가져오는 방식
//                        if let v = value as? Dictionary<String, Any> {
//                            print("\(v["title"])") //title values만 가져오기
//                            v["description"]
//                        }
//                    }
//                    {
//                    "status": "ok",
//                    "totalResults": 34,
//                    -"articles": [
//                    -{
//                    -"source": {
//                    "id": "google-news",
//                    "name": "Google News"
//                    },
//                    "author": null,
//                    "title": "3분기 전기요금 동결…“높은 물가상승률 우려” / KBS 2021.06.21. - KBS News",
                }
                catch {}
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 데이터 개수에 대한 명시 -> 숫자
        
        if let news = newsData {
            return news.count //뉴스 개수만큼 반환
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 데이터 성질에 대한 명시
        // 1번 방법 : 임의의 셀 만들기
        // 2번 방법 : 스토리보드 + id -> 가장 많이 선호하는 방식
        //let cell = UITableViewCell.init(style: .default, reuseIdentifier: "TableCellType1")
        let cell = TableMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        //id가 Type1이고, 순번으로 다시 셀을 정의하여 재사용한다.
        //as : 부모와 자식 관계에서 친자를 확인하는 기능 / as! -> 확실하다.
        
        let idx = indexPath.row
        if let news = newsData{
            
            let row = news[idx] //뉴스의 idx 번지의 row를 가져온다.
            if let r = row as? Dictionary<String, Any> { //가져온 row를 딕셔너리화
                print("TITLE :: \(r)")
                if let title = r["title"] as? String{
                    cell.LabelText.text = title
                }
                 //딕셔너리화된 row에서 제목을 추출하여 라벨로 배치한다.
            }
            
        }
            
        //cell.textLabel?.text = "\(indexPath.row)" //숫자를 순차적으로 등록한다.
        
        return cell
    }
    
    
    //Click Event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("CLICK !!! \(indexPath.row)")
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController
        
        if let news = newsData {
            let row = news[indexPath.row]//뉴스의 idx 번지의 row를 가져온다.
            if let r = row as? Dictionary<String, Any> { //가져온 row를 딕셔너리화
                
                if let imageUrl = r["urlToIamge"] as? String{
                    controller.imageUrl = imageUrl
                }
                if let desc = r["description"] as? String{
                    controller.desc = desc
                }
                 //딕셔너리화된 row에서 제목을 추출하여 라벨로 배치한다.
            }
        }
        
        //이동 (수동)
        showDetailViewController(controller, sender: nil)
        
    }
    
    //(2) 세그웨이 : 부모(가나다) - 자식(가나다)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id {
            if let controller = segue.destination as? NewsDetailController {
                
                if let news = newsData {
                    if let indexPath = TableMain.indexPathForSelectedRow {
                        let row = news[indexPath.row]//뉴스의 idx 번지의 row를 가져온다.
                        if let r = row as? Dictionary<String, Any> { //가져온 row를 딕셔너리화
                            print("TITLE :: \(r)")
                            if let imageUrl = r["urlToIamge"] as? String{
                                controller.imageUrl = imageUrl
                            }
                            if let desc = r["description"] as? String{
                                controller.desc = desc
                            }
                             //딕셔너리화된 row에서 제목을 추출하여 라벨로 배치한다.
                        }
                    }
                }
            }
        }
        //이동 (자동)
    }
    
    // 1. 디테일 : 상세화면 구성
    // 2. 값을 전송 (1) - tableView delegate / (2) - story board (segue)
    // 3. 화면 이동 알고리즘 (이동하기전에 값을 미리 세팅해야한다.)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TableMain.delegate = self
        TableMain.dataSource = self
        //self는 나 자신에게 있는 함수를 찾아가라는 의미 (this와 유사한 느낌)
        
        getNews()
    }

    //table View : 테이블로 구성된 View -> 여러 개의 행이 모여있는 목록 View
    //사용하는 이유 : 정형화된 시각화 - 전화번호부
    
    // 1. 테이블에 사용되는 데이터가 무엇인가? - 전화번호 내용
    // 2. 테이블에 사용되는 데이터의 양은 얼마인가? - 100, 1000, ~
    // 3. 클릭을 통한 알고리즘
}

