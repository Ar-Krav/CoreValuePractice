public with sharing class AddNewServerController {

    public final String IP_ERROR = 'Incorrect Server IP';
    public final String IP_EXISTS_ERROR = 'IP already exists in global database';
    public final String SERVER_NAME_ERROR = 'Name already exists in global database';
    public final String SERVER_NO_SPACES_ERROR = 'Name can\'t start with spaces';
    public ServersService serverService { get; set; }
    public ServerController serverController { get; set; }

    public AddNewServerController() {
        this.serverService = new ServersService();
        this.serverController = new ServerController();
    }
    public Server__c server {
        get {
            if (server == null) {
                server = new Server__c();
            }
            return server;
        }
        set;
    }
    public List<SelectOption> serversDropDownList {
        get {
            if (serversDropDownList == null) {
                serversDropDownList = serverController.admin ? serverService.getServersDropDownList()
                                                             : serverService.getServersDropDownList(serverController.userLocations);
            }
            return serversDropDownList;
        }
        set;
    }

    public void displayFeedback(String message) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, message);
        ApexPages.addMessage(msg);
    }

    public PageReference insertServerRecord() {
        if (serverService.isNameValid(server.Name) && serverService.isIpValid(server.Ip__c)
                && serverService.isServerNameUnique(server.Name, server.Id)
                && serverService.isIPUnique(server.Ip__c, server.Id)) {
            serverService.insertNewServerRecordIntoDB(server);
            PageReference returnToServers = Page.Servers;
            returnToServers.getParameters().put(serverController.TAB_ID_NAME, ApexPages.currentPage().getParameters().get(serverController.TAB_ID_NAME));
            returnToServers.setRedirect(true);
            return returnToServers;
        } else {
            if (!serverService.isNameValid(server.Name)){
                displayFeedback(SERVER_NO_SPACES_ERROR);
            }
            if (!serverService.isIpValid(server.Ip__c)) {
                displayFeedback(IP_ERROR);
            }
            if (!serverService.isIPUnique(server.Ip__c, server.Id)) {
                displayFeedback(IP_EXISTS_ERROR);
            }
            if (!serverService.isServerNameUnique(server.Name, server.Id)) {
                displayFeedback(SERVER_NAME_ERROR);
            }
        }
        return null;
    }
}