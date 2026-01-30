public with sharing class ItemPurchaseController {
    @AuraEnabled(cacheable=true)
    public static Account getAccountInfo(Id accountId) {
        return [SELECT Id, Name, AccountNumber, Industry FROM Account WHERE Id = :accountId LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<Item__c> getItems(String searchTerm, String family, String type) {
        String query = 'SELECT Id, Name, Description__c, Price__c, Image__c, Family__c, Type__c FROM Item__c';
        List<String> filters = new List<String>();

        if (String.isNotBlank(searchTerm)) {
            String key = '%' + searchTerm + '%';
            filters.add('(Name LIKE :key OR Description__c LIKE :key)');
        }
        if (String.isNotBlank(family)) {
            filters.add('Family__c = :family');
        }
        if (String.isNotBlank(type)) {
            filters.add('Type__c = :type');
        }

        if (!filters.isEmpty()) {
            query += ' WHERE ' + String.join(filters, ' AND ');
        }

        return Database.query(query);
    }
}