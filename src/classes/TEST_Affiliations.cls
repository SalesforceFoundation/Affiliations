/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TEST_Affiliations {

    /// <name> Affiliations_Test </name>
    /// <summary> test default constructor </summary>
    static testMethod void Affiliations_Test() {
        Affiliations testAffiliations = new Affiliations();
    }
    
    /// <name> newContactOnOrgAccount </name>
    /// <summary> test creation of affiliation for contact on an Org account </summary>
    static testMethod void newContactOnOrgAccount() {
    	
    	Affiliations_Settings__c affiliationsSettingsForTests = Affiliations.getAffiliationsSettingsForTests(new Affiliations_Settings__c (Automatic_Affiliation_Creation_Turned_On__c = true));
        
        Account acc = new Account(Name='test77');
        insert acc;
        
        String title = 'CEO';
        Contact con = new Contact(
            FirstName='test',
            LastName='contact66',
            Title=title,
            AccountId = acc.Id
        );
        insert con;
        
        Id firstAffiliationId;
        
        Affiliation__c[] createdAffiliations = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c=:con.id AND Organization__c = :acc.id];
        
        firstAffiliationId = createdAffiliations[0].Id;
        
        system.assertEquals(system.label.DefaultCurrentStatus, createdAffiliations[0].Status__c);
        system.assertEquals(title, createdAffiliations[0].Role__c);
        system.assertEquals(System.Today(), createdAffiliations[0].StartDate__c);
        
        Account acc2 = new Account(Name='test88');
        insert acc2;
        
        con.AccountId = acc2.id;
        update con;
        
        Affiliation__c[] createdAffiliations2 = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c=:con.id AND Organization__c = :acc2.id];
        
        system.assertEquals(system.label.DefaultCurrentStatus, createdAffiliations2[0].Status__c);
        system.assertEquals(title, createdAffiliations2[0].Role__c);
        system.assertEquals(System.Today(), createdAffiliations2[0].StartDate__c);
        
        createdAffiliations = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where id=:firstAffiliationId];
        
        system.assertEquals(system.label.DefaultFormerStatus, createdAffiliations[0].Status__c);
        system.assertEquals(System.Today(), createdAffiliations[0].EndDate__c);        
    }
    
    static testMethod void newContactOnOrgAccountAutoOff() {
    	
    	Affiliations_Settings__c affiliationsSettingsForTests = Affiliations.getAffiliationsSettingsForTests(new Affiliations_Settings__c (Automatic_Affiliation_Creation_Turned_On__c = false));
        
        Account acc = new Account(Name='test77');
        insert acc;
        
        String title = 'CEO';
        Contact con = new Contact(
            FirstName='test',
            LastName='contact66',
            Title=title,
            AccountId = acc.Id
        );
        insert con;
        
        Id firstAffiliationId;
        
        Affiliation__c[] createdAffiliations = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c=:con.id AND Organization__c = :acc.id];
        
        system.assertEquals(0, createdAffiliations.size());        
    }


    /// <name> createAffiliation_Test </name>
    /// <summary> test method for createAffiliation_Test function </summary>
    static testMethod void newContactOnIndividualAccount() {
    	
    	Affiliations_Settings__c affiliationsSettingsForTests = Affiliations.getAffiliationsSettingsForTests(new Affiliations_Settings__c (Automatic_Affiliation_Creation_Turned_On__c = true));
        
        Account acc = new Account(Name='Individual');
        insert acc;
        
        Contact con = new Contact(FirstName='test', LastName='contact34',AccountId=acc.id);
        insert con;
        
        Affiliation__c[] createdAffiliations = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c=:con.id AND Organization__c = :acc.id];
        
        system.assertEquals(0, createdAffiliations.size());    
    }


    /// <name> newContactOnOrgAccount </name>
    /// <summary> test creation of affiliation for contact on an Org account </summary>
    static testMethod void contactWithMultipleAffiliations() {
    	
    	Affiliations_Settings__c affiliationsSettingsForTests = Affiliations.getAffiliationsSettingsForTests(new Affiliations_Settings__c (Automatic_Affiliation_Creation_Turned_On__c = true));
        
        Account acc = new Account(Name='test77');
        insert acc;
        
        Account acc2 = new Account(Name='test88');
        insert acc2;
        
        Account acc3 = new Account(Name='test99');
        insert acc3;
        
        String title = 'CEO';
        Contact con = new Contact(
            FirstName='test',
            LastName='contact66',
            Title=title,
            AccountId = acc.Id
        );
        insert con;
        
        Id firstAffiliationId;
        
        Affiliation__c[] createdAffiliations = [select id from Affiliation__c where Contact__c=:con.id AND Organization__c = :acc.id];
        
        firstAffiliationId = createdAffiliations[0].Id;
        
        con.AccountId = acc2.id;
        update con;
        
        Id secondAffiliationId;
        
        Affiliation__c[] createdAffiliations2 = [select id from Affiliation__c where Contact__c=:con.id AND Organization__c = :acc2.id];
        
        secondAffiliationId = createdAffiliations2[0].id;
        
        con.AccountId = acc3.id;
        update con;
        
        Affiliation__c[] createdAffiliations3 = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c=:con.id AND Organization__c = :acc3.id];
        createdAffiliations = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c=:con.id AND Organization__c = :acc.id];
        createdAffiliations2 = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c=:con.id AND Organization__c = :acc2.id];
        
        system.assertEquals(system.label.DefaultCurrentStatus, createdAffiliations3[0].Status__c);
        system.assertEquals(system.label.DefaultFormerStatus, createdAffiliations[0].Status__c);
        system.assertEquals(system.label.DefaultFormerStatus, createdAffiliations2[0].Status__c);        
    }
}