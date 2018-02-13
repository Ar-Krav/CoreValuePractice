/**
 * Created by Trainee 4 on 1/26/2018.
 */

public with sharing class FiltersEntity {

    public String nameEmp { get; set; }
    public String nameDevice { get; set; }
    public String location { get; set; }
    public String empType { get; set; }
    public String deviceType { get; set; }
    public String invNo { get; set; }
    public String monitorName { get; set; }

    public FiltersEntity() {
        
        nameEmp = '';
        nameDevice = '';
        location = '';
        empType = '';
        deviceType = '';
        invNo = '';
        monitorName = '';
    }
}