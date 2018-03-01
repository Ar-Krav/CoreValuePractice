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


    private Boolean previousMode;
    public Boolean isRelocate{
        get;
        set;
    }

    private String lastCity;

    public String selectedCity{
        get;
        set;
    }

    public List<SelectOption> relocationOptions{
        get{
            if (relocationOptions == null) {
                relocationOptions = deviceService.getRelocationSelectedOptions();
            }

            return relocationOptions;
        }
        set;
    }

    public List<Hardware__c> deviceList {
        get{
            System.debug('deviceList: ' + devicePaginationController);
            return devicePaginationController.getRecords();
        }
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

    public ApexPages.StandardSetController devicePaginationController{
        get{
            if (selectedCity != lastCity || isRelocate != previousMode) {

                devicePaginationController = isRelocate ? deviceService.getDevicesForRelocate(userAdminsLocations, deviceTableFilters) : deviceService.getDevicesStandardSetController(userAdminsLocations, deviceTableFilters);

                lastCity = selectedCity;
                previousMode = isRelocate;
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

    public void goToSelectedPage(){
        Integer selectedPageNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('selectedPage'));

        System.debug('goToSelectedPage: ' + selectedPageNum);
        devicePaginationController.setPageNumber(selectedPageNum);
    }

    public PageReference alertMonitorChanging(){
        return null;
    }

    public PageReference setFilteredDeviceData(){
        devicePaginationController = deviceService.getDevicesStandardSetController(userAdminsLocations, deviceTableFilters);

        return null;
    }

    public PageReference relocateDevice(){
        deviceService.updateDeviceLocation(deviceList);
        return null;
    }
}