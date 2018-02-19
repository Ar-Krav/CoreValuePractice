/**
 * Created by Ar-Krav on 24.01.2018.
 */

public with sharing class DevicePageController {
    private DevicePageDataModel deviceModel = new DevicePageDataModel();
    public String selectedCity;


    public Boolean isShowLocationSelection{
        get;
        set;
    }

    public List<Location__c> adminsCities{
        get;
        set;
    }

    public String allCitiesLabel{
        get;
        set;
    }

    public List<SelectOption> adminCitiesOption{
        get{
            if (adminCitiesOption == null) {

            }

            return adminCitiesOption;
        }
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
        Integer selectedPageNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('selectedPage'));
        devicePaginationController.setPageNumber(selectedPageNum);
    }

    public DevicePageController() {
        deviceModel.setFilterFields(nameFilterValue, ownerFilterValue, seriaFilterValue, typeFilterValue);

        adminsCities = deviceModel.getLocationUserAdmin(UserInfo.getUserId());

        isShowLocationSelection = adminsCities.size() > 1;


        List<String> adminsCitiesLabel = new List<String>();
        for (Location__c location : adminsCities) {
            adminsCitiesLabel.add(location.Name);
        }

        allCitiesLabel = deviceModel.getIsGlobalAdmin() ? ConstantsUtil.allCityMode : String.join(adminsCitiesLabel, ' AND ');

        selectedCity = isShowLocationSelection ? ConstantsUtil.allCityMode : adminsCities.get(0).Id;
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

    private List<SelectOption> getSelectOptions(){
        List<SelectOption> lst = new List<SelectOption>();

        lst.add(new SelectOption(ConstantsUtil.allCityMode, allCitiesLabel));

        for (Location__c location : adminsCities) {
            lst.add(new SelectOption(location.id, location.name));
        }

        return lst;
    }
}