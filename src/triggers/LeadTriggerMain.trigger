/**
 * Created by Adelchi on 17/07/2023.
 */

trigger LeadTriggerMain on Lead (after insert, after update, before update, before insert) {
    System.debug('Lead Trigger ....');

    List<Lead> leadList = new List<Lead>();

    if( Trigger.isInsert && Trigger.isAfter){
        for ( Lead l : Trigger.new){
//            if (l.LeadSource.contains('web')) {
                leadList.add(l);
                Utilities.sendPublicLink(leadList);
//            }

        }

    }

}