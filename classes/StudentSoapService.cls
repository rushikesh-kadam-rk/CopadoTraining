global class StudentSoapService {
    webService static Student__c getStudent(String studentId){
        return [SELECT Id, Student_Name__c, Phone_Number__c, School__c, Email__c FROM Student__c WHERE Id =: studentId];
    }
}