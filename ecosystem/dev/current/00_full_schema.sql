--
-- PostgreSQL database dump
--

\restrict jgfvaghagto6PlT2kQKgrEMH7K0eRZhA32wbP5qtqd65H20iDjEyTAAuekgaPqp

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-13 17:12:27

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
-- TOC entry 42 (class 2615 OID 17812)
-- Name: ecosystem; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA "ecosystem";


SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 356 (class 1259 OID 18165)
-- Name: entities; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE "ecosystem"."entities" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "type" "text" NOT NULL,
    "name" "text" NOT NULL,
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "metadata" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_entity_status" CHECK (("status" = ANY (ARRAY['active'::"text", 'inactive'::"text", 'suspended'::"text"]))),
    CONSTRAINT "chk_entity_type" CHECK (("type" = ANY (ARRAY['individual'::"text", 'company'::"text", 'group'::"text", 'organization'::"text"])))
);


--
-- TOC entry 357 (class 1259 OID 18174)
-- Name: entity_execution_participants; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE "ecosystem"."entity_execution_participants" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "relationship_id" "uuid" NOT NULL,
    "entity_id" "uuid" NOT NULL,
    "role" "text" NOT NULL,
    "share" numeric(20,6),
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "payout_model" "text" DEFAULT 'share'::"text" NOT NULL
);


--
-- TOC entry 358 (class 1259 OID 18183)
-- Name: entity_members; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE "ecosystem"."entity_members" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "entity_id" "uuid" NOT NULL,
    "internal_user_id" "uuid" NOT NULL,
    "member_role" "text" NOT NULL,
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "joined_at" timestamp with time zone DEFAULT "now"(),
    "invited_by" "uuid",
    "metadata" "jsonb"
);


--
-- TOC entry 359 (class 1259 OID 18191)
-- Name: entity_relations; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE "ecosystem"."entity_relations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "parent_entity_id" "uuid" NOT NULL,
    "child_entity_id" "uuid" NOT NULL,
    "relation_type" "text" DEFAULT 'subcontract'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "context_type" "text",
    "context_id" "uuid",
    "valid_from" timestamp with time zone DEFAULT "now"(),
    "valid_until" timestamp with time zone,
    "created_by" "uuid",
    "metadata" "jsonb",
    CONSTRAINT "chk_relation_context_type" CHECK ((("context_type" IS NULL) OR ("context_type" = ANY (ARRAY['escrow_case'::"text", 'project'::"text", 'employment'::"text", 'subcontract'::"text"])))),
    CONSTRAINT "chk_relation_type" CHECK (("relation_type" = ANY (ARRAY['subcontract'::"text", 'parent'::"text", 'member'::"text", 'affiliate'::"text"])))
);


--
-- TOC entry 360 (class 1259 OID 18200)
-- Name: entity_relationships; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE "ecosystem"."entity_relationships" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "from_entity_id" "uuid" NOT NULL,
    "to_entity_id" "uuid" NOT NULL,
    "relation_type" "text" NOT NULL,
    "context_type" "text",
    "context_id" "uuid",
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "start_at" timestamp with time zone DEFAULT "now"(),
    "end_at" timestamp with time zone,
    "weight" numeric,
    "metadata" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "role" "text" DEFAULT 'participant'::"text" NOT NULL,
    "roles" "jsonb",
    "scope" "text" DEFAULT 'global'::"text" NOT NULL,
    "visibility_scope" "text" DEFAULT 'internal'::"text" NOT NULL,
    "parent_relationship_id" "uuid",
    "relationship_mode" "text" DEFAULT 'direct'::"text" NOT NULL,
    "execution_entity_id" "uuid",
    "financial_entity_id" "uuid",
    CONSTRAINT "chk_entity_relationship_scope" CHECK (("scope" = ANY (ARRAY['global'::"text", 'organization'::"text", 'project'::"text", 'task'::"text", 'contract'::"text"]))),
    CONSTRAINT "chk_entity_relationship_self_reference" CHECK (("from_entity_id" <> "to_entity_id")),
    CONSTRAINT "chk_entity_relationship_type" CHECK (("relation_type" = ANY (ARRAY['manager'::"text", 'employee'::"text", 'freelancer'::"text", 'subcontractor'::"text", 'client'::"text", 'provider'::"text", 'advisor'::"text", 'partner'::"text", 'owner'::"text", 'observer'::"text"]))),
    CONSTRAINT "chk_entity_relationship_visibility" CHECK (("visibility_scope" = ANY (ARRAY['public'::"text", 'internal'::"text", 'restricted'::"text", 'hidden_chain'::"text"]))),
    CONSTRAINT "chk_relationship_mode" CHECK (("relationship_mode" = ANY (ARRAY['direct'::"text", 'delegated'::"text", 'transferred'::"text"])))
);


--
-- TOC entry 361 (class 1259 OID 18213)
-- Name: user_entity_membership; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE "ecosystem"."user_entity_membership" (
    "user_id" "uuid" NOT NULL,
    "entity_id" "uuid" NOT NULL,
    "role" "text" DEFAULT 'representative'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


--
-- TOC entry 362 (class 1259 OID 18220)
-- Name: work_assignments; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE "ecosystem"."work_assignments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "work_id" "uuid" NOT NULL,
    "assigned_from_entity_id" "uuid" NOT NULL,
    "assigned_to_entity_id" "uuid" NOT NULL,
    "role" "text" NOT NULL,
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "start_at" timestamp without time zone,
    "end_at" timestamp without time zone,
    "created_at" timestamp without time zone DEFAULT "now"()
);


--
-- TOC entry 363 (class 1259 OID 18228)
-- Name: work_participants; Type: TABLE; Schema: ecosystem; Owner: -
--

CREATE TABLE "ecosystem"."work_participants" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "escrow_case_id" "uuid" NOT NULL,
    "entity_id" "uuid" NOT NULL,
    "role" "text" NOT NULL,
    "relation_mode" "text" DEFAULT 'direct'::"text" NOT NULL,
    "visibility_scope" "text" DEFAULT 'internal'::"text" NOT NULL,
    "financial_role" "text",
    "execution_role" "text",
    "parent_participant_id" "uuid",
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "joined_at" timestamp with time zone DEFAULT "now"(),
    "left_at" timestamp with time zone,
    "metadata" "jsonb"
);


--
-- TOC entry 3959 (class 2606 OID 18585)
-- Name: entities entities_pkey; Type: CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entities"
    ADD CONSTRAINT "entities_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3963 (class 2606 OID 18586)
-- Name: entity_execution_participants entity_execution_participants_pkey; Type: CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_execution_participants"
    ADD CONSTRAINT "entity_execution_participants_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3965 (class 2606 OID 18587)
-- Name: entity_members entity_members_pkey; Type: CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_members"
    ADD CONSTRAINT "entity_members_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3967 (class 2606 OID 18588)
-- Name: entity_relations entity_relations_pkey; Type: CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_relations"
    ADD CONSTRAINT "entity_relations_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3974 (class 2606 OID 18589)
-- Name: entity_relationships entity_relationships_pkey; Type: CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_relationships"
    ADD CONSTRAINT "entity_relationships_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3976 (class 2606 OID 18590)
-- Name: user_entity_membership user_entity_membership_pkey; Type: CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."user_entity_membership"
    ADD CONSTRAINT "user_entity_membership_pkey" PRIMARY KEY ("user_id", "entity_id");


--
-- TOC entry 3978 (class 2606 OID 18591)
-- Name: work_assignments work_assignments_pkey; Type: CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."work_assignments"
    ADD CONSTRAINT "work_assignments_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3980 (class 2606 OID 18592)
-- Name: work_participants work_participants_pkey; Type: CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."work_participants"
    ADD CONSTRAINT "work_participants_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3960 (class 1259 OID 18515)
-- Name: idx_entities_status; Type: INDEX; Schema: ecosystem; Owner: -
--

CREATE INDEX "idx_entities_status" ON "ecosystem"."entities" USING "btree" ("status");


--
-- TOC entry 3961 (class 1259 OID 18516)
-- Name: idx_entities_type; Type: INDEX; Schema: ecosystem; Owner: -
--

CREATE INDEX "idx_entities_type" ON "ecosystem"."entities" USING "btree" ("type");


--
-- TOC entry 3968 (class 1259 OID 18517)
-- Name: idx_entity_relations_child; Type: INDEX; Schema: ecosystem; Owner: -
--

CREATE INDEX "idx_entity_relations_child" ON "ecosystem"."entity_relations" USING "btree" ("child_entity_id");


--
-- TOC entry 3969 (class 1259 OID 18518)
-- Name: idx_entity_relations_context; Type: INDEX; Schema: ecosystem; Owner: -
--

CREATE INDEX "idx_entity_relations_context" ON "ecosystem"."entity_relations" USING "btree" ("context_type", "context_id");


--
-- TOC entry 3970 (class 1259 OID 18519)
-- Name: idx_entity_relations_parent; Type: INDEX; Schema: ecosystem; Owner: -
--

CREATE INDEX "idx_entity_relations_parent" ON "ecosystem"."entity_relations" USING "btree" ("parent_entity_id");


--
-- TOC entry 3971 (class 1259 OID 18520)
-- Name: idx_entity_relations_parent_type; Type: INDEX; Schema: ecosystem; Owner: -
--

CREATE INDEX "idx_entity_relations_parent_type" ON "ecosystem"."entity_relations" USING "btree" ("parent_entity_id", "relation_type");


--
-- TOC entry 3972 (class 1259 OID 18521)
-- Name: idx_entity_relations_validity; Type: INDEX; Schema: ecosystem; Owner: -
--

CREATE INDEX "idx_entity_relations_validity" ON "ecosystem"."entity_relations" USING "btree" ("valid_from", "valid_until");


--
-- TOC entry 3985 (class 2606 OID 18907)
-- Name: entity_relations entity_relations_created_by_fkey; Type: FK CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_relations"
    ADD CONSTRAINT "entity_relations_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."user_identity_root"("internal_user_id") ON DELETE SET NULL;


--
-- TOC entry 3986 (class 2606 OID 18912)
-- Name: entity_relations fk_child_entity; Type: FK CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_relations"
    ADD CONSTRAINT "fk_child_entity" FOREIGN KEY ("child_entity_id") REFERENCES "ecosystem"."entities"("id") ON DELETE RESTRICT;


--
-- TOC entry 3983 (class 2606 OID 18895)
-- Name: entity_members fk_entity_members_entity; Type: FK CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_members"
    ADD CONSTRAINT "fk_entity_members_entity" FOREIGN KEY ("entity_id") REFERENCES "ecosystem"."entities"("id") ON DELETE CASCADE;


--
-- TOC entry 3984 (class 2606 OID 18900)
-- Name: entity_members fk_entity_members_user; Type: FK CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_members"
    ADD CONSTRAINT "fk_entity_members_user" FOREIGN KEY ("internal_user_id") REFERENCES "public"."user_identity_root"("internal_user_id") ON DELETE CASCADE;


--
-- TOC entry 3988 (class 2606 OID 18927)
-- Name: entity_relationships fk_entity_relationship_parent; Type: FK CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_relationships"
    ADD CONSTRAINT "fk_entity_relationship_parent" FOREIGN KEY ("parent_relationship_id") REFERENCES "ecosystem"."entity_relationships"("id") ON DELETE SET NULL;


--
-- TOC entry 3981 (class 2606 OID 18885)
-- Name: entity_execution_participants fk_exec_entity; Type: FK CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_execution_participants"
    ADD CONSTRAINT "fk_exec_entity" FOREIGN KEY ("entity_id") REFERENCES "ecosystem"."entities"("id") ON DELETE CASCADE;


--
-- TOC entry 3982 (class 2606 OID 18890)
-- Name: entity_execution_participants fk_exec_rel; Type: FK CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_execution_participants"
    ADD CONSTRAINT "fk_exec_rel" FOREIGN KEY ("relationship_id") REFERENCES "ecosystem"."entity_relationships"("id") ON DELETE CASCADE;


--
-- TOC entry 3987 (class 2606 OID 18917)
-- Name: entity_relations fk_parent_entity; Type: FK CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."entity_relations"
    ADD CONSTRAINT "fk_parent_entity" FOREIGN KEY ("parent_entity_id") REFERENCES "ecosystem"."entities"("id") ON DELETE RESTRICT;


--
-- TOC entry 3989 (class 2606 OID 18932)
-- Name: user_entity_membership user_entity_membership_entity_id_fkey; Type: FK CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."user_entity_membership"
    ADD CONSTRAINT "user_entity_membership_entity_id_fkey" FOREIGN KEY ("entity_id") REFERENCES "ecosystem"."entities"("id") ON DELETE CASCADE;


--
-- TOC entry 3990 (class 2606 OID 18937)
-- Name: user_entity_membership user_entity_membership_user_id_fkey; Type: FK CONSTRAINT; Schema: ecosystem; Owner: -
--

ALTER TABLE ONLY "ecosystem"."user_entity_membership"
    ADD CONSTRAINT "user_entity_membership_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user_identity_root"("internal_user_id") ON DELETE CASCADE;


--
-- TOC entry 4140 (class 0 OID 18165)
-- Dependencies: 356
-- Name: entities; Type: ROW SECURITY; Schema: ecosystem; Owner: -
--

ALTER TABLE "ecosystem"."entities" ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4141 (class 0 OID 18174)
-- Dependencies: 357
-- Name: entity_execution_participants; Type: ROW SECURITY; Schema: ecosystem; Owner: -
--

ALTER TABLE "ecosystem"."entity_execution_participants" ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4142 (class 0 OID 18183)
-- Dependencies: 358
-- Name: entity_members; Type: ROW SECURITY; Schema: ecosystem; Owner: -
--

ALTER TABLE "ecosystem"."entity_members" ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4143 (class 0 OID 18191)
-- Dependencies: 359
-- Name: entity_relations; Type: ROW SECURITY; Schema: ecosystem; Owner: -
--

ALTER TABLE "ecosystem"."entity_relations" ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4144 (class 0 OID 18200)
-- Dependencies: 360
-- Name: entity_relationships; Type: ROW SECURITY; Schema: ecosystem; Owner: -
--

ALTER TABLE "ecosystem"."entity_relationships" ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4145 (class 0 OID 18213)
-- Dependencies: 361
-- Name: user_entity_membership; Type: ROW SECURITY; Schema: ecosystem; Owner: -
--

ALTER TABLE "ecosystem"."user_entity_membership" ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4146 (class 0 OID 18220)
-- Dependencies: 362
-- Name: work_assignments; Type: ROW SECURITY; Schema: ecosystem; Owner: -
--

ALTER TABLE "ecosystem"."work_assignments" ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4147 (class 0 OID 18228)
-- Dependencies: 363
-- Name: work_participants; Type: ROW SECURITY; Schema: ecosystem; Owner: -
--

ALTER TABLE "ecosystem"."work_participants" ENABLE ROW LEVEL SECURITY;

-- Completed on 2026-05-13 17:12:27

--
-- PostgreSQL database dump complete
--

\unrestrict jgfvaghagto6PlT2kQKgrEMH7K0eRZhA32wbP5qtqd65H20iDjEyTAAuekgaPqp

