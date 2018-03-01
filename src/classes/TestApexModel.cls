/**
 * Created by Ar-Krav on 28.02.2018.
 */

public with sharing class TestApexModel {

    public List<Location__c> getUserAdminLocations(Id id, Boolean isGlobalAdmin){
        if (isGlobalAdmin) {
            return [SELECT name FROM Location__c];
        }
        else {
            return getUserPermissedLocations(id);
        }
    }

    public Boolean isUSerGlobalAdmin(Id userId){
        return getUserPermissedLocations(userId).isEmpty();
    }

    private List<Location__c> getUserPermissedLocations(Id userId){
        return [SELECT name FROM Location__c
                WHERE Id in (SELECT Location__c FROM UserPermissions__c WHERE User__c = :userId)];
    }

}