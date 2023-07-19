/**
 * Created by Adelchi on 17/07/2023.
 */

global without sharing class Utilities {

    public static void sendPublicLink(List<Lead> listLead){
        for(Lead l : listLead){
            String product = l.Prodotto_di_interesse__c.substringAfterLast('-');
            switch on product {
                when 'test1' {
//                    List<ContentDocument> cdList = [SELECT Id FROM ContentDocument WHERE Title =: l.Prodotto_di_interesse__c];
                    ContentVersion cv = [SELECT Id, ContentDocumentId, SharingOption FROM ContentVersion WHERE Title = 'test1' LIMIT 1];
                    System.debug(cv.SharingOption);
                    System.debug(cv.ContentDocumentId);
                    ContentDocumentLink cdLink = new ContentDocumentLink();
                    cdLink.LinkedEntityId = l.Id;
                    cdLink.ContentDocumentId = cv.ContentDocumentId;
                    cdLink.ShareType = 'V';
                    cdLink.Visibility = 'AllUsers';
                    insert cdLink;
                    System.debug(cdLink.Id);
                    ContentDistribution cd = new ContentDistribution();
                    cd.Name = l.Prodotto_di_interesse__c;
                    cd.ContentVersionId = cv.Id;
                    cd.PreferencesAllowViewInBrowser= true;
                    cd.PreferencesLinkLatestVersion=true;
                    cd.PreferencesNotifyOnVisit=true;
                    cd.PreferencesPasswordRequired=false;
                    cd.PreferencesAllowOriginalDownload= true;
                    System.debug(cd);
                    insert cd;
                    System.debug(cd.Id);
                    ContentDistribution cdReal = [SELECT ContentDownloadUrl FROM ContentDistribution WHERE Id =: cd.Id];
                    System.debug(cdReal.ContentDownloadUrl);

                    List<Messaging.SingleEmailMessage> mailSingleList =  new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage mailSingle =  new Messaging.SingleEmailMessage();

                    List<String> emailAddresses = new List<String>();
                    emailAddresses.add(l.Email);
                    mailSingle.setToAddresses(emailAddresses);
                    String body = cdReal.ContentDownloadUrl;
                    mailSingle.setSubject(l.Name+'  Your link is here');
                    mailSingle.setHtmlBody(body);
                    mailSingleList.add(mailSingle);
                    Messaging.sendEmail(mailSingleList);

                }
            }

        }
    }

}