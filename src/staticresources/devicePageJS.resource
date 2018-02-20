function redrawDeviceDataTable(){
    return $('#devices-table').DataTable( {
        "paging":   false,
        "info":     false,
        select: true
    } );
}

var deviceTable;

$(document).ready(function() {
    deviceTable = redrawDeviceDataTable();
    configTable = redrawConfigurationDataTable();
    pageButtonClick();
} );

var configTable;

function redrawConfigurationDataTable() {
    return $('#configuration-table').DataTable( {
        "paging":   false,
        "info":     false
    } );
}

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

        function selectRow(recordType, deviceId, deviceImgUrl) {

            var availableToChangeHardware = ['PC', 'Notebook', 'Server'];

            if (availableToChangeHardware.includes(recordType)){
                showDeviceHardwareData(deviceId, deviceImgUrl);
            }
            else {
                alertMonitorChanging();
            }
        }

        function pageButtonClick() {
            var htmlCode = '<button class="paginate-button current" type="button" onClick="searchWithFilter(\'\',\'\',\'\');">RESET FILTERS</button>';
            document.getElementById('devices-table_wrapper').insertAdjacentHTML('afterBegin',htmlCode);

            var buttonsBlock = document.getElementById('page-buttons-block');
            var lastButtonBlock = document.getElementById('last-page-button-block');

            var htmlCode='';

            currentPage == 1 && document.getElementById('first-page-button').classList.add('current');

            if (totalPages <= 6){
                for(var i = 2; i <= totalPages; i++){
                    htmlCode += checkNeccessaryHTMLCode(i, currentPage);
                }

                buttonsBlock.innerHTML = htmlCode;
                return;
            }


            if (totalPages > 0){
                htmlCode = '<input id="last-page-button" type="button" class="paginate-button" data-page="' + totalPages + '" value="' + totalPages + '" onclick="lastPage()"/>';
                lastButtonBlock.innerHTML = htmlCode;
                currentPage == totalPages && document.getElementById('last-page-button').classList.add('current');
            }

            htmlCode='';
            buttonsBlock.innerHTML = htmlCode;

            if(currentPage < 5){
                for(i = 2; i <= 5; i++){
                    htmlCode += checkNeccessaryHTMLCode(i, currentPage);
                }

                htmlCode += '<span class="ellipsis">…</span>';
            }
            else {
                if (totalPages - currentPage < 5 && totalPages - currentPage != 4){

                    console.log('PageMinus: ' + totalPages - currentPage);

                    htmlCode = '<span class="ellipsis">…</span>';

                    for(i = totalPages - 4; i < totalPages; i++){
                        htmlCode += checkNeccessaryHTMLCode(i, currentPage);
                    }
                }
                else {
                    htmlCode = '<span class="ellipsis">…</span>';

                    htmlCode += '<input type="button" class="paginate-button" data-page="' + (currentPage - 1) + '" value="' + (currentPage - 1) + '" onclick="goToPage(this)"/>';
                    htmlCode += '<input type="button" class="paginate-button current" data-page="' + currentPage + '" value="' + currentPage + '"/>';
                    htmlCode += '<input type="button" class="paginate-button" data-page="' + (currentPage + 1) + '" value="' + (currentPage + 1) + '" onclick="goToPage(this)"/>';

                    htmlCode += '<span class="ellipsis">…</span>';
                }
            }

            buttonsBlock.innerHTML = htmlCode;

            console.log('htmlDoC: ' + htmlCode);
        }

        function checkNeccessaryHTMLCode(i, currentPage) {
            var htmlCode='';

            if(i == currentPage){
                htmlCode += '<input type="button" class="paginate-button current" data-page="' + i + '" value="' + i + '"/>\n';
            }
            else {
                htmlCode += '<input type="button" class="paginate-button" data-page="' + i + '" value="' + i + '" onclick="goToPage(this)"/>\n';
            }

            return htmlCode;
        }

        function goToPage(element) {
            var pageNum = element.getAttribute('data-page');
            goToSelectedPageNum(pageNum);
        }