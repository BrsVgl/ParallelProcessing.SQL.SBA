CREATE TABLE [broker].[Conversation]
(
  SPID INT NOT NULL,
   FromService SYSNAME NOT NULL,
   ToService SYSNAME NOT NULL,
   OnContract SYSNAME NOT NULL,
   ConversationHandle UNIQUEIDENTIFIER NOT NULL,
   CONSTRAINT [PK__broker.Conversation] PRIMARY KEY NONCLUSTERED (SPID, FromService, ToService, OnContract),
   CONSTRAINT [UK__broker.Conversation__ConversationHandle] UNIQUE NONCLUSTERED (ConversationHandle)
)
