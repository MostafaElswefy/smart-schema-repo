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

\restrict XpgfpUhr2zTAn4vn1MLhiRoW5eFnnnN9shdg6BfN6kJ1z0EapSa3P4w1t3rqsBf

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
-- Name: app_rewards; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA app_rewards;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: reward_rule_versions; Type: TABLE; Schema: app_rewards; Owner: -
--

CREATE TABLE app_rewards.reward_rule_versions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_name text NOT NULL,
    version integer NOT NULL,
    reward_config jsonb NOT NULL,
    is_active boolean DEFAULT false,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    starts_at timestamp with time zone,
    expires_at timestamp with time zone,
    description text,
    title text,
    created_reason text,
    is_deleted boolean DEFAULT false NOT NULL,
    published_at timestamp with time zone,
    updated_by uuid,
    rule_name text
);


--
-- Name: reward_rule_audit_log; Type: TABLE; Schema: app_rewards; Owner: -
--

CREATE TABLE app_rewards.reward_rule_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rule_id uuid,
    event_name text NOT NULL,
    action_type text NOT NULL,
    old_version integer,
    new_version integer,
    changed_by uuid,
    changed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    old_reward_config jsonb,
    new_reward_config jsonb,
    CONSTRAINT reward_rule_audit_log_action_check CHECK ((action_type = ANY (ARRAY['create'::text, 'update'::text, 'activate'::text, 'deactivate'::text])))
);


--
-- Name: reward_transactions; Type: TABLE; Schema: app_rewards; Owner: -
--

CREATE TABLE app_rewards.reward_transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    event_name text NOT NULL,
    rule_id uuid,
    reward_type text NOT NULL,
    amount numeric,
    value text,
    status text DEFAULT 'granted'::text NOT NULL,
    idempotency_key text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    metadata jsonb
);


--
-- PostgreSQL database dump complete
--

\unrestrict XpgfpUhr2zTAn4vn1MLhiRoW5eFnnnN9shdg6BfN6kJ1z0EapSa3P4w1t3rqsBf

