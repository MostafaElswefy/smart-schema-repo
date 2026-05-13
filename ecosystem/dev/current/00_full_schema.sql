[
  {
    "object_type": "EXTENSION",
    "schema_name": "extensions",
    "object_name": "pg_stat_statements",
    "definition": "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;",
    "sort_order": 0
  },
  {
    "object_type": "EXTENSION",
    "schema_name": "extensions",
    "object_name": "pgcrypto",
    "definition": "CREATE EXTENSION IF NOT EXISTS pgcrypto;",
    "sort_order": 0
  },
  {
    "object_type": "EXTENSION",
    "schema_name": "extensions",
    "object_name": "uuid-ossp",
    "definition": "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";",
    "sort_order": 0
  },
  {
    "object_type": "EXTENSION",
    "schema_name": "pg_catalog",
    "object_name": "plpgsql",
    "definition": "CREATE EXTENSION IF NOT EXISTS plpgsql;",
    "sort_order": 0
  },
  {
    "object_type": "EXTENSION",
    "schema_name": "vault",
    "object_name": "supabase_vault",
    "definition": "CREATE EXTENSION IF NOT EXISTS supabase_vault;",
    "sort_order": 0
  },
  {
    "object_type": "TYPE",
    "schema_name": "ecosystem",
    "object_name": "entities",
    "definition": "CREATE TYPE ecosystem.entities AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "ecosystem",
    "object_name": "entity_execution_participants",
    "definition": "CREATE TYPE ecosystem.entity_execution_participants AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "ecosystem",
    "object_name": "entity_members",
    "definition": "CREATE TYPE ecosystem.entity_members AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "ecosystem",
    "object_name": "entity_relations",
    "definition": "CREATE TYPE ecosystem.entity_relations AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "ecosystem",
    "object_name": "entity_relationships",
    "definition": "CREATE TYPE ecosystem.entity_relationships AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "ecosystem",
    "object_name": "user_entity_membership",
    "definition": "CREATE TYPE ecosystem.user_entity_membership AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "ecosystem",
    "object_name": "work_assignments",
    "definition": "CREATE TYPE ecosystem.work_assignments AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "ecosystem",
    "object_name": "work_participants",
    "definition": "CREATE TYPE ecosystem.work_participants AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TABLE",
    "schema_name": "ecosystem",
    "object_name": "entities",
    "definition": "CREATE TABLE ecosystem.entities (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\\n    type text NOT NULL,\\n    name text NOT NULL,\\n    status text NOT NULL DEFAULT 'active'::text,\\n    metadata jsonb,\\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\\n    updated_at timestamp with time zone NOT NULL DEFAULT now()\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "ecosystem",
    "object_name": "entity_execution_participants",
    "definition": "CREATE TABLE ecosystem.entity_execution_participants (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\\n    relationship_id uuid NOT NULL,\\n    entity_id uuid NOT NULL,\\n    role text NOT NULL,\\n    share numeric(20,6),\\n    status text NOT NULL DEFAULT 'active'::text,\\n    created_at timestamp with time zone DEFAULT now(),\\n    payout_model text NOT NULL DEFAULT 'share'::text\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "ecosystem",
    "object_name": "entity_members",
    "definition": "CREATE TABLE ecosystem.entity_members (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\\n    entity_id uuid NOT NULL,\\n    internal_user_id uuid NOT NULL,\\n    member_role text NOT NULL,\\n    status text NOT NULL DEFAULT 'active'::text,\\n    joined_at timestamp with time zone DEFAULT now(),\\n    invited_by uuid,\\n    metadata jsonb\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "ecosystem",
    "object_name": "entity_relations",
    "definition": "CREATE TABLE ecosystem.entity_relations (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\\n    parent_entity_id uuid NOT NULL,\\n    child_entity_id uuid NOT NULL,\\n    relation_type text NOT NULL DEFAULT 'subcontract'::text,\\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\\n    context_type text,\\n    context_id uuid,\\n    valid_from timestamp with time zone DEFAULT now(),\\n    valid_until timestamp with time zone,\\n    created_by uuid,\\n    metadata jsonb\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "ecosystem",
    "object_name": "entity_relationships",
    "definition": "CREATE TABLE ecosystem.entity_relationships (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\\n    from_entity_id uuid NOT NULL,\\n    to_entity_id uuid NOT NULL,\\n    relation_type text NOT NULL,\\n    context_type text,\\n    context_id uuid,\\n    status text NOT NULL DEFAULT 'active'::text,\\n    start_at timestamp with time zone DEFAULT now(),\\n    end_at timestamp with time zone,\\n    weight numeric,\\n    metadata jsonb,\\n    created_at timestamp with time zone DEFAULT now(),\\n    role text NOT NULL DEFAULT 'participant'::text,\\n    roles jsonb,\\n    scope text NOT NULL DEFAULT 'global'::text,\\n    visibility_scope text NOT NULL DEFAULT 'internal'::text,\\n    parent_relationship_id uuid,\\n    relationship_mode text NOT NULL DEFAULT 'direct'::text,\\n    execution_entity_id uuid,\\n    financial_entity_id uuid\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "ecosystem",
    "object_name": "user_entity_membership",
    "definition": "CREATE TABLE ecosystem.user_entity_membership (\\n    user_id uuid NOT NULL,\\n    entity_id uuid NOT NULL,\\n    role text NOT NULL DEFAULT 'representative'::text,\\n    created_at timestamp with time zone DEFAULT now()\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "ecosystem",
    "object_name": "work_assignments",
    "definition": "CREATE TABLE ecosystem.work_assignments (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\\n    work_id uuid NOT NULL,\\n    assigned_from_entity_id uuid NOT NULL,\\n    assigned_to_entity_id uuid NOT NULL,\\n    role text NOT NULL,\\n    status text NOT NULL DEFAULT 'active'::text,\\n    start_at timestamp without time zone,\\n    end_at timestamp without time zone,\\n    created_at timestamp without time zone DEFAULT now()\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "ecosystem",
    "object_name": "work_participants",
    "definition": "CREATE TABLE ecosystem.work_participants (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\\n    escrow_case_id uuid NOT NULL,\\n    entity_id uuid NOT NULL,\\n    role text NOT NULL,\\n    relation_mode text NOT NULL DEFAULT 'direct'::text,\\n    visibility_scope text NOT NULL DEFAULT 'internal'::text,\\n    financial_role text,\\n    execution_role text,\\n    parent_participant_id uuid,\\n    status text NOT NULL DEFAULT 'active'::text,\\n    joined_at timestamp with time zone DEFAULT now(),\\n    left_at timestamp with time zone,\\n    metadata jsonb\\n);",
    "sort_order": 4
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "entities_pkey",
    "definition": "ALTER TABLE ecosystem.entities ADD CONSTRAINT entities_pkey PRIMARY KEY (id);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "entity_execution_participants_pkey",
    "definition": "ALTER TABLE ecosystem.entity_execution_participants ADD CONSTRAINT entity_execution_participants_pkey PRIMARY KEY (id);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "entity_members_pkey",
    "definition": "ALTER TABLE ecosystem.entity_members ADD CONSTRAINT entity_members_pkey PRIMARY KEY (id);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "entity_relations_pkey",
    "definition": "ALTER TABLE ecosystem.entity_relations ADD CONSTRAINT entity_relations_pkey PRIMARY KEY (id);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "entity_relationships_pkey",
    "definition": "ALTER TABLE ecosystem.entity_relationships ADD CONSTRAINT entity_relationships_pkey PRIMARY KEY (id);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "user_entity_membership_pkey",
    "definition": "ALTER TABLE ecosystem.user_entity_membership ADD CONSTRAINT user_entity_membership_pkey PRIMARY KEY (user_id, entity_id);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "work_assignments_pkey",
    "definition": "ALTER TABLE ecosystem.work_assignments ADD CONSTRAINT work_assignments_pkey PRIMARY KEY (id);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "work_participants_pkey",
    "definition": "ALTER TABLE ecosystem.work_participants ADD CONSTRAINT work_participants_pkey PRIMARY KEY (id);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "chk_entity_relationship_scope",
    "definition": "ALTER TABLE ecosystem.entity_relationships ADD CONSTRAINT chk_entity_relationship_scope CHECK ((scope = ANY (ARRAY['global'::text, 'organization'::text, 'project'::text, 'task'::text, 'contract'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "chk_entity_relationship_self_reference",
    "definition": "ALTER TABLE ecosystem.entity_relationships ADD CONSTRAINT chk_entity_relationship_self_reference CHECK ((from_entity_id <> to_entity_id));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "chk_entity_relationship_type",
    "definition": "ALTER TABLE ecosystem.entity_relationships ADD CONSTRAINT chk_entity_relationship_type CHECK ((relation_type = ANY (ARRAY['manager'::text, 'employee'::text, 'freelancer'::text, 'subcontractor'::text, 'client'::text, 'provider'::text, 'advisor'::text, 'partner'::text, 'owner'::text, 'observer'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "chk_entity_relationship_visibility",
    "definition": "ALTER TABLE ecosystem.entity_relationships ADD CONSTRAINT chk_entity_relationship_visibility CHECK ((visibility_scope = ANY (ARRAY['public'::text, 'internal'::text, 'restricted'::text, 'hidden_chain'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "chk_entity_status",
    "definition": "ALTER TABLE ecosystem.entities ADD CONSTRAINT chk_entity_status CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text, 'suspended'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "chk_entity_type",
    "definition": "ALTER TABLE ecosystem.entities ADD CONSTRAINT chk_entity_type CHECK ((type = ANY (ARRAY['individual'::text, 'company'::text, 'group'::text, 'organization'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "chk_relation_context_type",
    "definition": "ALTER TABLE ecosystem.entity_relations ADD CONSTRAINT chk_relation_context_type CHECK (((context_type IS NULL) OR (context_type = ANY (ARRAY['escrow_case'::text, 'project'::text, 'employment'::text, 'subcontract'::text]))));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "chk_relation_type",
    "definition": "ALTER TABLE ecosystem.entity_relations ADD CONSTRAINT chk_relation_type CHECK ((relation_type = ANY (ARRAY['subcontract'::text, 'parent'::text, 'member'::text, 'affiliate'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "chk_relationship_mode",
    "definition": "ALTER TABLE ecosystem.entity_relationships ADD CONSTRAINT chk_relationship_mode CHECK ((relationship_mode = ANY (ARRAY['direct'::text, 'delegated'::text, 'transferred'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "entity_relations_created_by_fkey",
    "definition": "ALTER TABLE ecosystem.entity_relations ADD CONSTRAINT entity_relations_created_by_fkey FOREIGN KEY (created_by) REFERENCES user_identity_root(internal_user_id) ON DELETE SET NULL;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "fk_child_entity",
    "definition": "ALTER TABLE ecosystem.entity_relations ADD CONSTRAINT fk_child_entity FOREIGN KEY (child_entity_id) REFERENCES ecosystem.entities(id) ON DELETE RESTRICT;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "fk_entity_members_entity",
    "definition": "ALTER TABLE ecosystem.entity_members ADD CONSTRAINT fk_entity_members_entity FOREIGN KEY (entity_id) REFERENCES ecosystem.entities(id) ON DELETE CASCADE;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "fk_entity_members_user",
    "definition": "ALTER TABLE ecosystem.entity_members ADD CONSTRAINT fk_entity_members_user FOREIGN KEY (internal_user_id) REFERENCES user_identity_root(internal_user_id) ON DELETE CASCADE;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "fk_entity_relationship_parent",
    "definition": "ALTER TABLE ecosystem.entity_relationships ADD CONSTRAINT fk_entity_relationship_parent FOREIGN KEY (parent_relationship_id) REFERENCES ecosystem.entity_relationships(id) ON DELETE SET NULL;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "fk_exec_entity",
    "definition": "ALTER TABLE ecosystem.entity_execution_participants ADD CONSTRAINT fk_exec_entity FOREIGN KEY (entity_id) REFERENCES ecosystem.entities(id) ON DELETE CASCADE;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "fk_exec_rel",
    "definition": "ALTER TABLE ecosystem.entity_execution_participants ADD CONSTRAINT fk_exec_rel FOREIGN KEY (relationship_id) REFERENCES ecosystem.entity_relationships(id) ON DELETE CASCADE;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "fk_parent_entity",
    "definition": "ALTER TABLE ecosystem.entity_relations ADD CONSTRAINT fk_parent_entity FOREIGN KEY (parent_entity_id) REFERENCES ecosystem.entities(id) ON DELETE RESTRICT;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "user_entity_membership_entity_id_fkey",
    "definition": "ALTER TABLE ecosystem.user_entity_membership ADD CONSTRAINT user_entity_membership_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES ecosystem.entities(id) ON DELETE CASCADE;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "ecosystem",
    "object_name": "user_entity_membership_user_id_fkey",
    "definition": "ALTER TABLE ecosystem.user_entity_membership ADD CONSTRAINT user_entity_membership_user_id_fkey FOREIGN KEY (user_id) REFERENCES user_identity_root(internal_user_id) ON DELETE CASCADE;",
    "sort_order": 8
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "ecosystem",
    "object_name": "entities",
    "definition": "ALTER TABLE ecosystem.entities OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "ecosystem",
    "object_name": "entity_execution_participants",
    "definition": "ALTER TABLE ecosystem.entity_execution_participants OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "ecosystem",
    "object_name": "entity_members",
    "definition": "ALTER TABLE ecosystem.entity_members OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "ecosystem",
    "object_name": "entity_relations",
    "definition": "ALTER TABLE ecosystem.entity_relations OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "ecosystem",
    "object_name": "entity_relationships",
    "definition": "ALTER TABLE ecosystem.entity_relationships OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "ecosystem",
    "object_name": "user_entity_membership",
    "definition": "ALTER TABLE ecosystem.user_entity_membership OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "ecosystem",
    "object_name": "work_assignments",
    "definition": "ALTER TABLE ecosystem.work_assignments OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "ecosystem",
    "object_name": "work_participants",
    "definition": "ALTER TABLE ecosystem.work_participants OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "RLS",
    "schema_name": "ecosystem",
    "object_name": "entities",
    "definition": "ALTER TABLE ecosystem.entities ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "ecosystem",
    "object_name": "entity_execution_participants",
    "definition": "ALTER TABLE ecosystem.entity_execution_participants ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "ecosystem",
    "object_name": "entity_members",
    "definition": "ALTER TABLE ecosystem.entity_members ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "ecosystem",
    "object_name": "entity_relations",
    "definition": "ALTER TABLE ecosystem.entity_relations ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "ecosystem",
    "object_name": "entity_relationships",
    "definition": "ALTER TABLE ecosystem.entity_relationships ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "ecosystem",
    "object_name": "user_entity_membership",
    "definition": "ALTER TABLE ecosystem.user_entity_membership ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "ecosystem",
    "object_name": "work_assignments",
    "definition": "ALTER TABLE ecosystem.work_assignments ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "ecosystem",
    "object_name": "work_participants",
    "definition": "ALTER TABLE ecosystem.work_participants ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  }
]