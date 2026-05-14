[
  {
    "object_type": "schema_metadata",
    "sort_order": 0,
    "data": {
      "schema": "app_rewards",
      "version": "1.0.0",
      "exported_at": "2026-05-14T07:25:28.220274+00:00",
      "module_name": "rewards_engine",
      "business_purpose": "Reward management and processing"
    }
  },
  {
    "object_type": "enums",
    "sort_order": 1,
    "data": null
  },
  {
    "object_type": "tables",
    "sort_order": 2,
    "data": [
      {
        "name": "allowed_reward_types",
        "schema": "app_rewards",
        "columns": [
          {
            "name": "reward_type",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "description",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "is_active",
            "type": "boolean",
            "default": "true",
            "nullable": true,
            "is_identity": false
          }
        ],
        "indexes": null,
        "raw_sql": "CREATE TABLE app_rewards.allowed_reward_types (\\n    reward_type text NOT NULL,\n    description text,\n    is_active boolean DEFAULT true,\n    CONSTRAINT allowed_reward_types_pkey PRIMARY KEY (reward_type)\\n);",
        "primary_key": [
          "reward_type"
        ],
        "foreign_keys": null,
        "business_purpose": null,
        "check_constraints": null,
        "unique_constraints": null
      },
      {
        "name": "processing_log",
        "schema": "app_rewards",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "event_id",
            "type": "uuid",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "step",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "status",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "details",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "error_message",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "trace_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_processing_log_event",
            "unique": false,
            "definition": "CREATE INDEX idx_processing_log_event ON app_rewards.processing_log USING btree (event_id, created_at)"
          },
          {
            "name": "idx_processing_log_trace",
            "unique": false,
            "definition": "CREATE INDEX idx_processing_log_trace ON app_rewards.processing_log USING btree (trace_id)"
          }
        ],
        "raw_sql": "CREATE TABLE app_rewards.processing_log (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    event_id uuid NOT NULL,\n    step text NOT NULL,\n    status text NOT NULL,\n    details jsonb,\n    error_message text,\n    trace_id uuid,\n    created_at timestamp with time zone DEFAULT now(),\n    CONSTRAINT processing_log_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "processing_log_event_id_fkey",
            "columns": [
              "event_id"
            ],
            "on_delete": "CASCADE",
            "on_update": "",
            "ref_table": "reward_events",
            "ref_schema": "app_rewards",
            "ref_columns": [
              "id"
            ]
          }
        ],
        "business_purpose": null,
        "check_constraints": null,
        "unique_constraints": null
      },
      {
        "name": "reward_events",
        "schema": "app_rewards",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "internal_user_id",
            "type": "uuid",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "payload",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "metadata",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "status",
            "type": "text",
            "default": "'pending'::text",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "retry_count",
            "type": "integer",
            "default": "0",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "last_error",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "completed_at",
            "type": "timestamp with time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "next_retry_at",
            "type": "timestamp with time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "max_retries",
            "type": "integer",
            "default": "3",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "event_id",
            "type": "uuid",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "dead_letter_reason",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "dead_letter_category",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "processing_started_at",
            "type": "timestamp with time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_reward_events_created_at",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_events_created_at ON app_rewards.reward_events USING btree (created_at DESC)"
          },
          {
            "name": "idx_reward_events_dead_letter",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_events_dead_letter ON app_rewards.reward_events USING btree (status, dead_letter_category) WHERE (status = 'dead_letter'::text)"
          },
          {
            "name": "idx_reward_events_event_id",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_events_event_id ON app_rewards.reward_events USING btree (event_id)"
          },
          {
            "name": "idx_reward_events_next_retry",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_events_next_retry ON app_rewards.reward_events USING btree (next_retry_at) WHERE (status = 'retrying'::text)"
          },
          {
            "name": "idx_reward_events_pending_retrying_created",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_events_pending_retrying_created ON app_rewards.reward_events USING btree (status, created_at, id) WHERE (status = ANY (ARRAY['pending'::text, 'retrying'::text]))"
          },
          {
            "name": "idx_reward_events_processing_started",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_events_processing_started ON app_rewards.reward_events USING btree (processing_started_at) WHERE (status = ANY (ARRAY['pending'::text, 'retrying'::text, 'processing'::text]))"
          },
          {
            "name": "idx_reward_events_queue",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_events_queue ON app_rewards.reward_events USING btree (status, next_retry_at, created_at) WHERE (status = ANY (ARRAY['pending'::text, 'retrying'::text]))"
          },
          {
            "name": "idx_reward_events_status",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_events_status ON app_rewards.reward_events USING btree (status)"
          },
          {
            "name": "idx_reward_events_user_status",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_events_user_status ON app_rewards.reward_events USING btree (internal_user_id, status)"
          }
        ],
        "raw_sql": "CREATE TABLE app_rewards.reward_events (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    internal_user_id uuid NOT NULL,\n    payload jsonb,\n    created_at timestamp with time zone DEFAULT now(),\n    metadata jsonb,\n    status text DEFAULT 'pending'::text,\n    retry_count integer DEFAULT 0,\n    last_error text,\n    completed_at timestamp with time zone,\n    next_retry_at timestamp with time zone,\n    max_retries integer DEFAULT 3,\n    event_id uuid NOT NULL,\n    dead_letter_reason text,\n    dead_letter_category text,\n    processing_started_at timestamp with time zone,\n    CONSTRAINT reward_events_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "fk_reward_events_event_id",
            "columns": [
              "event_id"
            ],
            "on_delete": "",
            "on_update": "",
            "ref_table": "reward_events_registry",
            "ref_schema": "app_rewards",
            "ref_columns": [
              "event_id"
            ]
          },
          {
            "name": "reward_events_internal_user_id_fkey",
            "columns": [
              "internal_user_id"
            ],
            "on_delete": "CASCADE",
            "on_update": "",
            "ref_table": "user_identity_root",
            "ref_schema": "public",
            "ref_columns": [
              "internal_user_id"
            ]
          }
        ],
        "business_purpose": null,
        "check_constraints": [
          {
            "name": "chk_retry_limit",
            "expression": "retry_count <= max_retries"
          },
          {
            "name": "chk_reward_events_status",
            "expression": "status = ANY (ARRAY['pending'::text, 'processing'::text, 'completed'::text, 'failed'::text, 'retrying'::text])"
          }
        ],
        "unique_constraints": null
      },
      {
        "name": "reward_events_registry",
        "schema": "app_rewards",
        "columns": [
          {
            "name": "event_id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "event_name",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "description",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "is_active",
            "type": "boolean",
            "default": "true",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "updated_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "reward_events_registry_new_event_name_key",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX reward_events_registry_new_event_name_key ON app_rewards.reward_events_registry USING btree (event_name)"
          }
        ],
        "raw_sql": "CREATE TABLE app_rewards.reward_events_registry (\\n    event_id uuid NOT NULL DEFAULT gen_random_uuid(),\n    event_name text NOT NULL,\n    description text,\n    is_active boolean DEFAULT true,\n    created_at timestamp with time zone DEFAULT now(),\n    updated_at timestamp with time zone DEFAULT now(),\n    CONSTRAINT reward_events_registry_new_pkey PRIMARY KEY (event_id)\\n);",
        "primary_key": [
          "event_id"
        ],
        "foreign_keys": null,
        "business_purpose": null,
        "check_constraints": null,
        "unique_constraints": [
          {
            "name": "reward_events_registry_new_event_name_key",
            "columns": [
              "event_name"
            ]
          }
        ]
      },
      {
        "name": "reward_ledger_view",
        "schema": "app_rewards",
        "columns": [
          {
            "name": "user_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "asset_code",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "total_points",
            "type": "numeric",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "total_cashback",
            "type": "numeric",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "badges_count",
            "type": "bigint",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "discounts_count",
            "type": "bigint",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "last_earned_at",
            "type": "timestamp with time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          }
        ],
        "indexes": null,
        "raw_sql": "CREATE TABLE app_rewards.reward_ledger_view (\\n    user_id uuid,\n    asset_code text,\n    total_points numeric,\n    total_cashback numeric,\n    badges_count bigint,\n    discounts_count bigint,\n    last_earned_at timestamp with time zone\\n);",
        "primary_key": null,
        "foreign_keys": null,
        "business_purpose": null,
        "check_constraints": null,
        "unique_constraints": null
      },
      {
        "name": "reward_rule_audit_log",
        "schema": "app_rewards",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "rule_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "action_type",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "old_version",
            "type": "integer",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "new_version",
            "type": "integer",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "changed_by",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "changed_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "metadata",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "old_reward_config",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "new_reward_config",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "request_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "trace_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "event_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "transaction_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_audit_event_id",
            "unique": false,
            "definition": "CREATE INDEX idx_audit_event_id ON app_rewards.reward_rule_audit_log USING btree (event_id)"
          },
          {
            "name": "idx_audit_transaction_id",
            "unique": false,
            "definition": "CREATE INDEX idx_audit_transaction_id ON app_rewards.reward_rule_audit_log USING btree (transaction_id)"
          },
          {
            "name": "idx_reward_audit_log_event_id",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_audit_log_event_id ON app_rewards.reward_rule_audit_log USING btree (event_id)"
          }
        ],
        "raw_sql": "CREATE TABLE app_rewards.reward_rule_audit_log (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    rule_id uuid,\n    action_type text NOT NULL,\n    old_version integer,\n    new_version integer,\n    changed_by uuid,\n    changed_at timestamp with time zone DEFAULT now(),\n    metadata jsonb,\n    old_reward_config jsonb,\n    new_reward_config jsonb,\n    request_id uuid,\n    trace_id uuid,\n    event_id uuid,\n    transaction_id uuid,\n    CONSTRAINT reward_rule_audit_log_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "fk_reward_audit_log_event_id",
            "columns": [
              "event_id"
            ],
            "on_delete": "",
            "on_update": "",
            "ref_table": "reward_events_registry",
            "ref_schema": "app_rewards",
            "ref_columns": [
              "event_id"
            ]
          },
          {
            "name": "reward_rule_audit_log_changed_by_fkey",
            "columns": [
              "changed_by"
            ],
            "on_delete": "",
            "on_update": "",
            "ref_table": "user_identity_root",
            "ref_schema": "public",
            "ref_columns": [
              "internal_user_id"
            ]
          },
          {
            "name": "reward_rule_audit_log_rule_id_fkey",
            "columns": [
              "rule_id"
            ],
            "on_delete": "CASCADE",
            "on_update": "",
            "ref_table": "reward_rule_versions",
            "ref_schema": "app_rewards",
            "ref_columns": [
              "id"
            ]
          }
        ],
        "business_purpose": null,
        "check_constraints": [
          {
            "name": "reward_rule_audit_log_action_check",
            "expression": "action_type = ANY (ARRAY['create'::text, 'update'::text, 'activate'::text, 'deactivate'::text])"
          }
        ],
        "unique_constraints": null
      },
      {
        "name": "reward_rule_versions",
        "schema": "app_rewards",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "version",
            "type": "integer",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "reward_config",
            "type": "jsonb",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "is_active",
            "type": "boolean",
            "default": "false",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "created_by",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "updated_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "starts_at",
            "type": "timestamp with time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "expires_at",
            "type": "timestamp with time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "description",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "title",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "created_reason",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "is_deleted",
            "type": "boolean",
            "default": "false",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "published_at",
            "type": "timestamp with time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "updated_by",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "rule_name",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "event_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_reward_rule_versions_event_id",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_rule_versions_event_id ON app_rewards.reward_rule_versions USING btree (event_id)"
          },
          {
            "name": "uq_event_version",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX uq_event_version ON app_rewards.reward_rule_versions USING btree (event_id, version)"
          }
        ],
        "raw_sql": "CREATE TABLE app_rewards.reward_rule_versions (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    version integer NOT NULL,\n    reward_config jsonb NOT NULL,\n    is_active boolean DEFAULT false,\n    created_by uuid,\n    created_at timestamp with time zone DEFAULT now(),\n    updated_at timestamp with time zone DEFAULT now(),\n    starts_at timestamp with time zone,\n    expires_at timestamp with time zone,\n    description text,\n    title text,\n    created_reason text,\n    is_deleted boolean NOT NULL DEFAULT false,\n    published_at timestamp with time zone,\n    updated_by uuid,\n    rule_name text,\n    event_id uuid,\n    CONSTRAINT reward_rule_versions_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "fk_reward_rule_versions_event_id",
            "columns": [
              "event_id"
            ],
            "on_delete": "",
            "on_update": "",
            "ref_table": "reward_events_registry",
            "ref_schema": "app_rewards",
            "ref_columns": [
              "event_id"
            ]
          },
          {
            "name": "reward_rule_versions_created_by_fkey",
            "columns": [
              "created_by"
            ],
            "on_delete": "",
            "on_update": "",
            "ref_table": "user_identity_root",
            "ref_schema": "public",
            "ref_columns": [
              "internal_user_id"
            ]
          },
          {
            "name": "reward_rule_versions_updated_by_fkey",
            "columns": [
              "updated_by"
            ],
            "on_delete": "",
            "on_update": "",
            "ref_table": "user_identity_root",
            "ref_schema": "public",
            "ref_columns": [
              "internal_user_id"
            ]
          }
        ],
        "business_purpose": null,
        "check_constraints": [
          {
            "name": "chk_reward_config_structure_exclusive",
            "expression": "CHECK ((reward_config ? 'amount'::text) <> (reward_config ? 'rewards'::text)) NOT VALID"
          },
          {
            "name": "chk_reward_config_valid",
            "expression": "CHECK (app_rewards.is_valid_reward_config(reward_config)) NOT VALID"
          }
        ],
        "unique_constraints": [
          {
            "name": "uq_event_version",
            "columns": [
              "version",
              "event_id"
            ]
          }
        ]
      },
      {
        "name": "reward_transactions",
        "schema": "app_rewards",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "internal_user_id",
            "type": "uuid",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "rule_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "reward_type",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "amount",
            "type": "numeric",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "value",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "status",
            "type": "text",
            "default": "'granted'::text",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "idempotency_key",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "metadata",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "earned_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "asset_code",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "source_type",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "source_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "wallet_transaction_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "rule_snapshot",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "wallet_confirmed",
            "type": "boolean",
            "default": "false",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "wallet_confirmed_at",
            "type": "timestamp with time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "wallet_failure_reason",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "event_id",
            "type": "uuid",
            "default": null,
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_reward_transactions_event_id",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_transactions_event_id ON app_rewards.reward_transactions USING btree (event_id)"
          },
          {
            "name": "idx_reward_tx_created",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_tx_created ON app_rewards.reward_transactions USING btree (created_at DESC)"
          },
          {
            "name": "idx_reward_tx_rule",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_tx_rule ON app_rewards.reward_transactions USING btree (rule_id)"
          },
          {
            "name": "idx_reward_tx_status",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_tx_status ON app_rewards.reward_transactions USING btree (status)"
          },
          {
            "name": "idx_reward_tx_user",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_tx_user ON app_rewards.reward_transactions USING btree (internal_user_id)"
          },
          {
            "name": "idx_reward_tx_wallet_pending",
            "unique": false,
            "definition": "CREATE INDEX idx_reward_tx_wallet_pending ON app_rewards.reward_transactions USING btree (wallet_confirmed, created_at) WHERE (wallet_confirmed = false)"
          },
          {
            "name": "uq_reward_transactions_idempotency",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX uq_reward_transactions_idempotency ON app_rewards.reward_transactions USING btree (idempotency_key)"
          },
          {
            "name": "uq_reward_work",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX uq_reward_work ON app_rewards.reward_transactions USING btree (internal_user_id, event_id, rule_id, reward_type)"
          }
        ],
        "raw_sql": "CREATE TABLE app_rewards.reward_transactions (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    internal_user_id uuid NOT NULL,\n    rule_id uuid,\n    reward_type text NOT NULL,\n    amount numeric,\n    value text,\n    status text NOT NULL DEFAULT 'granted'::text,\n    idempotency_key text NOT NULL,\n    created_at timestamp with time zone DEFAULT now(),\n    metadata jsonb,\n    earned_at timestamp with time zone DEFAULT now(),\n    asset_code text,\n    source_type text,\n    source_id uuid,\n    wallet_transaction_id uuid,\n    rule_snapshot jsonb,\n    wallet_confirmed boolean DEFAULT false,\n    wallet_confirmed_at timestamp with time zone,\n    wallet_failure_reason text,\n    event_id uuid NOT NULL,\n    CONSTRAINT reward_transactions_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "fk_reward_transactions_event_id",
            "columns": [
              "event_id"
            ],
            "on_delete": "",
            "on_update": "",
            "ref_table": "reward_events_registry",
            "ref_schema": "app_rewards",
            "ref_columns": [
              "event_id"
            ]
          },
          {
            "name": "fk_reward_transactions_rule",
            "columns": [
              "rule_id"
            ],
            "on_delete": "SET NULL",
            "on_update": "",
            "ref_table": "reward_rule_versions",
            "ref_schema": "app_rewards",
            "ref_columns": [
              "id"
            ]
          },
          {
            "name": "fk_reward_type_allowed",
            "columns": [
              "reward_type"
            ],
            "on_delete": "",
            "on_update": "",
            "ref_table": "allowed_reward_types",
            "ref_schema": "app_rewards",
            "ref_columns": [
              "reward_type"
            ]
          },
          {
            "name": "reward_transactions_internal_user_id_fkey",
            "columns": [
              "internal_user_id"
            ],
            "on_delete": "CASCADE",
            "on_update": "",
            "ref_table": "user_identity_root",
            "ref_schema": "public",
            "ref_columns": [
              "internal_user_id"
            ]
          }
        ],
        "business_purpose": null,
        "check_constraints": [
          {
            "name": "chk_reward_transactions_status",
            "expression": "status = ANY (ARRAY['granted'::text, 'cancelled'::text, 'expired'::text, 'pending'::text])"
          },
          {
            "name": "chk_reward_type",
            "expression": "reward_type = ANY (ARRAY['point'::text, 'badge'::text, 'discount'::text, 'level'::text, 'cashback'::text])"
          }
        ],
        "unique_constraints": [
          {
            "name": "uq_reward_transactions_idempotency",
            "columns": [
              "idempotency_key"
            ]
          },
          {
            "name": "uq_reward_work",
            "columns": [
              "internal_user_id",
              "rule_id",
              "reward_type",
              "event_id"
            ]
          }
        ]
      }
    ]
  },
  {
    "object_type": "views",
    "sort_order": 3,
    "data": [
      {
        "name": "reward_ledger_view",
        "schema": "app_rewards",
        "columns": [
          {
            "name": "user_id",
            "type": "uuid"
          },
          {
            "name": "asset_code",
            "type": "text"
          },
          {
            "name": "total_points",
            "type": "numeric"
          },
          {
            "name": "total_cashback",
            "type": "numeric"
          },
          {
            "name": "badges_count",
            "type": "bigint"
          },
          {
            "name": "discounts_count",
            "type": "bigint"
          },
          {
            "name": "last_earned_at",
            "type": "timestamp with time zone"
          }
        ],
        "raw_sql": "CREATE VIEW app_rewards.reward_ledger_view AS  SELECT internal_user_id AS user_id,\n    asset_code,\n    sum(\n        CASE\n            WHEN ((status = 'granted'::text) AND (reward_type = 'point'::text)) THEN amount\n            ELSE (0)::numeric\n        END) AS total_points,\n    sum(\n        CASE\n            WHEN ((status = 'granted'::text) AND (reward_type = 'cashback'::text)) THEN amount\n            ELSE (0)::numeric\n        END) AS total_cashback,\n    count(*) FILTER (WHERE (reward_type = 'badge'::text)) AS badges_count,\n    count(*) FILTER (WHERE (reward_type = 'discount'::text)) AS discounts_count,\n    max(earned_at) AS last_earned_at\n   FROM app_rewards.reward_transactions\n  GROUP BY internal_user_id, asset_code;;",
        "definition": " SELECT internal_user_id AS user_id,\n    asset_code,\n    sum(\n        CASE\n            WHEN ((status = 'granted'::text) AND (reward_type = 'point'::text)) THEN amount\n            ELSE (0)::numeric\n        END) AS total_points,\n    sum(\n        CASE\n            WHEN ((status = 'granted'::text) AND (reward_type = 'cashback'::text)) THEN amount\n            ELSE (0)::numeric\n        END) AS total_cashback,\n    count(*) FILTER (WHERE (reward_type = 'badge'::text)) AS badges_count,\n    count(*) FILTER (WHERE (reward_type = 'discount'::text)) AS discounts_count,\n    max(earned_at) AS last_earned_at\n   FROM app_rewards.reward_transactions\n  GROUP BY internal_user_id, asset_code;"
      }
    ]
  },
  {
    "object_type": "functions",
    "sort_order": 4,
    "data": [
      {
        "name": "activate_reward_rule",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.activate_reward_rule(p_rule_id uuid, p_changed_by uuid DEFAULT NULL::uuid)\n RETURNS jsonb\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$declare\r\n    v_rule app_rewards.reward_rule_versions%rowtype;\r\nbegin\r\n    -- =========================================\r\n    -- GET RULE\r\n    -- =========================================\r\n    select *\r\n    into v_rule\r\n    from app_rewards.reward_rule_versions\r\n    where id = p_rule_id;\r\n\r\n    if not found then\r\n        return jsonb_build_object('success', false, 'error', 'RULE_NOT_FOUND');\r\n    end if;\r\n\r\n    -- =========================================\r\n    -- DEACTIVATE OTHERS\r\n    -- =========================================\r\n    update app_rewards.reward_rule_versions\r\n    set\r\n        is_active = false,\r\n        updated_at = now(),\r\n        updated_by = p_changed_by\r\n    where event_name = v_rule.event_name;\r\n\r\n    -- =========================================\r\n    -- ACTIVATE TARGET\r\n    -- =========================================\r\n    update app_rewards.reward_rule_versions\r\n    set\r\n        is_active = true,\r\n        updated_at = now(),\r\n        updated_by = p_changed_by\r\n    where id = p_rule_id;\r\n\r\n    -- =========================================\r\n    -- AUDIT LOG\r\n    -- =========================================\r\n    insert into app_rewards.reward_rule_audit_log (\r\n        rule_id, event_name, action_type,\r\n        old_version, new_version, changed_by,\r\n        new_reward_config\r\n    ) values (\r\n        p_rule_id, v_rule.event_name, 'activate',\r\n        v_rule.version, v_rule.version, p_changed_by,\r\n        v_rule.reward_config\r\n    );\r\n\r\n    -- =========================================\r\n    -- SUCCESS\r\n    -- =========================================\r\n    return jsonb_build_object(\r\n        'success', true,\r\n        'data', jsonb_build_object(\r\n            'rule_id', p_rule_id,\r\n            'event_name', v_rule.event_name,\r\n            'version', v_rule.version,\r\n            'rule_name', v_rule.rule_name   -- ✅ تمت الإضافة\r\n        )\r\n    );\r\nend;$function$\n",
        "returns": "jsonb",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_rule_id",
            "type": "uuid"
          },
          {
            "name": "p_changed_by",
            "type": "uuid"
          }
        ]
      },
      {
        "name": "calc_next_retry_at",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.calc_next_retry_at(base_delay_seconds integer DEFAULT 2, retry_count integer DEFAULT 0)\n RETURNS timestamp with time zone\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    RETURN now() + (base_delay_seconds * power(2, retry_count)) * interval '1 second';\r\nEND;\r\n$function$\n",
        "returns": "timestamp with time zone",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "base_delay_seconds",
            "type": "integer"
          },
          {
            "name": "retry_count",
            "type": "integer"
          }
        ]
      },
      {
        "name": "calculate_reward",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.calculate_reward(p_rule_config jsonb)\n RETURNS TABLE(amount numeric, value text, asset_code text)\n LANGUAGE plpgsql\n IMMUTABLE\nAS $function$\r\nBEGIN\r\n    amount := COALESCE((p_rule_config->>'amount')::numeric, 0);\r\n    value := COALESCE(p_rule_config->>'value', '');\r\n    asset_code := COALESCE(p_rule_config->>'asset_code', 'point');\r\n    RETURN NEXT;\r\nEND;\r\n$function$\n",
        "returns": "record",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_rule_config",
            "type": "jsonb"
          },
          {
            "name": "amount",
            "type": null
          },
          {
            "name": "value",
            "type": null
          },
          {
            "name": "asset_code",
            "type": null
          }
        ]
      },
      {
        "name": "check_event_reward",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.check_event_reward(p_event_name text)\n RETURNS jsonb\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$declare\r\n    v_rule app_rewards.reward_rule_versions%rowtype;\r\n    v_now timestamptz := now();\r\n    v_config jsonb;\r\n    v_rewards_array jsonb;\r\nbegin\r\n    if p_event_name is null or trim(p_event_name) = '' then\r\n        return jsonb_build_object('success', false, 'error', 'Event name is required', 'code', 'EVENT_NAME_REQUIRED');\r\n    end if;\r\n\r\n    select *\r\n    into v_rule\r\n    from app_rewards.reward_rule_versions\r\n    where event_name = p_event_name\r\n      and is_active = true\r\n      and is_deleted = false\r\n      and (starts_at is null or starts_at <= v_now)\r\n      and (expires_at is null or expires_at >= v_now)\r\n    order by version desc\r\n    limit 1;\r\n\r\n    if not found then\r\n        return jsonb_build_object('success', false, 'error', 'No active reward rule found for event: ' || p_event_name, 'code', 'NO_ACTIVE_RULE');\r\n    end if;\r\n\r\n    v_config := v_rule.reward_config;\r\n    -- تحويل الكائن البسيط إلى مصفوفة تحتوي عنصراً واحداً\r\n    if jsonb_typeof(v_config) = 'object' and not (v_config ? 'rewards') then\r\n        v_rewards_array := jsonb_build_array(v_config);\r\n    else\r\n        v_rewards_array := v_config->'rewards';\r\n    end if;\r\n\r\n    return jsonb_build_object(\r\n        'success', true,\r\n        'data', jsonb_build_object(\r\n            'rule_id', v_rule.id,\r\n            'rule_name', v_rule.rule_name,\r\n            'version', v_rule.version,\r\n            'rewards', v_rewards_array,\r\n            'event_name', v_rule.event_name,\r\n            'title', v_rule.title,\r\n            'description', v_rule.description\r\n        )\r\n    );\r\nend;$function$\n",
        "returns": "jsonb",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_event_name",
            "type": "text"
          }
        ]
      },
      {
        "name": "check_reward_granted",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.check_reward_granted(p_user_id uuid, p_event_name text, p_reward_type text DEFAULT NULL::text)\n RETURNS jsonb\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$\r\ndeclare\r\n    v_exists boolean;\r\nbegin\r\n    if p_reward_type is null then\r\n        select exists (\r\n            select 1 from app_rewards.reward_transactions\r\n            where internal_user_id = p_user_id\r\n              and event_name = p_event_name\r\n              and status = 'granted'\r\n            limit 1\r\n        ) into v_exists;\r\n    else\r\n        select exists (\r\n            select 1 from app_rewards.reward_transactions\r\n            where internal_user_id = p_user_id\r\n              and event_name = p_event_name\r\n              and reward_type = p_reward_type\r\n              and status = 'granted'\r\n            limit 1\r\n        ) into v_exists;\r\n    end if;\r\n\r\n    return jsonb_build_object(\r\n        'success', true,\r\n        'data', jsonb_build_object(\r\n            'already_granted', v_exists,\r\n            'event_name', p_event_name,\r\n            'reward_type', p_reward_type\r\n        )\r\n    );\r\nend;\r\n$function$\n",
        "returns": "jsonb",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_user_id",
            "type": "uuid"
          },
          {
            "name": "p_event_name",
            "type": "text"
          },
          {
            "name": "p_reward_type",
            "type": "text"
          }
        ]
      },
      {
        "name": "create_reward_rule",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.create_reward_rule(p_event_name text, p_reward_config jsonb, p_rule_name text DEFAULT NULL::text, p_title text DEFAULT NULL::text, p_description text DEFAULT NULL::text, p_created_reason text DEFAULT NULL::text, p_created_by text DEFAULT NULL::text, p_is_active boolean DEFAULT false, p_starts_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_expires_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_published_at timestamp with time zone DEFAULT NULL::timestamp with time zone)\n RETURNS jsonb\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$declare\r\n    v_next_version integer;\r\n    v_rule_id uuid;\r\n    v_created_by_uuid uuid;\r\n    v_is_valid_uuid boolean;\r\nbegin\r\n    -- =========================================\r\n    -- VALIDATION\r\n    -- =========================================\r\n    if p_event_name is null or trim(p_event_name) = '' then\r\n        return jsonb_build_object('success', false, 'error', 'event_name is required');\r\n    end if;\r\n\r\n    if p_reward_config is null then\r\n        return jsonb_build_object('success', false, 'error', 'reward_config is required');\r\n    end if;\r\n\r\n    if p_starts_at is not null and p_expires_at is not null and p_starts_at >= p_expires_at then\r\n        return jsonb_build_object('success', false, 'error', 'starts_at must be before expires_at');\r\n    end if;\r\n\r\n    -- =========================================\r\n    -- VALIDATE AND CONVERT created_by\r\n    -- =========================================\r\n    if p_created_by is not null and trim(p_created_by) <> '' then\r\n        begin\r\n            v_created_by_uuid := p_created_by::uuid;\r\n        exception\r\n            when others then\r\n                return jsonb_build_object('success', false, 'error', 'Invalid UUID format for created_by');\r\n        end;\r\n        -- التحقق من وجوده في جدول الجذر\r\n        if not exists (select 1 from public.user_identity_root where internal_user_id = v_created_by_uuid) then\r\n            return jsonb_build_object('success', false, 'error', 'created_by user does not exist in identity root');\r\n        end if;\r\n    else\r\n        v_created_by_uuid := null;\r\n    end if;\r\n\r\n    -- =========================================\r\n    -- GET NEXT VERSION\r\n    -- =========================================\r\n    select coalesce(max(version), 0) + 1\r\n    into v_next_version\r\n    from app_rewards.reward_rule_versions\r\n    where event_name = p_event_name;\r\n\r\n    -- =========================================\r\n    -- DEACTIVATE OLD ACTIVE RULE\r\n    -- =========================================\r\n    if p_is_active = true then\r\n        update app_rewards.reward_rule_versions\r\n        set\r\n            is_active = false,\r\n            updated_at = now(),\r\n            updated_by = v_created_by_uuid\r\n        where event_name = p_event_name\r\n          and is_active = true;\r\n    end if;\r\n\r\n    -- =========================================\r\n    -- INSERT RULE (مع إضافة rule_name)\r\n    -- =========================================\r\n    insert into app_rewards.reward_rule_versions (\r\n        event_name,\r\n        version,\r\n        reward_config,\r\n        rule_name,                 -- ✅ تمت الإضافة\r\n        title,\r\n        description,\r\n        created_reason,\r\n        created_by,\r\n        updated_by,\r\n        is_active,\r\n        starts_at,\r\n        expires_at,\r\n        published_at\r\n    ) values (\r\n        p_event_name,\r\n        v_next_version,\r\n        p_reward_config,\r\n        p_rule_name,               -- ✅ القيمة الجديدة\r\n        p_title,\r\n        p_description,\r\n        p_created_reason,\r\n        v_created_by_uuid,\r\n        v_created_by_uuid,\r\n        p_is_active,\r\n        p_starts_at,\r\n        p_expires_at,\r\n        p_published_at\r\n    )\r\n    returning id into v_rule_id;\r\n\r\n    -- =========================================\r\n    -- AUDIT LOG\r\n    -- =========================================\r\n    insert into app_rewards.reward_rule_audit_log (\r\n        rule_id,\r\n        event_name,\r\n        action_type,\r\n        new_version,\r\n        changed_by,\r\n        new_reward_config,\r\n        metadata\r\n    ) values (\r\n        v_rule_id,\r\n        p_event_name,\r\n        'create',\r\n        v_next_version,\r\n        v_created_by_uuid,\r\n        p_reward_config,\r\n        jsonb_build_object(\r\n            'title', p_title,\r\n            'description', p_description,\r\n            'rule_name', p_rule_name          -- ✅ إضافة الاسم في metadata\r\n        )\r\n    );\r\n\r\n    -- =========================================\r\n    -- SUCCESS\r\n    -- =========================================\r\n    return jsonb_build_object(\r\n        'success', true,\r\n        'data', jsonb_build_object(\r\n            'rule_id', v_rule_id,\r\n            'event_name', p_event_name,\r\n            'version', v_next_version,\r\n            'rule_name', p_rule_name          -- ✅ إعادة الاسم\r\n        )\r\n    );\r\nend;$function$\n",
        "returns": "jsonb",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_event_name",
            "type": "text"
          },
          {
            "name": "p_reward_config",
            "type": "jsonb"
          },
          {
            "name": "p_rule_name",
            "type": "text"
          },
          {
            "name": "p_title",
            "type": "text"
          },
          {
            "name": "p_description",
            "type": "text"
          },
          {
            "name": "p_created_reason",
            "type": "text"
          },
          {
            "name": "p_created_by",
            "type": "text"
          },
          {
            "name": "p_is_active",
            "type": "boolean"
          },
          {
            "name": "p_starts_at",
            "type": "timestamp with time zone"
          },
          {
            "name": "p_expires_at",
            "type": "timestamp with time zone"
          },
          {
            "name": "p_published_at",
            "type": "timestamp with time zone"
          }
        ]
      },
      {
        "name": "deactivate_reward_rule",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.deactivate_reward_rule(p_rule_id uuid, p_changed_by uuid DEFAULT NULL::uuid)\n RETURNS jsonb\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$declare\r\n    v_rule app_rewards.reward_rule_versions%rowtype;\r\nbegin\r\n    -- =========================================\r\n    -- GET RULE\r\n    -- =========================================\r\n    select *\r\n    into v_rule\r\n    from app_rewards.reward_rule_versions\r\n    where id = p_rule_id;\r\n\r\n    if not found then\r\n        return jsonb_build_object(\r\n            'success', false,\r\n            'error', 'RULE_NOT_FOUND'\r\n        );\r\n    end if;\r\n\r\n    -- =========================================\r\n    -- DEACTIVATE\r\n    -- =========================================\r\n    update app_rewards.reward_rule_versions\r\n    set\r\n        is_active = false,\r\n        updated_at = now(),\r\n        updated_by = p_changed_by\r\n    where id = p_rule_id;\r\n\r\n    -- =========================================\r\n    -- AUDIT LOG\r\n    -- =========================================\r\n    insert into app_rewards.reward_rule_audit_log (\r\n        rule_id,\r\n        event_name,\r\n        action_type,\r\n        old_version,\r\n        new_version,\r\n        changed_by,\r\n        old_reward_config\r\n    ) values (\r\n        p_rule_id,\r\n        v_rule.event_name,\r\n        'deactivate',\r\n        v_rule.version,\r\n        v_rule.version,\r\n        p_changed_by,\r\n        v_rule.reward_config\r\n    );\r\n\r\n    -- =========================================\r\n    -- SUCCESS\r\n    -- =========================================\r\n    return jsonb_build_object(\r\n        'success', true,\r\n        'data', jsonb_build_object(\r\n            'rule_id', p_rule_id,\r\n            'event_name', v_rule.event_name,\r\n            'version', v_rule.version,\r\n            'rule_name', v_rule.rule_name,   -- ✅ تمت الإضافة\r\n            'deactivated_at', now()\r\n        )\r\n    );\r\nend;$function$\n",
        "returns": "jsonb",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_rule_id",
            "type": "uuid"
          },
          {
            "name": "p_changed_by",
            "type": "uuid"
          }
        ]
      },
      {
        "name": "emit_reward_event",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.emit_reward_event(p_user_id uuid, p_event_name text, p_payload jsonb DEFAULT '{}'::jsonb, p_metadata jsonb DEFAULT '{}'::jsonb)\n RETURNS uuid\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_event_id uuid;\r\n    v_registry_event_id uuid;\r\nBEGIN\r\n    SELECT event_id INTO v_registry_event_id\r\n    FROM app_rewards.reward_events_registry\r\n    WHERE event_name = p_event_name AND is_active = true;\r\n    IF NOT FOUND THEN\r\n        RAISE EXCEPTION 'Event name \"%\" does not exist or is inactive', p_event_name;\r\n    END IF;\r\n\r\n    INSERT INTO app_rewards.reward_events (internal_user_id, event_id, payload, metadata, status)\r\n    VALUES (p_user_id, v_registry_event_id, p_payload, p_metadata, 'pending')\r\n    RETURNING id INTO v_event_id;\r\n\r\n    RETURN v_event_id;\r\nEND;\r\n$function$\n",
        "returns": "uuid",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_user_id",
            "type": "uuid"
          },
          {
            "name": "p_event_name",
            "type": "text"
          },
          {
            "name": "p_payload",
            "type": "jsonb"
          },
          {
            "name": "p_metadata",
            "type": "jsonb"
          }
        ]
      },
      {
        "name": "fetch_next_events",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.fetch_next_events(p_limit integer)\n RETURNS SETOF app_rewards.reward_events\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    RETURN QUERY\r\n    SELECT *\r\n    FROM app_rewards.reward_events\r\n    WHERE status IN ('pending', 'retrying')\r\n      AND (next_retry_at IS NULL OR next_retry_at <= now())\r\n      AND (processing_started_at IS NULL OR processing_started_at < now() - interval '5 minutes')\r\n    ORDER BY created_at, id\r\n    LIMIT p_limit\r\n    FOR UPDATE SKIP LOCKED;\r\nEND;\r\n$function$\n",
        "returns": "app_rewards.reward_events",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_limit",
            "type": "integer"
          }
        ]
      },
      {
        "name": "get_active_rule_version",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.get_active_rule_version(p_event_id uuid)\n RETURNS TABLE(rule_id uuid, version integer, reward_config jsonb, starts_at timestamp with time zone, expires_at timestamp with time zone)\n LANGUAGE plpgsql\n STABLE\nAS $function$\r\nBEGIN\r\n    RETURN QUERY\r\n    SELECT rv.id, rv.version, rv.reward_config, rv.starts_at, rv.expires_at\r\n    FROM app_rewards.reward_rule_versions rv\r\n    WHERE rv.event_id = p_event_id\r\n      AND rv.is_active = true\r\n      AND rv.is_deleted = false\r\n      AND (rv.starts_at IS NULL OR rv.starts_at <= now())\r\n      AND (rv.expires_at IS NULL OR rv.expires_at > now())\r\n    ORDER BY rv.version DESC\r\n    LIMIT 1;\r\nEND;\r\n$function$\n",
        "returns": "record",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_event_id",
            "type": "uuid"
          },
          {
            "name": "rule_id",
            "type": null
          },
          {
            "name": "version",
            "type": null
          },
          {
            "name": "reward_config",
            "type": null
          },
          {
            "name": "starts_at",
            "type": null
          },
          {
            "name": "expires_at",
            "type": null
          }
        ]
      },
      {
        "name": "get_reward_rules",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.get_reward_rules(p_event_name text DEFAULT NULL::text, p_is_active boolean DEFAULT NULL::boolean, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0)\n RETURNS jsonb\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$declare\r\n    v_rules jsonb;\r\n    v_total_count bigint;\r\nbegin\r\n    -- إجمالي عدد القواعد (بدون pagination)\r\n    select count(*)\r\n    into v_total_count\r\n    from app_rewards.reward_rule_versions\r\n    where (p_event_name is null or event_name = p_event_name)\r\n      and (p_is_active is null or is_active = p_is_active)\r\n      and is_deleted = false;\r\n\r\n    -- جلب القواعد المطلوبة مع الصفحات\r\n    select coalesce(jsonb_agg(\r\n        jsonb_build_object(\r\n            'id', r.id,\r\n            'event_name', r.event_name,\r\n            'version', r.version,\r\n            'rule_name', r.rule_name,               -- ✅ العمود الجديد\r\n            'reward_config', r.reward_config,\r\n            'title', r.title,\r\n            'description', r.description,\r\n            'is_active', r.is_active,\r\n            'starts_at', r.starts_at,\r\n            'expires_at', r.expires_at,\r\n            'published_at', r.published_at,\r\n            'created_at', r.created_at,\r\n            'updated_at', r.updated_at,\r\n            'created_by', r.created_by,\r\n            'updated_by', r.updated_by,\r\n            'created_reason', r.created_reason\r\n        )\r\n        order by r.version desc\r\n    ), '[]'::jsonb)\r\n    into v_rules\r\n    from app_rewards.reward_rule_versions r\r\n    where (p_event_name is null or r.event_name = p_event_name)\r\n      and (p_is_active is null or r.is_active = p_is_active)\r\n      and r.is_deleted = false\r\n    limit p_limit\r\n    offset p_offset;\r\n\r\n    return jsonb_build_object(\r\n        'success', true,\r\n        'data', jsonb_build_object(\r\n            'rules', v_rules,\r\n            'total_count', v_total_count,\r\n            'limit', p_limit,\r\n            'offset', p_offset\r\n        )\r\n    );\r\nexception\r\n    when others then\r\n        return jsonb_build_object(\r\n            'success', false,\r\n            'error', sqlerrm,\r\n            'code', sqlstate\r\n        );\r\nend;$function$\n",
        "returns": "jsonb",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_event_name",
            "type": "text"
          },
          {
            "name": "p_is_active",
            "type": "boolean"
          },
          {
            "name": "p_limit",
            "type": "integer"
          },
          {
            "name": "p_offset",
            "type": "integer"
          }
        ]
      },
      {
        "name": "grant_reward",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.grant_reward(p_event_name text, p_user_id text, p_idempotency_key text, p_metadata jsonb DEFAULT '{}'::jsonb)\n RETURNS jsonb\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$declare\r\n    v_user_uuid uuid;\r\n    v_rule_data jsonb;\r\n    v_rule_id uuid;\r\n    v_rule_version int;\r\n    v_rewards jsonb;\r\n    v_reward_item jsonb;\r\n    v_reward_type text;\r\n    v_amount numeric;\r\n    v_currency text;\r\n    v_discount_code text;\r\n    v_now timestamptz := now();\r\n    v_transaction_ids jsonb := '[]'::jsonb;\r\n    v_item_key text;\r\n    v_check jsonb;\r\nbegin\r\n    -- 1. التحقق من صحة user_id\r\n    if p_user_id is null or trim(p_user_id) = '' then\r\n        return jsonb_build_object('success', false, 'error', 'User ID is required', 'code', 'USER_ID_REQUIRED');\r\n    end if;\r\n    begin\r\n        v_user_uuid := p_user_id::uuid;\r\n    exception\r\n        when others then\r\n            return jsonb_build_object('success', false, 'error', 'Invalid UUID format for user_id', 'code', 'INVALID_UUID');\r\n    end;\r\n\r\n    -- 2. وجود المستخدم\r\n    if not exists (select 1 from public.user_identity_root where internal_user_id = v_user_uuid) then\r\n        return jsonb_build_object('success', false, 'error', 'User does not exist in identity root', 'code', 'USER_NOT_FOUND');\r\n    end if;\r\n\r\n    -- 3. جلب القاعدة والمكافآت\r\n    select api_rewards.check_event_reward(p_event_name) into v_rule_data;\r\n    if (v_rule_data->>'success')::boolean != true then\r\n        return v_rule_data;\r\n    end if;\r\n\r\n    v_rule_id := (v_rule_data->'data'->>'rule_id')::uuid;\r\n    v_rule_version := (v_rule_data->'data'->>'version')::int;\r\n    v_rewards := v_rule_data->'data'->'rewards';\r\n\r\n    -- 4. معالجة كل مكافأة على حدة\r\n    for v_reward_item in select * from jsonb_array_elements(v_rewards)\r\n    loop\r\n        v_reward_type := v_reward_item->>'type';\r\n        v_amount := (v_reward_item->>'amount')::numeric;\r\n        v_currency := v_reward_item->>'currency';\r\n        v_discount_code := v_reward_item->>'discount_code';\r\n\r\n        -- التحقق باستخدام دالة check_reward_granted (لمنع تكرار نفس النوع)\r\n        select api_rewards.check_reward_granted(v_user_uuid, p_event_name, v_reward_type) into v_check;\r\n        if (v_check->'data'->>'already_granted')::boolean = true then\r\n            -- تم صرف هذا النوع من المكافأة سابقاً، نتخطاه\r\n            continue;\r\n        end if;\r\n\r\n        -- مفتاح idempotency الخاص بهذه المكافأة (احتياطي إضافي)\r\n        v_item_key := p_idempotency_key || '_' || v_reward_type;\r\n\r\n        -- التحقق من عدم تكرار idempotency_key (للتأكيد)\r\n        if exists (select 1 from app_rewards.reward_transactions where idempotency_key = v_item_key) then\r\n            continue;\r\n        end if;\r\n\r\n        -- تحديث المحفظة حسب نوع المكافأة\r\n        case v_reward_type\r\n            when 'points' then\r\n                if v_amount is not null then\r\n                    update app_wallet.user_wallet_summary\r\n                    set points_available = points_available + v_amount,\r\n                        points_total = points_total + v_amount,\r\n                        updated_at = v_now\r\n                    where internal_user_id = v_user_uuid;\r\n                end if;\r\n            when 'coins' then\r\n                if v_amount is not null then\r\n                    update app_wallet.user_wallet_summary\r\n                    set coins_available = coins_available + v_amount,\r\n                        coins_total = coins_total + v_amount,\r\n                        updated_at = v_now\r\n                    where internal_user_id = v_user_uuid;\r\n                end if;\r\n            when 'cash' then\r\n                if v_amount is not null then\r\n                    update app_wallet.user_wallet_summary\r\n                    set cash_available = cash_available + v_amount,\r\n                        cash_total = cash_total + v_amount,\r\n                        updated_at = v_now\r\n                    where internal_user_id = v_user_uuid;\r\n                end if;\r\n            when 'discount' then\r\n                -- لا تحديث للمحفظة\r\n                null;\r\n            else\r\n                return jsonb_build_object('success', false, 'error', 'Unsupported reward type: ' || v_reward_type, 'code', 'UNSUPPORTED_TYPE');\r\n        end case;\r\n\r\n        -- تسجيل المعاملة\r\n        insert into app_rewards.reward_transactions (\r\n            user_id, event_name, rule_id, reward_type, amount, value, status,\r\n            idempotency_key, metadata, created_at\r\n        )\r\n        values (\r\n            v_user_uuid, p_event_name, v_rule_id, v_reward_type, v_amount,\r\n            coalesce(v_currency, v_discount_code),\r\n            'granted', v_item_key, p_metadata, v_now\r\n        );\r\n\r\n        v_transaction_ids := v_transaction_ids || jsonb_build_object(v_reward_type, v_item_key);\r\n    end loop;\r\n\r\n    return jsonb_build_object(\r\n        'success', true,\r\n        'data', jsonb_build_object(\r\n            'transaction_ids', v_transaction_ids,\r\n            'rule_id', v_rule_id,\r\n            'rule_version', v_rule_version,\r\n            'event_name', p_event_name\r\n        )\r\n    );\r\nexception\r\n    when others then\r\n        return jsonb_build_object('success', false, 'error', sqlerrm, 'code', sqlstate);\r\nend;$function$\n",
        "returns": "jsonb",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_event_name",
            "type": "text"
          },
          {
            "name": "p_user_id",
            "type": "text"
          },
          {
            "name": "p_idempotency_key",
            "type": "text"
          },
          {
            "name": "p_metadata",
            "type": "jsonb"
          }
        ]
      },
      {
        "name": "grant_reward_transaction",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.grant_reward_transaction(p_user_id uuid, p_event_id uuid, p_rule_id uuid, p_reward_type text, p_idempotency_key text, p_amount numeric DEFAULT NULL::numeric, p_value text DEFAULT NULL::text, p_asset_code text DEFAULT NULL::text, p_source_type text DEFAULT NULL::text, p_source_id uuid DEFAULT NULL::uuid, p_metadata jsonb DEFAULT '{}'::jsonb, p_rule_snapshot jsonb DEFAULT NULL::jsonb)\n RETURNS uuid\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_transaction_id uuid;\r\nBEGIN\r\n    -- محاولة الإدراج (إذا كان idempotency_key موجوداً، سينتج unique_violation)\r\n    INSERT INTO app_rewards.reward_transactions (\r\n        user_id, event_id, rule_id, reward_type, amount, value,\r\n        asset_code, source_type, source_id, idempotency_key,\r\n        metadata, rule_snapshot, status, earned_at\r\n    ) VALUES (\r\n        p_user_id, p_event_id, p_rule_id, p_reward_type, p_amount, p_value,\r\n        p_asset_code, p_source_type, p_source_id, p_idempotency_key,\r\n        p_metadata, p_rule_snapshot, 'granted', now()\r\n    )\r\n    RETURNING id INTO v_transaction_id;\r\n    RETURN v_transaction_id;\r\nEXCEPTION WHEN unique_violation THEN\r\n    -- المفتاح موجود مسبقاً -> نعيد المعاملة القديمة\r\n    SELECT id INTO v_transaction_id\r\n    FROM app_rewards.reward_transactions\r\n    WHERE idempotency_key = p_idempotency_key;\r\n    RETURN v_transaction_id;\r\nEND;\r\n$function$\n",
        "returns": "uuid",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_user_id",
            "type": "uuid"
          },
          {
            "name": "p_event_id",
            "type": "uuid"
          },
          {
            "name": "p_rule_id",
            "type": "uuid"
          },
          {
            "name": "p_reward_type",
            "type": "text"
          },
          {
            "name": "p_idempotency_key",
            "type": "text"
          },
          {
            "name": "p_amount",
            "type": "numeric"
          },
          {
            "name": "p_value",
            "type": "text"
          },
          {
            "name": "p_asset_code",
            "type": "text"
          },
          {
            "name": "p_source_type",
            "type": "text"
          },
          {
            "name": "p_source_id",
            "type": "uuid"
          },
          {
            "name": "p_metadata",
            "type": "jsonb"
          },
          {
            "name": "p_rule_snapshot",
            "type": "jsonb"
          }
        ]
      },
      {
        "name": "is_valid_reward_config",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.is_valid_reward_config(config jsonb)\n RETURNS boolean\n LANGUAGE plpgsql\n IMMUTABLE\nAS $function$\r\nBEGIN\r\n    RETURN (config ? 'amount' AND (config->>'amount') ~ '^[0-9]+\\.?[0-9]*$')\r\n        OR (config ? 'rewards' AND jsonb_typeof(config->'rewards') = 'array');\r\nEND;\r\n$function$\n",
        "returns": "boolean",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "config",
            "type": "jsonb"
          }
        ]
      },
      {
        "name": "log_processing_step",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.log_processing_step(p_event_id uuid, p_step text, p_status text, p_details jsonb DEFAULT NULL::jsonb, p_error text DEFAULT NULL::text, p_trace_id uuid DEFAULT NULL::uuid)\n RETURNS void\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    INSERT INTO app_rewards.processing_log (event_id, step, status, details, error_message, trace_id)\r\n    VALUES (p_event_id, p_step, p_status, p_details, p_error, p_trace_id);\r\nEND;\r\n$function$\n",
        "returns": "void",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_event_id",
            "type": "uuid"
          },
          {
            "name": "p_step",
            "type": "text"
          },
          {
            "name": "p_status",
            "type": "text"
          },
          {
            "name": "p_details",
            "type": "jsonb"
          },
          {
            "name": "p_error",
            "type": "text"
          },
          {
            "name": "p_trace_id",
            "type": "uuid"
          }
        ]
      },
      {
        "name": "process_reward_event",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.process_reward_event(p_limit integer DEFAULT 10)\n RETURNS TABLE(processed_event_id uuid, transaction_id uuid, action_taken text)\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_event app_rewards.reward_events%ROWTYPE;\r\n    v_trace_id uuid;\r\n    v_result RECORD;\r\nBEGIN\r\n    FOR v_event IN SELECT * FROM app_rewards.fetch_next_events(p_limit)\r\n    LOOP\r\n        v_trace_id := gen_random_uuid();\r\n        FOR v_result IN SELECT * FROM app_rewards.process_single_event(v_event.id, v_trace_id)\r\n        LOOP\r\n            processed_event_id := v_event.id;\r\n            transaction_id := v_result.transaction_id;\r\n            action_taken := v_result.action_taken;\r\n            RETURN NEXT;\r\n        END LOOP;\r\n    END LOOP;\r\nEND;\r\n$function$\n",
        "returns": "record",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_limit",
            "type": "integer"
          },
          {
            "name": "processed_event_id",
            "type": null
          },
          {
            "name": "transaction_id",
            "type": null
          },
          {
            "name": "action_taken",
            "type": null
          }
        ]
      },
      {
        "name": "process_single_event",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.process_single_event(p_event_id uuid, p_trace_id uuid DEFAULT gen_random_uuid())\n RETURNS TABLE(transaction_id uuid, action_taken text)\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_event app_rewards.reward_events%ROWTYPE;\r\n    v_rule RECORD;\r\n    v_calc RECORD;\r\n    v_transaction_id uuid;\r\n    v_action text;\r\n    v_now timestamptz := now();\r\n    v_retry_count int;\r\n    v_max_retries int;\r\n    v_reward_type text;\r\nBEGIN\r\n    SELECT * INTO v_event FROM app_rewards.reward_events WHERE id = p_event_id FOR UPDATE;\r\n    IF NOT FOUND THEN\r\n        RETURN;\r\n    END IF;\r\n    \r\n    PERFORM app_rewards.log_processing_step(p_event_id, 'process', 'start', jsonb_build_object('status', v_event.status), NULL, p_trace_id);\r\n    \r\n    UPDATE app_rewards.reward_events SET status = 'processing', processing_started_at = v_now WHERE id = p_event_id;\r\n    \r\n    -- resolve rule\r\n    SELECT * INTO v_rule FROM app_rewards.resolve_rule(v_event.event_id);\r\n    IF NOT FOUND THEN\r\n        UPDATE app_rewards.reward_events SET status = 'failed', last_error = 'No active rule found', completed_at = v_now WHERE id = p_event_id;\r\n        PERFORM app_rewards.log_processing_step(p_event_id, 'resolve_rule', 'failure', NULL, 'No active rule found', p_trace_id);\r\n        transaction_id := NULL; action_taken := 'no_rule'; RETURN NEXT;\r\n        RETURN;\r\n    END IF;\r\n    PERFORM app_rewards.log_processing_step(p_event_id, 'resolve_rule', 'success', jsonb_build_object('rule_id', v_rule.rule_id), NULL, p_trace_id);\r\n    \r\n    -- calculate reward\r\n    BEGIN\r\n        SELECT * INTO v_calc FROM app_rewards.calculate_reward(v_rule.rule_config);\r\n        PERFORM app_rewards.log_processing_step(p_event_id, 'calculate', 'success', jsonb_build_object('amount', v_calc.amount), NULL, p_trace_id);\r\n    EXCEPTION WHEN OTHERS THEN\r\n        UPDATE app_rewards.reward_events SET status = 'failed', last_error = SQLERRM, completed_at = v_now WHERE id = p_event_id;\r\n        PERFORM app_rewards.log_processing_step(p_event_id, 'calculate', 'failure', NULL, SQLERRM, p_trace_id);\r\n        transaction_id := NULL; action_taken := 'calc_error'; RETURN NEXT;\r\n        RETURN;\r\n    END;\r\n    \r\n    -- استخراج reward_type من الـ config (افتراضي 'point')\r\n    v_reward_type := COALESCE(v_rule.reward_config->>'reward_type', v_rule.reward_config->>'type', 'point');\r\n    \r\n    -- grant transaction\r\n    BEGIN\r\n        v_transaction_id := app_rewards.grant_reward_transaction(\r\n            p_user_id => v_event.user_id,\r\n            p_event_id => v_event.event_id,\r\n            p_rule_id => v_rule.rule_id,\r\n            p_reward_type => v_reward_type,\r\n            p_idempotency_key => v_event.id::text || ':' || v_rule.rule_id::text,\r\n            p_amount => v_calc.amount,\r\n            p_value => v_calc.value,\r\n            p_asset_code => v_calc.asset_code,\r\n            p_source_type => 'reward_event',\r\n            p_source_id => v_event.id,\r\n            p_metadata => v_event.metadata,\r\n            p_rule_snapshot => v_rule.rule_snapshot\r\n        );\r\n        UPDATE app_rewards.reward_events SET status = 'completed', completed_at = v_now WHERE id = p_event_id;\r\n        PERFORM app_rewards.log_processing_step(p_event_id, 'grant', 'success', jsonb_build_object('transaction_id', v_transaction_id), NULL, p_trace_id);\r\n        v_action := 'granted';\r\n    EXCEPTION WHEN OTHERS THEN\r\n        v_action := 'failed_retry';\r\n        v_transaction_id := NULL;\r\n        PERFORM app_rewards.log_processing_step(p_event_id, 'grant', 'failure', NULL, SQLERRM, p_trace_id);\r\n        \r\n        v_retry_count := COALESCE(v_event.retry_count, 0);\r\n        v_max_retries := COALESCE(v_event.max_retries, 3);\r\n        \r\n        IF v_retry_count + 1 >= v_max_retries THEN\r\n            -- آخر محاولة أو تجاوز الحد: ننهيها كـ failed\r\n            UPDATE app_rewards.reward_events\r\n            SET status = 'failed',\r\n                retry_count = v_retry_count + 1,\r\n                last_error = SQLERRM,\r\n                completed_at = v_now\r\n            WHERE id = p_event_id;\r\n            v_action := 'failed_final';\r\n        ELSE\r\n            UPDATE app_rewards.reward_events\r\n            SET status = 'retrying',\r\n                retry_count = v_retry_count + 1,\r\n                last_error = SQLERRM,\r\n                next_retry_at = app_rewards.calc_next_retry_at(2, v_retry_count + 1)\r\n            WHERE id = p_event_id;\r\n        END IF;\r\n    END;\r\n    \r\n    transaction_id := v_transaction_id;\r\n    action_taken := v_action;\r\n    RETURN NEXT;\r\nEND;\r\n$function$\n",
        "returns": "record",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_event_id",
            "type": "uuid"
          },
          {
            "name": "p_trace_id",
            "type": "uuid"
          },
          {
            "name": "transaction_id",
            "type": null
          },
          {
            "name": "action_taken",
            "type": null
          }
        ]
      },
      {
        "name": "refresh_reward_ledger_mv",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.refresh_reward_ledger_mv()\n RETURNS void\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    REFRESH MATERIALIZED VIEW CONCURRENTLY app_rewards.reward_ledger_mv;\r\nEND;\r\n$function$\n",
        "returns": "void",
        "language": "plpgsql",
        "arguments": null
      },
      {
        "name": "resolve_rule",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.resolve_rule(p_event_id uuid)\n RETURNS TABLE(rule_id uuid, rule_version integer, rule_config jsonb, rule_snapshot jsonb, starts_at timestamp with time zone, expires_at timestamp with time zone)\n LANGUAGE plpgsql\n STABLE\nAS $function$\r\nBEGIN\r\n    RETURN QUERY\r\n    SELECT\r\n        rv.id,\r\n        rv.version,\r\n        rv.reward_config,\r\n        jsonb_build_object(\r\n            'id', rv.id,\r\n            'event_id', rv.event_id,\r\n            'version', rv.version,\r\n            'reward_config', rv.reward_config,\r\n            'starts_at', rv.starts_at,\r\n            'expires_at', rv.expires_at\r\n        ) AS rule_snapshot,\r\n        rv.starts_at,\r\n        rv.expires_at\r\n    FROM app_rewards.reward_rule_versions rv\r\n    WHERE rv.event_id = p_event_id\r\n      AND rv.is_active = true\r\n      AND rv.is_deleted = false\r\n      AND (rv.starts_at IS NULL OR rv.starts_at <= now())\r\n      AND (rv.expires_at IS NULL OR rv.expires_at > now())\r\n    ORDER BY rv.version DESC\r\n    LIMIT 1;\r\nEND;\r\n$function$\n",
        "returns": "record",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_event_id",
            "type": "uuid"
          },
          {
            "name": "rule_id",
            "type": null
          },
          {
            "name": "rule_version",
            "type": null
          },
          {
            "name": "rule_config",
            "type": null
          },
          {
            "name": "rule_snapshot",
            "type": null
          },
          {
            "name": "starts_at",
            "type": null
          },
          {
            "name": "expires_at",
            "type": null
          }
        ]
      },
      {
        "name": "soft_delete_reward_rule",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.soft_delete_reward_rule(p_rule_id uuid, p_changed_by uuid DEFAULT NULL::uuid)\n RETURNS jsonb\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$declare\r\n    v_rule app_rewards.reward_rule_versions%rowtype;\r\nbegin\r\n    -- =========================================\r\n    -- GET RULE\r\n    -- =========================================\r\n    select *\r\n    into v_rule\r\n    from app_rewards.reward_rule_versions\r\n    where id = p_rule_id;\r\n\r\n    if not found then\r\n        return jsonb_build_object(\r\n            'success', false,\r\n            'error', 'RULE_NOT_FOUND'\r\n        );\r\n    end if;\r\n\r\n    -- =========================================\r\n    -- SOFT DELETE\r\n    -- =========================================\r\n    update app_rewards.reward_rule_versions\r\n    set\r\n        is_deleted = true,\r\n        is_active = false,\r\n        updated_at = now(),\r\n        updated_by = p_changed_by\r\n    where id = p_rule_id;\r\n\r\n    -- =========================================\r\n    -- AUDIT LOG\r\n    -- =========================================\r\n    insert into app_rewards.reward_rule_audit_log (\r\n        rule_id,\r\n        event_name,\r\n        action_type,\r\n        old_version,\r\n        new_version,\r\n        changed_by,\r\n        old_reward_config,\r\n        metadata\r\n    ) values (\r\n        p_rule_id,\r\n        v_rule.event_name,\r\n        'update',\r\n        v_rule.version,\r\n        v_rule.version,\r\n        p_changed_by,\r\n        v_rule.reward_config,\r\n        jsonb_build_object(\r\n            'is_deleted', true\r\n        )\r\n    );\r\n\r\n    -- =========================================\r\n    -- SUCCESS\r\n    -- =========================================\r\n    return jsonb_build_object(\r\n        'success', true,\r\n        'data', jsonb_build_object(\r\n            'rule_id', p_rule_id,\r\n            'event_name', v_rule.event_name,\r\n            'version', v_rule.version,\r\n            'rule_name', v_rule.rule_name,   -- ✅ تمت الإضافة\r\n            'deleted_at', now()\r\n        )\r\n    );\r\nend;$function$\n",
        "returns": "jsonb",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_rule_id",
            "type": "uuid"
          },
          {
            "name": "p_changed_by",
            "type": "uuid"
          }
        ]
      },
      {
        "name": "update_reward_rule",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.update_reward_rule(p_rule_id uuid, p_rule_name text DEFAULT NULL::text, p_reward_config jsonb DEFAULT NULL::jsonb, p_title text DEFAULT NULL::text, p_description text DEFAULT NULL::text, p_is_active boolean DEFAULT NULL::boolean, p_starts_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_expires_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_published_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_updated_by uuid DEFAULT NULL::uuid)\n RETURNS jsonb\n LANGUAGE plpgsql\n SECURITY DEFINER\nAS $function$declare\r\n    v_old_rule app_rewards.reward_rule_versions%rowtype;\r\nbegin\r\n    -- =========================================\r\n    -- GET OLD RULE\r\n    -- =========================================\r\n    select *\r\n    into v_old_rule\r\n    from app_rewards.reward_rule_versions\r\n    where id = p_rule_id;\r\n\r\n    if not found then\r\n        return jsonb_build_object(\r\n            'success', false,\r\n            'error', 'RULE_NOT_FOUND'\r\n        );\r\n    end if;\r\n\r\n    -- =========================================\r\n    -- HANDLE ACTIVE SWITCH\r\n    -- =========================================\r\n    if p_is_active = true then\r\n        update app_rewards.reward_rule_versions\r\n        set\r\n            is_active = false,\r\n            updated_at = now(),\r\n            updated_by = p_updated_by\r\n        where event_name = v_old_rule.event_name\r\n          and is_active = true\r\n          and id <> p_rule_id;\r\n    end if;\r\n\r\n    -- =========================================\r\n    -- UPDATE RULE\r\n    -- =========================================\r\n    update app_rewards.reward_rule_versions\r\n    set\r\n        rule_name = coalesce(p_rule_name, rule_name),          -- ✅ تحديث الاسم\r\n        reward_config = coalesce(p_reward_config, reward_config),\r\n        title = coalesce(p_title, title),\r\n        description = coalesce(p_description, description),\r\n        is_active = coalesce(p_is_active, is_active),\r\n        starts_at = coalesce(p_starts_at, starts_at),\r\n        expires_at = coalesce(p_expires_at, expires_at),\r\n        published_at = coalesce(p_published_at, published_at),\r\n        updated_at = now(),\r\n        updated_by = p_updated_by\r\n    where id = p_rule_id;\r\n\r\n    -- =========================================\r\n    -- AUDIT LOG\r\n    -- =========================================\r\n    insert into app_rewards.reward_rule_audit_log (\r\n        rule_id,\r\n        event_name,\r\n        action_type,\r\n        old_version,\r\n        new_version,\r\n        changed_by,\r\n        old_reward_config,\r\n        new_reward_config\r\n    ) values (\r\n        p_rule_id,\r\n        v_old_rule.event_name,\r\n        'update',\r\n        v_old_rule.version,\r\n        v_old_rule.version,\r\n        p_updated_by,\r\n        v_old_rule.reward_config,\r\n        coalesce(p_reward_config, v_old_rule.reward_config)\r\n    );\r\n\r\n    -- =========================================\r\n    -- SUCCESS\r\n    -- =========================================\r\n    return jsonb_build_object(\r\n        'success', true,\r\n        'data', jsonb_build_object(\r\n            'rule_id', p_rule_id,\r\n            'event_name', v_old_rule.event_name,\r\n            'version', v_old_rule.version,\r\n            'rule_name', coalesce(p_rule_name, v_old_rule.rule_name)  -- ✅ إضافة الاسم إلى الرد\r\n        )\r\n    );\r\nend;$function$\n",
        "returns": "jsonb",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_rule_id",
            "type": "uuid"
          },
          {
            "name": "p_rule_name",
            "type": "text"
          },
          {
            "name": "p_reward_config",
            "type": "jsonb"
          },
          {
            "name": "p_title",
            "type": "text"
          },
          {
            "name": "p_description",
            "type": "text"
          },
          {
            "name": "p_is_active",
            "type": "boolean"
          },
          {
            "name": "p_starts_at",
            "type": "timestamp with time zone"
          },
          {
            "name": "p_expires_at",
            "type": "timestamp with time zone"
          },
          {
            "name": "p_published_at",
            "type": "timestamp with time zone"
          },
          {
            "name": "p_updated_by",
            "type": "uuid"
          }
        ]
      },
      {
        "name": "validate_and_snapshot_rule",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.validate_and_snapshot_rule()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    IF NEW.rule_id IS NOT NULL AND NEW.rule_snapshot IS NULL THEN\r\n        SELECT jsonb_build_object(\r\n            'id', rv.id,\r\n            'event_id', rv.event_id,\r\n            'version', rv.version,\r\n            'reward_config', rv.reward_config,\r\n            'starts_at', rv.starts_at,\r\n            'expires_at', rv.expires_at\r\n        ) INTO NEW.rule_snapshot\r\n        FROM app_rewards.reward_rule_versions rv\r\n        WHERE rv.id = NEW.rule_id\r\n          AND rv.is_active = true\r\n          AND (rv.starts_at IS NULL OR rv.starts_at <= now())\r\n          AND (rv.expires_at IS NULL OR rv.expires_at > now())\r\n          AND rv.is_deleted = false;\r\n    END IF;\r\n    RETURN NEW;\r\nEND;\r\n$function$\n",
        "returns": "trigger",
        "language": "plpgsql",
        "arguments": null
      },
      {
        "name": "validate_reward_config_details",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.validate_reward_config_details()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_item jsonb;\r\n    v_type text;\r\nBEGIN\r\n    IF NOT (NEW.reward_config ? 'amount' OR NEW.reward_config ? 'rewards') THEN\r\n        RAISE EXCEPTION 'reward_config must contain either \"amount\" or \"rewards\" key';\r\n    END IF;\r\n    \r\n    IF NEW.reward_config ? 'amount' THEN\r\n        IF NOT (NEW.reward_config->>'amount') ~ '^[0-9]+\\.?[0-9]*$' THEN\r\n            RAISE EXCEPTION 'Invalid amount in reward_config: %', NEW.reward_config->>'amount';\r\n        END IF;\r\n    END IF;\r\n    \r\n    IF NEW.reward_config ? 'rewards' THEN\r\n        IF jsonb_typeof(NEW.reward_config->'rewards') != 'array' THEN\r\n            RAISE EXCEPTION 'rewards must be an array';\r\n        END IF;\r\n        FOR i IN 0..jsonb_array_length(NEW.reward_config->'rewards') - 1 LOOP\r\n            v_item := NEW.reward_config->'rewards'->i;\r\n            v_type := v_item->>'type';\r\n            IF v_type IS NULL THEN\r\n                RAISE EXCEPTION 'Each reward in array must have a \"type\" field';\r\n            END IF;\r\n            IF NOT EXISTS (SELECT 1 FROM app_rewards.allowed_reward_types WHERE reward_type = v_type AND is_active = true) THEN\r\n                RAISE EXCEPTION 'Reward type \"%\" is not allowed', v_type;\r\n            END IF;\r\n        END LOOP;\r\n    END IF;\r\n    \r\n    RETURN NEW;\r\nEND;\r\n$function$\n",
        "returns": "trigger",
        "language": "plpgsql",
        "arguments": null
      },
      {
        "name": "write_audit_log",
        "schema": "app_rewards",
        "source": "CREATE OR REPLACE FUNCTION app_rewards.write_audit_log(p_rule_id uuid, p_action_type text, p_old_version integer, p_new_version integer, p_changed_by uuid, p_old_reward_config jsonb DEFAULT NULL::jsonb, p_new_reward_config jsonb DEFAULT NULL::jsonb, p_metadata jsonb DEFAULT '{}'::jsonb, p_event_id uuid DEFAULT NULL::uuid, p_transaction_id uuid DEFAULT NULL::uuid, p_request_id uuid DEFAULT NULL::uuid, p_trace_id uuid DEFAULT NULL::uuid)\n RETURNS void\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    IF p_action_type NOT IN ('create', 'update', 'activate', 'deactivate') THEN\r\n        RAISE EXCEPTION 'Invalid action_type: %', p_action_type;\r\n    END IF;\r\n\r\n    INSERT INTO app_rewards.reward_rule_audit_log (\r\n        rule_id, action_type, old_version, new_version, changed_by,\r\n        old_reward_config, new_reward_config, metadata,\r\n        event_id, transaction_id, request_id, trace_id\r\n    ) VALUES (\r\n        p_rule_id, p_action_type, p_old_version, p_new_version, p_changed_by,\r\n        p_old_reward_config, p_new_reward_config, p_metadata,\r\n        p_event_id, p_transaction_id, p_request_id, p_trace_id\r\n    );\r\nEND;\r\n$function$\n",
        "returns": "void",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_rule_id",
            "type": "uuid"
          },
          {
            "name": "p_action_type",
            "type": "text"
          },
          {
            "name": "p_old_version",
            "type": "integer"
          },
          {
            "name": "p_new_version",
            "type": "integer"
          },
          {
            "name": "p_changed_by",
            "type": "uuid"
          },
          {
            "name": "p_old_reward_config",
            "type": "jsonb"
          },
          {
            "name": "p_new_reward_config",
            "type": "jsonb"
          },
          {
            "name": "p_metadata",
            "type": "jsonb"
          },
          {
            "name": "p_event_id",
            "type": "uuid"
          },
          {
            "name": "p_transaction_id",
            "type": "uuid"
          },
          {
            "name": "p_request_id",
            "type": "uuid"
          },
          {
            "name": "p_trace_id",
            "type": "uuid"
          }
        ]
      }
    ]
  },
  {
    "object_type": "triggers",
    "sort_order": 5,
    "data": [
      {
        "name": "trg_validate_reward_config_details",
        "table": "reward_rule_versions",
        "schema": "app_rewards",
        "definition": "CREATE TRIGGER trg_validate_reward_config_details BEFORE INSERT OR UPDATE OF reward_config ON app_rewards.reward_rule_versions FOR EACH ROW EXECUTE FUNCTION app_rewards.validate_reward_config_details()"
      },
      {
        "name": "trg_reward_transactions_validate_snapshot",
        "table": "reward_transactions",
        "schema": "app_rewards",
        "definition": "CREATE TRIGGER trg_reward_transactions_validate_snapshot BEFORE INSERT ON app_rewards.reward_transactions FOR EACH ROW EXECUTE FUNCTION app_rewards.validate_and_snapshot_rule()"
      }
    ]
  },
  {
    "object_type": "policies",
    "sort_order": 6,
    "data": [
      {
        "name": "Users can insert own reward_events",
        "roles": null,
        "table": "reward_events",
        "using": null,
        "schema": "app_rewards",
        "raw_sql": null,
        "operation": "INSERT",
        "with_check": "(auth.uid() = internal_user_id)"
      },
      {
        "name": "Users can view own reward_events",
        "roles": null,
        "table": "reward_events",
        "using": "(auth.uid() = internal_user_id)",
        "schema": "app_rewards",
        "raw_sql": null,
        "operation": "SELECT",
        "with_check": null
      },
      {
        "name": "Anyone can view registry",
        "roles": null,
        "table": "reward_events_registry",
        "using": "true",
        "schema": "app_rewards",
        "raw_sql": null,
        "operation": "SELECT",
        "with_check": null
      },
      {
        "name": "Admins can view audit log",
        "roles": null,
        "table": "reward_rule_audit_log",
        "using": "(auth.role() = 'service_role'::text)",
        "schema": "app_rewards",
        "raw_sql": null,
        "operation": "SELECT",
        "with_check": null
      },
      {
        "name": "Admins can manage rules",
        "roles": null,
        "table": "reward_rule_versions",
        "using": "(auth.role() = 'service_role'::text)",
        "schema": "app_rewards",
        "raw_sql": null,
        "operation": "ALL",
        "with_check": null
      },
      {
        "name": "Anyone can view reward rules",
        "roles": null,
        "table": "reward_rule_versions",
        "using": "true",
        "schema": "app_rewards",
        "raw_sql": null,
        "operation": "SELECT",
        "with_check": null
      },
      {
        "name": "Users can view own reward_transactions",
        "roles": null,
        "table": "reward_transactions",
        "using": "(auth.uid() = internal_user_id)",
        "schema": "app_rewards",
        "raw_sql": null,
        "operation": "SELECT",
        "with_check": null
      }
    ]
  }
]

