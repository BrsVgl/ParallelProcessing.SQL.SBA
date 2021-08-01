CREATE SERVICE [WorkloadClientService]
	ON QUEUE [broker].[WorkloadClientQueue]
	(
		InsertedWorkloadContract
	)
