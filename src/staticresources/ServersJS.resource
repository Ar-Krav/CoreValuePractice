$(document).ready(function(){
    $('#servers-table').DataTable({
                "columnDefs": [
                    { "orderable": false, "targets": 'no-sort',
                      "width": "2%", "targets": 0,}
                  ],
                "aaSorting": [1,'asc']
            });
    $('#servers-table-without-show-entries').DataTable({
            "columnDefs": [
                { "orderable": false, "targets": 'no-sort',
                  "width": "2%", "targets": 0,}
              ],
            "aaSorting": [1,'asc'],
            "bLengthChange": false
        });
});

function setupDataTable () {
    $('#servers-table').DataTable({
                    "columnDefs": [
                        { "orderable": false, "targets": 'no-sort',
                          "width": "2%", "targets": 0,}
                      ],
                    "aaSorting": [1,'asc']
                });
}