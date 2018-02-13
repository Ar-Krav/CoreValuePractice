/**
 * Created by Trainee 4 on 2/6/2018.
 */

public with sharing class MainInventoryDao {

    public List<Account> getAllEmployees() {
        return [
                SELECT id, Name, Type,LocationId__r.Name,LocationID__r.id, (
                        SELECT Name, id, RecordType.Name, InvNo__c
                        FROM Hardware__r
                        WHERE RecordType.developerName IN ('Server', ' Notebook', 'PC')
                )
                FROM Account
                ORDER BY Name DESC
        ];
    }

    public List<Hardware__c> getEmployeeMonitors(String idEmployee) {
        return [
                SELECT name,InvNo__c
                FROM Hardware__c
                WHERE AssignedToEmployee__r.id = :idEmployee
                AND RecordType.developerName = 'Monitor'
        ];
    }

    public List<Account> getEmployeesByLocations(List<String> locations) {
        return [
                SELECT id, Name, Type,LocationId__r.Name,LocationID__r.id, (
                        SELECT Name, id, RecordType.Name, InvNo__c
                        FROM Hardware__r
                        WHERE RecordType.developerName IN ('Server', ' Notebook', 'PC')
                )
                FROM Account
                WHERE LocationID__r.Name IN :locations
                ORDER BY Name DESC
        ];
    }

    public List<UserPermissions__c> getUserPermissionLocations(String userId) {
        return [
                SELECT Location__r.name
                FROM UserPermissions__c
                WHERE User__r.id = :userId
        ];
    }
    public List<Location__c> getAllLocationsNames() {
        return [
                SELECT name
                FROM Location__c
        ];
    }
}