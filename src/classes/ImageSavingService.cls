/**
 * Created by Trainee 4 on 2/8/2018.
 */

public with sharing class ImageSavingService {

    public List<Attachment> attachments { get; set; }
    public List<Account> accountsForImageAttach { get ; set; }
    public List<Hardware__c> hardWaresForImageAttach { get ; set; }

    public ImageSavingService(List<Attachment> attachments) {
        this.attachments = attachments;
        accountsForImageAttach = new List<Account>();
        hardWaresForImageAttach = new List<Hardware__c>();
        splitAttachmentsForRelatedObjects();
    }

    private void splitAttachmentsForRelatedObjects() {
        for (Attachment att : attachments) {
            Id parentId = att.ParentId;
            String imageUrl = getUrlLink(att);
            if (parentId.getSobjectType() == Account.sObjectType) {
                accountsForImageAttach.add(changeAccountById(parentId, imageUrl));
            }
            if (parentId.getSobjectType() == Hardware__c.sObjectType) {
                hardWaresForImageAttach.add(changeHardwareById(parentId, imageUrl));
            }
        }
    }

    private Account changeAccountById(Id parentId, String imageUrl) {
        Account actionAccount = [SELECT ImageUrl__c FROM Account WHERE id = :parentId];
        actionAccount.ImageUrl__c = imageUrl;
        return actionAccount;
    }

    private Hardware__c changeHardwareById(Id parentId, String imageUrl) {
        Hardware__c actionHardWare = [SELECT ImageUrl__c FROM Hardware__c WHERE id = :parentId];
        actionHardWare.ImageUrl__c = imageUrl;
        return actionHardWare;
    }

    private String getUrlLink(Attachment att) {
        return '/servlet/servlet.FileDownload?file=' + att.id;
    }
}