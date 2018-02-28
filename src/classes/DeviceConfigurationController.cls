/**
 * Created by Ar-Krav on 28.02.2018.
 */

public with sharing class DeviceConfigurationController {
    DeviceConfigurationService devConfService = new DeviceConfigurationService();

    public String deviceId{
        get;
        set;
    }

    public String deviceImageUrl{
        get;
        set;
    }

    public List<Hardware__c> deviceConfigurationList{
        get{
            deviceConfigurationList = devConfService.getDeviceConfigurationHardwares(deviceId);
            return deviceConfigurationList;
        }
        set;
    }

    public PageReference redirectToConfigurationEditorPage(){
        PageReference redirector = Page.DeviceConfigurationEditor;
        redirector.getParameters().put(ConstantsUtil.TAB_TAG_PREFIX, ConstantsUtil.DEVICES_TAB_TAG);
        redirector.getParameters().put('deviceId',deviceId);
        redirector.setRedirect(true);

        return redirector;
    }
}