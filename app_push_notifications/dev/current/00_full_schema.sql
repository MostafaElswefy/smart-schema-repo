[
  {
    "object_type": "schema_metadata",
    "sort_order": 0,
    "data": {
      "schema": "app_push_notifications",
      "version": "1.0.0",
      "exported_at": "2026-05-17T21:09:10.968613+00:00",
      "module_name": "rewards_engine",
      "business_purpose": "Reward management and processing"
    }
  },
  {
    "object_type": "enums",
    "sort_order": 1,
    "data": [
      {
        "name": "audit_triggered_by_type",
        "schema": "app_push_notifications",
        "values": "'rpc', 'system', 'admin', 'scheduler'",
        "raw_sql": "CREATE TYPE app_push_notifications.audit_triggered_by_type AS ENUM ('rpc', 'system', 'admin', 'scheduler');"
      },
      {
        "name": "dead_letter_final_status",
        "schema": "app_push_notifications",
        "values": "'failed', 'retried_max', 'resolved'",
        "raw_sql": "CREATE TYPE app_push_notifications.dead_letter_final_status AS ENUM ('failed', 'retried_max', 'resolved');"
      },
      {
        "name": "device_platform",
        "schema": "app_push_notifications",
        "values": "'android', 'ios', 'web'",
        "raw_sql": "CREATE TYPE app_push_notifications.device_platform AS ENUM ('android', 'ios', 'web');"
      },
      {
        "name": "push_notification_status",
        "schema": "app_push_notifications",
        "values": "'pending', 'processing', 'sent', 'failed', 'dead_letter'",
        "raw_sql": "CREATE TYPE app_push_notifications.push_notification_status AS ENUM ('pending', 'processing', 'sent', 'failed', 'dead_letter');"
      },
      {
        "name": "push_priority_type",
        "schema": "app_push_notifications",
        "values": "'normal', 'high'",
        "raw_sql": "CREATE TYPE app_push_notifications.push_priority_type AS ENUM ('normal', 'high');"
      },
      {
        "name": "push_target_type",
        "schema": "app_push_notifications",
        "values": "'user', 'broadcast', 'segment'",
        "raw_sql": "CREATE TYPE app_push_notifications.push_target_type AS ENUM ('user', 'broadcast', 'segment');"
      },
      {
        "name": "token_status_type",
        "schema": "app_push_notifications",
        "values": "'active', 'invalid', 'refreshed'",
        "raw_sql": "CREATE TYPE app_push_notifications.token_status_type AS ENUM ('active', 'invalid', 'refreshed');"
      }
    ]
  },
  {
    "object_type": "tables",
    "sort_order": 2,
    "data": [
      {
        "name": "dead_letter_queue",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "queue_id",
            "type": "uuid",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "event_key",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "internal_user_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "app_id",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "payload",
            "type": "jsonb",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "target_type",
            "type": "USER-DEFINED",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "target_filters",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "final_status",
            "type": "USER-DEFINED",
            "default": null,
            "nullable": false,
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
            "name": "error_code",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "retry_count",
            "type": "integer",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "archived_at",
            "type": "timestamp with time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "failure_category",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "replayable",
            "type": "boolean",
            "default": "false",
            "nullable": true,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_dlq_created",
            "unique": false,
            "definition": "CREATE INDEX idx_dlq_created ON app_push_notifications.dead_letter_queue USING btree (created_at DESC)"
          },
          {
            "name": "idx_dlq_queue",
            "unique": false,
            "definition": "CREATE INDEX idx_dlq_queue ON app_push_notifications.dead_letter_queue USING btree (queue_id)"
          },
          {
            "name": "idx_dlq_replayable",
            "unique": false,
            "definition": "CREATE INDEX idx_dlq_replayable ON app_push_notifications.dead_letter_queue USING btree (replayable, created_at)"
          },
          {
            "name": "idx_dlq_user",
            "unique": false,
            "definition": "CREATE INDEX idx_dlq_user ON app_push_notifications.dead_letter_queue USING btree (internal_user_id)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.dead_letter_queue (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    queue_id uuid NOT NULL,\n    event_key text NOT NULL,\n    internal_user_id uuid,\n    app_id text,\n    payload jsonb NOT NULL,\n    target_type USER-DEFINED NOT NULL,\n    target_filters jsonb,\n    final_status USER-DEFINED NOT NULL,\n    error_message text,\n    error_code text,\n    retry_count integer NOT NULL,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    archived_at timestamp with time zone,\n    failure_category text,\n    replayable boolean DEFAULT false,\n    CONSTRAINT dead_letter_queue_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "fk_dlq_queue",
            "columns": [
              "queue_id"
            ],
            "on_delete": "SET NULL",
            "on_update": "",
            "ref_table": "push_queue",
            "ref_schema": "app_push_notifications",
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
        "name": "delivery_attempts",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "queue_id",
            "type": "uuid",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "attempt_no",
            "type": "integer",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "status",
            "type": "USER-DEFINED",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "retry_reason",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "latency_ms",
            "type": "integer",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "provider_status",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "provider_response",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_delivery_attempts_queue",
            "unique": false,
            "definition": "CREATE INDEX idx_delivery_attempts_queue ON app_push_notifications.delivery_attempts USING btree (queue_id)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.delivery_attempts (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    queue_id uuid NOT NULL,\n    attempt_no integer NOT NULL,\n    status USER-DEFINED NOT NULL,\n    retry_reason text,\n    latency_ms integer,\n    provider_status text,\n    provider_response jsonb,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    CONSTRAINT delivery_attempts_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "delivery_attempts_queue_id_fkey",
            "columns": [
              "queue_id"
            ],
            "on_delete": "CASCADE",
            "on_update": "",
            "ref_table": "push_queue",
            "ref_schema": "app_push_notifications",
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
        "name": "device_tokens",
        "schema": "app_push_notifications",
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
            "name": "device_id",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "app_id",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "fcm_token",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "last_seen_at",
            "type": "timestamp with time zone",
            "default": "now()",
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
            "name": "last_token_update",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "platform",
            "type": "USER-DEFINED",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "token_status",
            "type": "USER-DEFINED",
            "default": "'active'::app_push_notifications.token_status_type",
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_device_tokens_token",
            "unique": false,
            "definition": "CREATE INDEX idx_device_tokens_token ON app_push_notifications.device_tokens USING btree (fcm_token)"
          },
          {
            "name": "idx_device_tokens_user_status",
            "unique": false,
            "definition": "CREATE INDEX idx_device_tokens_user_status ON app_push_notifications.device_tokens USING btree (internal_user_id, token_status)"
          },
          {
            "name": "idx_fcm_token_app",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX idx_fcm_token_app ON app_push_notifications.device_tokens USING btree (fcm_token, app_id)"
          },
          {
            "name": "unique_user_device",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX unique_user_device ON app_push_notifications.device_tokens USING btree (internal_user_id, device_id)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.device_tokens (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    internal_user_id uuid NOT NULL,\n    device_id text NOT NULL,\n    app_id text NOT NULL,\n    fcm_token text NOT NULL,\n    last_seen_at timestamp with time zone DEFAULT now(),\n    created_at timestamp with time zone DEFAULT now(),\n    updated_at timestamp with time zone DEFAULT now(),\n    last_token_update timestamp with time zone DEFAULT now(),\n    platform USER-DEFINED NOT NULL,\n    token_status USER-DEFINED NOT NULL DEFAULT 'active'::app_push_notifications.token_status_type,\n    CONSTRAINT device_tokens_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "fk_device_tokens_app",
            "columns": [
              "app_id"
            ],
            "on_delete": "",
            "on_update": "",
            "ref_table": "app_registry",
            "ref_schema": "public",
            "ref_columns": [
              "app_id"
            ]
          },
          {
            "name": "fk_device_tokens_user",
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
        "check_constraints": null,
        "unique_constraints": [
          {
            "name": "unique_user_device",
            "columns": [
              "internal_user_id",
              "device_id"
            ]
          }
        ]
      },
      {
        "name": "push_audit_log",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "event_key",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "payload_snapshot",
            "type": "jsonb",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "target_type",
            "type": "USER-DEFINED",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "target_filters",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "queue_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "triggered_by",
            "type": "USER-DEFINED",
            "default": null,
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_push_audit_created",
            "unique": false,
            "definition": "CREATE INDEX idx_push_audit_created ON app_push_notifications.push_audit_log USING btree (created_at DESC)"
          },
          {
            "name": "idx_push_audit_event_key",
            "unique": false,
            "definition": "CREATE INDEX idx_push_audit_event_key ON app_push_notifications.push_audit_log USING btree (event_key)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.push_audit_log (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    event_key text NOT NULL,\n    payload_snapshot jsonb NOT NULL,\n    target_type USER-DEFINED NOT NULL,\n    target_filters jsonb,\n    queue_id uuid,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    triggered_by USER-DEFINED NOT NULL,\n    CONSTRAINT push_audit_log_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "fk_push_audit_queue",
            "columns": [
              "queue_id"
            ],
            "on_delete": "SET NULL",
            "on_update": "",
            "ref_table": "push_queue",
            "ref_schema": "app_push_notifications",
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
        "name": "push_event_versions",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "event_key",
            "type": "text",
            "default": null,
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
            "name": "title",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "body",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "category",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "priority",
            "type": "USER-DEFINED",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "default_data",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "is_active",
            "type": "boolean",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "created_by",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "push_event_versions_event_key_version_key",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX push_event_versions_event_key_version_key ON app_push_notifications.push_event_versions USING btree (event_key, version)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.push_event_versions (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    event_key text NOT NULL,\n    version integer NOT NULL,\n    title text,\n    body text,\n    category text,\n    priority USER-DEFINED,\n    default_data jsonb,\n    is_active boolean,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    created_by text,\n    CONSTRAINT push_event_versions_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": null,
        "business_purpose": null,
        "check_constraints": null,
        "unique_constraints": [
          {
            "name": "push_event_versions_event_key_version_key",
            "columns": [
              "event_key",
              "version"
            ]
          }
        ]
      },
      {
        "name": "push_events",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "event_key",
            "type": "text",
            "default": null,
            "nullable": false,
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
            "name": "body",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "category",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "default_data",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "is_active",
            "type": "boolean",
            "default": "true",
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
            "name": "updated_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "priority",
            "type": "USER-DEFINED",
            "default": "'normal'::app_push_notifications.push_priority_type",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "version",
            "type": "integer",
            "default": "1",
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "push_events_event_key_key",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX push_events_event_key_key ON app_push_notifications.push_events USING btree (event_key)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.push_events (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    event_key text NOT NULL,\n    title text,\n    body text,\n    category text,\n    default_data jsonb,\n    is_active boolean NOT NULL DEFAULT true,\n    created_at timestamp with time zone DEFAULT now(),\n    updated_at timestamp with time zone DEFAULT now(),\n    priority USER-DEFINED DEFAULT 'normal'::app_push_notifications.push_priority_type,\n    version integer NOT NULL DEFAULT 1,\n    CONSTRAINT push_events_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": null,
        "business_purpose": null,
        "check_constraints": null,
        "unique_constraints": [
          {
            "name": "push_events_event_key_key",
            "columns": [
              "event_key"
            ]
          }
        ]
      },
      {
        "name": "push_failures",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "queue_id",
            "type": "uuid",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "reason",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "error_code",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "resolved",
            "type": "boolean",
            "default": "false",
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
            "name": "idx_push_failures_queue",
            "unique": false,
            "definition": "CREATE INDEX idx_push_failures_queue ON app_push_notifications.push_failures USING btree (queue_id) WHERE (resolved = false)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.push_failures (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    queue_id uuid NOT NULL,\n    reason text,\n    error_code text,\n    resolved boolean DEFAULT false,\n    created_at timestamp with time zone DEFAULT now(),\n    CONSTRAINT push_failures_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "fk_push_failures_queue",
            "columns": [
              "queue_id"
            ],
            "on_delete": "CASCADE",
            "on_update": "",
            "ref_table": "push_queue",
            "ref_schema": "app_push_notifications",
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
        "name": "push_metrics",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "event_key",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "date",
            "type": "date",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "total_sent",
            "type": "integer",
            "default": "0",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "total_failed",
            "type": "integer",
            "default": "0",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "avg_latency_ms",
            "type": "numeric",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "updated_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "push_metrics_event_key_date_key",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX push_metrics_event_key_date_key ON app_push_notifications.push_metrics USING btree (event_key, date)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.push_metrics (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    event_key text NOT NULL,\n    date date NOT NULL,\n    total_sent integer NOT NULL DEFAULT 0,\n    total_failed integer NOT NULL DEFAULT 0,\n    avg_latency_ms numeric,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    updated_at timestamp with time zone NOT NULL DEFAULT now(),\n    CONSTRAINT push_metrics_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": null,
        "business_purpose": null,
        "check_constraints": null,
        "unique_constraints": [
          {
            "name": "push_metrics_event_key_date_key",
            "columns": [
              "event_key",
              "date"
            ]
          }
        ]
      },
      {
        "name": "push_queue",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "event_key",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "internal_user_id",
            "type": "uuid",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "app_id",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "payload",
            "type": "jsonb",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "retry_count",
            "type": "integer",
            "default": "0",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "scheduled_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "sent_at",
            "type": "timestamp with time zone",
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
            "name": "target_filters",
            "type": "jsonb",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "idempotency_key",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "status",
            "type": "USER-DEFINED",
            "default": "'pending'::app_push_notifications.push_notification_status",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "target_type",
            "type": "USER-DEFINED",
            "default": "'user'::app_push_notifications.push_target_type",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "processing_started_at",
            "type": "timestamp with time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "processed_by",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "attempts_details",
            "type": "jsonb",
            "default": "'[]'::jsonb",
            "nullable": true,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_push_queue_pending",
            "unique": false,
            "definition": "CREATE INDEX idx_push_queue_pending ON app_push_notifications.push_queue USING btree (status, scheduled_at) WHERE (status = 'pending'::app_push_notifications.push_notification_status)"
          },
          {
            "name": "idx_push_queue_pending_processing",
            "unique": false,
            "definition": "CREATE INDEX idx_push_queue_pending_processing ON app_push_notifications.push_queue USING btree (status, scheduled_at, processing_started_at) WHERE (status = ANY (ARRAY['pending'::app_push_notifications.push_notification_status, 'processing'::app_push_notifications.push_notification_status]))"
          },
          {
            "name": "idx_push_queue_queue_status",
            "unique": false,
            "definition": "CREATE INDEX idx_push_queue_queue_status ON app_push_notifications.push_queue USING btree (status, id) WHERE (status = ANY (ARRAY['pending'::app_push_notifications.push_notification_status, 'processing'::app_push_notifications.push_notification_status]))"
          },
          {
            "name": "idx_push_queue_user_status",
            "unique": false,
            "definition": "CREATE INDEX idx_push_queue_user_status ON app_push_notifications.push_queue USING btree (internal_user_id, status)"
          },
          {
            "name": "idx_push_queue_worker",
            "unique": false,
            "definition": "CREATE INDEX idx_push_queue_worker ON app_push_notifications.push_queue USING btree (status, scheduled_at, id) WHERE (status = ANY (ARRAY['pending'::app_push_notifications.push_notification_status, 'processing'::app_push_notifications.push_notification_status]))"
          },
          {
            "name": "push_queue_idempotency_key_key",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX push_queue_idempotency_key_key ON app_push_notifications.push_queue USING btree (idempotency_key)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.push_queue (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    event_key text NOT NULL,\n    internal_user_id uuid,\n    app_id text,\n    payload jsonb NOT NULL,\n    retry_count integer NOT NULL DEFAULT 0,\n    scheduled_at timestamp with time zone DEFAULT now(),\n    sent_at timestamp with time zone,\n    created_at timestamp with time zone DEFAULT now(),\n    target_filters jsonb,\n    idempotency_key text,\n    status USER-DEFINED NOT NULL DEFAULT 'pending'::app_push_notifications.push_notification_status,\n    target_type USER-DEFINED NOT NULL DEFAULT 'user'::app_push_notifications.push_target_type,\n    processing_started_at timestamp with time zone,\n    processed_by text,\n    attempts_details jsonb DEFAULT '[]'::jsonb,\n    CONSTRAINT push_queue_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "fk_push_queue_app",
            "columns": [
              "app_id"
            ],
            "on_delete": "",
            "on_update": "",
            "ref_table": "app_registry",
            "ref_schema": "public",
            "ref_columns": [
              "app_id"
            ]
          },
          {
            "name": "fk_push_queue_event_key",
            "columns": [
              "event_key"
            ],
            "on_delete": "SET NULL",
            "on_update": "",
            "ref_table": "push_events",
            "ref_schema": "app_push_notifications",
            "ref_columns": [
              "event_key"
            ]
          },
          {
            "name": "fk_push_queue_user",
            "columns": [
              "internal_user_id"
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
            "name": "chk_push_queue_payload_valid",
            "expression": "app_push_notifications.is_valid_payload(payload)"
          }
        ],
        "unique_constraints": [
          {
            "name": "push_queue_idempotency_key_key",
            "columns": [
              "idempotency_key"
            ]
          }
        ]
      },
      {
        "name": "push_rate_limits",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "app_id",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "max_broadcast_per_minute",
            "type": "integer",
            "default": "10",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "max_user_per_minute",
            "type": "integer",
            "default": "100",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "last_reset_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "current_broadcast_count",
            "type": "integer",
            "default": "0",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "current_user_count",
            "type": "integer",
            "default": "0",
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": null,
        "raw_sql": "CREATE TABLE app_push_notifications.push_rate_limits (\\n    app_id text NOT NULL,\n    max_broadcast_per_minute integer NOT NULL DEFAULT 10,\n    max_user_per_minute integer NOT NULL DEFAULT 100,\n    last_reset_at timestamp with time zone NOT NULL DEFAULT now(),\n    current_broadcast_count integer NOT NULL DEFAULT 0,\n    current_user_count integer NOT NULL DEFAULT 0,\n    CONSTRAINT push_rate_limits_pkey PRIMARY KEY (app_id)\\n);",
        "primary_key": [
          "app_id"
        ],
        "foreign_keys": [
          {
            "name": "push_rate_limits_app_id_fkey",
            "columns": [
              "app_id"
            ],
            "on_delete": "CASCADE",
            "on_update": "",
            "ref_table": "app_registry",
            "ref_schema": "public",
            "ref_columns": [
              "app_id"
            ]
          }
        ],
        "business_purpose": null,
        "check_constraints": null,
        "unique_constraints": null
      },
      {
        "name": "rate_limit_events",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "app_id",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "target_type",
            "type": "USER-DEFINED",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_rate_limit_events_app_created",
            "unique": false,
            "definition": "CREATE INDEX idx_rate_limit_events_app_created ON app_push_notifications.rate_limit_events USING btree (app_id, target_type, created_at)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.rate_limit_events (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    app_id text NOT NULL,\n    target_type USER-DEFINED NOT NULL,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    CONSTRAINT rate_limit_events_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "rate_limit_events_app_id_fkey",
            "columns": [
              "app_id"
            ],
            "on_delete": "CASCADE",
            "on_update": "",
            "ref_table": "app_registry",
            "ref_schema": "public",
            "ref_columns": [
              "app_id"
            ]
          }
        ],
        "business_purpose": null,
        "check_constraints": null,
        "unique_constraints": null
      },
      {
        "name": "retry_policies",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "app_id",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "policy_name",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "max_retries",
            "type": "integer",
            "default": "3",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "base_delay_seconds",
            "type": "integer",
            "default": "2",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "backoff_multiplier",
            "type": "numeric",
            "default": "2.0",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "max_delay_seconds",
            "type": "integer",
            "default": "3600",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "is_active",
            "type": "boolean",
            "default": "true",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "updated_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "retry_policies_app_id_key",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX retry_policies_app_id_key ON app_push_notifications.retry_policies USING btree (app_id)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.retry_policies (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    app_id text,\n    policy_name text NOT NULL,\n    max_retries integer NOT NULL DEFAULT 3,\n    base_delay_seconds integer NOT NULL DEFAULT 2,\n    backoff_multiplier numeric NOT NULL DEFAULT 2.0,\n    max_delay_seconds integer NOT NULL DEFAULT 3600,\n    is_active boolean NOT NULL DEFAULT true,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    updated_at timestamp with time zone NOT NULL DEFAULT now(),\n    CONSTRAINT retry_policies_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "retry_policies_app_id_fkey",
            "columns": [
              "app_id"
            ],
            "on_delete": "CASCADE",
            "on_update": "",
            "ref_table": "app_registry",
            "ref_schema": "public",
            "ref_columns": [
              "app_id"
            ]
          }
        ],
        "business_purpose": null,
        "check_constraints": null,
        "unique_constraints": [
          {
            "name": "retry_policies_app_id_key",
            "columns": [
              "app_id"
            ]
          }
        ]
      },
      {
        "name": "segments",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "segment_key",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "name",
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
            "name": "filters",
            "type": "jsonb",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "is_active",
            "type": "boolean",
            "default": "true",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "updated_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "segments_segment_key_key",
            "unique": true,
            "definition": "CREATE UNIQUE INDEX segments_segment_key_key ON app_push_notifications.segments USING btree (segment_key)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.segments (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    segment_key text NOT NULL,\n    name text NOT NULL,\n    description text,\n    filters jsonb NOT NULL,\n    is_active boolean NOT NULL DEFAULT true,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    updated_at timestamp with time zone NOT NULL DEFAULT now(),\n    CONSTRAINT segments_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": null,
        "business_purpose": null,
        "check_constraints": null,
        "unique_constraints": [
          {
            "name": "segments_segment_key_key",
            "columns": [
              "segment_key"
            ]
          }
        ]
      },
      {
        "name": "token_history",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "id",
            "type": "uuid",
            "default": "gen_random_uuid()",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "device_token_id",
            "type": "uuid",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "old_fcm_token",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "new_fcm_token",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "changed_reason",
            "type": "text",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "changed_by",
            "type": "text",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "created_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": [
          {
            "name": "idx_token_history_dates",
            "unique": false,
            "definition": "CREATE INDEX idx_token_history_dates ON app_push_notifications.token_history USING btree (created_at DESC)"
          },
          {
            "name": "idx_token_history_device",
            "unique": false,
            "definition": "CREATE INDEX idx_token_history_device ON app_push_notifications.token_history USING btree (device_token_id)"
          }
        ],
        "raw_sql": "CREATE TABLE app_push_notifications.token_history (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\n    device_token_id uuid NOT NULL,\n    old_fcm_token text,\n    new_fcm_token text NOT NULL,\n    changed_reason text NOT NULL,\n    changed_by text,\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\n    CONSTRAINT token_history_pkey PRIMARY KEY (id)\\n);",
        "primary_key": [
          "id"
        ],
        "foreign_keys": [
          {
            "name": "fk_token_history_device",
            "columns": [
              "device_token_id"
            ],
            "on_delete": "CASCADE",
            "on_update": "",
            "ref_table": "device_tokens",
            "ref_schema": "app_push_notifications",
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
        "name": "user_push_preferences",
        "schema": "app_push_notifications",
        "columns": [
          {
            "name": "internal_user_id",
            "type": "uuid",
            "default": null,
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "marketing_enabled",
            "type": "boolean",
            "default": "true",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "transactional_enabled",
            "type": "boolean",
            "default": "true",
            "nullable": false,
            "is_identity": false
          },
          {
            "name": "quiet_hours_start",
            "type": "time without time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "quiet_hours_end",
            "type": "time without time zone",
            "default": null,
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "timezone",
            "type": "text",
            "default": "'UTC'::text",
            "nullable": true,
            "is_identity": false
          },
          {
            "name": "updated_at",
            "type": "timestamp with time zone",
            "default": "now()",
            "nullable": false,
            "is_identity": false
          }
        ],
        "indexes": null,
        "raw_sql": "CREATE TABLE app_push_notifications.user_push_preferences (\\n    internal_user_id uuid NOT NULL,\n    marketing_enabled boolean NOT NULL DEFAULT true,\n    transactional_enabled boolean NOT NULL DEFAULT true,\n    quiet_hours_start time without time zone,\n    quiet_hours_end time without time zone,\n    timezone text DEFAULT 'UTC'::text,\n    updated_at timestamp with time zone NOT NULL DEFAULT now(),\n    CONSTRAINT user_push_preferences_pkey PRIMARY KEY (internal_user_id)\\n);",
        "primary_key": [
          "internal_user_id"
        ],
        "foreign_keys": [
          {
            "name": "user_push_preferences_internal_user_id_fkey",
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
        "check_constraints": null,
        "unique_constraints": null
      }
    ]
  },
  {
    "object_type": "views",
    "sort_order": 3,
    "data": null
  },
  {
    "object_type": "functions",
    "sort_order": 4,
    "data": [
      {
        "name": "check_rate_limit",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.check_rate_limit(p_app_id text, p_target_type text)\n RETURNS boolean\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    limit_record RECORD;\r\n    v_now TIMESTAMPTZ := now();\r\nBEGIN\r\n    SELECT * INTO limit_record FROM app_push_notifications.push_rate_limits WHERE app_id = p_app_id;\r\n    IF NOT FOUND THEN RETURN true; END IF;\r\n\r\n    IF v_now - limit_record.last_reset_at >= interval '1 minute' THEN\r\n        UPDATE app_push_notifications.push_rate_limits\r\n        SET current_broadcast_count = 0,\r\n            current_user_count = 0,\r\n            last_reset_at = v_now\r\n        WHERE app_id = p_app_id;\r\n        RETURN true;\r\n    END IF;\r\n\r\n    IF p_target_type = 'broadcast' AND limit_record.current_broadcast_count >= limit_record.max_broadcast_per_minute THEN\r\n        RETURN false;\r\n    ELSIF p_target_type = 'user' AND limit_record.current_user_count >= limit_record.max_user_per_minute THEN\r\n        RETURN false;\r\n    END IF;\r\n    RETURN true;\r\nEND;\r\n$function$\n",
        "returns": "boolean",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_app_id",
            "type": "text"
          },
          {
            "name": "p_target_type",
            "type": "text"
          }
        ]
      },
      {
        "name": "check_rate_limit",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.check_rate_limit(p_app_id text, p_target_type text, p_limit_per_minute integer DEFAULT 10, p_burst_limit integer DEFAULT 20)\n RETURNS boolean\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_count INT;\r\n    v_window_start TIMESTAMPTZ := now() - interval '1 minute';\r\n    v_recent_count INT;\r\nBEGIN\r\n    -- حساب عدد الطلبات في الدقيقة الأخيرة\r\n    SELECT COUNT(*) INTO v_count\r\n    FROM app_push_notifications.rate_limit_events\r\n    WHERE app_id = p_app_id\r\n      AND target_type = p_target_type::app_push_notifications.push_target_type\r\n      AND created_at > v_window_start;\r\n\r\n    -- السماح إذا كان العدد أقل من الحد\r\n    IF v_count < p_limit_per_minute THEN\r\n        -- تسجيل الحدث للاستخدام المستقبلي\r\n        INSERT INTO app_push_notifications.rate_limit_events (app_id, target_type) VALUES (p_app_id, p_target_type::app_push_notifications.push_target_type);\r\n        RETURN TRUE;\r\n    ELSE\r\n        -- التحقق من الاندفاع (باستخدام نافذة أقصر مثلاً 10 ثوانٍ)\r\n        SELECT COUNT(*) INTO v_recent_count\r\n        FROM app_push_notifications.rate_limit_events\r\n        WHERE app_id = p_app_id\r\n          AND target_type = p_target_type::app_push_notifications.push_target_type\r\n          AND created_at > now() - interval '10 seconds';\r\n        IF v_recent_count < p_burst_limit THEN\r\n            INSERT INTO app_push_notifications.rate_limit_events (app_id, target_type) VALUES (p_app_id, p_target_type::app_push_notifications.push_target_type);\r\n            RETURN TRUE;\r\n        ELSE\r\n            RETURN FALSE;\r\n        END IF;\r\n    END IF;\r\nEND;\r\n$function$\n",
        "returns": "boolean",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_app_id",
            "type": "text"
          },
          {
            "name": "p_target_type",
            "type": "text"
          },
          {
            "name": "p_limit_per_minute",
            "type": "integer"
          },
          {
            "name": "p_burst_limit",
            "type": "integer"
          }
        ]
      },
      {
        "name": "cleanup_rate_limit_events",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.cleanup_rate_limit_events()\n RETURNS void\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    DELETE FROM app_push_notifications.rate_limit_events WHERE created_at < now() - interval '1 hour';\r\nEND;\r\n$function$\n",
        "returns": "void",
        "language": "plpgsql",
        "arguments": null
      },
      {
        "name": "evaluate_condition",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.evaluate_condition(p_user_id uuid, p_cond jsonb)\n RETURNS boolean\n LANGUAGE plpgsql\n STABLE\nAS $function$\r\nDECLARE\r\n    v_key TEXT;\r\n    v_value TEXT;\r\n    v_platform TEXT;\r\n    v_country TEXT;\r\n    v_min_score INT;\r\n    v_user_score INT;\r\nBEGIN\r\n    -- كل كائن شرط له مفتاح واحد (مثل \"platform\", \"country\", \"min_score\")\r\n    FOR v_key IN SELECT jsonb_object_keys(p_cond) LOOP\r\n        v_value := p_cond->>v_key;\r\n        IF v_key = 'platform' THEN\r\n            RETURN EXISTS (SELECT 1 FROM app_push_notifications.device_tokens dt\r\n                          WHERE dt.internal_user_id = p_user_id\r\n                            AND dt.token_status = 'active'\r\n                            AND dt.platform::text = v_value);\r\n        ELSIF v_key = 'country' THEN\r\n            RETURN EXISTS (SELECT 1 FROM app_users.user_profile up\r\n                          WHERE up.internal_user_id = p_user_id\r\n                            AND up.country = v_value);\r\n        ELSIF v_key = 'min_score' THEN\r\n            v_min_score := v_value::INT;\r\n            SELECT COALESCE(up.score, 0) INTO v_user_score\r\n            FROM app_users.user_profile up\r\n            WHERE up.internal_user_id = p_user_id;\r\n            RETURN v_user_score >= v_min_score;\r\n        ELSE\r\n            -- شرط غير معروف → false\r\n            RETURN FALSE;\r\n        END IF;\r\n    END LOOP;\r\n    RETURN FALSE;\r\nEND;\r\n$function$\n",
        "returns": "boolean",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_user_id",
            "type": "uuid"
          },
          {
            "name": "p_cond",
            "type": "jsonb"
          }
        ]
      },
      {
        "name": "evaluate_rule",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.evaluate_rule(p_user_id uuid, p_rule jsonb)\n RETURNS boolean\n LANGUAGE plpgsql\n STABLE\nAS $function$\r\nDECLARE\r\n    v_type TEXT;\r\n    v_result BOOLEAN := TRUE;\r\n    v_item JSONB;\r\nBEGIN\r\n    IF p_rule IS NULL THEN\r\n        RETURN TRUE;\r\n    END IF;\r\n    -- إذا كانت القاعدة كائناً بسيطاً (بدون and/or/not)\r\n    IF NOT (p_rule ? 'and' OR p_rule ? 'or' OR p_rule ? 'not') THEN\r\n        RETURN app_push_notifications.evaluate_condition(p_user_id, p_rule);\r\n    END IF;\r\n\r\n    IF p_rule ? 'and' THEN\r\n        FOR v_item IN SELECT jsonb_array_elements(p_rule->'and') LOOP\r\n            IF NOT app_push_notifications.evaluate_rule(p_user_id, v_item) THEN\r\n                RETURN FALSE;\r\n            END IF;\r\n        END LOOP;\r\n        RETURN TRUE;\r\n    ELSIF p_rule ? 'or' THEN\r\n        FOR v_item IN SELECT jsonb_array_elements(p_rule->'or') LOOP\r\n            IF app_push_notifications.evaluate_rule(p_user_id, v_item) THEN\r\n                RETURN TRUE;\r\n            END IF;\r\n        END LOOP;\r\n        RETURN FALSE;\r\n    ELSIF p_rule ? 'not' THEN\r\n        RETURN NOT app_push_notifications.evaluate_rule(p_user_id, p_rule->'not');\r\n    ELSE\r\n        RETURN FALSE;\r\n    END IF;\r\nEND;\r\n$function$\n",
        "returns": "boolean",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_user_id",
            "type": "uuid"
          },
          {
            "name": "p_rule",
            "type": "jsonb"
          }
        ]
      },
      {
        "name": "evaluate_segment_filter",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.evaluate_segment_filter(p_user_id uuid, p_filter jsonb)\n RETURNS boolean\n LANGUAGE plpgsql\n STABLE\nAS $function$\r\nBEGIN\r\n    RETURN app_push_notifications.evaluate_rule(p_user_id, p_filter);\r\nEND;\r\n$function$\n",
        "returns": "boolean",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_user_id",
            "type": "uuid"
          },
          {
            "name": "p_filter",
            "type": "jsonb"
          }
        ]
      },
      {
        "name": "fetch_next_events",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.fetch_next_events(p_limit integer DEFAULT 10)\n RETURNS SETOF app_push_notifications.push_queue\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    RETURN QUERY\r\n    SELECT *\r\n    FROM app_push_notifications.push_queue\r\n    WHERE status = 'pending'\r\n      AND (scheduled_at IS NULL OR scheduled_at <= now())\r\n      AND (processing_started_at IS NULL OR processing_started_at < now() - interval '5 minutes')\r\n    ORDER BY scheduled_at NULLS FIRST, created_at\r\n    LIMIT p_limit\r\n    FOR UPDATE SKIP LOCKED;\r\nEND;\r\n$function$\n",
        "returns": "app_push_notifications.push_queue",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_limit",
            "type": "integer"
          }
        ]
      },
      {
        "name": "is_valid_payload",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.is_valid_payload(payload jsonb)\n RETURNS boolean\n LANGUAGE plpgsql\n IMMUTABLE\nAS $function$\r\nBEGIN\r\n    -- على الأقل يجب وجود title أو body أو default_data من push_events (سيتم دمجه)\r\n    -- هنا نكتفي بالتأكد من أنه كائن JSON صحيح وليس فارغاً\r\n    IF jsonb_typeof(payload) != 'object' THEN\r\n        RETURN false;\r\n    END IF;\r\n    -- يمكن إضافة شروط إضافية مثل وجود حقل 'title' أو 'data'\r\n    -- لكن هذا يعتمد على متطلبات عملك\r\n    RETURN true;\r\nEND;\r\n$function$\n",
        "returns": "boolean",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "payload",
            "type": "jsonb"
          }
        ]
      },
      {
        "name": "is_valid_status_transition",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.is_valid_status_transition(old_status app_push_notifications.push_notification_status, new_status app_push_notifications.push_notification_status)\n RETURNS boolean\n LANGUAGE plpgsql\n IMMUTABLE\nAS $function$\r\nBEGIN\r\n    RETURN CASE\r\n        WHEN old_status = 'pending' AND new_status IN ('processing', 'failed') THEN TRUE\r\n        WHEN old_status = 'processing' AND new_status IN ('sent', 'failed') THEN TRUE\r\n        WHEN old_status = 'failed' AND new_status IN ('pending', 'dead_letter') THEN TRUE\r\n        WHEN old_status = 'dead_letter' AND new_status = 'dead_letter' THEN TRUE   -- لا تغيير\r\n        ELSE FALSE\r\n    END;\r\nEND;\r\n$function$\n",
        "returns": "boolean",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "old_status",
            "type": "app_push_notifications.push_notification_status"
          },
          {
            "name": "new_status",
            "type": "app_push_notifications.push_notification_status"
          }
        ]
      },
      {
        "name": "move_to_dead_letter",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.move_to_dead_letter(p_queue_id uuid, p_error_message text, p_error_code text, p_failure_category text DEFAULT 'unknown'::text)\n RETURNS void\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_queue app_push_notifications.push_queue%ROWTYPE;\r\nBEGIN\r\n    SELECT * INTO v_queue FROM app_push_notifications.push_queue WHERE id = p_queue_id;\r\n    IF NOT FOUND THEN RETURN; END IF;\r\n\r\n    INSERT INTO app_push_notifications.dead_letter_queue (\r\n        queue_id, event_key, internal_user_id, app_id, payload,\r\n        target_type, target_filters, final_status, error_message,\r\n        error_code, retry_count, archived_at, failure_category,\r\n        replayable\r\n    ) VALUES (\r\n        v_queue.id, v_queue.event_key, v_queue.internal_user_id, v_queue.app_id, v_queue.payload,\r\n        v_queue.target_type, v_queue.target_filters, 'failed',\r\n        p_error_message, p_error_code, v_queue.retry_count, now(),\r\n        p_failure_category,\r\n        CASE WHEN p_failure_category IN ('invalid_token', 'rate_limited') THEN true ELSE false END\r\n    );\r\n\r\n    UPDATE app_push_notifications.push_queue\r\n    SET status = 'failed', sent_at = now()\r\n    WHERE id = p_queue_id;\r\nEND;\r\n$function$\n",
        "returns": "void",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_queue_id",
            "type": "uuid"
          },
          {
            "name": "p_error_message",
            "type": "text"
          },
          {
            "name": "p_error_code",
            "type": "text"
          },
          {
            "name": "p_failure_category",
            "type": "text"
          }
        ]
      },
      {
        "name": "requeue_from_dead_letter",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.requeue_from_dead_letter(p_dlq_id uuid)\n RETURNS uuid\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_dlq RECORD;\r\n    v_new_queue_id UUID;\r\nBEGIN\r\n    SELECT * INTO v_dlq FROM app_push_notifications.dead_letter_queue WHERE id = p_dlq_id AND replayable = true;\r\n    IF NOT FOUND THEN\r\n        RAISE EXCEPTION 'Dead letter record not found or not replayable';\r\n    END IF;\r\n\r\n    -- إعادة إنشاء الإشعار في push_queue\r\n    INSERT INTO app_push_notifications.push_queue (\r\n        event_key, internal_user_id, app_id, payload, target_type, target_filters, idempotency_key, status, retry_count, scheduled_at\r\n    ) VALUES (\r\n        v_dlq.event_key, v_dlq.internal_user_id, v_dlq.app_id, v_dlq.payload, v_dlq.target_type, v_dlq.target_filters, \r\n        gen_random_uuid()::text, 'pending', 0, now()\r\n    ) RETURNING id INTO v_new_queue_id;\r\n\r\n    -- تحديث حالة DLQ إلى resolved\r\n    UPDATE app_push_notifications.dead_letter_queue\r\n    SET final_status = 'resolved', archived_at = now()\r\n    WHERE id = p_dlq_id;\r\n\r\n    RETURN v_new_queue_id;\r\nEND;\r\n$function$\n",
        "returns": "uuid",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_dlq_id",
            "type": "uuid"
          }
        ]
      },
      {
        "name": "save_push_event_version",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.save_push_event_version()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    IF (OLD.title IS DISTINCT FROM NEW.title) OR\r\n       (OLD.body IS DISTINCT FROM NEW.body) OR\r\n       (OLD.category IS DISTINCT FROM NEW.category) OR\r\n       (OLD.priority IS DISTINCT FROM NEW.priority) OR\r\n       (OLD.default_data IS DISTINCT FROM NEW.default_data) OR\r\n       (OLD.is_active IS DISTINCT FROM NEW.is_active) THEN\r\n        -- حفظ النسخة القديمة\r\n        INSERT INTO app_push_notifications.push_event_versions \r\n            (event_key, version, title, body, category, priority, default_data, is_active, created_by)\r\n        VALUES (OLD.event_key, OLD.version, OLD.title, OLD.body, OLD.category, OLD.priority, OLD.default_data, OLD.is_active, 'auto_version');\r\n        -- زيادة الإصدار في الصف الجديد\r\n        NEW.version := OLD.version + 1;\r\n    END IF;\r\n    RETURN NEW;  -- السماح بإتمام التحديث الأصلي\r\nEND;\r\n$function$\n",
        "returns": "trigger",
        "language": "plpgsql",
        "arguments": null
      },
      {
        "name": "update_push_metrics",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.update_push_metrics(p_event_key text, p_latency_ms integer, p_success boolean)\n RETURNS void\n LANGUAGE plpgsql\nAS $function$\r\nDECLARE\r\n    v_today DATE := CURRENT_DATE;\r\nBEGIN\r\n    INSERT INTO app_push_notifications.push_metrics (event_key, date, total_sent, total_failed, avg_latency_ms)\r\n    VALUES (p_event_key, v_today, \r\n            CASE WHEN p_success THEN 1 ELSE 0 END,\r\n            CASE WHEN p_success THEN 0 ELSE 1 END,\r\n            p_latency_ms)\r\n    ON CONFLICT (event_key, date) DO UPDATE\r\n    SET total_sent = push_metrics.total_sent + CASE WHEN p_success THEN 1 ELSE 0 END,\r\n        total_failed = push_metrics.total_failed + CASE WHEN p_success THEN 0 ELSE 1 END,\r\n        avg_latency_ms = (push_metrics.avg_latency_ms * (push_metrics.total_sent + push_metrics.total_failed) + p_latency_ms) \r\n                         / (push_metrics.total_sent + push_metrics.total_failed + 1),\r\n        updated_at = now();\r\nEND;\r\n$function$\n",
        "returns": "void",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_event_key",
            "type": "text"
          },
          {
            "name": "p_latency_ms",
            "type": "integer"
          },
          {
            "name": "p_success",
            "type": "boolean"
          }
        ]
      },
      {
        "name": "update_token_timestamp",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.update_token_timestamp()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    IF OLD.fcm_token IS DISTINCT FROM NEW.fcm_token THEN\r\n        NEW.last_token_update = now();\r\n    END IF;\r\n    RETURN NEW;\r\nEND;\r\n$function$\n",
        "returns": "trigger",
        "language": "plpgsql",
        "arguments": null
      },
      {
        "name": "update_updated_at_column",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.update_updated_at_column()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    NEW.updated_at = now();\r\n    RETURN NEW;\r\nEND;\r\n$function$\n",
        "returns": "trigger",
        "language": "plpgsql",
        "arguments": null
      },
      {
        "name": "user_in_segment",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.user_in_segment(p_user_id uuid, p_segment_key text)\n RETURNS boolean\n LANGUAGE plpgsql\n STABLE\nAS $function$\r\nDECLARE\r\n    v_segment RECORD;\r\nBEGIN\r\n    SELECT * INTO v_segment FROM app_push_notifications.segments\r\n    WHERE segment_key = p_segment_key AND is_active = true;\r\n    IF NOT FOUND THEN RETURN false; END IF;\r\n    \r\n    RETURN app_push_notifications.evaluate_segment_filter(p_user_id, v_segment.filters);\r\nEND;\r\n$function$\n",
        "returns": "boolean",
        "language": "plpgsql",
        "arguments": [
          {
            "name": "p_user_id",
            "type": "uuid"
          },
          {
            "name": "p_segment_key",
            "type": "text"
          }
        ]
      },
      {
        "name": "validate_status_transition",
        "schema": "app_push_notifications",
        "source": "CREATE OR REPLACE FUNCTION app_push_notifications.validate_status_transition()\n RETURNS trigger\n LANGUAGE plpgsql\nAS $function$\r\nBEGIN\r\n    IF NOT app_push_notifications.is_valid_status_transition(OLD.status, NEW.status) THEN\r\n        RAISE EXCEPTION 'Invalid status transition from % to %', OLD.status, NEW.status;\r\n    END IF;\r\n    RETURN NEW;\r\nEND;\r\n$function$\n",
        "returns": "trigger",
        "language": "plpgsql",
        "arguments": null
      }
    ]
  },
  {
    "object_type": "triggers",
    "sort_order": 5,
    "data": [
      {
        "name": "trg_device_tokens_token_update",
        "table": "device_tokens",
        "schema": "app_push_notifications",
        "definition": "CREATE TRIGGER trg_device_tokens_token_update BEFORE UPDATE ON app_push_notifications.device_tokens FOR EACH ROW EXECUTE FUNCTION app_push_notifications.update_token_timestamp()"
      },
      {
        "name": "trg_device_tokens_updated_at",
        "table": "device_tokens",
        "schema": "app_push_notifications",
        "definition": "CREATE TRIGGER trg_device_tokens_updated_at BEFORE UPDATE ON app_push_notifications.device_tokens FOR EACH ROW EXECUTE FUNCTION app_push_notifications.update_updated_at_column()"
      },
      {
        "name": "trg_push_events_updated_at",
        "table": "push_events",
        "schema": "app_push_notifications",
        "definition": "CREATE TRIGGER trg_push_events_updated_at BEFORE UPDATE ON app_push_notifications.push_events FOR EACH ROW EXECUTE FUNCTION app_push_notifications.update_updated_at_column()"
      },
      {
        "name": "trg_push_events_versioning",
        "table": "push_events",
        "schema": "app_push_notifications",
        "definition": "CREATE TRIGGER trg_push_events_versioning BEFORE UPDATE ON app_push_notifications.push_events FOR EACH ROW EXECUTE FUNCTION app_push_notifications.save_push_event_version()"
      },
      {
        "name": "trg_push_queue_status_transition",
        "table": "push_queue",
        "schema": "app_push_notifications",
        "definition": "CREATE TRIGGER trg_push_queue_status_transition BEFORE UPDATE OF status ON app_push_notifications.push_queue FOR EACH ROW EXECUTE FUNCTION app_push_notifications.validate_status_transition()"
      },
      {
        "name": "trg_retry_policies_updated_at",
        "table": "retry_policies",
        "schema": "app_push_notifications",
        "definition": "CREATE TRIGGER trg_retry_policies_updated_at BEFORE UPDATE ON app_push_notifications.retry_policies FOR EACH ROW EXECUTE FUNCTION app_push_notifications.update_updated_at_column()"
      },
      {
        "name": "trg_segments_updated_at",
        "table": "segments",
        "schema": "app_push_notifications",
        "definition": "CREATE TRIGGER trg_segments_updated_at BEFORE UPDATE ON app_push_notifications.segments FOR EACH ROW EXECUTE FUNCTION app_push_notifications.update_updated_at_column()"
      },
      {
        "name": "trg_user_push_preferences_updated_at",
        "table": "user_push_preferences",
        "schema": "app_push_notifications",
        "definition": "CREATE TRIGGER trg_user_push_preferences_updated_at BEFORE UPDATE ON app_push_notifications.user_push_preferences FOR EACH ROW EXECUTE FUNCTION app_push_notifications.update_updated_at_column()"
      }
    ]
  },
  {
    "object_type": "policies",
    "sort_order": 6,
    "data": [
      {
        "name": "p_deny_all_rpc_only_device_tokens",
        "roles": [
          "authenticated",
          "anon"
        ],
        "table": "device_tokens",
        "using": "false",
        "schema": "app_push_notifications",
        "raw_sql": "CREATE POLICY p_deny_all_rpc_only_device_tokens ON app_push_notifications.device_tokens AS ALL TO authenticated,anon USING (false) WITH CHECK (false);",
        "operation": "ALL",
        "with_check": "false"
      },
      {
        "name": "p_deny_all_rpc_only_push_events",
        "roles": [
          "authenticated",
          "anon"
        ],
        "table": "push_events",
        "using": "false",
        "schema": "app_push_notifications",
        "raw_sql": "CREATE POLICY p_deny_all_rpc_only_push_events ON app_push_notifications.push_events AS ALL TO authenticated,anon USING (false) WITH CHECK (false);",
        "operation": "ALL",
        "with_check": "false"
      },
      {
        "name": "p_deny_all_rpc_only_push_failures",
        "roles": [
          "authenticated",
          "anon"
        ],
        "table": "push_failures",
        "using": "false",
        "schema": "app_push_notifications",
        "raw_sql": "CREATE POLICY p_deny_all_rpc_only_push_failures ON app_push_notifications.push_failures AS ALL TO authenticated,anon USING (false) WITH CHECK (false);",
        "operation": "ALL",
        "with_check": "false"
      },
      {
        "name": "p_deny_all_rpc_only_push_queue",
        "roles": [
          "authenticated",
          "anon"
        ],
        "table": "push_queue",
        "using": "false",
        "schema": "app_push_notifications",
        "raw_sql": "CREATE POLICY p_deny_all_rpc_only_push_queue ON app_push_notifications.push_queue AS ALL TO authenticated,anon USING (false) WITH CHECK (false);",
        "operation": "ALL",
        "with_check": "false"
      }
    ]
  }
]