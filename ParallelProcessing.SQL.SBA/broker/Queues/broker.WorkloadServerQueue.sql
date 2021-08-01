CREATE QUEUE [broker].[WorkloadServerQueue]
WITH ACTIVATION 
(
   STATUS = OFF,
   PROCEDURE_NAME = broker.WorkloadServerWorker,
   MAX_QUEUE_READERS = 1,
   EXECUTE AS SELF
)