SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict XALprzgLbQV96o25wtwHZnXZwG1cB1vvQSF4j5IFY8ViUycuo0OsPrtWk389m3A

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: approval_workflow_templates; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: approval_workflow_steps; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: approval_step_assignees; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: contracts; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: contract_approval_workflows; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: contract_approvals; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: contract_links; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: contract_messages; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: contract_ownership_history; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: contract_participants; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: contract_permissions; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: work_execution_units; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: dispute_cases; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: dispute_evidence; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: dispute_hearings; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: dispute_resolution_actions; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: event_outbox; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: event_outbox_processed; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: execution_logs; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: permission_evaluation_log; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: permission_policies; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: policy_assignments; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: policy_conditions; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: state_machines; Type: TABLE DATA; Schema: work; Owner: postgres
--

INSERT INTO "work"."state_machines" ("id", "entity_type", "name", "description", "created_at") VALUES
	('009c48e4-0e42-4771-bc49-748302e2069e', 'contract', 'Contract Lifecycle', 'States for contracts: draft, pending_approval, active, paused, completed, cancelled, rejected, expired, disputed, archived', '2026-05-11 21:31:53.672974+00'),
	('2b940150-6bf9-4a71-b186-4293d55234a0', 'milestone', 'Milestone Lifecycle', 'States for milestones: pending, in_progress, completed, cancelled', '2026-05-11 21:31:53.672974+00'),
	('8c62ae13-c2b9-4437-9bd5-268816a7be74', 'execution_unit', 'Execution Unit Lifecycle', 'States for execution units: pending, in_progress, completed, cancelled', '2026-05-11 21:31:53.672974+00'),
	('b1bf7348-6ddf-4f64-9e3a-8d9dd8bec4ed', 'approval', 'Approval Lifecycle', 'States for approvals: pending, approved, rejected', '2026-05-11 21:31:53.672974+00');


--
-- Data for Name: state_transition_history; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: state_transition_rules; Type: TABLE DATA; Schema: work; Owner: postgres
--

INSERT INTO "work"."state_transition_rules" ("id", "entity_type", "from_state", "to_state", "condition", "action", "priority", "created_at") VALUES
	('6208d4d8-e357-4669-a828-4a4e1f732367', 'contract', 'draft', 'pending_approval', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('3e0ca318-2b04-401c-8754-1d3b8e2dd297', 'contract', 'pending_approval', 'active', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('3cad07f7-756a-40e7-bec8-cf9bde1a2978', 'contract', 'pending_approval', 'rejected', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('a8b32c62-201a-4720-a148-be97c985f2d7', 'contract', 'active', 'paused', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('5871d91f-72dd-4e67-9b4b-4a18caeb21b6', 'contract', 'active', 'completed', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('ce354248-ca76-427a-82b5-251b6d73d615', 'contract', 'paused', 'active', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('907d02cd-1dbd-4486-a344-981750c64d84', 'contract', 'active', 'cancelled', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('73c0b900-60e0-4e46-a19a-95a267ded098', 'contract', 'paused', 'cancelled', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('a341e526-85f1-4cae-a9a0-790c5ca611d4', 'contract', 'completed', 'archived', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('5535edc7-3589-4ab1-b3cb-959550d7dc0b', 'contract', 'cancelled', 'archived', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('d80b34ca-5178-4305-b244-f37dc8449ba6', 'contract', 'rejected', 'archived', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('c54e91ba-bf36-4ff7-bddf-4216bdf8a8a5', 'contract', 'expired', 'archived', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('fc80ba7c-2a3b-42c3-bee4-e75688292152', 'contract', 'disputed', 'active', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('2a4c36da-6f52-4a33-b0cd-3a2c8e66794f', 'milestone', 'pending', 'in_progress', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('a9a7822c-28b5-4007-b178-2511fd370161', 'milestone', 'in_progress', 'completed', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('1299c729-f647-4f0c-ae9d-5fb7e0cedb46', 'milestone', 'pending', 'cancelled', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('2e812a2e-a74e-4bfb-9450-1da1d5a059e6', 'execution_unit', 'pending', 'in_progress', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('3ada1305-7b3f-4778-809e-8b34b43a6c2e', 'execution_unit', 'in_progress', 'completed', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('fb884190-0b70-4418-827c-bc7121408e3a', 'execution_unit', 'pending', 'cancelled', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('240065f4-ba10-44ac-aee2-91b97acdb393', 'approval', 'pending', 'approved', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00'),
	('4b5a7a70-beac-4128-aadd-3d4304e393e8', 'approval', 'pending', 'rejected', NULL, NULL, 0, '2026-05-11 21:31:53.672974+00');


--
-- Data for Name: work_contract_versions; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: work_financial_routes; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: work_ownership_transfers; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- Data for Name: work_visibility; Type: TABLE DATA; Schema: work; Owner: postgres
--



--
-- PostgreSQL database dump complete
--

-- \unrestrict XALprzgLbQV96o25wtwHZnXZwG1cB1vvQSF4j5IFY8ViUycuo0OsPrtWk389m3A

RESET ALL;
