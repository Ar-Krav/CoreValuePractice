/**
 * Created by Trainee 4 on 2/12/2018.
 */

trigger HardwareSaving on Hardware__c (before insert, before update) {
    HardwareSavingValidator hardwareSavingValidator = new HardwareSavingValidator(Trigger.new);
    hardwareSavingValidator.validateHardwares();
}