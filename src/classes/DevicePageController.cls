/**
 * Created by Ar-Krav on 24.01.2018.
 */

public with sharing class DevicePageController {
    private DevicePageDataModel deviceModel = new DevicePageDataModel();

    private UserPermissions__c signedUpUser;


    public Boolean isAdmin{
        get;
        set;
    }

    public String selectedCity{
        get;
        set;
    }

    public List<Hardware__c> deviceList {
        get{ return devicePaginationController.getRecords(); }

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

    public List<Location__c> officeLocations{
        get;
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
            }

            devicePaginationController.setPageSize(ConstantsUtil.itemsOnOnePaginationPage);
            return devicePaginationController;
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

    public DevicePageController() {
        deviceModel.setFilterFields(nameFilterValue, ownerFilterValue, seriaFilterValue, typeFilterValue);

        signedUpUser = deviceModel.getSigndUpUser(UserInfo.getUserId());
        isAdmin = signedUpUser.Location__c == null;
        selectedCity = isAdmin ? ConstantsUtil.allCityMode : signedUpUser.Location__c;

        officeLocations = isAdmin ? deviceModel.getLocations() : null;
    }

    public List<Hardware__c> getHardwares(){
        return (List<Hardware__c>) devicePaginationController.getRecords();
    }

    public PageReference sortDeviceByLocation(){
        selectedCity = ApexPages.currentPage().getParameters().get('selectedLocation');
        devicePaginationController = deviceModel.getDevicesStandardSetController(selectedCity);

        return null;
    }


    public PageReference setDeviceConfigurationListData(){
        selectedDeviceId =  Apexpages.currentPage().getParameters().get('deviceIdParameter');
        deviceImageUrl =  Apexpages.currentPage().getParameters().get('deviceImgUrl');

        System.debug('image URL: ' + deviceImageUrl);

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