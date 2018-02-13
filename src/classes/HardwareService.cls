/**
 * Created by Trainee 1 on 2/6/2018.
 */

public with sharing class HardwareService {

    private static final String MONITOR = 'Monitor';
    private static final String PC = 'Pc';
    private static final String NOTEBOOK = 'Notebook';

    public Account account { get; private set; }

    private List<Hardware__c> assignedHardware;

    private List<Hardware__c> emptyDevices;

    public HardwareService( Id accountId ) {
        account = getAccount( accountId );
        assignedHardware = getHardware( accountId );
        emptyDevices = getEmptyDevices( accountId );
    }

    private Account getAccount( Id accountId ) {
        return [
                SELECT  Id,
                        Name,
                        Type,
                        ImageFormula__c,
                        LocationId__c
                FROM Account
                WHERE Id = :accountId
                LIMIT 1
        ];
    }

    private List<Hardware__c> getHardware( Id accountId ) {
        return [
               SELECT  Id,
                       Parent__c,
                       Name,
                       RecordType.Name,
                       AssignedToEmployee__c,
                       InvNo__c,
                       OS__c,
               ( SELECT Id, Name, RecordType.Name FROM Hardware__r )
               FROM Hardware__c
               WHERE AssignedToEmployee__c =: accountId
       ];
    }

    private List<Hardware__c> getEmptyDevices( Id accountId ) {
        return [
                SELECT id,
                        RecordType.Name,
                        Name,
                        Description__c,
                        InvNo__c,
                        Cost__c,
                        LocationID__c,
                        OS__c,
                        Parent__c
                FROM HardWare__c
                WHERE Parent__c = null AND AssignedToEmployee__c = null AND LocationID__c =: account.LocationId__c ] ;
    }

    public Hardware__c getWorkstation() {

        Hardware__c worksatation = new Hardware__c();

        for ( Hardware__c hardware : assignedHardware ) {
            if ( hardware.RecordType.Name == PC || hardware.RecordType.Name == NOTEBOOK ) {
                worksatation = hardware;
            }
        }

        return worksatation;
    }

    public List<Hardware__c> getMonitors() {

        List<Hardware__c> monitors = new List<Hardware__c>();

        for (Hardware__c hardware : assignedHardware ) {
            if ( hardware.RecordType.Name == MONITOR ) {
                monitors.add(hardware);
            }
        }

        return monitors;
    }

    public List<Hardware__c> getPeriphery() {

        List<Hardware__c> periphery = new List<Hardware__c>();

        for (Hardware__c currentHardware :  assignedHardware) {
            if(currentHardware.RecordType.Name == PC || currentHardware.RecordType.Name == NOTEBOOK ){
                for (Hardware__c per : currentHardware.Hardware__r) {
                    periphery.add(per);
                }
            }
        }

        return periphery;
    }

    public List<Hardware__c> getEmptyPc(){

        List<Hardware__c> emptyPC = new List<Hardware__c>();

        for (Hardware__c hardware : emptyDevices ) {
            if ( hardware.RecordType.Name == PC || hardware.RecordType.Name == NOTEBOOK) {
                emptyPC.add(hardware);
            }
        }

        return emptyPC;
    }

    public List<Hardware__c> getEmptyMonitor(){

        List<Hardware__c> emptyMonitor = new List<Hardware__c>();

        for (Hardware__c hardware : emptyDevices ) {
            if ( hardware.RecordType.Name == MONITOR) {
                emptyMonitor.add(hardware);
            }
        }

        return emptyMonitor;
    }

    public void delCurrentPC() {
        Hardware__c currentPC = getWorkstation();
        currentPC.AssignedToEmployee__c = null;
        update currentPC;
    }

    public void delCurrentMonitor(Id currentMonitorId) {
        Hardware__c currentMon = new Hardware__c( Id = currentMonitorId, AssignedToEmployee__c = null );
        update currentMon;
    }

    public PageReference toPage(PageReference page, Map<String, String> params, Boolean doRedirect) {
        page.getParameters().putAll( params );
        page.setRedirect( doRedirect );
        return page;
    }
}