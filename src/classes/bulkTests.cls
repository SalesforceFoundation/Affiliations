public class bulkTests {

    static testMethod void newContactOnOrgAccount() {
        Account acc = new Account(Name='test77');
        insert acc;
        
        String newContactfirstName = 'test';
        String newContactLastName = 'Contact_forTests';
        String newContactTitle = 'CEO';
        List<Contact> cons = new List<contact>();
        Integer conCount = 200;
        for(Integer i=0;i<conCount;i++){
            Contact con = new Contact(
                FirstName=newContactfirstName,
                LastName=newContactLastName,
                Title=newContactTitle,
                AccountId = acc.Id
            );
            cons.add(con);
        }
        Test.startTest();
        insert cons;
        
        Id firstAffiliationId;
        
        Affiliation__c[] createdAffiliations = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c IN :cons AND Organization__c = :acc.id];
        
        firstAffiliationId = createdAffiliations[0].Id;
        
        system.assertEquals(conCount,createdAffiliations.size());
        
        system.assertEquals(system.label.DefaultCurrentStatus, createdAffiliations[0].Status__c);
        system.assertEquals(newContactTitle, createdAffiliations[0].Role__c);
        system.assertEquals(System.Today(), createdAffiliations[0].StartDate__c);
        
        Account acc2 = new Account(Name='test88');
        insert acc2;
        
        for(Contact thisContact : cons){    
            thisContact.AccountId = acc2.id;
        }
        update cons;
        Test.stopTest();
        Affiliation__c[] createdAffiliations2 = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c IN :cons AND Organization__c = :acc2.id];
        
        system.assertEquals(conCount,createdAffiliations2.size());
        
        system.assertEquals(system.label.DefaultCurrentStatus, createdAffiliations2[0].Status__c);
        system.assertEquals(newContactTitle, createdAffiliations2[0].Role__c);
        system.assertEquals(System.Today(), createdAffiliations2[0].StartDate__c);
        
    }
    
    static testMethod void newContactOnIndividualAccount() {
        Account acc = new Account(Name='Individual');
        insert acc;
        
        String newContactfirstName = 'test';
        String newContactLastName = 'Contact_forTests';
        String newContactTitle = 'CEO';
        List<Contact> cons = new List<contact>();
        Integer conCount = 200;
        for(Integer i=0;i<conCount;i++){
            Contact con = new Contact(
                FirstName=newContactfirstName,
                LastName=newContactLastName,
                Title=newContactTitle,
                AccountId = acc.Id
            );
            cons.add(con);
        }
        Test.startTest();
        insert cons;
        Test.stopTest();
        
        Affiliation__c[] createdAffiliations = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c IN :cons AND Organization__c = :acc.id];
        
        system.assertEquals(0, createdAffiliations.size());
    
    }
    
     static testMethod void contactWithMultipleAffiliations() {
        Account acc = new Account(Name='test77');
        insert acc;
        
        Account acc2 = new Account(Name='test88');
        insert acc2;
        
        Account acc3 = new Account(Name='test99');
        insert acc3;
        
        String newContactfirstName = 'test';
        String newContactLastName = 'Contact_forTests';
        String newContactTitle = 'CEO';
        List<Contact> cons = new List<contact>();
        Integer conCount = 200;
        for(Integer i=0;i<conCount;i++){
            Contact con = new Contact(
                FirstName=newContactfirstName,
                LastName=newContactLastName,
                Title=newContactTitle,
                AccountId = acc.Id
            );
            cons.add(con);
        }
        Test.startTest();
        insert cons;
        
        Id firstAffiliationId;
        
        Affiliation__c[] createdAffiliations = [select id from Affiliation__c where Contact__c IN :cons AND Organization__c = :acc.id];
        
        system.assertEquals(conCount,createdAffiliations.size());
        
        firstAffiliationId = createdAffiliations[0].Id;
        
        for(Contact thisContact : cons){    
            thisContact.AccountId = acc2.id;
        }
        update cons;
        
        Id secondAffiliationId;
        
        Affiliation__c[] createdAffiliations2 = [select id from Affiliation__c where Contact__c IN :cons AND Organization__c = :acc2.id];
        
        system.assertEquals(conCount,createdAffiliations2.size());
        
        secondAffiliationId = createdAffiliations2[0].id;
        
        for(Contact thisContact : cons){    
            thisContact.AccountId = acc3.id;
        }
        update cons;
        Test.stopTest();
        
        Affiliation__c[] createdAffiliations3 = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c IN :cons AND Organization__c = :acc3.id];
        createdAffiliations = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c IN :cons AND Organization__c = :acc.id limit 1];
        createdAffiliations2 = [select id, Status__c, StartDate__c, Role__c, Organization__c, EndDate__c, Contact__c from Affiliation__c where Contact__c IN :cons AND Organization__c = :acc2.id limit 1];
        
        system.assertEquals(conCount,createdAffiliations3.size());
        
        system.assertEquals(system.label.DefaultCurrentStatus, createdAffiliations3[0].Status__c);
        system.assertEquals(system.label.DefaultFormerStatus, createdAffiliations[0].Status__c);
        system.assertEquals(system.label.DefaultFormerStatus, createdAffiliations2[0].Status__c);
        
    }
}