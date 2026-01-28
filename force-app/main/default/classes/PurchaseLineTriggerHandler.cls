public with sharing class PurchaseLineTriggerHandler {

    public static void calculateTotals(List<PurchaseLine__c> lines) {
        Set<Id> purchaseIds = new Set<Id>();
        for (PurchaseLine__c line : lines) {
            if(line.PurchaseId__c != null) {
                purchaseIds.add(line.PurchaseId__c);
            }
        }

        if(purchaseIds.isEmpty()) {
            return;
        }

        // map for updates and speed
        Map<Id, Purchase__c> purchasesToUpdateMap = new Map<Id, Purchase__c>();
        for(Id pId: purchaseIds) {
            purchasesToUpdateMap.put(pId, new Purchase__c(
                    Id = pId,
                    TotalItems__c = 0,
                    GrandTotal__c = 0
            ));
        }

        // get Amount__c, PurchaseId__c, UnitCost__c, for update a Cost
        List<PurchaseLine__c> allLines = [
                SELECT Amount__c, PurchaseId__c, UnitCost__c
                FROM PurchaseLine__c
                WHERE PurchaseId__c IN :purchaseIds
        ];

        // do math section
        for(PurchaseLine__c line: allLines) {
            Purchase__c parent = purchasesToUpdateMap.get(line.PurchaseId__c);
            if(line.Amount__c != null && line.UnitCost__c != null) {
                parent.TotalItems__c += line.Amount__c;
                parent.GrandTotal__c += (line.Amount__c * line.UnitCost__c);
            }
        }

        // small
        if (!purchasesToUpdateMap.isEmpty()) {
            update purchasesToUpdateMap.values();
        }
    }
}