--
-- PostgreSQL database dump
--

\restrict 7UiD1prxjkthmM8CGZLx2TRP9sygMVBdet0NfmJ7zv2I0LZAdapHW56xQWkKk5L

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
-- Name: work; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA work;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: contract_approvals; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.contract_approvals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    requested_by_entity_id uuid NOT NULL,
    requested_from_entity_id uuid NOT NULL,
    approval_type text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    approved_at timestamp with time zone,
    rejected_at timestamp with time zone,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: contract_links; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.contract_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    parent_contract_id uuid NOT NULL,
    child_contract_id uuid NOT NULL,
    link_type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: contract_messages; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.contract_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    sender_entity_id uuid NOT NULL,
    message_type text DEFAULT 'text'::text NOT NULL,
    body text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: contract_milestones; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.contract_milestones (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    title text NOT NULL,
    description text,
    amount numeric(20,6),
    due_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    completed_at timestamp with time zone,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: contract_participants; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.contract_participants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    role text NOT NULL,
    participation_mode text DEFAULT 'direct'::text NOT NULL,
    visibility_scope text DEFAULT 'internal'::text NOT NULL,
    financial_role text,
    execution_role text,
    parent_participant_id uuid,
    allocation_percent numeric(5,2),
    status text DEFAULT 'active'::text NOT NULL,
    joined_at timestamp with time zone DEFAULT now() NOT NULL,
    left_at timestamp with time zone,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: contract_permissions; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.contract_permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    permission text NOT NULL,
    granted_by_entity_id uuid,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: contracts; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.contracts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    task_id uuid,
    title text NOT NULL,
    description text,
    status text DEFAULT 'draft'::text NOT NULL,
    asset_code text NOT NULL,
    total_amount numeric(20,6) DEFAULT 0 NOT NULL,
    current_version_no integer DEFAULT 1 NOT NULL,
    created_by_entity_id uuid NOT NULL,
    owned_by_entity_id uuid NOT NULL,
    visibility_mode text DEFAULT 'restricted'::text NOT NULL,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    cancelled_at timestamp with time zone,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: execution_logs; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.execution_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    action_type text NOT NULL,
    action_data jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: work_assignments; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.work_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    assigned_by_entity_id uuid NOT NULL,
    assigned_to_entity_id uuid NOT NULL,
    parent_assignment_id uuid,
    assignment_type text NOT NULL,
    title text,
    description text,
    allocated_amount numeric(20,6),
    execution_percent numeric(5,2),
    status text DEFAULT 'active'::text NOT NULL,
    start_at timestamp with time zone,
    end_at timestamp with time zone,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: work_contract_versions; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.work_contract_versions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    version_no integer NOT NULL,
    snapshot jsonb NOT NULL,
    created_by_entity_id uuid,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: work_execution_units; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.work_execution_units (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    parent_unit_id uuid,
    title text NOT NULL,
    description text,
    assigned_entity_id uuid,
    status text DEFAULT 'pending'::text NOT NULL,
    progress_percent numeric(5,2) DEFAULT 0 NOT NULL,
    allocated_amount numeric(20,6),
    start_at timestamp with time zone,
    completed_at timestamp with time zone,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: work_financial_routes; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.work_financial_routes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    payer_entity_id uuid NOT NULL,
    payee_entity_id uuid NOT NULL,
    beneficiary_type text NOT NULL,
    amount numeric(20,6),
    percentage numeric(10,4),
    priority integer DEFAULT 0 NOT NULL,
    is_hidden boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: work_ownership_transfers; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.work_ownership_transfers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    from_entity_id uuid NOT NULL,
    to_entity_id uuid NOT NULL,
    transfer_type text NOT NULL,
    transfer_scope text DEFAULT 'full'::text NOT NULL,
    notes text,
    effective_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: work_visibility; Type: TABLE; Schema: work; Owner: -
--

CREATE TABLE work.work_visibility (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_id uuid NOT NULL,
    viewer_entity_id uuid NOT NULL,
    visible_entity_id uuid NOT NULL,
    visibility_type text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    metadata jsonb
);


--
-- PostgreSQL database dump complete
--

\unrestrict 7UiD1prxjkthmM8CGZLx2TRP9sygMVBdet0NfmJ7zv2I0LZAdapHW56xQWkKk5L

