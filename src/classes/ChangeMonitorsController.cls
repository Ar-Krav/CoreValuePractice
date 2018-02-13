/**
 * Created by Trainee 1 on 2/5/2018.
 */

public with sharing class ChangeMonitorsController {

    private HardwareService hardwareChangeService { get; set;}

    public Account account {
        get {
            if (account == null) {
                account = hardwareChangeService.account;
            }
            return account;
        }
        set;
    }

    public Id monCheck {
        get {
            if (monCheck == null) {
                monCheck = ApexPages.currentPage().getParameters().get('deviceId');
            }
            return monCheck;
        }
        set;
    }

    public Id selectedDeviceId{
        get;
        set;
    }


    public List<Hardware__c> emptyMonitors {
        get {
            if (emptyMonitors == null) {
                emptyMonitors = hardwareChangeService.getEmptyMonitor();
            }
            return emptyMonitors;
        }
        set;
    }

    public ChangeMonitorsController()
    {
        Id accountId = ApexPages.currentPage().getParameters().get('accountId');
        hardwareChangeService = new HardwareService(accountId);
    }

    public PageReference updateMonitor() {

        List<Hardware__c> hardwares = new List<Hardware__c>();

        Hardware__c currentDevice = new Hardware__c(Id = monCheck, AssignedToEmployee__c = null);
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

    public PageReference addNewMonitor() {

        Hardware__c selectedEmptyDevice = new Hardware__c( Id = selectedDeviceId, AssignedToEmployee__c = account.Id );
        update selectedEmptyDevice;

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