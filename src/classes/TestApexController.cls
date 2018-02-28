/**
 * Created by Ar-Krav on 27.02.2018.
 */

public with sharing class TestApexController {
    private TestApexModel apexModel = new TestApexModel();
    private String allCitiesLabel;
    private Boolean isUserGlobalAdmin;

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
        isUserGlobalAdmin = apexModel.isUSerGlobalAdmin(UserInfo.getUserId());
        adminsCities = apexModel.getUserAdminLocations(UserInfo.getUserId(), isUserGlobalAdmin);

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

        return isUserGlobalAdmin ? 'All cities' : String.join(adminsCitiesLabel, ' & ');
    }
}