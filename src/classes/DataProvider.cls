/**
 * Created by Adelchi on 11/07/2023.
 */


public with sharing class DataProvider {

    public class WrapperDirection{
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String country{get;set;}
        @AuraEnabled public String postalCode{get;set;}
        @AuraEnabled public String street{get;set;}
        @AuraEnabled public String type{get;set;}
    }

    @AuraEnabled (cacheable=true)
    public static List<WrapperDirection> getListAccountAddresses(Boolean filter){

        System.debug(filter);

        String userId = System.UserInfo.getUserId();


        List<Lead> leadList = new List<Lead>();
        List<Lead> leadListGen = new List<Lead>();
        List<Account> accountList = new List<Account>();
        List<Account> accountListGen = new List<Account>();
        List<WrapperDirection> wrapperListToReturn = new List<WrapperDirection>();

        accountListGen = [
                SELECT Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude
                FROM Account
        ];

        leadList = [
                SELECT Name, City, Street, Country, PostalCode
                FROM Lead WHERE Status != 'Archiviato' AND OwnerId =: userId
        ];

        leadListGen = [
                SELECT Name, City, Street, Country, PostalCode
                FROM Lead WHERE Status != 'Archiviato'
        ];

        accountList = [
                SELECT Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude
                FROM Account WHERE OwnerId =: userId
        ];

        if(filter){
            for(Lead record : leadList){
                WrapperDirection wrapper = new WrapperDirection();
                wrapper.city = record.City;
                wrapper.street = record.Street;
                wrapper.country = record.Country;
                wrapper.postalCode = record.PostalCode;
                wrapper.name = record.Name;
                wrapper.type = 'L';
                wrapperListToReturn.add(wrapper);
            }
            for(Account record : accountList){
                WrapperDirection wrapper = new WrapperDirection();
                wrapper.city = record.BillingCity;
                wrapper.street = record.BillingStreet;
                wrapper.country = record.BillingCountry;
                wrapper.postalCode = record.BillingPostalCode;
                wrapper.name = record.Name;
                wrapper.type = 'A';
                wrapperListToReturn.add(wrapper);
            }
            System.debug('List array --> '+ wrapperListToReturn);
            return wrapperListToReturn;

        }else{
            for(Lead record : leadListGen){
                WrapperDirection wrapper = new WrapperDirection();
                wrapper.city = record.City;
                wrapper.street = record.Street;
                wrapper.country = record.Country;
                wrapper.postalCode = record.PostalCode;
                wrapper.name = record.Name;
                wrapper.type = 'L';
                wrapperListToReturn.add(wrapper);
            }

            for(Account record : accountListGen){
                WrapperDirection wrapper = new WrapperDirection();
                wrapper.city = record.BillingCity;
                wrapper.street = record.BillingStreet;
                wrapper.country = record.BillingCountry;
                wrapper.postalCode = record.BillingPostalCode;
                wrapper.name = record.Name;
                wrapper.type = 'A';
                wrapperListToReturn.add(wrapper);
            }
            System.debug('List array --> '+ wrapperListToReturn);
            return wrapperListToReturn;
        }

    }

    @AuraEnabled
    public static Double getDistanceBetween(Decimal x1a, Decimal y1a, Decimal x2a, Decimal y2b ){

        System.Location loc1 = Location.newInstance(x1a, y1a);
        System.Location loc2 = Location.newInstance(x2a, y2b);
        Double dist = Location.getDistance(loc1, loc2, 'km');
        return dist;
    }

}