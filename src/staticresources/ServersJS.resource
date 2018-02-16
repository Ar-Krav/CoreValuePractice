$(document).ready(function(){
    $('#servers-table').DataTable({
                "columnDefs": [
                    { "orderable": false, "targets": 'no-sort',
                      "width": "2%", "targets": 0,}
                  ],
                "aaSorting": [1,'asc']
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