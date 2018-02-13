public with sharing class MainInventoryService {

    public MainInventoryDao dao { get; set; }

    public MainInventoryService() {
        dao = new MainInventoryDao();
    }

    public Set<String> generateCityesList() {
        Set<String> cities = new Set<String>();
        for (Location__c location : dao.getAllLocationsNames()) {
            cities.add(location.name);
        }
        return cities;
    }

    public Boolean isUserAdmin(String id) {
        for (UserPermissions__c userPermissions : dao.getUserPermissionLocations(id)) {
            if (userPermissions.Location__c == null) {
                return true;
            }
        }
        return false;
    }

    public List<EmployeeMainPageDto> getAllEmployees() {
        return extractEmployeesIntoDto(dao.getAllEmployees());
    }

    public List<EmployeeMainPageDto> getEmployeesByPermission(String userId) {
        List<UserPermissions__c> userLocations = dao.getUserPermissionLocations(userId);
        List<String> locationsNames = new List<String>();
        for (UserPermissions__c userPerm : userLocations) {
            locationsNames.add(userPerm.Location__r.name);
        }
        return extractEmployeesIntoDto(dao.getEmployeesByLocations(locationsNames));
    }

    public List<EmployeeMainPageDto> getEmployeesByLocations(List<String> locations) {
        return extractEmployeesIntoDto(dao.getEmployeesByLocations(locations));
    }

    private List<EmployeeMainPageDto> extractEmployeesIntoDto(List<Account> accounts) {
        List<EmployeeMainPageDto> dtos = new List<EmployeeMainPageDto>();
        for (Account account : accounts) {
            List<Hardware__c> monitors = dao.getEmployeeMonitors(account.id);
            dtos.add(new EmployeeMainPageDto.EmployeeMainPageDtoBuilder()
                    .setEmpId(account.id)
                    .setEmpName(account.name)
                    .setEmpType(account.Type)
                    .setLocationId(account.LocationId__r.id)
                    .setLocationName(account.LocationId__r.Name)
                    .setDeviceId(account.Hardware__r.size() == 0 ? '' : account.Hardware__r.get(0).id)
                    .setDeviceName(account.Hardware__r.size() == 0 ? '' : account.Hardware__r.get(0).Name)
                    .setDeviceType(account.Hardware__r.size() == 0 ? '' : account.Hardware__r.get(0).RecordType.Name)
                    .setInvNumber(account.Hardware__r.size() == 0 ? '' : account.Hardware__r.get(0).InvNo__c)
                    .setMonitors(monitors)
                    .build());
        }
        return dtos;
    }
}