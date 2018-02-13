public with sharing class MainInventoryController {

    public String currentLocation { get; set; }

    public Set<String> cityes { get; set; }

    public String tabId { get; set; }

    public Boolean admin {
        get {
            if (admin == null) {
                admin = inventoryService.isUserAdmin(userId);
            }
            return admin;
        }
        set;
    }

    public String userId { get; set; }

    public MainInventoryService inventoryService {
        get {
            if (inventoryService == null) {
                inventoryService = new MainInventoryService();
            }
            return inventoryService;
        }
        set;
    }

    public List<EmployeeMainPageDto> employees {
        get {
            if (employees == null) {
                employees = admin ? inventoryService.getAllEmployees() : inventoryService.getEmployeesByPermission(userId);
            }
            return employees;
        }
        set;
    }

    public MainInventoryController() {
        cityes = inventoryService.generateCityesList();
        currentLocation = 'All offices';
        tabId = ApexPages.currentPage().getParameters().get('sfdc.tabName');
        userId = UserInfo.getUserId();
    }

    public PageReference loadHardWareListByLocation() {
        if (admin) {
            if (currentLocation.equals('All offices')) {
                employees = inventoryService.getAllEmployees();
            } else {
                employees = inventoryService.getEmployeesByLocations(new List<String>{currentLocation});
            }
        }
        return null;
    }
}