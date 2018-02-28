/**
 * Created by Ar-Krav on 28.02.2018.
 */

public with sharing class DeviceTableService {
    public ApexPages.StandardSetController getDevicesStandardSetController(List<Location__c> locations, DeviceTableFilters filters){
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

    public List<Hardware__c> getDeviceConfigurationHardwares(Id id){
        List<String> allowedRecordTypes = new List<String> {'Motherboard','CPU','RAM','HDD'};

        return [SELECT Name, InvNo__c, RecordType.name, Parent__c
        FROM Hardware__c
        WHERE Parent__c=:id
        AND RecordType.developername IN :allowedRecordTypes
        ORDER BY RecordType.developerName];
    }

    public void updateDeviceLocation(List<Hardware__c> devices){
        update devices;
    }

    public List<SelectOption> getRelocationSelectedOptions(){
        List<SelectOption> selectionList = new List<SelectOption>();

        for (Location__c location : [SELECT name FROM Location__c]) {
            selectionList.add(new SelectOption(location.id, location.name));
        }

        return selectionList;
    }
}