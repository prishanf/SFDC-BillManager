trigger PuppyImageAttchment on Attachment (after insert) {
    /*
     for(Attachment attch : trigger.new){
     	Puppy__c  puppy = [select id , Picture_Path__c from Puppy__c where id = :attch.ParentId]; 
        puppy.Picture_Path__c = '/servlet/servlet.FileDownload?file=' + attch.id;
        update puppy;
     }*/
}