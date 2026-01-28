trigger PurchaseLineTrigger on PurchaseLine__c (after insert, after update, after delete, after undelete) {

    List<PurchaseLine__c> lines = Trigger.isDelete ? Trigger.old : Trigger.new;

    PurchaseLineTriggerHandler.calculateTotals(lines);
}