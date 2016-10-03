/**
 * Publishes a message to Slack. Invocable from Process Builder.
 * Based on code original by Christophe Coenraets:
 *   http://coenraets.org/blog/2016/01/slack-salesforce-integration/
 *
 * @author      Scott Coleman <scott@cloudgiants.com>
 */
public with sharing class SlackPublisher {
     
    public class Payload {
        @InvocableVariable(label='Slack Webhook URL')
        public String slackURL;
        @InvocableVariable(label='Message Text')
        public String messageText;
        @InvocableVariable(label='Field 1 Name')
        public String field1Name;
        @InvocableVariable(label='Field 1 Value')
        public String field1Value;
        @InvocableVariable(label='Field 2 Name')
        public String field2Name;
        @InvocableVariable(label='Field 2 Value')
        public String field2Value;
        @InvocableVariable(label='Field 3 Name')
        public String field3Name;
        @InvocableVariable(label='Field 3 Value')
        public String field3Value;
        @InvocableVariable(label='Field 4 Name')
        public String field4Name;
        @InvocableVariable(label='Field 4 Value')
        public String field4Value;
        @InvocableVariable(label='Linked Record ID')
        public String recordId;
    }
     
    @InvocableMethod(label='Post to Slack')
    public static void postToSlack(List<Payload> payloads) {
        Payload p = payloads[0]; // If bulk, only post first to avoid overloading Slack channel
        Map<String,Object> msg = new Map<String,Object>();
        String messageText = p.messageText + '\n>>>';
        if(!String.isBlank(p.field1Name) && !String.isBlank(p.field1Value)) {
            messageText += '\n*' + p.field1Name + ':* ' + p.field1Value;
        }
        if(!String.isBlank(p.field2Name) && !String.isBlank(p.field2Value)) {
            messageText += '\n*' + p.field2Name + ':* ' + p.field2Value;
        }
        if(!String.isBlank(p.field3Name) && !String.isBlank(p.field3Value)) {
            messageText += '\n*' + p.field3Name + ':* ' + p.field3Value;
        }
        if(!String.isBlank(p.field4Name) && !String.isBlank(p.field4Value)) {
            messageText += '\n*' + p.field4Name + ':* ' + p.field4Value;
        }
        if(!String.isBlank(p.recordId)) {
            messageText += '\n*Link:* <' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + p.recordId + '>';
        }
        msg.put('text', messageText);
        msg.put('mrkdwn', true);
        String body = JSON.serialize(msg);    
        System.enqueueJob(new QueueableSlackCall(p.slackURL, 'POST', body));
    }
     
    public class QueueableSlackCall implements System.Queueable, Database.AllowsCallouts {
        private final String url;
        private final String method;
        private final String body;
         
        public QueueableSlackCall(String url, String method, String body) {
            this.url = url;
            this.method = method;
            this.body = body;
        }
         
        public void execute(System.QueueableContext ctx) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod(method);
            req.setBody(body);
            Http http = new Http();
            if(!Test.isRunningTest()) {
                HttpResponse res = http.send(req);
            }
        }
    }    
}