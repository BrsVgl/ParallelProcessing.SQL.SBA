CREATE QUEUE [broker].[WorkloadServerQueue]
WITH ACTIVATION 
(
   STATUS = ON,
   PROCEDURE_NAME = broker.WorkloadServerWorker,
   MAX_QUEUE_READERS = 10,
   EXECUTE AS Owner
)