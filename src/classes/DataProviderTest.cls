/**
 * Created by Adelchi on 20/07/2023.
 */

@IsTest(SeeAllData = true)
private class DataProviderTest {

    public static Lead leadTest;

    public static void generateTestRecords(){
        leadTest = new Lead();
        leadTest.LastName = 'testLastName';
        leadTest.Email = 'test@test.test';
        leadTest.Phone = '01234567890';
        leadTest.Status = 'Nuevo';
        leadTest.Company = 'testCompany';
        leadTest.Prodotto_di_interesse__c = 'test-test1';
        insert leadTest;

    }

    @IsTest
    static void testBehavior() {

        generateTestRecords();

        DataProvider.getListAccountAddresses(true);
        DataProvider.getListAccountAddresses(false);

    }
}