CREATE QUEUE [broker].[WorkloadServerQueue]
WITH ACTIVATION 
(
   STATUS = ON,
   PROCEDURE_NAME = broker.WorkloadServerWorker,
   MAX_QUEUE_READERS = 1,
   EXECUTE AS SELF
)