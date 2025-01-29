trigger ApprovalFormTrigger on Approval_form_log__c (after insert) {

       if (Trigger.isAfter && Trigger.isInsert) {
            for (Approval_form_log__c afl : Trigger.new) {
                   Order_Form__c orderForm = [Select id, name, Company_Name__c, Comments__c, Client_Approval_Status__c, Approval_Signatur_Name__c from Order_Form__c where id = :afl.Order_form_recordId__c LIMIT 1];
                   System.debug('@@@ Trigger orderForm 1 : '+orderForm);
                   orderForm.Client_Approval_Status__c = afl.Client_Approval_Status__c;
                   orderForm.Comments__c = afl.Comments__c;
                   orderForm.Approval_Signatur_Name__c = afl.Approval_Signatur_Name__c;
                   update orderForm;
                   System.debug('@@@ Trigger orderForm 2 : '+orderForm);
            }
        }
}