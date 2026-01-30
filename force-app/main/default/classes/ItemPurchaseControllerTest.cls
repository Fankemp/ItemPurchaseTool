@IsTest
private class ItemPurchaseControllerTest {

    @TestSetup
    static void setupData() {
        // Create test Account
        Account acc = new Account(Name = 'Test Account', Industry = 'Technology', AccountNumber = '12345');
        insert acc;

        // Create test Items with different types and families
        List<Item__c> items = new List<Item__c>();
        items.add(new Item__c(Name = 'Laptop Pro', Type__c = 'Electronics', Family__c = 'Category A', Price__c = 1500, Description__c = 'Powerful laptop'));
        items.add(new Item__c(Name = 'Cloud Software', Type__c = 'Electronics', Family__c = 'Category B', Price__c = 500, Description__c = 'Business solution'));
        items.add(new Item__c(Name = 'Mouse Wireless', Type__c = 'Electronics', Family__c = 'Category C', Price__c = 50, Description__c = 'Office mouse'));
        insert items;
    }

    @IsTest
    static void testGetAccountInfo() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        Account result = ItemPurchaseController.getAccountInfo(acc.Id);
        Test.stopTest();

        System.assertEquals(acc.Id, result.Id, 'Should return the correct account');
        System.assertEquals('Test Account', result.Name, 'Account name mismatch');
    }

    @IsTest
    static void testGetItemsNoFilters() {
        Test.startTest();
        // Passing empty strings to get all items
        List<Item__c> results = ItemPurchaseController.getItems('', '', '');
        Test.stopTest();

        System.assertEquals(3, results.size(), 'Should return all 3 items');
    }

    @IsTest
    static void testGetItemsWithSearch() {
        Test.startTest();
        // Search by name
        List<Item__c> results = ItemPurchaseController.getItems('Laptop', '', '');
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should find 1 item with "Laptop"');
        System.assertEquals('Laptop Pro', results[0].Name);
    }

    @IsTest
    static void testGetItemsWithFilters() {
        Test.startTest();
        // Filter by Type and Family
        List<Item__c> results = ItemPurchaseController.getItems('', 'Category B', 'Electronics');
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should find 1 item with SaaS/Software');
        System.assertEquals('Cloud Software', results[0].Name);
    }

    @IsTest
    static void testGetItemsEmptyResult() {
        Test.startTest();
        // Search for something that doesn't exist
        List<Item__c> results = ItemPurchaseController.getItems('NonExistent', '', '');
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Should return 0 items for non-existent search');
    }
}