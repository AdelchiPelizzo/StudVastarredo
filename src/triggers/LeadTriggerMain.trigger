/**
 * Created by Adelchi on 17/07/2023.
 */

trigger LeadTriggerMain on Lead (after insert, after update, before update, before insert) {
    System.debug('Lead Trigger ....');

    List<Lead> leadList = new List<Lead>();
    List<>

    for (Lead l : Trigger.new) {
        System.debug(l.Prodotto_di_interesse__c);
    }

}