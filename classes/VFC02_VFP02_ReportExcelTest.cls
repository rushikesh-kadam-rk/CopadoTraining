/* 
Version        : 1.00
Company        : Accenture
Date           : 17.OCT.2013
Author         : Ritesh Shahare
Description    : Test class for controller class VFC02_VFP02_ReportExcel
History        : 
                1.00 17.OCT.2013 Ritesh Shahare- Created
*/

@IsTest public with sharing class VFC02_VFP02_ReportExcelTest
{
    @IsTest static void testConstructor() 
    {
        // Create test record for current running salesforce org.
        Organization_Details__c defaultOrg = new Organization_Details__c(name='00Dg000000064R',MasterOrg__c=true,Organization_Name__c='Org 1',orgURL__c='https://na1.salesforce.com/');
        insert defaultOrg;
        // Create test record for salesforce org with which we are comparing the profiles data.
        Organization_Details__c compareOrg = new Organization_Details__c(name='00Dg000000064Q',MasterOrg__c=false,Organization_Name__c='Org 2',orgURL__c='https://na1.salesforce.com/');        
        insert compareOrg;
        
        // Create test profile report data for the profiles from current running org.
        ProfileData__c pProfileIDs = new ProfileData__c(DataType__c = 'ProfileIDs',Organization_Details__c = defaultOrg.id,name='Profile1');
        insert pProfileIDs;
        ProfileData__c pDataProfileIDs = new ProfileData__c(DataType__c = 'DataProfileIDs',Organization_Details__c = defaultOrg.id,name='Profile1');
        insert pDataProfileIDs;
        ProfileData__c pDeleteReportData = new ProfileData__c(DataType__c = 'DeleteReportData',Organization_Details__c = defaultOrg.id,name='Deleted');
        insert pDeleteReportData;
        ProfileData__c pReportType = new ProfileData__c(DataType__c = 'ReportType',Organization_Details__c = defaultOrg.id,name='Yes',Data1__c='Yes');
        insert pReportType;
        ProfileData__c pDataCategories1 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = defaultOrg.id,name='Custom App Settings');
        insert pDataCategories1;
        ProfileData__c pDataCategories2 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = defaultOrg.id,name='Tab Settings');
        insert pDataCategories2;
        ProfileData__c pDataCategories3 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = defaultOrg.id,name='Record Type Settings');
        insert pDataCategories3;
        ProfileData__c pDataCategories4 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = defaultOrg.id,name='Administrative & General User Permissions');
        insert pDataCategories4;
        ProfileData__c pDataCategories5 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = defaultOrg.id,name='Object Permissions');
        insert pDataCategories5;
        ProfileData__c pDataCategories6 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = defaultOrg.id,name='Desktop Integration Clients');
        insert pDataCategories6;
        ProfileData__c pDataCategories7 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = defaultOrg.id,name='Login Hours');
        insert pDataCategories7;
        ProfileData__c pDataCategories8 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = defaultOrg.id,name='Login IP Ranges');
        insert pDataCategories8;
        ProfileData__c pDataCategories9 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = defaultOrg.id,name='Apex Class Access');
        insert pDataCategories9;
        ProfileData__c pDataCategories10 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = defaultOrg.id,name='Visualforce Page Access');
        insert pDataCategories10;
        ProfileData__c pDateTimeStamp = new ProfileData__c(DataType__c = 'DateTimeStamp',Organization_Details__c = defaultOrg.id,DTime__c = System.Today(),name='Profile1');
        insert pDateTimeStamp;
        ProfileData__c pasData = new ProfileData__c(DataType__c = 'Custom App Settings',Organization_Details__c = defaultOrg.id,name='Profile1',Data1__c='App1',Data2__c='Checked',Data3__c='Not Checked');
        insert pasData;
        ProfileData__c ptsData = new ProfileData__c(DataType__c = 'Tab Settings',Organization_Details__c = defaultOrg.id,name='Profile1',Data1__c='Home',Data2__c='Default On');
        insert ptsData;
        ProfileData__c prtData = new ProfileData__c(DataType__c = 'Record Type Settings',Organization_Details__c = defaultOrg.id,name='Profile1',Data1__c='Account',Data2__c='Recordtype1');
        insert prtData;
        ProfileData__c pagData = new ProfileData__c(DataType__c = 'Administrative & General User Permissions',Organization_Details__c = defaultOrg.id,name='Profile1',Data1__c='API Enabled',Data2__c='Checked');
        insert pagData;
        ProfileData__c popData = new ProfileData__c(DataType__c = 'Object Permissions',Organization_Details__c = defaultOrg.id,name='Profile1',Data1__c='Issue Comments',Data2__c='Checked',Data3__c='Checked',Data4__c='Checked',Data5__c='Checked',Data6__c='Checked',Data7__c='Checked');
        insert popData;
        ProfileData__c pdiData = new ProfileData__c(DataType__c = 'Desktop Integration Clients',Organization_Details__c = defaultOrg.id,name='Profile1',Data1__c='Offline',Data2__c='Off (access denied)');
        insert pdiData;
        ProfileData__c plhData = new ProfileData__c(DataType__c = 'Login Hours',Organization_Details__c = defaultOrg.id,name='Profile1',Data1__c='Sunday',Data2__c='11am',Data3__c='11pm');
        insert plhData;
        ProfileData__c pipData = new ProfileData__c(DataType__c = 'Login IP Ranges',Organization_Details__c = defaultOrg.id,name='Profile1',Data1__c='1.1.1.1',Data2__c='2.2.2.2');
        insert pipData;
        ProfileData__c pacData = new ProfileData__c(DataType__c = 'Apex Class Access',Organization_Details__c = defaultOrg.id,name='Profile1',Data1__c='Test1');
        insert pacData;
        ProfileData__c pvfData = new ProfileData__c(DataType__c = 'Visualforce Page Access',Organization_Details__c = defaultOrg.id,name='Profile1',Data1__c='Test1');
        insert pvfData;
        
        // Create test profile report data for the profiles from salesforce org against which we will be comparing our data with.
        ProfileData__c pProfileIDs2 = new ProfileData__c(DataType__c = 'ProfileIDs',Organization_Details__c = compareOrg.id,name='Profile1');
        insert pProfileIDs2;
        ProfileData__c pDataProfileIDs2 = new ProfileData__c(DataType__c = 'DataProfileIDs',Organization_Details__c = compareOrg.id,name='Profile1');
        insert pDataProfileIDs2;
        ProfileData__c pDeleteReportData2 = new ProfileData__c(DataType__c = 'DeleteReportData',Organization_Details__c = compareOrg.id,name='Deleted');
        insert pDeleteReportData2;
        ProfileData__c pReportType3 = new ProfileData__c(DataType__c = 'ReportType',Organization_Details__c = compareOrg.id,name='Yes',Data1__c='Yes');
        insert pReportType3;
        ProfileData__c pDataCategories12 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = compareOrg.id,name='Custom App Settings');
        insert pDataCategories12;
        ProfileData__c pDataCategories22 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = compareOrg.id,name='Tab Settings');
        insert pDataCategories22;
        ProfileData__c pDataCategories32 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = compareOrg.id,name='Record Type Settings');
        insert pDataCategories32;
        ProfileData__c pDataCategories42 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = compareOrg.id,name='Administrative & General User Permissions');
        insert pDataCategories42;
        ProfileData__c pDataCategories52 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = compareOrg.id,name='Object Permissions');
        insert pDataCategories52;
        ProfileData__c pDataCategories62 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = compareOrg.id,name='Desktop Integration Clients');
        insert pDataCategories62;
        ProfileData__c pDataCategories72 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = compareOrg.id,name='Login Hours');
        insert pDataCategories72;
        ProfileData__c pDataCategories82 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = compareOrg.id,name='Login IP Ranges');
        insert pDataCategories82;
        ProfileData__c pDataCategories92 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = compareOrg.id,name='Apex Class Access');
        insert pDataCategories92;
        ProfileData__c pDataCategories102 = new ProfileData__c(DataType__c = 'DataCategories',Organization_Details__c = compareOrg.id,name='Visualforce Page Access');
        insert pDataCategories102;
        ProfileData__c pDateTimeStamp2 = new ProfileData__c(DataType__c = 'DateTimeStamp',Organization_Details__c = compareOrg.id,DTime__c = System.Today(),name='Profile1');
        insert pDateTimeStamp2;
        ProfileData__c pasData2 = new ProfileData__c(DataType__c = 'Custom App Settings',Organization_Details__c = compareOrg.id,name='Profile1',Data1__c='App1',Data2__c='Checked',Data3__c='Checked');
        insert pasData2;
        ProfileData__c ptsData2 = new ProfileData__c(DataType__c = 'Tab Settings',Organization_Details__c = compareOrg.id,name='Profile1',Data1__c='Home',Data2__c='Default Off');
        insert ptsData2;
        ProfileData__c prtData2 = new ProfileData__c(DataType__c = 'Record Type Settings',Organization_Details__c = compareOrg.id,name='Profile1',Data1__c='Account',Data2__c='Recordtype2');
        insert prtData2;
        ProfileData__c pagData2 = new ProfileData__c(DataType__c = 'Administrative & General User Permissions',Organization_Details__c = compareOrg.id,name='Profile1',Data1__c='API Enabled',Data2__c='Not Checked');
        insert pagData2;
        ProfileData__c popData2 = new ProfileData__c(DataType__c = 'Object Permissions',Organization_Details__c = compareOrg.id,name='Profile1',Data1__c='Issue Comments',Data2__c='Checked',Data3__c='Not Checked',Data4__c='Checked',Data5__c='Checked',Data6__c='Checked',Data7__c='Checked');
        insert popData2;
        ProfileData__c pdiData2 = new ProfileData__c(DataType__c = 'Desktop Integration Clients',Organization_Details__c = compareOrg.id,name='Profile1',Data1__c='Offline',Data2__c='On (access granted)');
        insert pdiData2;
        ProfileData__c plhData2 = new ProfileData__c(DataType__c = 'Login Hours',Organization_Details__c = compareOrg.id,name='Profile1',Data1__c='Sunday',Data2__c='11am',Data3__c='12pm');
        insert plhData2;
        ProfileData__c pipData2 = new ProfileData__c(DataType__c = 'Login IP Ranges',Organization_Details__c = compareOrg.id,name='Profile1',Data1__c='1.1.1.1',Data2__c='2.2.2.3');
        insert pipData2;
        ProfileData__c pacData2 = new ProfileData__c(DataType__c = 'Apex Class Access',Organization_Details__c = compareOrg.id,name='Profile1',Data1__c='Test12');
        insert pacData2;
        ProfileData__c pvfData2 = new ProfileData__c(DataType__c = 'Visualforce Page Access',Organization_Details__c = compareOrg.id,name='Profile1',Data1__c='Test12');
        insert pvfData2;
        
        // Call the methods which are used for showing the report with highlighter turned on.
        VFC02_VFP02_ReportExcel vRE1 = new VFC02_VFP02_ReportExcel();
        ProfileData__c pr2 = [select id,name,data1__c from ProfileData__c where id=:pReportType.id];
        pr2.name='No';
        pr2.Data1__c='No';
        update pr2;
        
        // Call the methods which are used for showing the report with highlighter turned off.
        VFC02_VFP02_ReportExcel vRE2 = new VFC02_VFP02_ReportExcel();
    }
}