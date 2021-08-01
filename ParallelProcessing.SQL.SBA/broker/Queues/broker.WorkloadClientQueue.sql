CREATE QUEUE [broker].[WorkloadClientQueue]
WITH ACTIVATION 
(
   STATUS = ON,
   PROCEDURE_NAME = broker.WorkloadClientWorker,
   MAX_QUEUE_READERS = 10,
   EXECUTE AS Owner
)