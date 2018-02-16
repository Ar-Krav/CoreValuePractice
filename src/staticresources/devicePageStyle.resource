#pagination-buttons-block{
    text-align: right;
}

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

.ellipsis{
    padding:0 1em;
}

.paginate-button.current{
    color:#333 !important;
    border:1px solid #979797;
    background-color:white;
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0%, #fff), color-stop(100%, #dcdcdc));
    background:-webkit-linear-gradient(top, #fff 0%, #dcdcdc 100%);background:-moz-linear-gradient(top, #fff 0%, #dcdcdc 100%);
    background:-ms-linear-gradient(top, #fff 0%, #dcdcdc 100%);background:-o-linear-gradient(top, #fff 0%, #dcdcdc 100%);
    background:linear-gradient(to bottom, #fff 0%, #dcdcdc 100%)
}

.paginate-button.current:hover{
    color:#333 !important;
    border:1px solid #979797;
    background-color:white;
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0%, #fff), color-stop(100%, #dcdcdc));
    background:-webkit-linear-gradient(top, #fff 0%, #dcdcdc 100%);
    background:-moz-linear-gradient(top, #fff 0%, #dcdcdc 100%);
    background:-ms-linear-gradient(top, #fff 0%, #dcdcdc 100%);
    background:-o-linear-gradient(top, #fff 0%, #dcdcdc 100%);
    background:linear-gradient(to bottom, #fff 0%, #dcdcdc 100%) !important;
}

.paginate-button{
    box-sizing: border-box;
    display: inline-block;
    min-width: 1.5em;
    padding: 0.5em 1em;
    margin-left: 2px;
    text-align: center;
    cursor: pointer;
    color: #333 !important;
    background-color: transparent;
    text-decoration: none !important;
    border: 1px solid transparent;
    border-radius: 2px;
}

.paginate-button:active{
    outline:none;
    background-color:#2b2b2b;
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0%, #2b2b2b), color-stop(100%, #0c0c0c));
    background:-webkit-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);
    background:-moz-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);
    background:-ms-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);
    background:-o-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);
    background:linear-gradient(to bottom, #2b2b2b 0%, #0c0c0c 100%) !important;
    box-shadow:inset 0 0 3px #111;
}

.paginate-button:hover{
    color:white !important;
    border:1px solid #111;
    background-color:#585858;
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0%, #585858), color-stop(100%, #111));
    background:-webkit-linear-gradient(top, #585858 0%, #111 100%);background:-moz-linear-gradient(top, #585858 0%, #111 100%);
    background:-ms-linear-gradient(top, #585858 0%, #111 100%);background:-o-linear-gradient(top, #585858 0%, #111 100%);
    background:linear-gradient(to bottom, #585858 0%, #111 100%)
}

.paginate-button.disabled,.paginate-button.disabled:hover,.paginate-button.disabled:active{
    pointer-events: none;
    cursor:default;
    color:#666 !important;
    border:1px solid transparent;
    background:transparent;
    box-shadow:none
}