/**
 * Created by Trainee 4 on 2/6/2018.
 */

trigger AttachmentTrigger on Attachment (after insert, after update) {
    ImageSavingService savingService = new ImageSavingService(Trigger.new);

    update savingService.accountsForImageAttach;
    update savingService.hardWaresForImageAttach;
}