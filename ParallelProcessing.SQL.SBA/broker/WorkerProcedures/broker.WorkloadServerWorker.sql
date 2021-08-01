CREATE PROCEDURE [broker].[WorkloadServerWorker]
AS
   DECLARE @conversationHandle UNIQUEIDENTIFIER;
   DECLARE @messageTypeName SYSNAME;
   DECLARE @message nvarchar(max)
   BEGIN TRANSACTION;
   RECEIVE TOP(1) 
      @conversationHandle = conversation_handle,
      @messageTypeName = message_type_name,
      @message = message_body
   FROM broker.WorkloadServerQueue
   IF @conversationHandle IS NOT NULL
   BEGIN
      --DELETE FROM broker.Conversation
      --WHERE ConversationHandle = @conversationHandle;
      IF @messageTypeName = EndOfMessageStream
         END CONVERSATION @conversationHandle;
      ELSE IF @messageTypeName = InsertedWorkloadMessage
      BEGIN
         SELECT @message
      END
   END
   COMMIT TRANSACTION;