/**
 * Publishes a record to Salesforce. Invocable from Process Builder.
  * Based on code original by Christophe Coenraets:
 *   http://coenraets.org/blog/2016/01/slack-salesforce-integration/
 *
 * @author      Scott Coleman <scott@cloudgiants.com>
 */
public with sharing class SalesforcePublisher {
    public class Payload {
        @InvocableVariable(label='Named Credential Name')
        public String namedCredential;
        @InvocableVariable(label='Object API Name')
        public String objectName;
        @InvocableVariable(label='Field 1 API Name')
        public String field1Name;
        @InvocableVariable(label='Field 1 Value')
        public String field1Value;
        @InvocableVariable(label='Field 2 API Name')
        public String field2Name;
        @InvocableVariable(label='Field 2 Value')
        public String field2Value;
        @InvocableVariable(label='Field 3 API Name')
        public String field3Name;
        @InvocableVariable(label='Field 3 Value')
        public String field3Value;
        @InvocableVariable(label='Field 4 API Name')
        public String field4Name;
        @InvocableVariable(label='Field 4 Value')
        public String field4Value;
        @InvocableVariable(label='Field 5 API Name')
        public String field5Name;
        @InvocableVariable(label='Field 5 Value')
        public String field5Value;
    }

    @InvocableMethod(label='Publish to Salesforce')
    public static void publishToSalesforce(List<Payload> payloads) {
        Payload p = payloads[0];
        Map<String,String> record = new Map<String,String>();
        if(!String.isBlank(p.field1Name) && !String.isBlank(p.field1Value)) {
            record.put(p.field1Name, p.field1Value);
        }
        if(!String.isBlank(p.field2Name) && !String.isBlank(p.field2Value)) {
            record.put(p.field2Name, p.field2Value);
        }
        if(!String.isBlank(p.field3Name) && !String.isBlank(p.field3Value)) {
            record.put(p.field3Name, p.field3Value);
        }
        if(!String.isBlank(p.field4Name) && !String.isBlank(p.field4Value)) {
            record.put(p.field4Name, p.field4Value);
        }
        if(!String.isBlank(p.field5Name) && !String.isBlank(p.field5Value)) {
            record.put(p.field5Name, p.field5Value);
        }
        String body = JSON.serialize(record);
        String endpoint = 'callout:' + p.namedCredential + '/services/data/v33.0/sobjects/' + p.objectName;
        System.enqueueJob(new QueueableRestApiCall(endpoint, 'POST', body));
    }
     
    public class QueueableRestApiCall implements System.Queueable, Database.AllowsCallouts {
        private final String endpoint;
        private final String method;
        private final String body;
         
        public QueueableRestApiCall(String endpoint, String method, String body) {
            this.endpoint = endpoint;
            this.method = method;
            this.body = body;
        }
         
        public void execute(System.QueueableContext ctx) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod(method);
            req.setHeader('Content-Type', 'application/json');
            req.setBody(body);
            Http http = new Http();
            if(!Test.isRunningTest()) {
                HttpResponse res = http.send(req);
            }
        }
    } 
}