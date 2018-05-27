//
//  ViewController.swift
//  Swift4
//
//  Created by Chathura Lakmal on 10/10/17.
//  Copyright © 2017 Chathura Lakmal. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //readAndInsertJsonData()
        //getStudentData(studentId: 101)
        //getStudentCourseData(studentId: 101, courseId: 21)
        //updateCourseData(studentId: 101, courseId: 21, courseName: "Sinhala")
        //getStudentCourseData(studentId: 101, courseId: 21)
        //deleteCourseData(studentId: 101, courseId: 21)
        //getStudentCourseData(studentId: 101, courseId: 21)
        //DBManager.sharedInstanceDBManager.deleteAllStudentData()
        //getStudentData(studentId: 101)
    }
    
    private func readAndInsertJsonData() {
        do {
            if let file = Bundle.main.url(forResource: "coreDataSample", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    DBManager.sharedInstanceDBManager.insertStudentData(studentJson: object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     //Fetch Data
    func retrieveAllData(){
        print(DBManager.sharedInstanceDBManager.fetchStudentData().count)
        //I assume Core Data only has one object thats why we use [0]. or else we can loop if there is more
        let studentObject = DBManager.sharedInstanceDBManager.fetchStudentData()[0]
        print("Student Id : \(studentObject.studentId)")
        print("Student Name : \(studentObject.firstName!) \(studentObject.lastName!)")
        print("Student Email : \(studentObject.email!)")
        
        print("--COURSES--------")
        let coursesInfo = studentObject.courses?.allObjects as! [Course]
        
        for(_,element) in coursesInfo.enumerated(){
            print("Course Id : \(element.courseId)")
            print("Course Name : \(element.courseName!)")
        }
    }
    
   //Get Student by Id
    func getStudentData(studentId: Int64){
       let studentObject = DBManager.sharedInstanceDBManager.fetchStudentData(studentId: studentId) as [Student]
         print("Student : \(studentObject.count)")
    }
    
    //Get course by student and course Id
    func getStudentCourseData(studentId: Int64,courseId: Int64){
        let courseObject = DBManager.sharedInstanceDBManager.fetchCourseData(studentId: studentId, courseId: courseId) as [Course]
        for(_,element) in courseObject.enumerated(){
            print("Course Name : \(element.courseName!)")
        }
        
    }
    
    //Update Data
    //Update course by student and course Id
    func updateCourseData(studentId: Int64, courseId: Int64, courseName: String){
        DBManager.sharedInstanceDBManager.updateCourseData(studentId: studentId, courseId: courseId, courseName: courseName)
        
    }
    
    
    //Delete
    //Delete Data by course Id
    func deleteCourseData(studentId:Int64, courseId: Int64){
        DBManager.sharedInstanceDBManager.deleteCourseData(studentId: studentId, courseId: courseId)
    }


}

