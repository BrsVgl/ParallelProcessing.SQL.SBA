CREATE QUEUE [broker].[WorkloadClientQueue]
WITH ACTIVATION 
(
   STATUS = ON,
   PROCEDURE_NAME = broker.WorkloadClientWorker,
   MAX_QUEUE_READERS = 1,
   EXECUTE AS SELF
)