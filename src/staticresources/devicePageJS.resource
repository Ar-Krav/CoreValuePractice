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

        var lastSelectedRow;
        function markSelectedRow(element){
            if (lastSelectedRow != undefined){
                lastSelectedRow.style.backgroundColor = 'white';
            }

            element.style.backgroundColor = '#e4f3ff';
            lastSelectedRow = element;
        }

        function selectRow(element, recordType, deviceId, deviceImgUrl) {

console.log('IN JS: ' + deviceImgUrl);

            var availableToChangeHardware = ['PC', 'Notebook', 'Server'];

            if (availableToChangeHardware.includes(recordType)){
                markSelectedRow(element);
                showDeviceHardwareData(deviceId, deviceImgUrl);
            }
            else {
                markSelectedRow(element);
                alertMonitorChanging();
            }
        }