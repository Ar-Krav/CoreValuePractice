/**
 * Created by Ar-Krav on 27.02.2018.
 */

public with sharing class DevConfigController {
    private DevicePageDataModel deviceModel = new DevicePageDataModel();

    public String selectedCity{
        get;
        set;
    }

    public List<Hardware__c> deviceList {
        get{
            System.debug('deviceList: ' + devicePaginationController);
            return devicePaginationController.getRecords();
        }
    }

    public String deviceImageUrl{
        get;
        set;
    }

    public List<Hardware__c> deviceConfigurationList{
        get;
        set;
    }

    public String nameFilterValue{
        get {
            if (nameFilterValue == null) {
                nameFilterValue = '';
            }

            return nameFilterValue;
        }

        set;
    }

    public String ownerFilterValue{
        get {
            if (ownerFilterValue == null) {
                ownerFilterValue = '';
            }

            return ownerFilterValue;
        }

        set;
    }

    public String seriaFilterValue{
        get {
            if (seriaFilterValue == null) {
                seriaFilterValue = '';
            }

            return seriaFilterValue;
        }

        set;
    }

    public String typeFilterValue{
        get {
            if (typeFilterValue == null) {
                typeFilterValue = '';
            }

            return typeFilterValue;
        }

        set;
    }

    public Id selectedDeviceId{
        get;
        set;
    }

    public ApexPages.StandardSetController devicePaginationController{
        get{
            if (devicePaginationController == null) {
                devicePaginationController = deviceModel.getDevicesStandardSetController(selectedCity);
                System.debug('selectedCity-lazy: ' + selectedCity);
            }

            System.debug('selectedCity-out: ' + selectedCity);

            devicePaginationController.setPageSize(ConstantsUtil.itemsOnOnePaginationPage);
            return devicePaginationController;
        }
        set;
    }

    public Integer totalPagesNum{
        get{
            return (Integer) Math.ceil((Decimal)devicePaginationController.getResultSize() / ConstantsUtil.itemsOnOnePaginationPage);
        }
        set;
    }

    public void first(){
        deviceConfigurationList = null;
        this.devicePaginationController.first();
    }

    public void last(){
        deviceConfigurationList = null;
        this.devicePaginationController.last();
    }

    public void next(){
        deviceConfigurationList = null;
        this.devicePaginationController.next();
    }

    public void previous(){
        deviceConfigurationList = null;
        this.devicePaginationController.previous();
    }

    public void goToSelectedPage(){
        deviceConfigurationList = null;

        Integer selectedPageNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('selectedPage'));
        devicePaginationController.setPageNumber(selectedPageNum);
    }


    public DevConfigController() {
        deviceModel.setFilterFields(nameFilterValue, ownerFilterValue, seriaFilterValue, typeFilterValue);
        deviceModel.getLocationUserAdmin(UserInfo.getUserId());

        System.debug('selectedCity-const: ' + selectedCity);
    }

    public PageReference sortDeviceByLocation(){
        devicePaginationController = deviceModel.getDevicesStandardSetController(selectedCity);

        return null;
    }

    public List<Hardware__c> getHardwares(){
        return (List<Hardware__c>) devicePaginationController.getRecords();
    }

    public PageReference setDeviceConfigurationListData(){
        selectedDeviceId =  Apexpages.currentPage().getParameters().get('deviceIdParameter');
        deviceImageUrl =  Apexpages.currentPage().getParameters().get('deviceImgUrl');

        deviceConfigurationList = deviceModel.getListHardwaresOfDevice(selectedDeviceId);
        return null;
    }

    public PageReference alertMonitorChanging(){
        deviceConfigurationList = null;
        return null;
    }

    public PageReference setFilteredDeviceData(){
        deviceConfigurationList = null;
        deviceModel.setFilterFields(nameFilterValue, ownerFilterValue, seriaFilterValue, typeFilterValue);
        devicePaginationController = deviceModel.getDevicesStandardSetController(selectedCity);

        return null;
    }

    public PageReference redirectToConfigurationEditorPage(){
        PageReference redirector = Page.DeviceConfigurationEditor;
        redirector.getParameters().put(ConstantsUtil.TAB_TAG_PREFIX, ConstantsUtil.DEVICES_TAB_TAG);
        redirector.getParameters().put('deviceId',selectedDeviceId);
        redirector.setRedirect(true);

        return redirector;
    }
}