public class PartnersCommHeaderImgController {

    public string logofilePath{get;set;}

    public PartnersCommHeaderImgController() {
        //logofilePath = '/partners/resource/PartnersCommLogos/logos/logo.png';
        //logofilePath = '';
        logofilePath = null;
        loadSetting();
    }

    private void loadSetting()
    {
        Id profId = UserInfo.getProfileId();

        /*
        for(PartnersCommLogos__c pcl : PartnersCommLogos__c.getall().values())
        {
            if(!(pcl.ProfileId__c InstanceOf Id)) continue;

            if(pcl.ProfileId__c == profId) logofilePath = '/partners/resource/PartnersCommLogos/logos/' + pcl.Filename__c;
        }
        */

        try
        {
            PartnersCommunityLogos__c pcl = PartnersCommunityLogos__c.getInstance();

            if(pcl.Filename__c != null) logofilePath = '/partners/resource/PartnersCommLogos/logos/' + pcl.Filename__c;
            system.debug(logofilePath);
            //logofilePath = EncodingUtil.urlEncode(logofilePath, 'UTF-8');
            //system.debug('new logofilePath: ' + logofilePath);
        }
        catch(Exception e)
        {

        }
    }

}