CREATE PROCEDURE [broker].[WorkloadServerWorker]
AS
   DECLARE @conversationHandle UNIQUEIDENTIFIER;
   DECLARE @messageTypeName SYSNAME;
   DECLARE @message xml

   WAITFOR DELAY '00:00:05'

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
      IF @messageTypeName = 'EndOfMessageStream'
         END CONVERSATION @conversationHandle;
      ELSE IF @messageTypeName = 'InsertedWorkloadMessage'
      BEGIN
        ;WITH IdList AS (
          SELECT 
            Id = x.c.value('(./Id)[1]', 'int')
          FROM @message.nodes('INSERTED') x(c)
        )
        UPDATE wl 
        SET 
          [Output] = Input 
          , OutputCreated = GETDATE()
        FROM dbo.Workload wl
        JOIN IdList cI ON wl.Id = cI.Id
      END
   END
   COMMIT TRANSACTION;