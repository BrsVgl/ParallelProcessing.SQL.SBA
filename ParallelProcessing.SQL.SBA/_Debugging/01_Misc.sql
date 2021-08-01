USE [ParallelProcessing.SQL.SBA]
GO
DELETE broker.Conversation

INSERT dbo.Workload (Input)
	SELECT '123'
	UNION SELECT 'abc'

SELECT * FROM sys.conversation_endpoints
SELECT R = 'broker.Conversation', * FROM broker.Conversation
SELECT R = 'dbo.Workload', * FROM dbo.Workload

SELECT R = '[broker].[WorkloadClientQueue]', * FROM [broker].[WorkloadClientQueue]
SELECT R = '[broker].[WorkloadServerQueue]', * FROM [broker].[WorkloadServerQueue]

SELECT * FROM sys.service_contract_message_usages 
SELECT * FROM sys.service_contract_usages
SELECT * FROM sys.service_queue_usages 

-- Message Types
SELECT *
FROM sys.service_message_types;
-- Contracts
SELECT *
FROM sys.service_contracts;

-- Queues
SELECT *
FROM sys.service_queues;

-- Services
SELECT *
FROM sys.services;

-- Endpoints
SELECT *
FROM sys.endpoints;