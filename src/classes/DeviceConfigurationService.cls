/**
 * Created by Ar-Krav on 28.02.2018.
 */

public with sharing class DeviceConfigurationService {
    public List<Hardware__c> getDeviceConfigurationHardwares(Id id){
        List<String> allowedRecordTypes = new List<String> {'Motherboard','CPU','RAM','HDD'};

        return [SELECT Name, InvNo__c, RecordType.name, Parent__c
        FROM Hardware__c
        WHERE Parent__c=:id
        AND RecordType.developername IN :allowedRecordTypes
        ORDER BY RecordType.developerName];
    }
}