public with sharing class ChangePcController {

    private HardwareService hardwareChangeService;

    public Account account {
        get {
            if (account == null) {
                account = hardwareChangeService.account;
            }
            return account;
        }
        set;
    }

    public String selectedDevice { get; set;}

    public Hardware__c userWorkStation {
        get {
            if (userWorkStation == null) {
                userWorkStation = hardwareChangeService.getWorkstation();
            }
            return userWorkStation;
        }
        set;
    }

    public Id selectedDeviceId{
        get;
        set;
    }

    public List<Hardware__c> emptyPc {
        get {
            if (emptyPc == null) {
                emptyPc = hardwareChangeService.getEmptyPc();
            }
            return emptyPc;
        }
        set;
    }

    public ChangePcController() {
        Id accountId = ApexPages.currentPage().getParameters().get('accountId');
        hardwareChangeService = new HardwareService(accountId);

    }

    public PageReference addDeviceForUser() {
        Hardware__c selectedEmptyDevice = new Hardware__c( Id = selectedDeviceId, AssignedToEmployee__c = account.Id );
        update selectedEmptyDevice;

        Map<String, String> params = new Map<String, String>{
                'accountId' => account.Id,
                'sfdc.tabName' => ApexPages.currentPage().getParameters().get('sfdc.tabName')

        };

        return hardwareChangeService.toPage( Page.Hardware, params, true );

    }

    public PageReference updateUserDevice() {
        List<Hardware__c> hardwares = new List<Hardware__c>();

        Hardware__c currentDevice = new Hardware__c(Id = userWorkStation.id, AssignedToEmployee__c = null);
        Hardware__c selectedEmptyDevice = new Hardware__c(Id = selectedDeviceId, AssignedToEmployee__c = account.Id);

        hardwares.add(currentDevice);
        hardwares.add(selectedEmptyDevice);
        update hardwares;

        Map<String, String> params = new Map<String, String>{
                'accountId' => account.Id,
                'sfdc.tabName' => ApexPages.currentPage().getParameters().get('sfdc.tabName')

        };

        return hardwareChangeService.toPage( Page.Hardware, params, true );
    }

    public PageReference cancelDevice() {

        Map<String, String> params = new Map<String, String>{
                'accountId' => account.Id,
                'sfdc.tabName' => ApexPages.currentPage().getParameters().get('sfdc.tabName')

        };

        return hardwareChangeService.toPage( Page.Hardware, params, true );
    }

    public PageReference setDeviceConfigurationListData(){
        selectedDeviceId =  Apexpages.currentPage().getParameters().get('deviceIdParameter');
        return null;
    }

}