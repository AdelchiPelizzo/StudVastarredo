/**
 * Created by Adelchi on 06/07/2023.
 */

global with sharing class LeadManager implements Schedulable {

    global void execute(SchedulableContext ctx) {

        System.debug('schedule executing');

        List<CronTrigger> cronTriggers = [SELECT CronJobDetail.Name, CronExpression, NextFireTime FROM CronTrigger];
        System.debug(cronTriggers.size());

        Date dateOfToday = Date.today();

        if (cronTriggers.size() < 99){
            System.debug('inside first check');
            List<Lead> leadToUpdate = new List<Lead>();
            leadToUpdate = [SELECT Id, LastActivityDate, LastModifiedDate, Status FROM Lead WHERE Status != 'Archiviato'];

            System.debug('lead to update '+leadToUpdate);
            for(Integer i = 0; i < leadToUpdate.size(); i++){
                System.debug('inside for loop ');
                Integer numberDaysActivity = 0;
                if(leadToUpdate[i].LastActivityDate != null){
                    numberDaysActivity = Integer.valueOf(leadToUpdate[i].LastActivityDate.daysBetween(dateOfToday));
                    System.debug('numberDaysActivity inside if '+numberDaysActivity);
                }
                System.debug('numberDaysActivity outside if '+numberDaysActivity);
                Integer numberDaysModify = leadToUpdate[i].LastModifiedDate.date().daysBetween(dateOfToday);
                System.debug('numberDaysModify '+numberDaysModify);
                 if(true){
//                 if((numberDaysModify > 1) && (numberDaysActivity > 1) ){
                    System.debug('inside timelapse check');

                    leadToUpdate[i].Status = 'Archiviato';
                    System.debug('Chronos Job Limit Not exceeded  '+cronTriggers.size());

                }else{
                    System.debug('inside timelapse ELSE');

                }
            }
            update leadToUpdate;
        }else{

            System.debug('inside first check ELSE  ');
            System.debug('Chronos Job Limit exceeded  '+cronTriggers.size());
            sendEmail();
        }
    }

    public static void sendEmail(){
        System.debug('sending email');
        String emailUser = System.UserInfo.getUserEmail();
        String userName = System.UserInfo.getUserName();

        System.debug(emailUser);
        System.debug(userName);
        List<Messaging.Email> emails = new List<Messaging.Email>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(emailUser);
        List<String> ccAddresses = new List<String>();
        ccAddresses.add('etl@studioware.eu');
        email.setToAddresses(sendTo);
        email.setCcAddresses(ccAddresses);
        email.setReplyTo('assistenza@studioware.eu');
        email.setSenderDisplayName('Salesforce System');
        email.setSaveAsActivity(false);
        email.setSubject('Impostazione per l\'archiviazione Lead/Prospetti fallita');
        String body = '<html><body> Gentile ' + System.UserInfo.getName() + ',<br><br>L\'impostazione dell\' Archiviazione Periodica Prospetti/Lead, inerti da oltre un mese, e\' fallita.<br>Causa la presenza di oltre 99 processi attivi.<br>Si consiglia di eliminare almeno uno e riprovare.<br>Richiedere assistenza rispondendo a questo indirizzo email.</body></html>';

        email.setHtmlBody(body);
        emails.add(email);
        Messaging.sendEmail(emails);
    }
}
