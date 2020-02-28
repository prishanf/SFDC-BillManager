public class SObjectMetaUtil {

    
    public static void createObject(MetadataService.CustomObject newObject)
	{
		MetadataService.MetadataPort service = createService();
		MetadataService.CustomObject customObject = new MetadataService.CustomObject();
		List<MetadataService.SaveResult> results = 		
			service.createMetadata(
				new MetadataService.Metadata[] { customObject });		
		handleSaveResults(results[0]);
        
	}
    
    
    
    private static MetadataService.MetadataPort createService()
	{ 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;		
	}
    
    /**
	 * Example helper method to interpret a SaveResult, throws an exception if errors are found
	 **/
	private static void handleSaveResults(MetadataService.SaveResult saveResult)
	{
		if(saveResult==null || saveResult.success)
			return;
		if(saveResult.errors!=null) 
		{
			List<String> messages = new List<String>();
			messages.add(
				(saveResult.errors.size()==1 ? 'Error ' : 'Errors ') +'occured processing component ' + saveResult.fullName + '.');
			for(MetadataService.Error error : saveResult.errors)
				messages.add(
					error.message + ' (' + error.statusCode + ').' + 
					( error.fields!=null && error.fields.size()>0 ? 
						' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
			if(messages.size()>0)
				throw new MetadataServiceExamplesException(String.join(messages, ' '));
		}
		if(!saveResult.success)
			throw new MetadataServiceExamplesException('Request failed with no specified error.');
	}
    
    public class MetadataServiceExamplesException extends Exception { }
}