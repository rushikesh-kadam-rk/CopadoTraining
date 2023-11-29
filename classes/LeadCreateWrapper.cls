public with sharing class LeadCreateWrapper {
    @AuraEnabled public String mobile { get; set; }
    @AuraEnabled public String lastName { get; set; }
    @AuraEnabled public String accountId { get; set; }
    @AuraEnabled public String rmNameId { get; set; }
    @AuraEnabled public String dispositionStatus { get; set; }
    @AuraEnabled public String productValue { get; set; }
    @AuraEnabled public String productSubTypeValue { get; set; }
    @AuraEnabled public String promotionCode { get; set; }
    @AuraEnabled public String leadValue { get; set; }
    @AuraEnabled public String customerProfileValue { get; set; }
    @AuraEnabled public String constitutionValue { get; set; }
    @AuraEnabled public String emailId { get; set; }
    @AuraEnabled public String firstName { get; set; }
    @AuraEnabled public Date dob { get; set; }
    @AuraEnabled public String companyChange { get; set; }
    @AuraEnabled public Date doiValue { get; set; }

    @AuraEnabled public String keyManName { get; set; }
    @AuraEnabled public Integer loanAmount { get; set; }
    @AuraEnabled public Boolean assessedIncomeProgramValue { get; set; }
    @AuraEnabled public String propertyIdentifiedValue { get; set; }
    @AuraEnabled public Integer tenure { get; set; }
    @AuraEnabled public String propertyCategoryValue { get; set; }
    @AuraEnabled public String depositionRemark { get; set; }
    @AuraEnabled public String currentCitySearch { get; set; }
    @AuraEnabled public String officeCitySearch { get; set; }
    @AuraEnabled public String leadRecordId { get; set; }
    @AuraEnabled public String leadClosureValue { get; set; }
    @AuraEnabled public String lmsLeadId { get; set; }
    @AuraEnabled public String referralCode { get; set; }
    @AuraEnabled public String leadStatus { get; set; }
}