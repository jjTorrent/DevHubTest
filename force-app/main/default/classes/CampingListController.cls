public with sharing class CampingListController {
    @AuraEnabled
    public static List<Camping_Item__c> getItems() {
        List<String> fieldsToCheck = new List<String>{'Name','Quantity__c','Price__c','Packed__c'};
        Map<String, Schema.SObjectField> fieldDescribeTokens = Schema.SObjectType.Camping_Item__c.fields.getMap();
        for (String field : fieldsToCheck) {
            if (!fieldDescribeTokens.get(field).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        return [SELECT Id, Name, Quantity__c, Price__c, Packed__c FROM Camping_Item__c];
	}

	@AuraEnabled
    public static Camping_Item__c saveItem(Camping_Item__c item) {
        List<String> fieldsToCheck = new List<String>{'Name','Quantity__c','Price__c','Packed__c'};
        Map<String, Schema.SObjectField> fieldDescribeTokens = Schema.SObjectType.Camping_Item__c.fields.getMap();
        for (String field : fieldsToCheck) {
            if (!fieldDescribeTokens.get(field).getDescribe().isUpdateable()) {
                throw new System.NoAccessException();
            }
        }
        upsert item;
        return item;
	}
}