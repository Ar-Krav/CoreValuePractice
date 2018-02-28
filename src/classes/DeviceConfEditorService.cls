/**
 * Created by Ar-Krav on 28.02.2018.
 */

public with sharing class DeviceConfEditorService {
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

    public List<Hardware__c> getListHardwaresOfDevice(Id id){
        List<String> allowedRecordTypes = new List<String> {'Motherboard','CPU','RAM','HDD'};

        return [SELECT Name, InvNo__c, RecordType.name, Parent__c
        FROM Hardware__c
        WHERE Parent__c=:id
        AND RecordType.developername IN :allowedRecordTypes
        ORDER BY RecordType.developerName];
    }
}