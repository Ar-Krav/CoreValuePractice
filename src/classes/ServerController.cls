public with sharing class ServerController {

    public final String TAB_ID_NAME = 'sfdc.tabName';
    public ServersService serverService { get; set; }

    public ServerController() {
        this.serverService = new ServersService();
        userId = UserInfo.getUserId();
        if(!admin){
            userLocations = serverService.getUserLocation(userId);
        }
    }

    public String userId { get; set; }
    public List<String> userLocations { get; set; }
    public String locationSelector { get; set; }
    public String locationLabel {
        get {
            if (locationLabel == null) {
                if(admin)
                    locationLabel = serverService.ALL_LOCATIONS;
                else locationLabel = serverService.findLocationLabel(userLocations);
            }
            return locationLabel;
        }
        set;
    }
    public Boolean admin {
        get {
            if (admin == null) {
                admin = serverService.isUserAdmin(userId);
            }
            return admin;
        }
        set;
    }
    public String tabId {
        get {
            if (tabId == null) {
                tabId = ApexPages.currentPage().getParameters().get(TAB_ID_NAME);
            }
            return tabId;
        }
        set;
    }
    public List<Server__c> serversData {
        get {
            if (serversData == null) {
                serversData = admin? serverService.getServersData() : serverService.getServersDataByTheUserLocations(userLocations);
            }
            return serversData;
        }
        set;
    }
    public List<SelectOption> locationsDropDownList {
        get {
            if (locationsDropDownList == null) {
                locationsDropDownList = serverService.getLocationsDropDownList();

            }
            return locationsDropDownList;
        }
        set;
    }

    public PageReference redirectToAddNewServerPage() {
        PageReference addServer = Page.AddNewServer;
        addServer.getParameters().put(TAB_ID_NAME, tabId);
        addServer.setRedirect(true);
        return addServer;
    }

    public PageReference changeLocation() {
        if(admin) {
            locationLabel = serverService.findLocationLabel(locationSelector, locationLabel);
            serversData = serverService.getServersBySelector(locationSelector);
        }
        return null;
    }

}