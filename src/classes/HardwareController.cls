public with sharing class HardwareController {

    private HardwareService hardwareService;

    public Hardware__c userWorkStation {
        get {
            if (userWorkStation == null) {
                userWorkStation = hardwareService.getWorkstation();
            }
            return userWorkStation;
        }
        set;
    }

    public List<Hardware__c> userMonitors {
        get {
            if (userMonitors == null) {
                userMonitors = hardwareService.getMonitors();
            }
            return userMonitors;
        }
        set;
    }

    public List<Hardware__c> userPeriphery {
        get {
            if (userPeriphery == null) {
                userPeriphery = hardwareService.getPeriphery();
            }
            return userPeriphery;
        }
        set;
    }

    public Account account {
        get {
            if (account == null) {
                account = hardwareService.account;
            }
            return account;
        }
        set;
    }

    public Id delMonitorById { get; set; }

    public Hardware__c firstHDD {
        get;
        set;
    }
    public Hardware__c secondHDD {
        get;
        set;
    }

    public HardwareController() {
        Id accountId = ApexPages.currentPage().getParameters().get('accountId');
        hardwareService = new HardwareService(accountId);
        setHddInfo();
    }

    public PageReference insertServerRecord() {

        Map<String, String> params = new Map<String, String>{
                'accountId' => account.Id,
                'sfdc.tabName' => ApexPages.currentPage().getParameters().get('sfdc.tabName')

        };

        return hardwareService.toPage( Page.ChangePc, params, true );
    }

    public PageReference backToMainPage() {

        Map<String, String> params = new Map<String, String>{
                'sfdc.tabName' => ApexPages.currentPage().getParameters().get('sfdc.tabName')

        };

        return hardwareService.toPage( Page.MainInventory, params, true );
    }

    public PageReference editHardwareConfiguration() {

        Map<String, String> params = new Map<String, String>{
                'accountId' => account.Id,
                'deviceId' => userWorkStation.id,
                'sfdc.tabName' => ApexPages.currentPage().getParameters().get('sfdc.tabName')

        };

        return hardwareService.toPage( Page.DeviceConfigurationEditor, params, true );
    }

    public PageReference changeMonitor() {
        Map<String, String> params = new Map<String, String>{
                'accountId' => account.Id,
                'sfdc.tabName' => ApexPages.currentPage().getParameters().get('sfdc.tabName')

        };

        return hardwareService.toPage( Page.ChangeMonitors, params, true );
    }

    public PageReference addMonitor() {
        Map<String, String> params = new Map<String, String>{
                'accountId' => account.Id,
                'sfdc.tabName' => ApexPages.currentPage().getParameters().get('sfdc.tabName')

        };

        return hardwareService.toPage( Page.ChangeMonitors, params, true );
    }

    public PageReference deleteComputer() {

        hardwareService.delCurrentPC();
        Map<String, String> params = new Map<String, String>{
                'accountId' => account.Id,
                'sfdc.tabName' => ApexPages.currentPage().getParameters().get('sfdc.tabName')

        };

        return hardwareService.toPage( Page.Hardware, params, true );
    }

    public PageReference deleteMonitor() {

        hardwareService.delCurrentMonitor(delMonitorById);

        Map<String, String> params = new Map<String, String>{
                'accountId' => account.Id,
                'sfdc.tabName' => ApexPages.currentPage().getParameters().get('sfdc.tabName')

        };

        return hardwareService.toPage( Page.Hardware, params, true );
    }

    private void setHddInfo() {
        Boolean isFirstHDD = true;
        for (Hardware__c hardware : userPeriphery) {
            if (isFirstHDD && hardware.RecordType.name.equals('HDD')) {
                isFirstHDD = false;
                firstHDD = hardware;
                continue;
            }
            if (!isFirstHDD && hardware.RecordType.name.equals('HDD')) {
                secondHDD = hardware;
            }
        }
    }
}