/* 
Version        : 1.00
Company        : Accenture
Date           : 11.OCT.2013
Author         : Ritesh Shahare
Description    : Controller class for VFP02_ReportExcel page 
History        : 
                1.00 11.OCT.2013 Ritesh Shahare- Created
*/

public class VFC02_VFP02_ReportExcel
{
    // Intialize the variables
    Public Map<String,Map<String,String>> mapVFs {get;set;}
    Public Map<String,Map<String,String>> mapVFsColors {get;set;}
    Public List<String> lstVFPages {get;set;}
    
    Public Map<String,Map<String,String>> mapApex {get;set;}
    Public Map<String,Map<String,String>> mapApexColors {get;set;}
    Public List<String> lstApex {get;set;}
    
    Public Map<String,Map<String,String>> mapIP {get;set;}
    Public Map<String,Map<String,String>> mapIPColors {get;set;}
    Public List<String> lstIP {get;set;}

    Public Map<String,Map<String,String>> mapDI {get;set;}
    Public Map<String,Map<String,String>> mapDIColors {get;set;}
    Public List<String> lstDI {get;set;}

    Public Map<String,Map<String,String>> mapOP {get;set;}
    Public Map<String,Map<String,String>> mapOPColors {get;set;}
    Public List<String> lstOP {get;set;}
    
    Public Map<String,Map<String,String>> mapAG {get;set;}
    Public Map<String,Map<String,String>> mapAGColors {get;set;}
    Public List<String> lstAG {get;set;}
    
    Public Map<String,Map<String,String>> mapRT {get;set;}
    Public Map<String,Map<String,String>> mapRTColors {get;set;}
    Public List<String> lstRT {get;set;}
    
    Public Map<String,Map<String,String>> mapTS {get;set;}
    Public Map<String,Map<String,String>> mapTSColors {get;set;}
    Public List<String> lstTS {get;set;}
    
    Public Map<String,Map<String,String>> mapCA {get;set;}
    Public Map<String,Map<String,String>> mapCAColors {get;set;}
    Public List<String> lstCA {get;set;}
    
    Public Map<String,Map<String,String>> mapLH {get;set;}
    Public Map<String,Map<String,String>> mapLHColors {get;set;}
    Public List<String> lstLH {get;set;}
    Private String defaultOrgName;
    Private String compareToOrgName;
    Private List<String> indVal1 = new List<String>();
    Private List<String> indVal2 = new List<String>();
    Private String compareProName;
    Private String strBGColor;
    Private String strReportType;
    Private string strDifHighlighter;
    Private String OrgID;
    Private String compOrgID;
    
    // ===============================
    //    C.O.N.S.T.R.U.C.T.O.R
    // ===============================
    public VFC02_VFP02_ReportExcel()
    {
        try
        {
            lstVFPages = new List<String>();
            Set<String> setVFPages = new Set<String>();
            mapVFs = new Map<String,Map<String,String>>();
            mapVFsColors = new Map<String,Map<String,String>>();
            
            lstApex = new List<String>();
            Set<String> setApex = new Set<String>();
            mapApex = new Map<String,Map<String,String>>();
            mapApexColors = new Map<String,Map<String,String>>();
            
            lstIP = new List<String>();
            Set<String> setIP = new Set<String>();
            mapIP = new Map<String,Map<String,String>>();
            mapIPColors = new Map<String,Map<String,String>>();
            
            lstDI = new List<String>();
            Set<String> setDI = new Set<String>();
            mapDI = new Map<String,Map<String,String>>();
            mapDIColors = new Map<String,Map<String,String>>();
            
            lstOP = new List<String>();
            Set<String> setOP = new Set<String>();
            mapOP = new Map<String,Map<String,String>>();
            mapOPColors = new Map<String,Map<String,String>>();
            
            lstAG = new List<String>();
            Set<String> setAG = new Set<String>();
            mapAG = new Map<String,Map<String,String>>();
            mapAGColors = new Map<String,Map<String,String>>();
            
            lstRT = new List<String>();
            Set<String> setRT = new Set<String>();
            mapRT = new Map<String,Map<String,String>>();
            mapRTColors = new Map<String,Map<String,String>>();
            
            lstTS = new List<String>();
            Set<String> setTS = new Set<String>();
            mapTS = new Map<String,Map<String,String>>();
            mapTSColors = new Map<String,Map<String,String>>();
            
            lstCA = new List<String>();
            Set<String> setCA = new Set<String>();
            mapCA = new Map<String,Map<String,String>>();
            mapCAColors = new Map<String,Map<String,String>>();
            
            lstLH = new List<String>();
            Set<String> setLH = new Set<String>();
            mapLH = new Map<String,Map<String,String>>();
            mapLHColors = new Map<String,Map<String,String>>();
            
            Set<String> setOrgIDs = new Set<String>();
            
            // Get the org name of the current running salesforce org.
            defaultOrgName = [SELECT Organization_Name__c From Organization_Details__c where MasterOrg__c = true LIMIT 1].Organization_Name__c;
            // Get the org name of the salesforce org against which we are comparing the profile data.
            compareToOrgName = [SELECT Organization_Name__c From Organization_Details__c where MasterOrg__c = false LIMIT 1].Organization_Name__c;
            
            // Get the org id of the current running salesforce org.
            OrgID = [SELECT Id From Organization_Details__c where MasterOrg__c=true LIMIT 1].id;
            // Get the org id of the salesforce org against which we are comparing the profile data.
            compOrgID = [SELECT Id From Organization_Details__c where MasterOrg__c=false LIMIT 1].id;
            
            // These 2 parameters (strReportType & strDifHighlighter) are basically used to determine which methods to call i.e the ones with difference highlighter code or the ones without it. 
            strReportType = [select name from ProfileData__c where datatype__c in ('ReportType') and Organization_Details__c = :OrgID].name;
            strDifHighlighter = [select data1__c from ProfileData__c where datatype__c in ('ReportType') and Organization_Details__c = :OrgID].data1__c;
            
            // This set is used to pull the report data for different orgs.if we are comparing the profiles against the same org then only current running org id is stored in this set.
            // if we are going to compare profiles against different org then the org id of that org is also stored in this set.
            setOrgIDs.add(OrgID);
            if(strDifHighlighter.equalsignorecase('Yes'))
            setOrgIDs.add(compOrgID);
            
            // Datatype --> Profile --> Map of Values with key as column headings and values as column values on visual force page
            Map<String,Map<String,Map<String,String>>> mapProfileCategory = new Map<String,Map<String,Map<String,String>>>();
            
            Set<String> setPro = new Set<String>();
            Set<String> setCat = new Set<String>();
            
            List<ProfileData__c> lstSelProfileItems = [select name,datatype__c from ProfileData__c where datatype__c in ('DataProfileIDs','DataCategories')];
            for(ProfileData__c pi : lstSelProfileItems)
            {
                 if(pi.datatype__c=='DataProfileIDs')
                     setPro.add(pi.name);
                 else
                     setCat.add(pi.name);   
            }
           
            List<ProfileData__c> lstProfileData = [select OrgWiseProfileName__c,id,Organization_Details__c,name,DataType__c,Data1__c,Data2__c,Data3__c,Data4__c,Data5__c,Data6__c,Data7__c from ProfileData__c where Organization_Details__c in : setOrgIDs and  datatype__c in :setCat and name in :setPro order by datatype__c,OrgWiseProfileName__c,id desc];
            
            for(ProfileData__c pd : lstProfileData)
            {
                
                if(pd.DataType__c.equalsignorecase('Visualforce Page Access')) // Store the distinct list of visual force pages in a set
                    setVFPages.add(pd.Data1__c);
                else if(pd.DataType__c.equalsignorecase('Apex Class Access')) // Store the distinct list of apex classes in a set
                    setApex.add(pd.Data1__c);
                else if(pd.DataType__c.equalsignorecase('Login IP Ranges')) // Store the distinct list of ip ranges in a set
                    setIP.add(pd.Data1__c + ' To ' + pd.Data2__c);
                else if(pd.DataType__c.equalsignorecase('Desktop Integration Clients')) // Store the distinct list of Desktop Integration Clients in a set
                    setDI.add(pd.Data1__c);
                else if(pd.DataType__c.equalsignorecase('Object Permissions')) // Store the distinct list of Standard and Custom Object Permissions in a set
                    setOP.add(pd.Data1__c);
                else if(pd.DataType__c.equalsignorecase('Administrative & General User Permissions')) // Store the distinct list of Administrative & General User Permissions
                    setAG.add(pd.Data1__c);
                else if(pd.DataType__c.equalsignorecase('Record Type Settings')) // Store the distinct list of Record Type Settings
                    setRT.add(pd.Data1__c);
                else if(pd.DataType__c.equalsignorecase('Tab Settings')) // Store the distinct list of Tab Settings
                    setTS.add(pd.Data1__c);
                else if(pd.DataType__c.equalsignorecase('Custom App Settings')) // Store the distinct list of Custom App Settings
                    setCA.add(pd.Data1__c);
                else if(pd.DataType__c.equalsignorecase('Login Hours')) // Store the distinct list of Login Hours
                    setLH.add(pd.Data1__c);    
                
                // This code snippet actually builds a map with hierarchy as DataType -> Profiles -> Section Details    
                if(mapProfileCategory.containskey(pd.DataType__c) && mapProfileCategory.get(pd.DataType__c).containskey(pd.OrgWiseProfileName__c))
                {
                    Map<String,Map<String,String>> mapProItems =mapProfileCategory.get(pd.DataType__c);
                    Map<String,String> mapVals = mapProItems.get(pd.OrgWiseProfileName__c);
                    
                    if(pd.DataType__c.equalsignorecase('Login IP Ranges'))
                        mapVals.put(pd.Data1__c + ' To ' + pd.Data2__c,pd.Data1__c + ' To ' + pd.Data2__c);
                    else if(pd.DataType__c.equalsignorecase('Object Permissions'))
                        mapVals.put(pd.Data1__c,pd.Data2__c + '-' + pd.Data3__c + '-' + pd.Data4__c + '-' + pd.Data5__c + '-' + pd.Data6__c + '-' + pd.Data7__c);
                    else if(pd.DataType__c.equalsignorecase('Custom App Settings') || pd.DataType__c.equalsignorecase('Login Hours'))
                        mapVals.put(pd.Data1__c,pd.Data2__c + '-' + pd.Data3__c);    
                    else if(pd.DataType__c.equalsignorecase('Desktop Integration Clients') || pd.DataType__c.equalsignorecase('Administrative & General User Permissions') || pd.DataType__c.equalsignorecase('Tab Settings'))
                    {         
                             mapVals.put(pd.Data1__c,pd.Data2__c);
                    }
                    else if (pd.DataType__c.equalsignorecase('Record Type Settings'))
                    {
                         if(mapVals.containskey(pd.Data1__c))
                         {
                             mapVals.put(pd.Data1__c,mapVals.get(pd.Data1__c) + pd.Data2__c);
                         }
                         else
                             mapVals.put(pd.Data1__c,pd.Data2__c);
                    }
                    else
                        mapVals.put(pd.Data1__c,pd.Data1__c);
                        
                    mapProItems.put(pd.OrgWiseProfileName__c,mapVals);
                    mapProfileCategory.put(pd.DataType__c,mapProItems);
                }
                else
                {
                    Map<String,Map<String,String>> mapProItems;
                    
                    if(mapProfileCategory.containskey(pd.DataType__c))
                        mapProItems =mapProfileCategory.get(pd.DataType__c);
                    else
                        mapProItems = new Map<String,Map<String,String>>();
                        
                    Map<String,String> mapVals = new Map<String,String>();
                    
                    if(pd.DataType__c.equalsignorecase('Login IP Ranges'))
                        mapVals.put(pd.Data1__c + ' To ' + pd.Data2__c,pd.Data1__c + ' To ' + pd.Data2__c);
                    else if(pd.DataType__c.equalsignorecase('Object Permissions'))
                        mapVals.put(pd.Data1__c,pd.Data2__c + '-' + pd.Data3__c + '-' + pd.Data4__c + '-' + pd.Data5__c + '-' + pd.Data6__c + '-' + pd.Data7__c);
                    else if(pd.DataType__c.equalsignorecase('Custom App Settings') || pd.DataType__c.equalsignorecase('Login Hours'))
                        mapVals.put(pd.Data1__c,pd.Data2__c + '-' + pd.Data3__c);    
                    else if(pd.DataType__c.equalsignorecase('Desktop Integration Clients') || pd.DataType__c.equalsignorecase('Administrative & General User Permissions') || pd.DataType__c.equalsignorecase('Tab Settings'))
                         mapVals.put(pd.Data1__c,pd.Data2__c);
                    else if (pd.DataType__c.equalsignorecase('Record Type Settings'))
                    {
                         if(mapVals.containskey(pd.Data1__c))
                         {
                             mapVals.put(pd.Data1__c,mapVals.get(pd.Data1__c) + pd.Data2__c);
                         }
                         else
                             mapVals.put(pd.Data1__c,pd.Data2__c);
                    }
                    else
                        mapVals.put(pd.Data1__c,pd.Data1__c);
                    
                    mapProItems.put(pd.OrgWiseProfileName__c,mapVals);
                    mapProfileCategory.put(pd.DataType__c,mapProItems);
                }
            }
            
            // Get the VF lists for each profiles and a consolidated list in sorted order
            if(mapProfileCategory.containskey('Visualforce Page Access'))
            {
                mapVFs = mapProfileCategory.get('Visualforce Page Access');
                lstVFPages.addAll(setVFPages);
                lstVFPages.sort(); 
                if(strDifHighlighter=='Yes' && strReportType=='Yes')
                    generateVFPagesDatawithColor();
                else
                    generateVFPagesData();
                
            }
            
            // Get the Apex lists for each profiles and a consolidated list in sorted order
            if(mapProfileCategory.containskey('Apex Class Access'))
            {
                mapApex = mapProfileCategory.get('Apex Class Access');
                lstApex.addAll(setApex);
                lstApex.sort(); 
                if(strDifHighlighter=='Yes' && strReportType=='Yes')
                    generateApexDatawithColor();
                else
                    generateApexData();
            }
            
            // Get the IP Ranges for each profiles and a consolidated list in sorted order
            if(mapProfileCategory.containskey('Login IP Ranges'))
            {
                mapIP = mapProfileCategory.get('Login IP Ranges');
                lstIP.addAll(setIP);
                lstIP.sort(); 
                if(strDifHighlighter=='Yes' && strReportType=='Yes')
                    generateIPDatawithColor();
                else
                    generateIPData();
            }
            
            // Get the Login Hours for each profiles and a consolidated list in sorted order
            if(mapProfileCategory.containskey('Login Hours'))
            {
                mapLH = mapProfileCategory.get('Login Hours');
                lstLH.addAll(setLH);
                lstLH.sort(); 
                if(strDifHighlighter=='Yes' && strReportType=='Yes')
                    generateLHDatawithColor();
                else
                    generateLHData();
            }
            
            // Get the Desktop Integration Clients for each profiles and a consolidated list in sorted order
            if(mapProfileCategory.containskey('Desktop Integration Clients'))
            {
                mapDI = mapProfileCategory.get('Desktop Integration Clients');
                lstDI.addAll(setDI);
                lstDI.sort(); 
                if(strDifHighlighter=='Yes' && strReportType=='Yes')
                    generateDIDatawithColor();
                else
                    generateDIData();
            }
            
            // Get the Standard and Custom Objects permission for each profiles and a consolidated list in sorted order
            if(mapProfileCategory.containskey('Object Permissions'))
            {
                mapOP = mapProfileCategory.get('Object Permissions');
                lstOP.addAll(setOP);
                lstOP.sort(); 
                if(strDifHighlighter=='Yes' && strReportType=='Yes')
                    generateOPDatawithColor();
                else
                    generateOPData();
            } 
            
            // Get the Administrative and General permissions for each profiles and a consolidated list in sorted order
            if(mapProfileCategory.containskey('Administrative & General User Permissions'))
            {
                mapAG = mapProfileCategory.get('Administrative & General User Permissions');
                lstAG.addAll(setAG);
                lstAG.sort(); 
                if(strDifHighlighter=='Yes' && strReportType=='Yes')
                    generateAGDatawithColor();
                else
                    generateAGData();
            } 
            
            // Get the Record Type permissions for each profiles and a consolidated list in sorted order
            if(mapProfileCategory.containskey('Record Type Settings'))
            {
                mapRT = mapProfileCategory.get('Record Type Settings');
                lstRT.addAll(setRT);
                lstRT.sort(); 
                if(strDifHighlighter=='Yes' && strReportType=='Yes')
                    generateRTDatawithColor();
                else
                    generateRTData();
            } 
            
            // Get the Tab Settings for each profiles and a consolidated list in sorted order
            if(mapProfileCategory.containskey('Tab Settings'))
            {
                mapTS = mapProfileCategory.get('Tab Settings');
                lstTS.addAll(setTS);
                lstTS.sort(); 
                if(strDifHighlighter=='Yes' && strReportType=='Yes')
                    generateTSDatawithColor();
                else
                    generateTSData();
            } 
            
            // Get the Custom App Settings for each profiles and a consolidated list in sorted order
            if(mapProfileCategory.containskey('Custom App Settings'))
            {
                mapCA = mapProfileCategory.get('Custom App Settings');
                lstCA.addAll(setCA);
                lstCA.sort(); 
                if(strDifHighlighter=='Yes' && strReportType=='Yes')
                    generateCADatawithColor();
                else
                    generateCAData();
            }
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the data from salesforce database.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }            
    }

    // ================================
    // = M.E.T.H.O.D.S
    // ================================

    /** 
        This method pulls,process and builds the Visual Force Pages Data with difference highlighter code.
    */
    private void generateVFPagesDatawithColor()
    {
        try
        {
            Map<String,String> setValsColors = new Map<String,String>();
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapVFs.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapVFs.put(pName,mapVals);
                    mapVFsColors.put(pName,setValsColors);
                    mapVals = new Map<String,String>(); 
                    setValsColors = new Map<String,String>(); 
                }
                Map<String,String> setVals = mapVFs.get(proName);
                
                if(proName.contains(defaultOrgName))
                    compareProName = proName.replace(defaultOrgName,compareToOrgName);
                else
                    compareProName = proName.replace(compareToOrgName,defaultOrgName);
    
                for(String vfName : lstVFPages)
                {
                    if(setVals.containskey(vfName))
                        mapVals.put(vfName,'Yes');
                    else
                        mapVals.put(vfName,'No');
                    
                    if(mapVFs.containskey(compareProName) && 
                    ((!mapVFs.get(compareProName).containskey(vfName) && setVals.containskey(vfName) && !setVals.get(vfName).equalsignorecase('No') ) || 
                    (setVals.containskey(vfName) && mapVFs.get(compareProName).containskey(vfName) && mapVFs.get(compareProName).get(vfName).equalsignorecase('Yes') &&  mapVFs.get(compareProName).get(vfName).equalsignorecase('No')) || 
                    (!setVals.containskey(vfName) && mapVFs.get(compareProName).containskey(vfName) && mapVFs.get(compareProName).get(vfName).equalsignorecase('No')  && mapVFs.get(compareProName).get(vfName).equalsignorecase('Yes')) || 
                    (mapVFs.get(compareProName).containskey(vfName) && !mapVFs.get(compareProName).get(vfName).equalsignorecase('No')  && !setVals.containskey(vfName))))
                        setValsColors.put(vfName,'RED');
                    else
                        setValsColors.put(vfName,'BLACK');
                }
                pName = proName;
                if(counter==mapVFs.size())
                {
                    mapVFs.put(pName,mapVals);
                    mapVFsColors.put(pName,setValsColors);
                }
                counter++;
            } 
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the visual force page data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }
    
    /** 
        This method pulls,process and builds the Visual Force Pages Data with no difference highlighter code.
    */
    private void generateVFPagesData()
    {
        try
        {
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapVFs.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapVFs.put(pName,mapVals);
                    mapVals = new Map<String,String>();  
                }
                Map<String,String> setVals = mapVFs.get(proName);
    
                for(String vfName : lstVFPages)
                {
                    if(setVals.containskey(vfName))
                        mapVals.put(vfName,'Yes');
                    else
                        mapVals.put(vfName,'No');
                }
                pName = proName;
                if(counter==mapVFs.size())
                    mapVFs.put(pName,mapVals);
                counter++;
            } 
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the visual force page data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }
    
    /**
        This method pulls,process and builds the Apex Data with difference highlighter code.
    */
    private void generateApexDatawithColor()
    {
        try
        {
            Map<String,String> setValsColors = new Map<String,String>();
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapApex.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapApex.put(pName,mapVals);
                    mapApexColors.put(pName,setValsColors);
                    mapVals = new Map<String,String>();  
                    setValsColors = new Map<String,String>();
                }
                Map<String,String> setVals = mapApex.get(proName);
                
                if(proName.contains(defaultOrgName))
                    compareProName = proName.replace(defaultOrgName,compareToOrgName);
                else
                    compareProName = proName.replace(compareToOrgName,defaultOrgName);
    
                for(String apexName : lstApex)
                {
                    if(setVals.containskey(apexName))
                        mapVals.put(apexName ,'Yes');
                    else
                        mapVals.put(apexName ,'No');
                    
                    if(mapApex.containskey(compareProName) && 
                    ((!mapApex.get(compareProName).containskey(apexName) && setVals.containskey(apexName) && !setVals.get(apexName).equalsignorecase('No') ) || 
                    (setVals.containskey(apexName) && mapApex.get(compareProName).containskey(apexName) && mapApex.get(compareProName).get(apexName).equalsignorecase('Yes') &&  mapApex.get(compareProName).get(apexName).equalsignorecase('No')) || 
                    (!setVals.containskey(apexName) && mapApex.get(compareProName).containskey(apexName) && mapApex.get(compareProName).get(apexName).equalsignorecase('No')  && mapApex.get(compareProName).get(apexName).equalsignorecase('Yes')) || 
                    (mapApex.get(compareProName).containskey(apexName) && !mapApex.get(compareProName).get(apexName).equalsignorecase('No')  && !setVals.containskey(apexName))))
                        setValsColors.put(apexName,'RED');
                    else
                        setValsColors.put(apexName,'BLACK');
                }
                pName = proName;
                if(counter==mapApex.size())
                {
                    mapApex.put(pName,mapVals);
                    mapApexColors.put(pName,setValsColors);
                }
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the apex class data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }
    
    /**
        This method pulls,process and builds the Apex Data with no difference highlighter code.
    */
    private void generateApexData()
    {
        try
        {
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapApex.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapApex.put(pName,mapVals);
                    mapVals = new Map<String,String>();  
                }
                Map<String,String> setVals = mapApex.get(proName);
    
                for(String apexName : lstApex)
                {
                    if(setVals.containskey(apexName))
                        mapVals.put(apexName ,'Yes');
                    else
                        mapVals.put(apexName ,'No');
                }
                pName = proName;
                if(counter==mapApex.size())
                    mapApex.put(pName,mapVals);
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the apex class data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }
    
    /**
        This method pulls,process and builds the IP Range Data with difference highlighter code.
    */
    private void generateIPDatawithColor()
    {
        try
        {
            Map<String,String> setValsColors = new Map<String,String>();
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapIP.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapIP.put(pName,mapVals);
                    mapIPColors.put(pName,setValsColors);
                    mapVals = new Map<String,String>();  
                    setValsColors = new Map<String,String>();
                }
                Map<String,String> setVals = mapIP.get(proName);
                
                if(proName.contains(defaultOrgName))
                    compareProName = proName.replace(defaultOrgName,compareToOrgName);
                else
                    compareProName = proName.replace(compareToOrgName,defaultOrgName);
                
                for(String ipName : lstIP)
                {
                    if(setVals.containskey(ipName))
                        mapVals.put(ipName ,'Yes');
                    else
                        mapVals.put(ipName ,'No');

                    if(mapIP.containskey(compareProName) && 
                    ((!mapIP.get(compareProName).containskey(ipName) && setVals.containskey(ipName) && !setVals.get(ipName).equalsignorecase('No') ) || 
                    (setVals.containskey(ipName) && mapIP.get(compareProName).containskey(ipName) && mapIP.get(compareProName).get(ipName).equalsignorecase('Yes') &&  mapIP.get(compareProName).get(ipName).equalsignorecase('No')) || 
                    (!setVals.containskey(ipName) && mapIP.get(compareProName).containskey(ipName) && mapIP.get(compareProName).get(ipName).equalsignorecase('No')  && mapIP.get(compareProName).get(ipName).equalsignorecase('Yes')) || 
                    (mapIP.get(compareProName).containskey(ipName) && !mapIP.get(compareProName).get(ipName).equalsignorecase('No')  && !setVals.containskey(ipName))))
                        setValsColors.put(ipName,'RED');
                    else
                        setValsColors.put(ipName,'BLACK');
                }
                pName = proName;
                if(counter==mapIP.size())
                {
                    mapIP.put(pName,mapVals);
                    mapIPColors.put(pName,setValsColors);
                }
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the ip range data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }
    
    /**
        This method pulls,process and builds the IP Range Data with no difference highlighter code.
    */
    private void generateIPData()
    {
        try
        {
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapIP.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapIP.put(pName,mapVals);
                    mapVals = new Map<String,String>();  
                }
                Map<String,String> setVals = mapIP.get(proName);
                
                for(String ipName : lstIP)
                {
                    if(setVals.containskey(ipName))
                        mapVals.put(ipName ,'Yes');
                    else
                        mapVals.put(ipName ,'No');
                }
                pName = proName;
                if(counter==mapIP.size())
                    mapIP.put(pName,mapVals);
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the ip range data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }
    
    /**
        This method pulls,process and builds the Login Hours with difference highlighter code.
    */
    private void generateLHDatawithColor()
    {
        try
        {
            Map<String,String> setValsColors = new Map<String,String>();
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapLH.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapLH.put(pName,mapVals);
                    mapLHColors.put(pName,setValsColors);
                    mapVals = new Map<String,String>(); 
                    setValsColors = new Map<String,String>(); 
                }
                Map<String,String> setVals = mapLH.get(proName);
                
                if(proName.contains(defaultOrgName))
                    compareProName = proName.replace(defaultOrgName,compareToOrgName);
                else
                    compareProName = proName.replace(compareToOrgName,defaultOrgName);
    
                for(String lhName : lstLH)
                {
                    if(setVals.containskey(lhName))
                    {
                        if(mapLH.containskey(compareProName) && mapLH.get(compareProName).get(lhName) != setVals.get(lhName))
                            setValsColors.put(lhName,'RED');
                        else
                            setValsColors.put(lhName,'BLACK');
                                
                        mapVals.put(lhName ,setVals.get(lhName));
                    }
                    else
                        mapVals.put(lhName ,'Not Configured');
                }
                pName = proName;
                if(counter==mapLH.size())
                {
                    mapLH.put(pName,mapVals);
                    mapLHColors.put(pName,setValsColors);
                }
                counter++;
            }
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the login hours data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }               
    }
    
    /**
        This method pulls,process and builds the Login Hours with no difference highlighter code.
    */
    private void generateLHData()
    {
        try
        {
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapLH.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapLH.put(pName,mapVals);
                    mapVals = new Map<String,String>();  
                }
                Map<String,String> setVals = mapLH.get(proName);
    
                for(String lhName : lstLH)
                {
                    if(setVals.containskey(lhName))
                        mapVals.put(lhName ,setVals.get(lhName));
                    else
                        mapVals.put(lhName ,'Not Configured');
                }
                pName = proName;
                if(counter==mapLH.size())
                    mapLH.put(pName,mapVals);
                counter++;
            }
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the login hours data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }               
    }
    
    /**
        This method pulls,process and builds the Desktop Integration Clients Data with difference highlighter code.
    */
    private void generateDIDatawithColor()
    {
        try
        {
            Map<String,String> setValsColors = new Map<String,String>();
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapDI.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapDI.put(pName,mapVals);
                    mapDIColors.put(pName,setValsColors);
                    mapVals = new Map<String,String>(); 
                    setValsColors = new Map<String,String>();
                }
                Map<String,String> setVals = mapDI.get(proName);
                
                if(proName.contains(defaultOrgName))
                    compareProName = proName.replace(defaultOrgName,compareToOrgName);
                else
                    compareProName = proName.replace(compareToOrgName,defaultOrgName);
                
                for(String diName : lstDI)
                {
                        if(setVals.containskey(diName))
                        {
                            if(mapDI.containskey(compareProName) && mapDI.get(compareProName).get(diName) != setVals.get(diName))
                                setValsColors.put(diName,'RED');
                            else
                                setValsColors.put(diName,'BLACK');
                                
                            mapVals.put(diName ,setVals.get(diName));
                        }
                }
                pName = proName;
                if(counter==mapDI.size())
                {
                    mapDI.put(pName,mapVals);
                    mapDIColors.put(pName,setValsColors);
                }
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the desktop integration client data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }
    
    /**
        This method pulls,process and builds the Desktop Integration Clients Data with no difference highlighter code.
    */
    private void generateDIData()
    {
        try
        {
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapDI.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapDI.put(pName,mapVals);
                    mapVals = new Map<String,String>();  
                }
                Map<String,String> setVals = mapDI.get(proName);
                
                for(String diName : lstDI)
                {
                        if(setVals.containskey(diName))
                        mapVals.put(diName ,setVals.get(diName));
                }
                pName = proName;
                if(counter==mapDI.size())
                {
                    mapDI.put(pName,mapVals);
                }
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the desktop integration client data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }
    
    /**
        This method pulls,process and builds the Standard and Custom Objects permission Data with difference highlighter code.
    */
    private void generateOPDatawithColor()
    {
        try
        {
            Map<String,String> setValsColors = new Map<String,String>();
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapOP.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapOP.put(pName,mapVals);
                    mapOPColors.put(pName,setValsColors);
                    mapVals = new Map<String,String>();  
                    setValsColors = new Map<String,String>();
                }
                Map<String,String> setVals = mapOP.get(proName);
                
                if(proName.contains(defaultOrgName))
                    compareProName = proName.replace(defaultOrgName,compareToOrgName);
                else
                    compareProName = proName.replace(compareToOrgName,defaultOrgName);
                
                for(String opName : lstOP)
                {
                        if(setVals.containskey(opName))
                        {
                            if(mapOP.containskey(compareProName) && mapOP.get(compareProName).containskey(opName))
                            {
                                indVal1 = mapOP.get(compareProName).get(opName).split('-');
                                indVal2 = setVals.get(opName).split('-');
                                strBGColor = '';
                                integer arLength;
                                
                                if(indVal1.size()<=indVal2.size())
                                    arLength = indVal1.size();
                                else
                                    arLength = indVal2.size();
                                    
                                if(arLength>0)
                                {
                                    for(integer i=0;i<arLength;i++)
                                    {
                                        if(indVal1[i]!=indVal2[i])
                                        strBGColor = strBGColor + '-RED';
                                        else
                                        strBGColor = strBGColor + '-BLACK';
                                    }
                                    
                                    setValsColors.put(opName,strBGColor.right(strBGColor.length()-1));    
                                }
                                else
                                    setValsColors.put(opName,'RED-RED-RED-RED-RED-RED');
                            }
                            else
                            {
                                // BLACK-BLACK-BLACK-BLACK-BLACK-BLACK
                                if(mapOP.containskey(compareProName))
                                    setValsColors.put(opName,'RED-RED-RED-RED-RED-RED');
                                else
                                    setValsColors.put(opName,' BLACK-BLACK-BLACK-BLACK-BLACK-BLACK');
                            }
                            mapVals.put(opName ,setVals.get(opName));
                        }
                        else
                        {
                            setValsColors.put(opName,'BLACK-BLACK-BLACK-BLACK-BLACK-BLACK-BLACK');
                            mapVals.put(opName ,'-');
                        }
                        if(opName.equalsignorecase('Test1Objects'))
                            system.debug(lstOP.size() + 'hey there--->' + proName + '--->' + opName + '--->' +  setValsColors);
                }
                pName = proName;
                if(counter==mapOP.size())
                {
                    mapOP.put(pName,mapVals);
                    mapOPColors.put(pName,setValsColors);
                }
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the custom object permission data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }
    
    /**
        This method pulls,process and builds Standard and Custom Objects permission Data with no difference highlighter code.
    */
    private void generateOPData()
    {
        try
        {
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapOP.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapOP.put(pName,mapVals);
                    mapVals = new Map<String,String>();  
                }
                Map<String,String> setVals = mapOP.get(proName);
                
                for(String opName : lstOP)
                {
                        if(setVals.containskey(opName))
                            mapVals.put(opName ,setVals.get(opName));
                        else
                            mapVals.put(opName ,'-');
                }
                pName = proName;
                if(counter==mapOP.size())
                {
                    mapOP.put(pName,mapVals);
                }
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the custom object permission data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }
    
    /**
        This method pulls,process and builds the Administratve and General Permissions Data with difference highlighter code.
    */
    private void generateAGDatawithColor()
    {
        try
        {
            Map<String,String> setValsColors = new Map<String,String>();
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapAG.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapAG.put(pName,mapVals);
                    mapAGColors.put(pName,setValsColors);
                    mapVals = new Map<String,String>();  
                    setValsColors = new Map<String,String>();
                }
                Map<String,String> setVals = mapAG.get(proName);
                
                if(proName.contains(defaultOrgName))
                    compareProName = proName.replace(defaultOrgName,compareToOrgName);
                else
                    compareProName = proName.replace(compareToOrgName,defaultOrgName);
                
                for(String agName : lstAG)
                {
                        if(setVals.containskey(agName))
                        {
                            if(mapAG.containskey(compareProName) && mapAG.get(compareProName).get(agName) != setVals.get(agName))
                                setValsColors.put(agName,'RED');
                            else
                                setValsColors.put(agName,'BLACK');
                                
                            mapVals.put(agName ,setVals.get(agName));
                        }
                        else
                        {
                            setValsColors.put(agName,'BLACK');
                            mapVals.put(agName ,'-');
                        }
                }
                pName = proName;
                if(counter==mapAG.size())
                {
                    mapAG.put(pName,mapVals);
                    mapAGColors.put(pName,setValsColors);
                }
                counter++;
            }
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the administrative and general permission data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }   
    }
    
    /**
        This method pulls,process and builds the Administratve and General Permissions Data with no difference highlighter code.
    */
    private void generateAGData()
    {
        try
        {
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapAG.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapAG.put(pName,mapVals);
                    mapVals = new Map<String,String>();  
                }
                Map<String,String> setVals = mapAG.get(proName);
                
                for(String agName : lstAG)
                {
                        if(setVals.containskey(agName))
                            mapVals.put(agName ,setVals.get(agName));
                        else
                            mapVals.put(agName ,'-');
                }
                pName = proName;
                if(counter==mapAG.size())
                {
                    mapAG.put(pName,mapVals);
                }
                counter++;
            }
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the administrative and general permission data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }   
    }
    
    /**
        This method pulls,process and builds the Record Type Permissions Data with difference highlighter code.
    */
    private void generateRTDatawithColor()
    {
        try
        {
            Map<String,String> setValsColors = new Map<String,String>();
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapRT.keyset())
            {
                
                if(pName!='' && pName!=proName)
                {
                    mapRT.put(pName,mapVals);
                    mapRTColors.put(pName,setValsColors);
                    mapVals = new Map<String,String>();
                    setValsColors = new Map<String,String>();
                }
                Map<String,String> setVals = mapRT.get(proName);
                
                if(proName.contains(defaultOrgName))
                    compareProName = proName.replace(defaultOrgName,compareToOrgName);
                else
                    compareProName = proName.replace(compareToOrgName,defaultOrgName);
                
                for(String rtName : lstRT)
                {
                        if(setVals.containskey(rtName))
                        {
                            if(mapRT.containskey(compareProName) && mapRT.get(compareProName).get(rtName) != setVals.get(rtName))
                                setValsColors.put(rtName,'RED');
                            else
                                setValsColors.put(rtName,'BLACK');
                                
                            mapVals.put(rtName ,setVals.get(rtName));
                        }
                        else
                        {
                            setValsColors.put(rtName,'BLACK');
                            mapVals.put(rtName ,'-');
                        }
                        
                }
                pName = proName;
                if(counter==mapRT.size())
                {
                    mapRT.put(pName,mapVals);
                    mapRTColors.put(pName,setValsColors);
                }
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the record type permission data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        } 
    } 
    
    /**
        This method pulls,process and builds the Record Type Permissions Data with no difference highlighter code.
    */
    private void generateRTData()
    {
        try
        {
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapRT.keyset())
            {
                
                if(pName!='' && pName!=proName)
                {
                    mapRT.put(pName,mapVals);
                    mapVals = new Map<String,String>();  
                }
                Map<String,String> setVals = mapRT.get(proName);
                
                for(String rtName : lstRT)
                {
                        if(setVals.containskey(rtName))
                            mapVals.put(rtName ,setVals.get(rtName));
                        else
                            mapVals.put(rtName ,'-');
                        
                }
                pName = proName;
                if(counter==mapRT.size())
                {
                    mapRT.put(pName,mapVals);
                }
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the record type permission data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        } 
    } 
    
    /**
        This method pulls,process and builds the Tab Setting Data  with difference highlighter code.
    */
    private void generateTSDatawithColor()
    {
        try
        {
            Map<String,String> setValsColors = new Map<String,String>();
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapTS.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapTS.put(pName,mapVals);
                    mapTSColors.put(pName,setValsColors);
                    mapVals = new Map<String,String>();  
                    setValsColors = new Map<String,String>();
                }
                Map<String,String> setVals = mapTS.get(proName);
                
                if(proName.contains(defaultOrgName))
                    compareProName = proName.replace(defaultOrgName,compareToOrgName);
                else
                    compareProName = proName.replace(compareToOrgName,defaultOrgName);
                
                for(String tsName : lstTS)
                {
                        if(setVals.containskey(tsName))
                        {
                            if(mapTS.containskey(compareProName) && mapTS.get(compareProName).get(tsName) != setVals.get(tsName))
                                setValsColors.put(tsName,'RED');
                            else
                                setValsColors.put(tsName,'BLACK');
                            mapVals.put(tsName ,setVals.get(tsName));
                        }
                        else
                        {
                            setValsColors.put(tsName,'BLACK');
                            mapVals.put(tsName ,'-');
                        }
                }
                pName = proName;
                if(counter==mapTS.size())
                {
                    mapTS.put(pName,mapVals);
                    mapTSColors.put(pName,setValsColors);
                }
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the tab setting data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }     
    
    /**
        This method pulls,process and builds the Tab Setting Data with no difference highlighter code.
    */
    private void generateTSData()
    {
        try
        {
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapTS.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapTS.put(pName,mapVals);
                    mapVals = new Map<String,String>();  
                }
                Map<String,String> setVals = mapTS.get(proName);
                
                for(String tsName : lstTS)
                {
                        if(setVals.containskey(tsName))
                            mapVals.put(tsName ,setVals.get(tsName));
                        else
                            mapVals.put(tsName ,'-');
                }
                pName = proName;
                if(counter==mapTS.size())
                {
                    mapTS.put(pName,mapVals);
                }
                counter++;
            }  
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the tab setting data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }             
    }
    
    /**
        This method pulls,process and builds Custom App Settings Data with difference highlighter code.
    */
    private void generateCADatawithColor()
    {
        try
        {
            Map<String,String> setValsColors = new Map<String,String>();
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapCA.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapCA.put(pName,mapVals);
                    mapCAColors.put(pName,setValsColors);
                    mapVals = new Map<String,String>();  
                    setValsColors = new Map<String,String>();
                }
                Map<String,String> setVals = mapCA.get(proName);
               
                if(proName.contains(defaultOrgName))
                    compareProName = proName.replace(defaultOrgName,compareToOrgName);
                else
                    compareProName = proName.replace(compareToOrgName,defaultOrgName);
                
                for(String caName : lstCA)
                {
                        if(setVals.containskey(caName))
                        {
                            if(mapCA.containskey(compareProName) && mapCA.get(compareProName).containskey(caName))
                            {
                                indVal1 = mapCA.get(compareProName).get(caName).split('-');
                                indVal2 = setVals.get(caName).split('-');
                            
                                if(indVal1.size()>0 && indVal2.size()>0 && indVal1[0]!=indVal2[0])
                                    setValsColors.put(caName,'RED-BLACK');
                                else if(indVal1.size()>0 && indVal2.size()>0 && indVal1[1]!=indVal2[1])
                                    setValsColors.put(caName,'BLACK-RED');
                                else if(indVal1.size()>0 && indVal2.size()>0)
                                    setValsColors.put(caName,'BLACK-BLACK');
                                else
                                    setValsColors.put(caName,'RED-RED');
                            }
                            else
                                setValsColors.put(caName,'BLACK-BLACK');
                                
                            mapVals.put(caName ,setVals.get(caName));
                        }
                        else
                        {
                            setValsColors.put(caName,'BLACK-BLACK');
                            mapVals.put(caName ,'-');
                        }
                }
                pName = proName;
                if(counter==mapCA.size())
                {
                    mapCA.put(pName,mapVals);
                    mapCAColors.put(pName,setValsColors);
                }
                counter++;
            }
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the custom app setting data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }               
    }
    
    /**
        This method pulls,process and builds Custom App Settings Data with no difference highlighter code.
    */
    private void generateCAData()
    {
        try
        {
            String pName='';
            Map<String,String> mapVals = new Map<String,String>();
            Integer counter =1;
            for(String proName : mapCA.keyset())
            {
                if(pName!='' && pName!=proName)
                {
                    mapCA.put(pName,mapVals);
                    mapVals = new Map<String,String>();  
                }
                Map<String,String> setVals = mapCA.get(proName);
                
                for(String caName : lstCA)
                {
                        if(setVals.containskey(caName))
                            mapVals.put(caName ,setVals.get(caName));
                        else
                            mapVals.put(caName ,'-');
                }
                pName = proName;
                if(counter==mapCA.size())
                {
                    mapCA.put(pName,mapVals);
                }
                counter++;
            }
        }
        catch(Exception ex)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Error occured while reading the custom app setting data.Please contact the system administrator.!');            
           ApexPages.addmessage(myMsg); 
        }               
    }
     
}