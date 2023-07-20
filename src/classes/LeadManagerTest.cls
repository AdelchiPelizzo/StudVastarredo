/**
 * Created by Adelchi on 20/07/2023.
 */

@IsTest (SeeAllData=true)
private class LeadManagerTest {

    public static Lead leadTest;
    public static User userTest;

    public static void generateTestRecords(){
        leadTest = new Lead();
        leadTest.LastName = 'testLastName';
        leadTest.Email = 'test@test.test';
        leadTest.Phone = '01234567890';
        leadTest.Status = 'Nuevo';
        leadTest.Company = 'testCompany';
        leadTest.Prodotto_di_interesse__c = 'test-test1';
        insert leadTest;
        leadTest.LastName = 'toastLastName';
        update leadTest;
        userTest = new User();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        userTest = new User(
            Alias = 'standt',
            Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8',
            LastName='testName',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            Username='vastarredoTest@testorg.com'
        );

        insert userTest;

    }


    @IsTest
    static void testBehavior() {
        Test.startTest();
        generateTestRecords();
        LeadManager leadMan = new LeadManager();
        String sch = '0 0 15 * * ?';
        System.schedule('Test status Check', sch, leadMan );
        LeadManager.sendEmail();
        Test.stopTest();

    }
}