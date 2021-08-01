CREATE TABLE [dbo].[Workload]
(
	[Id] INT IDENTITY(1, 1) NOT NULL,
	Input nvarchar(100) NOT NULL,
	InputCreated datetime NOT NULL CONSTRAINT [DF__dbo.Workload_InputCreated] DEFAULT (GETDATE()),
	[Output] nvarchar(100) NULL,
	OutputCreated datetime NULL,
	CONSTRAINT [PK__dbo.Workload] PRIMARY KEY NONCLUSTERED (Id)
)
GO
CREATE TRIGGER [i__dbo.Workload__Enqueue] ON dbo.Workload FOR INSERT
AS
   DECLARE @ConversationHandle UNIQUEIDENTIFIER
   DECLARE @fromService SYSNAME
   DECLARE @toService SYSNAME
   DECLARE @onContract SYSNAME
   DECLARE @messageBody XML
   SET @fromService = 'WorkloadClientService'
   SET @toService = 'WorkloadServerService'
   SET @onContract = 'InsertedWorkloadContract'
   -- Check if there is already an ongoing conversation with the TargetService
   SELECT @ConversationHandle = ConversationHandle FROM broker.Conversation
      WHERE SPID = @@SPID
      AND FromService = @fromService
      AND ToService = @toService
      AND OnContract = @onContract
   IF @ConversationHandle IS NULL
   BEGIN
      -- We have to begin a new Service Broker conversation with the
      -- TargetService
      BEGIN DIALOG CONVERSATION @ConversationHandle
         FROM SERVICE @fromService
         TO SERVICE @toService
         ON CONTRACT @onContract
         WITH ENCRYPTION = OFF;
      -- Create the dialog timer for ending the ongoing conversation
      BEGIN CONVERSATION TIMER (@ConversationHandle) TIMEOUT = 10;
      -- Store the ongoing conversation for further use
      INSERT INTO broker.Conversation
      (SPID, FromService, ToService, OnContract, 
         ConversationHandle)
      VALUES
      (
         @@SPID,
         @fromService,
         @toService,
         @onContract,
         @ConversationHandle
      )
   END
   -- Construct the request message
   SET @messageBody = (SELECT * FROM INSERTED FOR XML AUTO, ELEMENTS);
   SELECT R = '[i__dbo.Workload__Enqueue]', messageBody = @messageBody;

   -- Send the message to the TargetService
   ;SEND ON CONVERSATION @ConversationHandle
   MESSAGE TYPE InsertedWorkloadMessage (@messageBody);
GO