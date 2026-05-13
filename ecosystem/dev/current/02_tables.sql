/*
|--------------------------------------------------------------------------
| FILE: 02_tables.sql
|--------------------------------------------------------------------------
|
| PURPOSE:
| يحتوي على جميع الجداول الأساسية داخل الـ schema.
|
| CONTENTS:
| - CREATE TABLE
| - Columns
| - Primary Keys
| - Foreign Keys
| - Constraints
|
| EXAMPLES:
| - contracts
| - contract_participants
| - execution_logs
|
| WHY IMPORTANT:
| يعتبر القلب الأساسي للبيانات داخل النظام.
|
|--------------------------------------------------------------------------
*/

--
-- PostgreSQL database dump
--

\restrict TovLEID8pZqhi7sIEUUIJ5BiWMyNEJlQtJqlfKFp1w2HKtfH7PUVQvmLSrrwYza

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
-- Name: ecosystem; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ecosystem;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: entities; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE ecosystem.entities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type text NOT NULL,
    name text NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_entity_status CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text, 'suspended'::text]))),
    CONSTRAINT chk_entity_type CHECK ((type = ANY (ARRAY['individual'::text, 'company'::text, 'group'::text, 'organization'::text])))
);


--
-- Name: entity_execution_participants; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE ecosystem.entity_execution_participants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    relationship_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    role text NOT NULL,
    share numeric(20,6),
    status text DEFAULT 'active'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    payout_model text DEFAULT 'share'::text NOT NULL
);


--
-- Name: entity_members; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE ecosystem.entity_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_id uuid NOT NULL,
    internal_user_id uuid NOT NULL,
    member_role text NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    joined_at timestamp with time zone DEFAULT now(),
    invited_by uuid,
    metadata jsonb
);


--
-- Name: entity_relations; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE ecosystem.entity_relations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    parent_entity_id uuid NOT NULL,
    child_entity_id uuid NOT NULL,
    relation_type text DEFAULT 'subcontract'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    context_type text,
    context_id uuid,
    valid_from timestamp with time zone DEFAULT now(),
    valid_until timestamp with time zone,
    created_by uuid,
    metadata jsonb,
    CONSTRAINT chk_relation_context_type CHECK (((context_type IS NULL) OR (context_type = ANY (ARRAY['escrow_case'::text, 'project'::text, 'employment'::text, 'subcontract'::text])))),
    CONSTRAINT chk_relation_type CHECK ((relation_type = ANY (ARRAY['subcontract'::text, 'parent'::text, 'member'::text, 'affiliate'::text])))
);


--
-- Name: entity_relationships; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE ecosystem.entity_relationships (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    from_entity_id uuid NOT NULL,
    to_entity_id uuid NOT NULL,
    relation_type text NOT NULL,
    context_type text,
    context_id uuid,
    status text DEFAULT 'active'::text NOT NULL,
    start_at timestamp with time zone DEFAULT now(),
    end_at timestamp with time zone,
    weight numeric,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now(),
    role text DEFAULT 'participant'::text NOT NULL,
    roles jsonb,
    scope text DEFAULT 'global'::text NOT NULL,
    visibility_scope text DEFAULT 'internal'::text NOT NULL,
    parent_relationship_id uuid,
    relationship_mode text DEFAULT 'direct'::text NOT NULL,
    execution_entity_id uuid,
    financial_entity_id uuid,
    CONSTRAINT chk_entity_relationship_scope CHECK ((scope = ANY (ARRAY['global'::text, 'organization'::text, 'project'::text, 'task'::text, 'contract'::text]))),
    CONSTRAINT chk_entity_relationship_self_reference CHECK ((from_entity_id <> to_entity_id)),
    CONSTRAINT chk_entity_relationship_type CHECK ((relation_type = ANY (ARRAY['manager'::text, 'employee'::text, 'freelancer'::text, 'subcontractor'::text, 'client'::text, 'provider'::text, 'advisor'::text, 'partner'::text, 'owner'::text, 'observer'::text]))),
    CONSTRAINT chk_entity_relationship_visibility CHECK ((visibility_scope = ANY (ARRAY['public'::text, 'internal'::text, 'restricted'::text, 'hidden_chain'::text]))),
    CONSTRAINT chk_relationship_mode CHECK ((relationship_mode = ANY (ARRAY['direct'::text, 'delegated'::text, 'transferred'::text])))
);


--
-- Name: user_entity_membership; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE ecosystem.user_entity_membership (
    user_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    role text DEFAULT 'representative'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: work_assignments; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE ecosystem.work_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    work_id uuid NOT NULL,
    assigned_from_entity_id uuid NOT NULL,
    assigned_to_entity_id uuid NOT NULL,
    role text NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: work_participants; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE ecosystem.work_participants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    escrow_case_id uuid NOT NULL,
    entity_id uuid NOT NULL,
    role text NOT NULL,
    relation_mode text DEFAULT 'direct'::text NOT NULL,
    visibility_scope text DEFAULT 'internal'::text NOT NULL,
    financial_role text,
    execution_role text,
    parent_participant_id uuid,
    status text DEFAULT 'active'::text NOT NULL,
    joined_at timestamp with time zone DEFAULT now(),
    left_at timestamp with time zone,
    metadata jsonb
);


--
-- PostgreSQL database dump complete
--

\unrestrict TovLEID8pZqhi7sIEUUIJ5BiWMyNEJlQtJqlfKFp1w2HKtfH7PUVQvmLSrrwYza

