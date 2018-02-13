public with sharing class ServersService {

    private static final String NO_SERVERS_MESSAGE = '<No free servers available>';
    private static final String SERVER_RECORD_TYPE = 'Server';
    public final String ALL_LOCATIONS = 'All offices';

    public Boolean isUserAdmin(String userId) {
        for (UserPermissions__c userPermissions : [SELECT Location__c
                                                   FROM UserPermissions__c
                                                   WHERE User__c = :userId]) {
            if (userPermissions.Location__c == null) {
                return true;
            }
        }
        return false;
    }

    public List<String> getUserLocation(String userId) {
        List<String> locationsIds = new List<String>();
        for (UserPermissions__c permissions : [SELECT Location__r.id
                                               FROM UserPermissions__c
                                               WHERE User__c=:userId]) {
            locationsIds.add(permissions.Location__r.id);
        }
        return locationsIds;
    }

    public List<Server__c> getServersData() {
        return [SELECT Name, Description__c, Ip__c, Hardware__c, Hardware__r.Name
                FROM Server__c];
    }

    public List<Server__c> getServersBySelector(String locationSelector) {
        return locationSelector == ALL_LOCATIONS?getServersData():[SELECT Name, Description__c, Ip__c, Hardware__c, Hardware__r.LocationID__c, Hardware__r.Name
                                                                   FROM Server__c
                                                                   WHERE Hardware__r.LocationID__c  =:locationSelector];
    }

    public List<Server__c> getServersDataByTheUserLocations(List<String> userLocations) {
        return [SELECT Name, Description__c, Ip__c, Hardware__c, Hardware__r.LocationID__c, Hardware__r.Name
                FROM Server__c
                WHERE Hardware__r.LocationID__c IN :userLocations];
    }

    public Server__c getCurrentServer(String currentServerID) {
        return [SELECT Name, Description__c, Ip__c, Hardware__c
        FROM Server__c
        WHERE id = :currentServerID];
    }
    //get servers  drop-down list for globalAdmin in AddNewServerPage
    public List<SelectOption> getServersDropDownList() {
        List<SelectOption> options = new List<SelectOption>();
        for (Hardware__c serverHardware : [SELECT Id, Name, LocationID__r.id
                                           FROM Hardware__c
                                           WHERE RecordType.developerName =: SERVER_RECORD_TYPE AND Id NOT IN (SELECT Hardware__c
                                                                                                               FROM Server__c)]) {
            options.add(new SelectOption(serverHardware.Id, serverHardware.Name));
        }
        if (options.isEmpty())
            options.add(new SelectOption('', NO_SERVERS_MESSAGE));
        return options;
    }
    //get servers  drop-down list for globalAdmin in EditNewServerPage
    public List<SelectOption> getServersDropDownList(String currentServerID) {
        List<SelectOption> options = new List<SelectOption>();
        for (Hardware__c serverHardware : [SELECT Id, Name, LocationID__r.id
                                           FROM Hardware__c
                                           WHERE RecordType.developerName =: SERVER_RECORD_TYPE AND Id NOT IN (SELECT Hardware__c
                                                                                                               FROM Server__c
                                                                                                               WHERE Id != :currentServerID)]) {
            options.add(new SelectOption(serverHardware.Id, serverHardware.Name));
        }
        return options;
    }
    //get servers  drop-down list for localAdmin in AddNewServerPage
    public List<SelectOption> getServersDropDownList(List<String> userLocations) {
        List<SelectOption> options = new List<SelectOption>();
        for (Hardware__c serverHardware : [SELECT Id, Name, LocationID__r.id
                                           FROM Hardware__c
                                           WHERE RecordType.developerName =: SERVER_RECORD_TYPE AND Id NOT IN (SELECT Hardware__c
                                                                                                               FROM Server__c)
                                           AND LocationID__r.id IN :userLocations]) {
            options.add(new SelectOption(serverHardware.Id, serverHardware.Name));
        }
        if (options.isEmpty())
            options.add(new SelectOption('', NO_SERVERS_MESSAGE));
        return options;
    }
    //get servers  drop-down list for localAdmin in EditNewServerPage
    public List<SelectOption> getServersDropDownList(List<String> userLocations, String currentServerID) {
        List<SelectOption> options = new List<SelectOption>();
        for (Hardware__c serverHardware : [SELECT Id, Name, LocationID__r.id
                                           FROM Hardware__c
                                           WHERE RecordType.developerName =: SERVER_RECORD_TYPE AND Id NOT IN (SELECT Hardware__c
                                                                                                               FROM Server__c
                                                                                                               WHERE Id != :currentServerID)
                                           AND LocationID__r.id IN :userLocations]) {
            options.add(new SelectOption(serverHardware.Id, serverHardware.Name));
        }
        return options;
    }

    public List<SelectOption> getLocationsDropDownList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(ALL_LOCATIONS, ALL_LOCATIONS));
        for (Location__c locationName : [SELECT Id, Name
                                         FROM Location__c]) {
            options.add(new SelectOption(locationName.Id, locationName.Name));
        }
        return options;
    }
    //used in servers page header "Servers of {!locationLabel}" for globalAdmin view
    public String findLocationLabel(String locationSelector, String locationLabel)
    {
        List<SelectOption> options = getLocationsDropDownList();
        for (SelectOption so : options)
            if (so.getValue() == locationSelector)
                locationLabel = so.getLabel();
        return locationLabel;
    }
    //used in servers page header "Servers of {!locationLabel}" for localAdmin view
    public String findLocationLabel(List<String> userLocations)
    {
        List<SelectOption> options = getLocationsDropDownList();
        List<String> locationsLabel = new List<String>();
        for (SelectOption so : options)
            if (userLocations.contains(so.getValue()))
                locationsLabel.add(so.getLabel());
        return String.join(locationsLabel, ' and ');
    }

    public Boolean isNameValid(String serverName){
        String nameRegex = '^[^-\\s][\\w_\\s-]+$';
        Pattern namePattern = Pattern.compile(nameRegex);
        return namePattern.matcher(serverName).matches();
    }

    public Boolean isIpValid(String serverIp) {
        String ipRegex = '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$';
        Pattern ipPattern = Pattern.compile(ipRegex);
        return ipPattern.matcher(serverIp).matches();
    }

    public Boolean isServerNameUnique(String serverName, String serverId) {
        return [SELECT COUNT()
                FROM Server__c
                WHERE Name = :serverName AND Id != :serverId] == 0;
    }

    public Boolean isIPUnique(String IpAddress, String serverId) {
        return [SELECT COUNT()
                FROM Server__c
                WHERE Ip__c = :IpAddress AND Id != :serverId] == 0;
    }

    public void insertNewServerRecordIntoDB(Server__c server) {
        insert server;
    }

    public void updateCurrentServerRecord(Server__c currentServer) {
        update currentServer;
    }
}