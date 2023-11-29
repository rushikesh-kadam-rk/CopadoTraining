/* 
Version        : 1.00
Company        : Accenture
Date           : 11.OCT.2013
Author         : Ritesh Shahare
Description    : Controller class for VFP01_ProfileCompareHomePage page 
History        : 
                1.00 11.OCT.2013 Ritesh Shahare- Created
*/

public class VFC01_VFP01_ProfileCompareHomePage
{
    // Intialize the variables
    private List<SelectOption> availableOptions {get;set;}
    public List<SelectOption> availableProfileList {get;set;} 
    public List<SelectOption> availableProfileListDifOrg {get;set;} 
    String[] pVals = new String[]{};
    String[] pSelVals = new String[]{};
    String[] pSelValsDifOrg = new String[]{};
    String[] itemVals = new String[]{};
    private List<Profile> lstProfile;
    private List<ProfileData__c> lstpd ;
    private List<ProfileData__c> lstpdDifOrg ;
    private Map<String,DateTime> mapProLM;
    public boolean IsStatusMsgVisible {get;set;}
    private string OrgID;
    private string compOrgID;
    private string compVal='No';
    private string orgcompVal='No';
    //=================================
    // G.E.T.T.E.R.S and S.E.T.T.E.R.S
    //=================================
    public String[] getpSelVals() 
    {
        return pSelVals ;
    }
    
    public void setpSelVals(String[] psv) 
    {
        this.pSelVals = psv;
    }
    
    public String[] getpSelValsDifOrg() 
    {
        return pSelValsDifOrg ;
    }
    
    public void setpSelValsDifOrg(String[] psv) 
    {
        this.pSelValsDifOrg = psv;
    }
    
    public String[] getpVals() 
    {
        return pVals ;
    }
    
    public void setpVals(String[] pv) 
    {
        this.pVals = pv;
    }
    
    public String[] getitemVals() 
    {
        return itemVals ;
    }
    
    public void setitemVals(String[] iv) 
    {
        this.itemVals = iv;
    }
    
    public String getcVal() 
    {
        return compVal;
    }
    
    public void setcVal(String cVal) 
    {
        this.compVal = cVal;
    }
    
    public String getoVal() 
    {
        return orgcompVal;
    }
    
    public void setoVal(String oVal) 
    {
        this.orgcompVal = oVal;
    }
 
    // ===============================
    //    C.O.N.S.T.R.U.C.T.O.R
    // ===============================  
     public VFC01_VFP01_ProfileCompareHomePage()
     {
         queryandPopulateProfiles();
     }
   
    // ================================
    // = M.E.T.H.O.D.S
    // ================================
    
    /** 
        This method is used to build the profile list for UI.
    */
     public void queryandPopulateProfiles()
     {
         try
         {
             // Get the org id of the current running salesforce org.
             OrgID = [SELECT Id From Organization_Details__c where MasterOrg__c=true LIMIT 1].id;
             
             // Get the org id of the salesforce against which we are comparing the profile data.
             compOrgID = [SELECT Id From Organization_Details__c where MasterOrg__c=false LIMIT 1].id;
         
             // Query all the profiles along with their last modified date.
             lstProfile = [select id,name,lastmodifieddate from profile order by name];
             
             // Query all the profiles for which have the parsed profile data
             lstpd = [select Name,DTime__c from ProfileData__c where Organization_Details__c = :OrgID and DataType__c = 'DateTimeStamp' ];
             lstpdDifOrg = [select Name,DTime__c from ProfileData__c where Organization_Details__c = :compOrgID and DataType__c = 'DateTimeStamp' order by name];
             mapProLM = New Map<String,DateTime>();
             
             for(ProfileData__c p : lstpd)
             {
               mapProLM.put(p.Name,p.DTime__c);
             }
             availableProfileList = new List<SelectOption>();
             
             // Build the profile select option list for UI.
             generateProfileList();
             
             IsStatusMsgVisible =false;
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while querying the profiles.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }
     }
     
    /**
         This method builds the profile list of which we have the in-synch report data
    */
    public void generateProfileList() 
    {
        try
        {
            List<SelectOption> availableOptions = new List<SelectOption>();
            List<SelectOption> availableOptionsDifOrg = new List<SelectOption>();
            
            // This forloop builds the option list for profiles having report data of the current running salesforce orgainisation.
            for(Profile pr : lstProfile)
            {
                  if(mapProLM.containskey(pr.name) && mapProLM.get(pr.name)==pr.lastmodifieddate)
                  {
                      availableOptions.add(new SelectOption(pr.Name,pr.Name + '- (Data Available - InSynch)'));
                  }
            }
            availableProfileList = availableOptions ;
            
            // This forloop builds the option list for profiles having report data of the salesforce orgainisation against which we are comparing our profiles data.
            for(ProfileData__c pd : lstpdDifOrg)
            {
                availableOptionsDifOrg.add(new SelectOption(pd.Name,pd.Name));
            }
            
            availableProfileListDifOrg = availableOptionsDifOrg ;
            
        }
        catch(Exception ex)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while building the profile list for which we have the insynch report data.Please contact the system administrator.!');            
            ApexPages.addmessage(myMsg); 
        }
    }
     
   /**
       This method process the delete report data request from UI.
   */  
   private void processDeleteRequest(String oID, String[] pSelV)
   {
       try
       {
            // Flush out the old profile list from the last execution for which we generated the report and store
            // the new selected profile list in place.
            List<ProfileData__c> lstOldSelProfiles = [select id from ProfileData__c where Organization_Details__c = :oID and DataType__c = 'DataProfileIDs' ];
            
            if(lstOldSelProfiles!=null && lstOldSelProfiles.size()>0)
                delete lstOldSelProfiles ;
        
            List<ProfileData__c> lstPr = new List<ProfileData__c>();
            
            for(String str : pSelV)
            {
                ProfileData__c p = new ProfileData__c();
                p.DataType__c = 'DataProfileIDs'  ;
                p.Organization_Details__c = oID ;
                p.name = str;
                lstPr.add(p);
            }
            
            if(lstPr.size()>0)
            {
                insert lstPr;
                
                // Flush out the old selected profiles from the last execution for which we generated the report data
                // and insert the new selected profile list 
                    
                List<ProfileData__c> lstOldDelProfiles = [select id from ProfileData__c where Organization_Details__c = :oID and DataType__c = 'DeleteReportData' ];
                if(lstOldDelProfiles!=null && lstOldDelProfiles.size()>0)
                    delete lstOldDelProfiles ;
                        
                List<Profile> lstp = [select id,name from profile where id in : pSelV];
                
                Set<String> setProNames = new Set<String>();
                
                for(profile p : lstp)
                {
                    setProNames.add(p.name);
                }    
                
                List<ProfileData__c> lstpData = [select id from ProfileData__c  where Organization_Details__c = :oID and (name in : setProNames or name in : pSelV) ];
                
                // if the records are less than 10k then delete the records else report the apex governor limit issue in processValidation method of UI VF page.
                if(lstpData.size()<10000)
                {
                    delete lstpData ;
                    
                    ProfileData__c p = new ProfileData__c();
                    p.DataType__c = 'DeleteReportData';
                    p.Organization_Details__c = oID;
                    p.name = 'Deleted';
                    insert p;
                }
                queryandPopulateProfiles();
        }
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while processing the delete request from UI.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }
   }  
     
    /**
        This method handles the delete report data request for the current running salesforce org.
    */
    public void removeReportData()
    {
        processDeleteRequest(OrgID,pSelVals);
    } 
     
    /**
        This method handles the delete report data request for the salesforce org against which we are comparing the profile data.
    */
    public void removeReportDataDifOrg()
    {
        processDeleteRequest(compOrgID,pSelValsDifOrg);
    } 
     
     
    /**
        This method stores the selected profiles of which we need to parse the report data.This is done because 
        the report page is a different page with its own controller and there is no way to directly pass the 
        profile list to that visual force page.
    */
    public void storeSelectedProfiles()
    {
        try
        {
            // Flush out the old selected profiles from the last execution for which we generated the report data
            // and insert the new selected profile list 
            List<ProfileData__c> lstOldSelProfiles = [select id from ProfileData__c where Organization_Details__c = :OrgID and DataType__c = 'ProfileIDs' ];
            if(lstOldSelProfiles!=null && lstOldSelProfiles.size()>0)
                delete lstOldSelProfiles ;
        
            List<ProfileData__c> lstPr = new List<ProfileData__c>();
            
            for(String str : pVals)
            {
                ProfileData__c p = new ProfileData__c();
                p.DataType__c = 'ProfileIDs'  ;
                p.Organization_Details__c = OrgID;
                p.name = str;
                lstPr.add(p);
            }
            insert lstPr;
            
            if(pVals.size()>0)
                IsStatusMsgVisible =true;
        }
        catch(Exception ex)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while storing the selected profiles for which we need to generate the report data.Please contact the system administrator.!');            
            ApexPages.addmessage(myMsg); 
        }
    }
 
    /**
        This method stores the selected profiles record in database for which we need to generate the report.
        This is done because we cant get the values of selected picklist values from javascript so we store it in database and then query
        it in the javascript code.
    */ 
    public void storeDataReportProfiles()
    {
        try
        {
            // Flush out the old profile list from the last execution for which we generated the report and store
            // the new selected profile list in place.
            List<ProfileData__c> lstOldSelProfiles = [select id from ProfileData__c where Organization_Details__c = :OrgID and DataType__c = 'DataProfileIDs' ];
            
            if(lstOldSelProfiles!=null && lstOldSelProfiles.size()>0)
                delete lstOldSelProfiles ;
        
            List<ProfileData__c> lstPr = new List<ProfileData__c>();
            
            for(String str : pSelVals)
            {
                ProfileData__c p = new ProfileData__c();
                p.DataType__c = 'DataProfileIDs'  ;
                p.Organization_Details__c = OrgID;
                p.name = str;
                lstPr.add(p);
            }
            
            insert lstPr;
            
            // Flush out the old report type data from the last execution.
            List<ProfileData__c> lstOldReportType = [select id from ProfileData__c where Organization_Details__c = :OrgID and DataType__c = 'ReportType' ];
            
            if(lstOldReportType!=null && lstOldReportType.size()>0)
                delete lstOldReportType ;
        
            ProfileData__c pRT = new ProfileData__c();
            pRT.DataType__c = 'ReportType'  ;
            pRT.Organization_Details__c = OrgID;
            pRT.name = compVal;
            pRT.data1__c=orgcompVal;
        
            insert pRT;
            
             // Flush out the old report categories from the last execution and store the new selected report category list.
            List<ProfileData__c> lstOldDataCat = [select id from ProfileData__c where Organization_Details__c = :OrgID and DataType__c = 'DataCategories' ];
            
            if(lstOldDataCat!=null && lstOldDataCat.size()>0)
                delete lstOldDataCat;
        
            List<ProfileData__c> lstPrdata = new List<ProfileData__c>();
            
            for(String str : itemVals)
            {
                ProfileData__c p = new ProfileData__c();
                p.DataType__c = 'DataCategories'  ;
                p.Organization_Details__c = OrgID;
                p.name = str;
                lstPrdata.add(p);
            }
            insert lstPrdata;
        }
        catch(Exception ex)
       {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while storing the selected profiles for which we need to generate the report.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
       }
    }
  
    /** 
        This method generate the profiles list of which we don't have the report data or
        the data is available but is out of synch with the latest profile.
    */
    public List<SelectOption> getProfileList() 
    {
        try
        {
            List<SelectOption> options = new List<SelectOption>();
            
            for(Profile pr : lstProfile)
            {
                  if(!mapProLM.containskey(pr.name))
                      options.add(new SelectOption(pr.id,pr.Name + '- (Data Not Available)'));
                  else if(mapProLM.containskey(pr.name) && mapProLM.get(pr.name)!=pr.lastmodifieddate)
                      options.add(new SelectOption(pr.id,pr.Name + '- (Data Available - Out of Synch)'));
            }
            return options;
        }
        catch(Exception ex)
       {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while building the profile list of which we do not have the parsed data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
           return null;
       }
    }
    
    /**
        This method builds a list with values for every section on the profile page.
     */
    public List<SelectOption> getItemsToCompare() 
    {
       try
       {
           List<SelectOption> options = new List<SelectOption>();
                
           Schema.DescribeFieldResult fieldResult = ProfileData__c.DataType__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
           for( Schema.PicklistEntry datatypePickValue : ple)
           {
              options.add(new SelectOption(datatypePickValue.getLabel(), datatypePickValue.getValue()));
           }       
           return options;
       }
       catch(Exception ex)
       {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while building the report category list for UI.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
           return null;
       }
    } 
    
    /**
        This method builds the values difference highlighter.
    */
    public List<SelectOption> getCompareValues() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('No','No'));
        options.add(new SelectOption('Yes','Yes'));
        return options;
    }
    
    /**
        This method builds the values for profile comparison against different orgs.
    */
    public List<SelectOption> getOrgCompareValues() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('No','No'));
        options.add(new SelectOption('Yes','Yes'));
        return options;
    }
   
}