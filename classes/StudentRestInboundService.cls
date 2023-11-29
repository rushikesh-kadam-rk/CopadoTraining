@RestResource(urlMapping='/studentsInfo/*')
global class StudentRestInboundService {

    global class StudentInfo{
        String studentName{get; set;}
        String studentAddress{get; set;}
        String studentPhone{get; set;}
        String schoolName{get; set;}
    }

    @HttpGet
    global static StudentInfo getStudent(){
        RestRequest request = RestContext.Request;

        String studentId = request.requestURI.subString(request.RequestURI.lastIndexOf('/')+1);

        Student__c studentRecord = [SELECT Id, Address__c, Student_Name__c, Phone_Number__c, School__r.Name 
                                    FROM Student__c
                                    WHERE Id =: studentId];

        StudentInfo studentWrapper = new StudentInfo();
        studentWrapper.studentName = studentRecord.Student_Name__c;
        studentWrapper.studentAddress = studentRecord.Address__c;
        studentWrapper.studentPhone = studentRecord.Phone_Number__c;
        studentWrapper.schoolName = studentRecord.School__r.Name;

        // Account acc = new Account();
        // acc.Name = 'Trying to create Account from HTTPGET request';
        // Database.insert(acc);

        return studentWrapper;

    }
}