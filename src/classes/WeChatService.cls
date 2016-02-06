/*
 * Web service class. can validate WeChat Request. and deal incoming message come from wechat.
 */
@RestResource(urlMapping='/wechatService')
global with sharing class WeChatService
{
    @HttpGet
    global static void verifyAccount()
    {
        RestRequest request = RestContext.request;
        String echo = request.params.get('echostr');
        Boolean isValid = isValidate(request);
        if(isValid)
        {
            RestContext.response.responseBody = Blob.valueOf(echo);
        }
    }

    // If request don't come from wechat or reques param invalid, reject this reqeust.
    public static Boolean isValidate(RestRequest request)
    {
        Boolean isValid = false;
 
        String token = request.params.get('token');
        
        String timestamp = request.params.get('timestamp');
        String nonce = request.params.get('nonce');
        String signature = request.params.get('signature');
        
        List<String> strArr = new List<String>{token,timestamp,nonce};
            strArr.sort();
        Blob signing = Crypto.generateDigest('SHA1',Blob.valueOf(strArr[0]+strArr[1]+strArr[2]));
        String result = EncodingUtil.convertToHex(signing);
        isValid = signature == null ? false : signature.equals(result);

        return isValid;
    }
}