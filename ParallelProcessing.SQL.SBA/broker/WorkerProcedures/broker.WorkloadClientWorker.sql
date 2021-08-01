CREATE PROCEDURE [broker].[WorkloadClientWorker]
AS
   DECLARE @conversationHandle UNIQUEIDENTIFIER;
   DECLARE @messageTypeName SYSNAME;
   BEGIN TRANSACTION;
   RECEIVE TOP(1) 
      @conversationHandle = conversation_handle,
      @messageTypeName = message_type_name
   FROM broker.WorkloadClientQueue
   IF @conversationHandle IS NOT NULL
   BEGIN
      DELETE FROM broker.Conversation
      WHERE ConversationHandle = @conversationHandle;
      IF @messageTypeName = 'http://schemas.microsoft.com/SQL/ServiceBroker/DialogTimer'
         SEND ON CONVERSATION @conversationHandle MESSAGE TYPE EndOfMessageStream;
      ELSE IF @messageTypeName = 
         'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
      BEGIN
         END CONVERSATION @conversationHandle;
      END
   END
   COMMIT TRANSACTION;