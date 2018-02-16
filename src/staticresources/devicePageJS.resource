        function doDeviceFiltration(e){
            var key=e.keyCode || e.which;

            if (key==13) {

                searchWithFilter(document.getElementById('device-name-filter').value,
                        document.getElementById('device-owner-filter').value,
                        document.getElementById('device-seria-filter').value,
                        document.getElementById('device-type-filter').value
                );
            }
        }

        function sortDeviceByLocation(){
            var dropDownList = document.getElementById('officeLocationsDropDown');
            var selectedItem = dropDownList.options[dropDownList.selectedIndex].value;

            changeLocation(selectedItem);

        }

        function selectRow(recordType, deviceId, deviceImgUrl) {

            var availableToChangeHardware = ['PC', 'Notebook', 'Server'];

            if (availableToChangeHardware.includes(recordType)){
                showDeviceHardwareData(deviceId, deviceImgUrl);
            }
            else {
                alertMonitorChanging();
            }
        }