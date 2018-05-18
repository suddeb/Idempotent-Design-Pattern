@RestResource(urlMapping='/CreateCasesIdempotent/')
global class CreateCasesServiceWithIdempotent {
	@HttpPost
	global static String createCases(Integer caseUniqueId, String subject){
		Savepoint sp = Database.setSavepoint();
		Case aCase;

		try{
			sudipta__Message_Log__c	mLog 		= new sudipta__Message_Log__c();
			mLog.sudipta__Case_Unique_ID__c		= caseUniqueId;
			insert mLog;

			aCase 			= new Case();
			aCase.subject 	= subject;

			insert aCase;
		}catch(Exception e){
			Database.rollback(sp);
			MyResponse myResponse = new MyResponse(e.getMessage());
			return JSON.serialize(myResponse);
		}
		MyResponse myResponse = new MyResponse('Case Creation Completed with caseNumber: ' + aCase.Id);
		return JSON.serialize(myResponse);

	}


	public class MyResponse {
		String message;

		public MyResponse(String message){
			this.message = message;
		}
	}
}