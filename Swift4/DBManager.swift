//
//  DBManager.swift
//  Swift4
//
//  Created by Chathura Lakmal on 10/26/17.
//  Copyright © 2017 Chathura Lakmal. All rights reserved.
//

import UIKit
import CoreData

class DBManager{
    static let sharedInstanceDBManager = DBManager()
    
    //Insert Method
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func insertStudentData(studentJson:[String:Any]){

        let context = appDelegate.persistentContainer.viewContext
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: context) as! Student

    
        student.firstName = studentJson["first_name"] as? String
        student.lastName = studentJson["last_name"] as? String
        student.email = studentJson["email"] as? String
        student.studentId = (studentJson["student_id"] as? Int64)!
        //Loop Course Data
        if let courseArray = studentJson["courses"] as? [[String : Any]] {
            // 2. Execute a loop (for-in) to access each element of the array.
            for element in courseArray {
                let course = NSEntityDescription.insertNewObject(forEntityName: "Course", into: context) as! Course
                //let course = Course()
                if let value = element["course_name"] as? String {
                    course.courseName = value
                }
                if let value = element["course_id"] as? Int64 {
                    course.courseId = value
                }
                student.addToCourses(course)
            }
        }
        
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }

    }
    
    
    //Fetch All Student Data
    func fetchStudentData()->[Student]{
        var studentData = [Student]()
        do{
            studentData = try context.fetch(Student.fetchRequest())
        }catch{
            print("ERROR FETCHING DATA")
        }
        return studentData
    }
    
    //Fetch Student Data for Student Id
    
    func fetchStudentData(studentId:Int64)->[Student]{
        var studentData = [Student]()
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "studentId==\(studentId)")
        do{
            studentData = try context.fetch(fetchRequest)
        }catch{
            print("ERROR FETCHING DATA")
        }
        return studentData
    }
    
    //Fetch Course Data for Student Id and Course Id
    
    func fetchCourseData(studentId:Int64, courseId:Int64)->[Course]{
        var courseData = [Course]()
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "ANY students.studentId ==\(studentId) && courseId == \(courseId)")
        do{
            courseData = try context.fetch(fetchRequest)
        }catch{
            print("ERROR FETCHING DATA")
        }
        return courseData
    }
    
    
    //Update Method
    
    func updateCourseData(studentId:Int64, courseId:Int64, courseName:String){
        var courseData = [Course]()
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "ANY students.studentId ==\(studentId) && courseId == \(courseId)")
        do{
            courseData = try context.fetch(fetchRequest)
            if(courseData.count != 0){
                let course = courseData[0]
                course.setValue(courseName, forKey: "courseName")
                
                do{
                    try context.save()
                }catch{
                     print("ERROR SAVING DATA")
                }
            }
        }catch{
            print("ERROR FETCHING DATA")
        }
    }
    
    
    
    
    //Delete Method
    func deleteCourseData(studentId:Int64, courseId:Int64){
        var courseData = [Course]()
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "ANY students.studentId ==\(studentId) && courseId == \(courseId)")
        do{
            courseData = try context.fetch(fetchRequest)
            do{
                for object in courseData {
                    context.delete(object)
                }
                
                try context.save()
            }catch{
                  print("ERROR SAVING DATA")
            }

        }catch{
            print("ERROR FETCHING DATA")
        }
    }
    
    func deleteAllCourseData(){
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
     
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func deleteAllStudentData(){
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

}
