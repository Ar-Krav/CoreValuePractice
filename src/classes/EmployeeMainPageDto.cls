/**
 * Created by Trainee 4 on 2/6/2018.
 */

public with sharing class EmployeeMainPageDto {

    public String empId { get; set; }
    public String empName { get; set; }
    public String empType { get; set; }
    public String locationName { get; set; }
    public String locationId { get; set; }
    public String deviceName { get; set; }
    public String deviceId { get; set; }
    public String deviceType { get; set; }
    public String invNumber { get; set; }
    public List<Hardware__c> monitors { get; set; }

    private EmployeeMainPageDto(EmployeeMainPageDtoBuilder builder) {
        this.empId = builder.empId;
        this.empName = builder.empName;
        this.empType = builder.empType;
        this.locationName = builder.locationName;
        this.locationId = builder.locationId;
        this.deviceName = builder.deviceName;
        this.deviceId = builder.deviceId;
        this.deviceType = builder.deviceType;
        this.invNumber = builder.invNumber;
        this.monitors = builder.monitors;
    }

    public with sharing class EmployeeMainPageDtoBuilder {

        public String empId { get; set; }
        public String empName { get; set; }
        public String empType { get; set; }
        public String locationName { get; set; }
        public String locationId { get; set; }
        public String deviceName { get; set; }
        public String deviceId { get; set; }
        public String deviceType { get; set; }
        public String invNumber { get; set; }
        public List<Hardware__c> monitors { get; set; }

        public EmployeeMainPageDtoBuilder setEmpId(String empId) {
            this.empId = empId;
            return this;
        }

        public EmployeeMainPageDtoBuilder setEmpName(String empName) {
            this.empName = empName;
            return this;
        }

        public EmployeeMainPageDtoBuilder setEmpType(String empType) {
            this.empType = empType;
            return this;
        }

        public EmployeeMainPageDtoBuilder setLocationName(String locationName) {
            this.locationName = locationName;
            return this;
        }

        public EmployeeMainPageDtoBuilder setLocationId(String locationId) {
            this.locationId = locationId;
            return this;
        }

        public EmployeeMainPageDtoBuilder setDeviceName(String deviceName) {
            this.deviceName = deviceName;
            return this;
        }

        public EmployeeMainPageDtoBuilder setDeviceId(String deviceId) {
            this.deviceId = deviceId;
            return this;
        }

        public EmployeeMainPageDtoBuilder setDeviceType(String deviceType) {
            this.deviceType = deviceType;
            return this;
        }

        public EmployeeMainPageDtoBuilder setInvNumber(String invNumber) {
            this.invNumber = invNumber;
            return this;
        }

        public EmployeeMainPageDtoBuilder setMonitors(List<Hardware__c> monitors) {
            this.monitors = monitors;
            return this;
        }

        public EmployeeMainPageDto build() {
            return new EmployeeMainPageDto(this);
        }
    }
}