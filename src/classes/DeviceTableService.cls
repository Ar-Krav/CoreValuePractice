/**
 * Created by Ar-Krav on 28.02.2018.
 */

public with sharing class DeviceTableService {

    public List<Location__c> getLocationUserAdmin(Id id){
        List<Location__c> loc = [SELECT name FROM Location__c
        WHERE Id in (SELECT Location__c FROM UserPermissions__c WHERE User__c = :id)];


        if (loc.get(0).name != null) {
            return loc;
        }
        else {
            return [SELECT name FROM Location__c];
        }
    }

    public ApexPages.StandardSetController getDevicesStandardSetController(List<Location__c> location, DeviceTableFilters filters){
        String query = 'SELECT imageUrl__c, Name, AssignedToEmployee__r.name, InvNo__c, RecordType.name, LocationID__c'+
                ' FROM Hardware__c'+
                ' WHERE Parent__c=null'+
                ' AND LocationID__c IN :locations' +
                ' AND name LIKE \'%' + filters.nameFilterValue + '%\'' + getOwnerFilterQuery(filters.ownerFilterValue) +
                ' AND InvNo__c LIKE \'%' + filters.seriaFilterValue + '%\''+
                ' AND RecordType.developerName LIKE \'%' + filters.typeFilterValue + '%\''+
                ' ORDER BY Name';
        return new ApexPages.StandardSetController(database.getQueryLocator(query));
    }

    private String getOwnerFilterQuery(String ownerFilterValue){
        return ownerFilterValue.equals('') ? ownerFilterValue : ' AND AssignedToEmployee__r.name LIKE \'%' + ownerFilterValue + '%\'';
    }
}