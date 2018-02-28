/**
 * Created by Ar-Krav on 28.02.2018.
 */

public with sharing class RelocateTableController{
    private DeviceTableService deviceService = new DeviceTableService();

    private List<Location__c> userAdminsLocations{
        get{
            if (userAdminsLocations == null) {
                userAdminsLocations = new List<Location__c>();
                for(Location__c location : userAdminLocationsArray){
                    userAdminsLocations.add(location);
                }
            }

            userAdminsLocations = new List<Location__c>();
            for(Location__c location : userAdminLocationsArray){
                userAdminsLocations.add(location);
            }

            if (selectedCity.equals(ConstantsUtil.allCityMode)) {
                return userAdminsLocations;
            }

            List<Location__c> tempLocList = new List<Location__c>();
            for (Location__c location : userAdminsLocations) {
                if (location.Id.equals(selectedCity)) {
                    tempLocList.add(location);
                    break;
                }
            }

            return tempLocList;
        }
        set;
    }

    public Location__c[] userAdminLocationsArray{
        get;
        set;
    }

    private String lastCity;

    public String selectedCity{
        get;
        set;
    }

    public List<SelectOption> relocationOptions{
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

    public DeviceTableFilters deviceTableFilters{
        get{
            if (deviceTableFilters == null) {
                deviceTableFilters = new DeviceTableFilters();
            }

            return deviceTableFilters;
        }
        set;
    }

    public Id selectedDeviceId{
        get;
        set;
    }

    public ApexPages.StandardSetController devicePaginationController{
        get{
            if (selectedCity != lastCity) {
                devicePaginationController = deviceService.getDevicesStandardSetController(userAdminsLocations, deviceTableFilters);
                devicePaginationController.setPageSize(ConstantsUtil.itemsOnOnePaginationPage);
                lastCity = selectedCity;
            }

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


    public RelocateTableController() {
        relocationOptions = deviceService.getRelocationSelectedOptions();
    }

    public PageReference setDeviceConfigurationListData(){
        selectedDeviceId =  Apexpages.currentPage().getParameters().get('deviceIdParameter');
        deviceImageUrl =  Apexpages.currentPage().getParameters().get('deviceImgUrl');

        deviceConfigurationList = deviceService.getDeviceConfigurationHardwares(selectedDeviceId);
        return null;
    }

    public PageReference alertMonitorChanging(){
        deviceConfigurationList = null;
        return null;
    }

    public PageReference setFilteredDeviceData(){
        deviceConfigurationList = null;
        devicePaginationController = deviceService.getDevicesStandardSetController(userAdminsLocations, deviceTableFilters);

        return null;
    }

    public PageReference relocateDevice(){
        deviceService.updateDeviceLocation(deviceList);

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