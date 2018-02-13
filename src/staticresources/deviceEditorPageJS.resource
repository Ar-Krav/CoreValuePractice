        var lastSelectedCell;
       function showStockByRecordType(recordType){

           showStock(recordType);

           if (lastSelectedCell != undefined){
               lastSelectedCell.style.backgroundColor = 'white';
           }

           var cellId = "configuration-table-cell-" + recordType;
           var selectedCell = document.getElementById(cellId);   

           selectedCell.style.backgroundColor = '#e4f3ff';
           lastSelectedCell = selectedCell;
        }


$(document).ready(function() {
            configurationTable = redrawConfigurationDataTable();
            stockTable = redrawStockDataTable();
        } );

        var configurationTable;

        function redrawConfigurationDataTable(){
            return $('#configuration-table').DataTable( {
                "paging":   false,
                "info":     false,
                "ordering": false,
                "searching": false
            } );
        };

        var stockTable;

        function redrawStockDataTable(){
            return $('#stock-table').DataTable( {
                "info":     false
            } );
        }


        