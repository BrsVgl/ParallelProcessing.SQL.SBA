CREATE PROCEDURE [broker].[WorkloadServerWorker]
AS
   DECLARE @conversationHandle UNIQUEIDENTIFIER;
   DECLARE @messageTypeName SYSNAME;
   DECLARE @message xml

   BEGIN TRANSACTION;
   RECEIVE TOP(1) 
      @conversationHandle = conversation_handle,
      @messageTypeName = message_type_name,
      @message = message_body
   FROM broker.WorkloadServerQueue
   IF @conversationHandle IS NOT NULL
   BEGIN
      IF @messageTypeName = 'EndOfMessageStream'
        OR @messageTypeName = N'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
        OR @messageTypeName = N'http://schemas.microsoft.com/SQL/ServiceBroker/Error'
        BEGIN
          END CONVERSATION @conversationHandle;
        END
      ELSE IF @messageTypeName = 'InsertedWorkloadMessage'
      BEGIN
        WAITFOR DELAY '00:00:01'
        ;WITH IdList AS (
          SELECT 
            Id = x.c.value('(./Id)[1]', 'int')
          FROM @message.nodes('INSERTED') x(c)
        )
        UPDATE wl 
        SET 
          [Output] = [dbo].[GenerateMd5](Input)
          , OutputCreated = GETDATE()
        FROM dbo.Workload wl
        JOIN IdList cI ON wl.Id = cI.Id
      END
   END
   COMMIT TRANSACTION;