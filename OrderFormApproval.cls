public without sharing class OrderFormApproval {


	@AuraEnabled(cacheable=true)
	public static List<order_form_product__c> getOrderFormProductData(Id recordId){
		System.debug('orderformId : '+recordId);
		List<order_form_product__c> orderFormProductList = [Select id, Name, Product__c, Product__r.Name, Product__r.Description, Quantity__c, Actual_Price__c,  Discount_Price__c, Subtotal_Price__c, Order_Form__c from order_form_product__c where Order_Form__c =: recordId];
		return orderFormProductList;
	}

	/*@AuraEnabled(cacheable=true)
    public static String getExternalIp() {
        String ipAddress = Auth.SessionManagement.getCurrentSession().get('SourceIp');
		return ipAddress;
	} */

	@AuraEnabled
    public static void orderFormApprove(Id recordId, String comments, String drawnSig, String uploadSign, String approvalSignaturName) {
        try {

			Approval_form_log__c approvalForm = new Approval_form_log__c();
			approvalForm.Order_form_recordId__c = recordId;						//approvalForm.Order_Form__c = recordId;
			approvalForm.Client_Approval_Status__c = 'Approved';
			approvalForm.Comments__c = comments;
			approvalForm.Approval_Signatur_Name__c = approvalSignaturName;
			insert approvalForm;

			if(String.isNotBlank(uploadSign)){
				ContentDocumentLink link = new ContentDocumentLink();
        		link.ContentDocumentId = uploadSign;
        		link.LinkedEntityId = recordId;
        		link.ShareType = 'V';
        		link.Visibility = 'AllUsers';
        		insert link;

				ContentDocumentLink link2 = new ContentDocumentLink();
        		link2.ContentDocumentId = uploadSign;
        		link2.LinkedEntityId = approvalForm.Id;
        		link2.ShareType = 'V';
        		link2.Visibility = 'AllUsers';
        		insert link2;
			} else {
				Blob fileBlob = EncodingUtil.base64Decode(drawnSig);
				ContentVersion contentVersion = new ContentVersion();
            	contentVersion.Title = 'ApproverSign.png';
            	contentVersion.PathOnClient = 'ApproverSign.png';
            	contentVersion.VersionData = fileBlob;
            	contentVersion.IsMajorVersion = true;
            	insert contentVersion;

            	ContentDocumentLink contentLink = new ContentDocumentLink();
            	contentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;
            	contentLink.LinkedEntityId = recordId;
            	contentLink.ShareType = 'V';
            	contentLink.Visibility = 'AllUsers';
            	insert contentLink;

				ContentDocumentLink contentLink2 = new ContentDocumentLink();
            	contentLink2.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;
            	contentLink2.LinkedEntityId = approvalForm.Id;
            	contentLink2.ShareType = 'V';
            	contentLink2.Visibility = 'AllUsers';
            	insert contentLink2;
			}
        } catch (Exception e) {
			System.debug('### Exception: ' + e.getMessage());
            throw new AuraHandledException('Error updating comments: ' + e.getMessage());
        }
    }

	@AuraEnabled
    public static void orderFormDecline(Id recordId, String comments, String drawnSig, String uploadSign, String approvalSignaturName) {
        try {
			Approval_form_log__c approvalForm = new Approval_form_log__c();
			approvalForm.Order_form_recordId__c = recordId;						//approvalForm.Order_Form__c = recordId;
			approvalForm.Client_Approval_Status__c = 'Declined';
			approvalForm.Comments__c = comments;
			insert approvalForm;

			if(String.isNotBlank(uploadSign)){
				ContentDocumentLink link = new ContentDocumentLink();
        		link.ContentDocumentId = uploadSign;
        		link.LinkedEntityId = recordId;
        		link.ShareType = 'V';
        		link.Visibility = 'AllUsers';
        		insert link;

				ContentDocumentLink link2 = new ContentDocumentLink();
        		link2.ContentDocumentId = uploadSign;
        		link2.LinkedEntityId = approvalForm.Id;
        		link2.ShareType = 'V';
        		link2.Visibility = 'AllUsers';
        		insert link2;
			} else {
				Blob fileBlob = EncodingUtil.base64Decode(drawnSig);
				ContentVersion contentVersion = new ContentVersion();
            	contentVersion.Title = 'ApproverSign.png';
            	contentVersion.PathOnClient = 'ApproverSign.png';
            	contentVersion.VersionData = fileBlob;
            	contentVersion.IsMajorVersion = true;
            	insert contentVersion;

            	ContentDocumentLink contentLink = new ContentDocumentLink();
            	contentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;
            	contentLink.LinkedEntityId = recordId;
            	contentLink.ShareType = 'V';
            	contentLink.Visibility = 'AllUsers';
            	insert contentLink;

				ContentDocumentLink contentLink2 = new ContentDocumentLink();
            	contentLink2.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;
            	contentLink2.LinkedEntityId = approvalForm.Id;
            	contentLink2.ShareType = 'V';
            	contentLink2.Visibility = 'AllUsers';
            	insert contentLink2;
			}
        } catch (Exception e) {
			System.debug('### Exception: ' + e.getMessage());
            throw new AuraHandledException('Error updating comments: ' + e.getMessage());
        }
    }
}