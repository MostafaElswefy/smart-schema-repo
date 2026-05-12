--
-- PostgreSQL database dump
--

\restrict yOjW3AVw7b0L7tlmYv7TK9zdxW2W41z9eKhgJyDWhQlLooXHZ7A4Dhw3sosNgfZ

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.3

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
-- Data for Name: contract_approvals; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.contract_approvals (id, contract_id, requested_by_entity_id, requested_from_entity_id, approval_type, status, approved_at, rejected_at, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: contract_links; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.contract_links (id, parent_contract_id, child_contract_id, link_type, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: contract_messages; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.contract_messages (id, contract_id, sender_entity_id, message_type, body, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: contract_milestones; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.contract_milestones (id, contract_id, title, description, amount, due_at, status, completed_at, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: contracts; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.contracts (id, project_id, task_id, title, description, status, asset_code, total_amount, current_version_no, created_by_entity_id, owned_by_entity_id, visibility_mode, started_at, completed_at, cancelled_at, metadata, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: contract_participants; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.contract_participants (id, contract_id, entity_id, role, participation_mode, visibility_scope, financial_role, execution_role, parent_participant_id, allocation_percent, status, joined_at, left_at, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: contract_permissions; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.contract_permissions (id, contract_id, entity_id, permission, granted_by_entity_id, created_at) FROM stdin;
\.


--
-- Data for Name: execution_logs; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.execution_logs (id, contract_id, entity_id, action_type, action_data, created_at) FROM stdin;
\.


--
-- Data for Name: work_assignments; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.work_assignments (id, contract_id, assigned_by_entity_id, assigned_to_entity_id, parent_assignment_id, assignment_type, title, description, allocated_amount, execution_percent, status, start_at, end_at, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: work_contract_versions; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.work_contract_versions (id, contract_id, version_no, snapshot, created_by_entity_id, created_at) FROM stdin;
\.


--
-- Data for Name: work_execution_units; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.work_execution_units (id, contract_id, parent_unit_id, title, description, assigned_entity_id, status, progress_percent, allocated_amount, start_at, completed_at, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: work_financial_routes; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.work_financial_routes (id, contract_id, payer_entity_id, payee_entity_id, beneficiary_type, amount, percentage, priority, is_hidden, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: work_ownership_transfers; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.work_ownership_transfers (id, contract_id, from_entity_id, to_entity_id, transfer_type, transfer_scope, notes, effective_at, created_at) FROM stdin;
\.


--
-- Data for Name: work_visibility; Type: TABLE DATA; Schema: work; Owner: -
--

COPY work.work_visibility (id, contract_id, viewer_entity_id, visible_entity_id, visibility_type, created_at, metadata) FROM stdin;
\.


--
-- PostgreSQL database dump complete
--

\unrestrict yOjW3AVw7b0L7tlmYv7TK9zdxW2W41z9eKhgJyDWhQlLooXHZ7A4Dhw3sosNgfZ

