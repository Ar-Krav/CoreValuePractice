@isTest
private class ServersServiceTest {

    static ServerController cont;

    public ServersServiceTest() {
    }

    static testMethod void isUserAdminTest() {
        Integer numUsers = 2;
        User[] users = createUsersWithUserPermissionsAndLocations(2);
        for (Integer i = 0; i < numUsers; i++) {
            System.runAs(users[i]) {
                new ServerController();
                Boolean isAdmin = false;
                for (UserPermissions__c userPermissions : [
                        SELECT Location__c
                        FROM UserPermissions__c
                        WHERE User__c = :users[i].Id
                ]) {
                    system.debug(userPermissions);
                    if (userPermissions.Location__c == null) {
                        isAdmin = true;
                    }
                }
                system.debug(isAdmin);
                system.assertEquals(isAdmin, cont.admin);
            }
        }
    }

    public static List<User> createUsersWithUserPermissionsAndLocations(Integer numUsers) {

        List<User> users = new List<User>();

        Profile pf = [Select Id from profile where Name = 'System Administrator'];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueOf(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '') ;
        Integer RandomId = Integer.valueOf(Math.rint(Math.random() * 1000000));
        String uniqueName = orgId + dateString + RandomId;
        for (Integer i = 0; i < numUsers; i++) {
            User u = new User(firstname = 'ABC' + i,
                    lastName = 'XYZ' + i,
                    email = uniqueName + i + '@test' + orgId + '.org',
                    Username = uniqueName + i + '@test' + orgId + '.org',
                    EmailEncodingKey = 'ISO-8859-1',
                    Alias = uniqueName.substring(18, 23) + i,
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US',
                    ProfileId = pf.Id);
            users.add(u);
        }
        insert users;

        List<UserPermissions__c> userPerm = new List<UserPermissions__c>();
        String[] locations = new String[]{'a041N0000165aND', null, 'a041N0000165aND', 'a041N0000165aNm', null, null, 'a041N0000165aMP', 'a041N000016YsCe'};

        for (Integer j = 0; j < numUsers; j++) {
            UserPermissions__c userPermissions = new UserPermissions__c(Name = 'TestAccountPermission' + j, Location__c = locations[j], User__c = users[j].Id);
            userPerm.add(userPermissions);
        }
        insert userPerm;

        List<Location__c> globalLocations = new List<Location__c>();
        for (Integer j = 0; j < numUsers; j++) {
            Location__c location = new Location__c(Name = 'TestLocationName' + j);
            globalLocations.add(location);
        }
        insert globalLocations;

        return users;
    }
}