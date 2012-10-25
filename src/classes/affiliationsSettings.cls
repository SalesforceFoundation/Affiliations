public with sharing class affiliationsSettings {

    public Affiliations_Settings__c settingsToUpdate;
    public Affiliations_Settings__c pageSettings = new Affiliations_Settings__c();
    
    public affiliationsSettings(){
        
    }
    
    public Affiliations_Settings__c getSettings() {
        pageSettings = Affiliations.getAffiliationsSettings();
        return pageSettings;
    }
    //we can't do a DML in a getter, so I call it from the action of the page
    public PageReference getSettingsFirstTime() {
        pageSettings = Affiliations.getAffiliationsSettings();
        return null;
    }
    
    
    private void showInfoMsg(String arg){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,arg);
        ApexPages.addMessage(myMsg);
    }
    
    public void updateSettings(){
        
        update pageSettings;
        showInfoMsg('Affiliations Settings updated');
    }
    
     public static testMethod void TEST_affiliationsSettings() {
        
        Test.setCurrentPageReference(new PageReference('Page.affiliationsSettings'));
        
        //pass the controller into the extension
        affiliationsSettings controller = new affiliationsSettings(); 
        controller.getSettingsFirstTime();
        system.assertNotEquals(null,controller.getSettings());
        controller.updateSettings();       
    }
}