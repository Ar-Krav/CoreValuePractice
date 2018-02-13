/**
 * Created by Ar-Krav on 31.01.2018.
 */

public with sharing class DeviceConfigurationPageController {
    private DevicePageDataModel deviceModel = new DevicePageDataModel();

    public Hardware__c deviceUnit{
        get;
        set;
    }

    public String selectedHardwareType{
        get;
        set;
    }

    public List<Hardware__c> hardwareListInStock{
        get;
        set;
    }

    public Map<String, Hardware__c> currentDeviceConfiguration{
        get{
            if (currentDeviceConfiguration == null) {
                currentDeviceConfiguration = new Map<String, Hardware__c>();

                currentDeviceConfiguration.put('Motherboard',new Hardware__c());
                currentDeviceConfiguration.put('CPU',new Hardware__c());
                currentDeviceConfiguration.put('RAM',new Hardware__c());
                currentDeviceConfiguration.put('HDD1',new Hardware__c());
                currentDeviceConfiguration.put('HDD2',new Hardware__c());
            }

            return currentDeviceConfiguration;
        }
        set;
    }

    public Map<String, Hardware__c> newDeviceConfiguration{
        get{
            if (newDeviceConfiguration == null) {
                newDeviceConfiguration = new Map<String, Hardware__c>();

                newDeviceConfiguration.put('Motherboard',new Hardware__c());
                newDeviceConfiguration.put('CPU',new Hardware__c());
                newDeviceConfiguration.put('RAM',new Hardware__c());
                newDeviceConfiguration.put('HDD1',new Hardware__c());
                newDeviceConfiguration.put('HDD2',new Hardware__c());
            }

            return newDeviceConfiguration;
        }
        set;
    }

    public Boolean isDataToSave{
        get{
            if (isDataToSave == null){
                isDataToSave = false;
            }

            return isDataToSave;
        }
        set;
    }

    public Map<String, Hardware__c> removedDeviceConfiguration{
        get{
            if (removedDeviceConfiguration == null) {
                removedDeviceConfiguration = new Map<String, Hardware__c>();

                removedDeviceConfiguration.put('Motherboard',new Hardware__c());
                removedDeviceConfiguration.put('CPU',new Hardware__c());
                removedDeviceConfiguration.put('RAM',new Hardware__c());
                removedDeviceConfiguration.put('HDD1',new Hardware__c());
                removedDeviceConfiguration.put('HDD2',new Hardware__c());
            }

            return removedDeviceConfiguration;
        }
        set;
    }


    public DeviceConfigurationPageController(){
        deviceUnit = deviceModel.getDeviceInfoById(ApexPages.currentPage().getParameters().get('deviceId'));

        currentDeviceConfiguration = deviceModel.getDeviceConfMap(deviceUnit.id);
    }


    public PageReference getStockData(){
        selectedHardwareType = ApexPages.currentPage().getParameters().get('cellRecordType');

        String soqlHardwareType = selectedHardwareType.equals('HDD1') || selectedHardwareType.equals('HDD2') ? 'HDD' : selectedHardwareType;
        List<Id> newConfIds = new List<Id>();
        for (Hardware__c hardware : newDeviceConfiguration.values()) {
            newConfIds.add(hardware.id);
        }

        hardwareListInStock = deviceModel.getStockHardware(soqlHardwareType, newConfIds, deviceUnit);

        return null;
    }

    public PageReference setNewDeviceComponent(){
        Id newHardwareId = ApexPages.currentPage().getParameters().get('hardwareId');
        newDeviceConfiguration.put(selectedHardwareType, deviceModel.getHardwareInfoById(newHardwareId));

        isDataToSave = true;
        hardwareListInStock = null;

        return null;
    }

    public PageReference removeNewConfigHardware(){
        String hardwareType = ApexPages.currentPage().getParameters().get('recordType');

        recreateMapHardware(newDeviceConfiguration, hardwareType);

        checkIsDataToSave();
        hardwareListInStock = null;

        return null;
    }

    public PageReference removeDefaultConfigHardware(){
        String hardwareType = ApexPages.currentPage().getParameters().get('recordType');

        removedDeviceConfiguration.put(hardwareType, currentDeviceConfiguration.get(hardwareType));
        recreateMapHardware(currentDeviceConfiguration, hardwareType);

        isDataToSave = true;
        hardwareListInStock = null;

        return null;
    }

    public PageReference restoreDefaultConfHardware(){
        String hardwareType = ApexPages.currentPage().getParameters().get('recordType');

        currentDeviceConfiguration.put(hardwareType, removedDeviceConfiguration.get(hardwareType));
        recreateMapHardware(removedDeviceConfiguration, hardwareType);

        checkIsDataToSave();
        hardwareListInStock = null;

        return null;
    }

    private void recreateMapHardware(Map<String, Hardware__c> hardwareMap, String key){
        hardwareMap.remove(key);
        hardwareMap.put(key, new Hardware__c());
    }

    public PageReference closeEditor(){
        PageReference redirectedPage;
        String redirectAccountId = ApexPages.currentPage().getParameters().get('accountId');
        String tabName = ApexPages.currentPage().getParameters().get(ConstantsUtil.TAB_TAG_PREFIX);

        if (redirectAccountId == null) {

            if (tabName.equals(ConstantsUtil.HOME_TAB_TAG)) {
                redirectedPage = Page.MainInventory;
            }

            if (tabName.equals(ConstantsUtil.SERVER_TAB_TAG)) {
                redirectedPage = Page.Servers;
            }

            if (tabName.equals(ConstantsUtil.DEVICES_TAB_TAG)) {
                redirectedPage = Page.DevicePage;
            }

            redirectedPage.getParameters().put(ConstantsUtil.TAB_TAG_PREFIX, tabName);
        }
        else {
            redirectedPage = Page.Hardware;
            redirectedPage.getParameters().put(ConstantsUtil.TAB_TAG_PREFIX, ConstantsUtil.HOME_TAB_TAG);
            redirectedPage.getParameters().put('accountId',redirectAccountId);
        }

        redirectedPage.setRedirect(true);

        return redirectedPage;
    }

    public PageReference saveNewConfig(){

        deviceModel.updateNewDeviceConfig(currentDeviceConfiguration, newDeviceConfiguration, removedDeviceConfiguration, deviceUnit.id);
        return closeEditor();
    }

    private void checkIsDataToSave(){
        isDataToSave = false;
        checkConfMapData(removedDeviceConfiguration);
        checkConfMapData(newDeviceConfiguration);
    }

    private void checkConfMapData(Map<String, Hardware__c> checkedMap){
        Hardware__c blankHardwareObj = new Hardware__c();

        for (Hardware__c hardware : checkedMap.values()) {
            if (hardware != blankHardwareObj) {
                isDataToSave = true;
            }
        }
    }
}