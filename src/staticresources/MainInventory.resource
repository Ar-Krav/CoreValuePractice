/*
Please consider that the JS part isn't production ready at all, I just code it to show the concept of merging filters and titles together !
*/
var showMode = "none";

$(document).ready(function () {
    setupDataTable();

    $('#changeModeButton').click(function () {

        if (showMode === "none") {
            showMode = "table-cell";
        }
        else {
            showMode = "none";
        }
        $('.fulltable').css("display", showMode);
    });

    $('#cityDropDown').change(function (e) {
        loadHardWareListByLocation($('#cityDropDownBlock option:selected').val())
    });
});

function setupDataTable() {
    var table = $('#renderTable').DataTable({
        "order": [[1, "desc"]]
    });

    table.on('draw', function () {
        $('.fulltable').css("display", showMode);
        var top = $('#renderTable').offset().top;
        $('body,html').animate({scrollTop: top}, 500);
    });


    $('#renderTable tfoot th').each(function () {
        var title = $(this).text();
        $(this).html('<input type="text" placeholder="' + title + '" />');
    });

    table.columns().every(function () {
        var that = this;
        $('input', this.footer()).on('keyup change', function () {
            if (that.search() !== this.value) {
                that
                    .search(this.value)
                    .draw();
            }
        });
    });
}