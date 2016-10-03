/**
 * Test class for SlackPublisher
 *
 * @author      Scott Coleman <scott@cloudgiants.com>
 */
@isTest
public class SalesforcePublisherTest {

    @isTest
    static void publishToSalesforceTest () {
        SalesforcePublisher.Payload payload = new SalesforcePublisher.Payload();
        payload.namedCredential = 'TestCredential';
        payload.objectName = 'Account';
        payload.field1Name = 'Field 1';
        payload.field1Value = 'Value 1';
        payload.field2Name = 'Field 2';
        payload.field2Value = 'Value 2';
        payload.field3Name = 'Field 3';
        payload.field3Value = 'Value 3';
        payload.field4Name = 'Field 4';
        payload.field4Value = 'Value 4';
        payload.field5Name = 'Field 5';
        payload.field5Value = 'Value 5';
        
        Test.startTest();

        SalesforcePublisher.publishToSalesforce(new List<SalesforcePublisher.Payload>{payload});
        
        Test.stopTest();
    }

}