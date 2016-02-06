public class WeChatUtil 
{	
    private static Final String END_POINT = 'https://georgejt-developer-edition.ap2.force.com/services/apexrest/testRestApi';
    private static Final String ACCESS_TOKEN_URL = 'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=';
        
    public static String getAccessToken()
    {
        List<String> appList = getAppIdAndAppSecret();
        
        String endPoint = ACCESS_TOKEN_URL;
    	endPoint += appList[0] + '&secret=' + appList[1];
        
        HttpResponse res = new HttpResponse();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        res = (new Http()).send(request);
        
        AccessTokenObj accessToken = (AccessTokenObj)JSON.deserializeStrict(res.getBody(), AccessTokenObj.class);
        return accessToken.access_token;
    }
    
    public static void updateAccessToken()
    {
        String accessToken = getAccessToken();
        We_Chat_Setting__c weChatSetting = We_Chat_Setting__c.getOrgDefaults();
        if(weChatSetting.Access_Token__c != accessToken)
        {
            weChatSetting.Access_Token__c = accessToken;
            update weChatSetting;
        }
    }
    
    private static List<String> getAppIdAndAppSecret()
    {
        We_Chat_Setting__c weChatSetting = We_Chat_Setting__c.getOrgDefaults();
        String appId = weChatSetting.App_ID__c;
        String appSecret = weChatSetting.App_Secret__c;
        return new List<String> {appId, appSecret};
    }
    
    public class AccessTokenObj
    {
        public String access_token { get; set; }
        public Integer expires_in { get; set; }
    }
}