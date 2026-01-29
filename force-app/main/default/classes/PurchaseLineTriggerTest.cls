@IsTest
private class PurchaseLineTriggerTest {

    @IsTest
    static void testFullPurchaseCycle() {
        // create a test client
        Account acc = new Account(Name = 'Test Client');
        insert acc;

        // create item
        Item__c product = new Item__c(
                Name = 'Laptop',
                Price__c = 1000,
                Type__c = 'Electronics',
                Family__c = 'Category A'
        );
        insert product;

        // create a test Purchase and insert
        Purchase__c purchase = new Purchase__c(
                ClientId__c = acc.Id
        );
        insert purchase;

        // test for PurchaseLine
        PurchaseLine__c line1 = new PurchaseLine__c(
                PurchaseId__c = purchase.Id,
                ItemId__c = product.Id,
                Amount__c = 2,
                UnitCost__c = 1000
        );

        Test.startTest();
        insert line1;
        Test.stopTest();

        // check our trigger
        purchase = [SELECT TotalItems__c, GrandTotal__c FROM Purchase__c WHERE Id = :purchase.Id];
        System.assertEquals(2, purchase.TotalItems__c, 'Total items should be 2');
        System.assertEquals(2000, purchase.GrandTotal__c, 'Grand total should be 2000');

        // test that our update work
        line1.Amount__c = 3;
        update line1;

        purchase = [SELECT GrandTotal__c FROM Purchase__c WHERE Id = :purchase.Id];
        System.assertEquals(3000, purchase.GrandTotal__c, 'Grand total after update should be 3000');

        // test that delete work
        delete line1;

        purchase = [SELECT GrandTotal__c FROM Purchase__c WHERE Id = :purchase.Id];
        System.assertEquals(0, purchase.GrandTotal__c, 'Grand total after deletion should be 0');

        // test that undelete work
        undelete line1;

        purchase = [SELECT GrandTotal__c FROM Purchase__c WHERE Id = :purchase.Id];
        System.assertEquals(3000, purchase.GrandTotal__c, 'Grand total after undelete should be 3000');
    }

    @IsTest
    static void testBulkInsert() {
        // test how the trigger handles many records at once (Bulk testing)
        Account acc = new Account(Name = 'Bulk Client');
        insert acc;

        Item__c product = new Item__c(Name = 'Bulk Item', Price__c = 10, Type__c = 'Electronics', Family__c = 'Category A');
        insert product;

        Purchase__c p = new Purchase__c(ClientId__c = acc.Id);
        insert p;

        List<PurchaseLine__c> lines = new List<PurchaseLine__c>();
        for(Integer i = 0; i < 200; i++) {
            lines.add(new PurchaseLine__c(
                    PurchaseId__c = p.Id,
                    ItemId__c = product.Id,
                    Amount__c = 1,
                    UnitCost__c = 10
            ));
        }

        Test.startTest();
        insert lines;
        Test.stopTest();

        p = [SELECT TotalItems__c, GrandTotal__c FROM Purchase__c WHERE Id = :p.Id];
        System.assertEquals(200, p.TotalItems__c, 'Bulk: Total items count mismatch');
        System.assertEquals(2000, p.GrandTotal__c, 'Bulk: Grand total mismatch');
    }
}