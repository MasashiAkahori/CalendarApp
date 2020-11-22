//
//  Calendar.swift
//  CalendarApp
//
//  Created by 赤堀雅司 on 9/10/20.
//

import UIKit
import Firebase
import FSCalendar
import FirebaseDatabase
import FirebaseAuth

class CalendarViewController: UIViewController {
  
  fileprivate var calendar: FSCalendar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    view.backgroundColor = UIColor.white
    
    navigationItem.title = "Guest"
    checkIfUserIsLoggedIn()
    
    calendar = FSCalendar(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 300))
    calendar.scrollDirection = .vertical
    calendar.scope = .month
    self.view.addSubview(calendar)
    
    
    
    
  }
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  func checkIfUserIsLoggedIn() {
    //アプリを開いたときに実行されるfunction
    //uidが既にあるかどうか確認する
  if Auth.auth().currentUser?.uid == nil {
    //Auth.auth().currentUser で現在loginしているユーザーの情報にアクセスできる
    //uid(ユーザーID)がない時、handleLogoutを実行する
    perform(#selector(handleLogout), with: nil, afterDelay: 0)
  } else {
    //uid(ユーザーID)がある時、fetchUserAndSetupnavBarTitleを実行する
    fetchUserAndSetupnavBarTitle()
  }
  }
  
  func fetchUserAndSetupnavBarTitle() {
    //uid があった時
    guard let uid = Auth.auth().currentUser?.uid else {
      return
    }
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      
      //observeSingleEnventは1度だけトリガーするmethodで、データの１回読み取りに使う
      //snapshot にはdictionaryの情報が入っている(databseに入れた情報など)
      
      
     
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
    //    self.navigationItem.title = dictionary["name"] as? String
        
        let user = User(dictionary: dictionary)
        self.setupNavBarWithUser(user: user)
      }
    }, withCancel: nil)
  }
  
  func setupNavBarWithUser(user: User) {
    let nameLabel = UILabel()
    nameLabel.text = user.name
    nameLabel.textColor = UIColor.black
    
    
            
    self.navigationItem.titleView = nameLabel

  }
  
  
  @objc func handleLogout() {
    do {
      try Auth.auth().signOut()
      //Auth.auth().signOut() でauth に登録してあるlogin情報をサインアウトに変更できる(signIn --> signOut に変える)
    } catch let logoutError {
      print(logoutError)
    }
    
    let loginController = LoginController()
    loginController.calendarViewController = self
    //他のControllerにおいて、signOutした状態にする
    
    present(loginController, animated: true, completion: nil)
    //present　は他のViewを割り込むように表示させるメソッド
    print("Logout")
  }
  
}


extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
//  func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//    let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position)
//    cell.imageView.contentMode = .scaleToFill
//    return cell
//  }
}
