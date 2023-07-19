/**
 * Created by Adelchi on 17/07/2023.
 */

trigger LeadTriggerMain on Lead (after insert, after update, before update, before insert) {
    System.debug('Lead Trigger ....');

    if( Trigger.isInsert && Trigger.isAfter){
        for ( Lead l : Trigger.new){
//            if (l.LeadSource.contains('web')) {
                List<Lead> leadList = new List<Lead>();
                leadList.add(l);
                Utilities.sendPublicLink(leadList);
//            }

        }

    }

}