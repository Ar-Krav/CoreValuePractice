public with sharing class EditServerRecordController {

    public EditServerRecordController() {
        this.serverService = new ServersService();
        this.serverController = new ServerController();
        this.addNewServerController = new AddNewServerController();
    }
    private final static String ID_NAME = 'id';
    public ServersService serverService { get; set; }
    public AddNewServerController addNewServerController { get; set; }
    public ServerController serverController { get; set; }
    public String currentServerId {
        get {
            if (currentServerId == null) {
                currentServerId = ApexPages.currentPage().getParameters().get(ID_NAME);
            }
            return currentServerId;
        }
        set;
    }
    public Server__c currentServer {
        get {
            if (currentServer == null) {
                currentServer = serverService.getCurrentServer(currentServerId);
            }
            return currentServer;
        }
        set;
    }
    public List<SelectOption> serversDropDownList {
        get {
            if (serversDropDownList == null) {
                serversDropDownList = serverController.admin ? serverService.getServersDropDownList(currentServerId)
                                                             : serverService.getServersDropDownList(serverController.userLocations, currentServerId);
            }
            return serversDropDownList;
        }
        set;
    }

    public PageReference updateServerRecord() {
        if (serverService.isNameValid(currentServer.Name) && serverService.isIpValid(currentServer.Ip__c)
                && serverService.isServerNameUnique(currentServer.Name, currentServer.Id)
                && serverService.isIPUnique(currentServer.Ip__c, currentServer.Id)) {
            serverService.updateCurrentServerRecord(currentServer);
            PageReference returnToServers = Page.Servers;
            returnToServers.getParameters().put(serverController.TAB_ID_NAME, serverController.tabId);
            returnToServers.setRedirect(true);
            return returnToServers;
        } else {
            if (!serverService.isNameValid(currentServer.Name)){
                addNewServerController.displayFeedback(addNewServerController.SERVER_NO_SPACES_ERROR);
            }
            if (!serverService.isIpValid(currentServer.Ip__c)) {
                addNewServerController.displayFeedback(addNewServerController.IP_ERROR);
            }
            if (!serverService.isIPUnique(currentServer.Ip__c, currentServer.Id)) {
                addNewServerController.displayFeedback(addNewServerController.IP_EXISTS_ERROR);
            }
            if (!serverService.isServerNameUnique(currentServer.Name, currentServer.Id)) {
                addNewServerController.displayFeedback(addNewServerController.SERVER_NAME_ERROR);
            }
        }
        return null;
    }

}