// HardwareJS

$(document).ready(function(){
    $('#devices-table').DataTable({
        "columnDefs": [
            { "orderable": false, "targets": 'no-sort'  }
          ],
          "info": false,
          "paging": false,
          "ordering": false,
          "searching": false
    });
    $('#hardware-table').DataTable({
            "columnDefs": [
                { "orderable": false, "targets": 'no-sort'  }
              ],
              "info": false,
              "paging": false,
              "ordering": false,
              "searching": false
        });
  $('#monitor-table').DataTable({
            "columnDefs": [
                { "orderable": false, "targets": 'no-sort'  }
              ],
              "info": false,
              "paging": false,
              "ordering": false,
              "searching": false
        });
});

var lastRow;
 function ggg(event, deviceId) {
     $("[id$='btn']").prop('disabled', false).removeClass('btnDisabled').addClass('btn');
     $("[id$='btn1']").prop('disabled', false).removeClass('btnDisabled').addClass('btn');
     if(lastRow != undefined)
     lastRow.style.backgroundColor = 'white';
     event.style.backgroundColor = '#e4f3ff';
     lastRow = event;
     showDeviceHardwareData(deviceId);
     };