CREATE SERVICE [WorkloadServerService]
	ON QUEUE [broker].[WorkloadServerQueue]
	(
		InsertedWorkloadContract
	)
