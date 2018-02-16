#device-block, #configuration-info{
            width:49%;
            display:inline-block;
        }

        #main-box{
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            align-items: stretch;
        }

        #device-block{
            min-width: 634px;
        }

        #configuration-info{
        	min-width: 519px;	
        }

        #devices-table, #configuration-table{
            table-layout: fixed;
            width: 100%;
        }

        #devices-table tfoot{
            display: table-header-group;
        }

        .table-col-40{
            width: 40%;
        }

        .table-col-30{
            width: 30%;
        }

        .table-col-25{
            width: 25%;
        }

        .table-col-20{
            width: 20%;
        }

        p.overlapping-text{
            width: 100%;
            margin: 0;

            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .filter-field{
            width: 100%;
            font-size: 90%;
        }