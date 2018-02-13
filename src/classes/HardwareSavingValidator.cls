/**
 * Created by Trainee 4 on 2/12/2018.
 */

public with sharing class HardwareSavingValidator {

    public List<Hardware__c> hardwares { get; set; }
    public static final String globalLinkRegex = '^((http|https)://)??(www[.])??([a-zA-Z0-9]|-)+?([.][a-zA-Z0-9(-|/|=|?)??]+?)+?$';
    public static final String salesForceImageStoragePathRegex = '^\\/servlet\\/servlet\\.FileDownload\\?file=.+$';
    public Pattern globalLinkPattern { get; set; }
    public Pattern salesForcePattern { get; set; }

    public HardwareSavingValidator(List<Hardware__c> hardwares) {
        this.hardwares = hardwares;
        this.globalLinkPattern = Pattern.compile(globalLinkRegex);
        this.salesForcePattern = Pattern.compile(salesForceImageStoragePathRegex);
    }

    public void validateHardwares() {
        for (Hardware__c hardWare : hardwares) {
            validateLocations(hardWare);
            validateImage(hardWare);
            validateComposition(hardWare);
        }
    }

    private void validateImage(Hardware__c hardWare) {
        if (hardWare.ImageUrl__c != null) {
            Matcher globalLinkMatcher = globalLinkPattern.matcher(hardWare.ImageUrl__c);
            Matcher salesForceMatcher = salesForcePattern.matcher(hardWare.ImageUrl__c);
            if (!globalLinkMatcher.matches() && !salesForceMatcher.matches()) {
                hardWare.ImageUrl__c.addError('Wrong url!');
            }
        }
    }

    private void validateLocations(Hardware__c hardWare) {
        if (hardWare.Parent__c != null && hardWare.LocationID__c != [select LocationID__c from Hardware__c where id = :hardWare.Parent__c].LocationID__c) {
            hardWare.LocationID__c.addError('Location of parent hardware and current did\'nt match!');
        }
    }

    private void validateComposition(Hardware__c hardWare) {
        System.debug([select name from RecordType where id=:hardWare.RecordTypeId]);
        System.debug(hardWare.Parent__r.RecordType.Name);
    }
}