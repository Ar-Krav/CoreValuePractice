/**
 * Created by Ar-Krav on 28.02.2018.
 */

public with sharing class DeviceTableFilters {
    public String nameFilterValue{
        get;
        set;
    }

    public String ownerFilterValue{
        get;
        set;
    }

    public String seriaFilterValue{
        get;
        set;
    }

    public String typeFilterValue{
        get;
        set;
    }

    public DeviceTableFilters(){
        this.nameFilterValue = '';
        this.seriaFilterValue = '';
        this.typeFilterValue = '';
        this.ownerFilterValue = '';
    }
}