/**
 * Created by Ar-Krav on 27.02.2018.
 */

public with sharing class TestApexController {
    private DevicePageDataModel deviceModel = new DevicePageDataModel();
    private String allCitiesLabel;
    public List<Location__c> adminsCities{
        get;
        set;
    }


    public String selectedCity{
        get;
        set;
    }

    public String selectedCitiesLabel{
        get{
            if (!isShowLocationSelection) {
                selectedCitiesLabel = adminsCities.get(0).Name;
            }
            else{
                selectedCitiesLabel = allCitiesLabel;
                for (Location__c location : adminsCities) {
                    if (selectedCity != ConstantsUtil.allCityMode && location.id == selectedCity) {
                        selectedCitiesLabel = location.name;
                    }
                }
            }

            return selectedCitiesLabel;
        }
        set;
    }

    public Boolean isShowLocationSelection{
        get;
        set;
    }

    public List<SelectOption> adminCitiesOption{
        get;
        set;
    }


    public TestApexController() {
        adminsCities = deviceModel.getLocationUserAdmin(UserInfo.getUserId());

        if (adminsCities.size() > 1) {

            isShowLocationSelection = true;

            allCitiesLabel = getAllCitiesLabel();
            adminCitiesOption = getAdminCitiesOptions();

            selectedCity = ConstantsUtil.allCityMode;
        }
        else {
            selectedCity = adminsCities.get(0).Id;
        }
    }

    private List<SelectOption> getAdminCitiesOptions(){
        List<SelectOption> selectionList = new List<SelectOption>();

        selectionList.add(new SelectOption(ConstantsUtil.allCityMode, allCitiesLabel));

        for (Location__c location : adminsCities) {
            selectionList.add(new SelectOption(location.id, location.name));
        }

        return selectionList;
    }

    private String getAllCitiesLabel(){
        List<String> adminsCitiesLabel = new List<String>();
        for (Location__c location : adminsCities) {
            adminsCitiesLabel.add(location.Name);
        }

        return deviceModel.getIsGlobalAdmin() ? 'All cities' : String.join(adminsCitiesLabel, ' & ');
    }
}