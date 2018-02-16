
$(document).ready(function() {
    $('.ip-address').mask('099.099.099.099');
    $('.record-input').css({
        'width': ($('.servers-select-list').width() -2 + 'px')
        });
    $('.description-input').css({
            'width': ($('.servers-select-list').width() -4 + 'px')
            });
    $('.command-buttons-margin').css({
                'margin-left': ($('.servers-select-list').width()/2 - $('.add-button').width() - $('.cancel-button').width()/2 + 'px')
                });
    if($('.on-add').val() == ''){
        $( ".on-add" ).prop( "disabled", true );
        $( ".record-input" ).prop( "disabled", true );
        $( ".ip-address" ).prop( "disabled", true );
        $( ".description-input" ).prop( "disabled", true );
        $( ".add-button" ).prop( "disabled", true );
        $( ".add-button" ).addClass( "btnDisabled" );
    }
    });

function addNewServerIpValidation(){
    let addIpInputField = document.getElementById('add-new-server:j_id4:add-new-server-block:j_id31:j_id46:ip');
    let ipValidationRegExp = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/;
    if(!ipValidationRegExp.test(addIpInputField.value) && addIpInputField.value!='') {
        addIpInputField.classList.add('error-border');
        $('.ip-error-text').show();
        } else {
            addIpInputField.classList.remove('error-border');
            $('.ip-error-text').hide();
        }
    }

function editServerIpValidation() {
    let editIpInputField = document.getElementById('edit-server-record:j_id4:edit-server-record-block:j_id31:j_id46:ip');
    let ipValidationRegExp = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/;
    if(!ipValidationRegExp.test(editIpInputField.value) && editIpInputField.value!='') {
        editIpInputField.classList.add('error-border');
        $('.ip-error-text').show();
        } else {
            editIpInputField.classList.remove('error-border');
            $('.ip-error-text').hide();
            }
    }

function removeOddWhitespacesFromName() {
    $('.server-name').val($.trim($('.server-name').val()));
    $('.server-name').val($.trim($('.server-name').val().replace(/[\s\s+]+/g, ' ')));
}

function removeOddWhitespacesFromDesc() {
    $('.description-input').val($.trim($('.description-input').val()));
    $('.description-input').val($.trim($('.description-input').val().replace(/[\s\s+]+/g, ' ')));
}