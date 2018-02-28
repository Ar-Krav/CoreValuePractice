/**
 * Created by Ar-Krav on 24.01.2018.
 */

public with sharing class DevicePageDataModel {

    private String nameFilterValue, seriaFilterValue, typeFilterValue, ownerFilterValue;
    private List<Location__c> allOfficeLocation;
    private Boolean isGlobalAdmin;
    private List<Location__c> allCities;

    public DevicePageDataModel(){
        allCities = getLocations();
    }

    public List<Location__c> getAllCities(){
        return allCities;
    }

    public Boolean getIsGlobalAdmin(){
        return isGlobalAdmin;
    }

    public void setFilterFields(String nameFilterValue, String ownerFilterValue, String seriaFilterValue, String typeFilterValue){
        this.nameFilterValue = nameFilterValue;
        this.ownerFilterValue = ownerFilterValue;
        this.seriaFilterValue = seriaFilterValue;
        this.typeFilterValue = typeFilterValue;
    }

    public List<Hardware__c> getListHardwaresOfDevice(Id id){
        List<String> allowedRecordTypes = new List<String> {'Motherboard','CPU','RAM','HDD'};

        return [SELECT Name, InvNo__c, RecordType.name, Parent__c
        FROM Hardware__c
        WHERE Parent__c=:id
                AND RecordType.developername IN :allowedRecordTypes
        ORDER BY RecordType.developerName];
    }

    private String getOwnerFilterQuery(String ownerFilterValue){
        return ownerFilterValue.equals('') ? ownerFilterValue : ' AND AssignedToEmployee__r.name LIKE \'%' + ownerFilterValue + '%\'';
    }

    private ApexPages.StandardSetController getDevicesFromAllLocations(List<Location__c> locations, DeviceTableFilters filters){
        /*String query = 'SELECT imageUrl__c, Name, AssignedToEmployee__r.name, InvNo__c, RecordType.name, LocationID__c'+
                ' FROM Hardware__c'+
                ' WHERE Parent__c=null'+
                ' AND LocationID__c IN :locations' +
                ' AND name LIKE \'%' + nameFilterValue + '%\'' + getOwnerFilterQuery() +
                ' AND InvNo__c LIKE \'%' + seriaFilterValue + '%\''+
                ' AND RecordType.developerName LIKE \'%' + typeFilterValue + '%\''+
                ' ORDER BY Name';*/

        String query = 'SELECT imageUrl__c, Name, AssignedToEmployee__r.name, InvNo__c, RecordType.name, LocationID__c'+
                ' FROM Hardware__c'+
                ' WHERE Parent__c=null'+
                ' AND LocationID__c IN :locations' +
                ' AND name LIKE \'%' + filters.nameFilterValue + '%\'' + getOwnerFilterQuery(filters.ownerFilterValue) +
                ' AND InvNo__c LIKE \'%' + filters.seriaFilterValue + '%\''+
                ' AND RecordType.developerName LIKE \'%' + filters.typeFilterValue + '%\''+
                ' ORDER BY Name';
        ApexPages.StandardSetController cont = new ApexPages.StandardSetController(database.getQueryLocator(query));
        return cont;
    }

    private ApexPages.StandardSetController getDevicesByLocation(Id location, DeviceTableFilters filters){

        /*String query = 'SELECT imageUrl__c, Name, AssignedToEmployee__r.name, InvNo__c, RecordType.name, LocationID__c'+
                ' FROM Hardware__c'+
                ' WHERE Parent__c=null AND LocationID__c=\'' + location + '\'' +
                ' AND name LIKE \'%' + nameFilterValue + '%\'' +
                getOwnerFilterQuery() +
                ' AND InvNo__c LIKE \'%' + seriaFilterValue + '%\''+
                ' AND RecordType.developerName LIKE \'%' + typeFilterValue + '%\''+
                ' ORDER BY Name';*/

        String query = 'SELECT imageUrl__c, Name, AssignedToEmployee__r.name, InvNo__c, RecordType.name, LocationID__c'+
                ' FROM Hardware__c'+
                ' WHERE Parent__c=null AND LocationID__c=\'' + location + '\'' +
                ' AND name LIKE \'%' + filters.nameFilterValue + '%\'' +
                getOwnerFilterQuery(filters.ownerFilterValue) +
                ' AND InvNo__c LIKE \'%' + filters.seriaFilterValue + '%\''+
                ' AND RecordType.developerName LIKE \'%' + filters.typeFilterValue + '%\''+
                ' ORDER BY Name';

        return new ApexPages.StandardSetController(database.getQueryLocator(query));
    }

    public List<Location__c> getLocations(){
        return [SELECT name FROM Location__c];
    }

    public ApexPages.StandardSetController getDevicesStandardSetController(String location, DeviceTableFilters filters){
        System.debug('deviceModel: ' + location);

        return location.equals('all-cities') ? getDevicesFromAllLocations(allOfficeLocation, filters) : getDevicesByLocation(Id.valueOf(location), filters);
    }

    public List<HArdware__c> getStockHardware(String recordType, List<Id> selectedHardwaresIds, Hardware__c device){

        Id changedDeviceId = device.id;
        Id location = device.LocationId__c;

        return [SELECT name, InvNo__c, Parent__r.name, Parent__r.InvNo__c, RecordType.developerName
                FROM Hardware__c
                WHERE (Parent__r.AssignedToEmployee__c = null OR Parent__c = null)
                        AND Id NOT IN :selectedHardwaresIds
                        AND Parent__c != :changedDeviceId
                        AND RecordType.developerName = :recordType
                        AND LocationId__c = :location];
    }


    public Hardware__c getDeviceInfoById(Id id){
        return [SELECT Name, AssignedToEmployee__r.name, InvNo__c, RecordType.name, LocationID__c
                FROM Hardware__c
                WHERE Id = :id];
    }

    public Hardware__c getHardwareInfoById(Id id){
        return [SELECT Name, Parent__c
        FROM Hardware__c
        WHERE Id = :id];
    }

    private List<UserPermissions__c> getSigndUpUserPermissions(Id id){

        System.debug('USER ID: ' + id);

        return [SELECT Location__c FROM UserPermissions__c WHERE User__c = :id];
    }

    public List<Location__c> getLocationUserAdmin(Id id){
        List<UserPermissions__c> userPermissionsLocations = getSigndUpUserPermissions(id);
        isGlobalAdmin = userPermissionsLocations.get(0).Location__c == null;


        List<Location__c> userLocationAdmin = new List<Location__c>();

        if (isGlobalAdmin) {
            userLocationAdmin = allCities;
        }
        else {
            for (Integer i = 0; i < userPermissionsLocations.size(); i++) {
                Id locationId = userPermissionsLocations.get(i).Location__c;

                for (Location__c location : allCities) {
                    if (location.Id.equals(locationId)) {
                        userLocationAdmin.add(location);
                    }
                }
            }
        }

        allOfficeLocation = userLocationAdmin;
        return userLocationAdmin;
    }

    public Map<String,Hardware__c> getDeviceConfMap(Id deviceId){
        Map<String,Hardware__c> deviceConfMap = getInitializedConfMap();
        List<Hardware__c> deviceConfList = getListHardwaresOfDevice(deviceId);
        String mapKey = '';
        Boolean isFirstHDD = true;

        for (Hardware__c hardware : deviceConfList) {
            mapKey = hardware.RecordType.name;


            System.debug('hardware: ' + hardware.RecordType.name);
            System.debug('hardware1: ' + hardware + '\n');

            if (!isFirstHDD && mapKey.equals('HDD')) {
                mapKey = 'HDD2';
            }

            if (isFirstHDD && mapKey.equals('HDD')) {
                mapKey = 'HDD1';
                isFirstHDD = false;
            }

            deviceConfMap.put(mapKey, hardware);
        }

        return deviceConfMap;
    }

    private Map<String,Hardware__c> getInitializedConfMap(){
        Map<String,Hardware__c> blankMap = new Map<String, Hardware__c>();

        blankMap.put('Motherboard',new Hardware__c());
        blankMap.put('CPU',new Hardware__c());
        blankMap.put('RAM',new Hardware__c());
        blankMap.put('HDD1',new Hardware__c());
        blankMap.put('HDD2',new Hardware__c());

        return blankMap;
    }

    public void updateNewDeviceConfig(Map<String, Hardware__c> defaultConfMap, Map<String, Hardware__c> newConfMap, Map<String, Hardware__c> removedConfMap, Id deviceId){
        Hardware__c blankHardwareObj = new Hardware__c();

        for (String mapKey : newConfMap.keySet()) {

            Hardware__c newConfHardware = newConfMap.get(mapKey);

            if (newConfHardware == blankHardwareObj) {
                continue;
            }

            Hardware__c defaultConfHardware = defaultConfMap.get(mapKey);

            if (defaultConfHardware != blankHardwareObj) {
                defaultConfHardware.Parent__c = newConfHardware.Parent__c;
            }
        }


        List<Hardware__c> newConfList = new List<Hardware__c>();

        for (Hardware__c hardware : newConfMap.values()) {
            if (hardware != blankHardwareObj){
                hardware.Parent__c = deviceId;
                newConfList.add(hardware);
            }
        }

        for (Hardware__c hardware : defaultConfMap.values()) {
            if (hardware != blankHardwareObj){
                newConfList.add(hardware);
            }
        }

        for (Hardware__c hardware : removedConfMap.values()) {
            if (hardware != blankHardwareObj) {
                hardware.Parent__c = null;
                newConfList.add(hardware);
            }
        }

        update newConfList;
    }

    public void updateDeviceLocation(Hardware__c device, Id newLocation){
        device.LocationID__c = newLocation;
        update device;
    }

    public List<SelectOption> getRelocationSelectedOptions(){
        List<SelectOption> selectionList = new List<SelectOption>();

        for (Location__c location : allCities) {
            selectionList.add(new SelectOption(location.id, location.name));
        }

        return selectionList;
    }
}