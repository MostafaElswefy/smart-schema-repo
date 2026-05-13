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
    "schema_name": "app_wallet",
    "object_name": "assets",
    "definition": "CREATE TYPE app_wallet.assets AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "app_wallet",
    "object_name": "exchange_rates",
    "definition": "CREATE TYPE app_wallet.exchange_rates AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "app_wallet",
    "object_name": "transactions",
    "definition": "CREATE TYPE app_wallet.transactions AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "app_wallet",
    "object_name": "transactions_audit",
    "definition": "CREATE TYPE app_wallet.transactions_audit AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "app_wallet",
    "object_name": "user_asset_balance",
    "definition": "CREATE TYPE app_wallet.user_asset_balance AS ();",
    "sort_order": 1
  },
  {
    "object_type": "TYPE",
    "schema_name": "app_wallet",
    "object_name": "wallet_recalc_queue",
    "definition": "CREATE TYPE app_wallet.wallet_recalc_queue AS ();",
    "sort_order": 1
  },
  {
    "object_type": "SEQUENCE",
    "schema_name": "app_wallet",
    "object_name": "transactions_audit_audit_id_seq",
    "definition": "CREATE SEQUENCE app_wallet.transactions_audit_audit_id_seq;",
    "sort_order": 3
  },
  {
    "object_type": "SEQUENCE",
    "schema_name": "app_wallet",
    "object_name": "wallet_recalc_queue_id_seq",
    "definition": "CREATE SEQUENCE app_wallet.wallet_recalc_queue_id_seq;",
    "sort_order": 3
  },
  {
    "object_type": "TABLE",
    "schema_name": "app_wallet",
    "object_name": "assets",
    "definition": "CREATE TABLE app_wallet.assets (\\n    code text NOT NULL,\\n    asset_kind text NOT NULL,\\n    decimals integer NOT NULL DEFAULT 0,\\n    is_active boolean NOT NULL DEFAULT true,\\n    metadata jsonb,\\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\\n    updated_at timestamp with time zone NOT NULL DEFAULT now()\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "app_wallet",
    "object_name": "exchange_rates",
    "definition": "CREATE TABLE app_wallet.exchange_rates (\\n    from_asset text NOT NULL,\\n    to_asset text NOT NULL,\\n    rate numeric(20,10) NOT NULL,\\n    effective_from timestamp with time zone NOT NULL DEFAULT now(),\\n    effective_until timestamp with time zone,\\n    created_at timestamp with time zone DEFAULT now()\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "app_wallet",
    "object_name": "transactions",
    "definition": "CREATE TABLE app_wallet.transactions (\\n    id uuid NOT NULL DEFAULT gen_random_uuid(),\\n    balance_before numeric(20,6),\\n    balance_after numeric(20,6),\\n    amount numeric(20,6) NOT NULL,\\n    app_id text,\\n    direction text NOT NULL,\\n    description text,\\n    created_at timestamp with time zone DEFAULT now(),\\n    updated_at timestamp with time zone DEFAULT now(),\\n    completed_at timestamp with time zone,\\n    status text NOT NULL DEFAULT 'pending'::text,\\n    title text,\\n    meta jsonb,\\n    notes text,\\n    payment_provider text,\\n    payment_method text,\\n    payment_source text,\\n    payment_fee_amount numeric(20,6),\\n    payment_net_amount numeric(20,6),\\n    payment_gross_amount numeric(20,6),\\n    payment_idempotency_key text,\\n    payment_reference_id text,\\n    admin_user_id uuid,\\n    event_name text,\\n    source_type text,\\n    source_id uuid,\\n    ledger_reference_id uuid,\\n    created_by uuid,\\n    updated_by uuid,\\n    actor_user_id uuid NOT NULL,\\n    actor_role text NOT NULL DEFAULT 'owner'::text,\\n    counterparty_user_id uuid,\\n    is_reversed boolean NOT NULL DEFAULT false,\\n    reversed_at timestamp with time zone,\\n    transaction_type text,\\n    effective_at timestamp with time zone,\\n    transfer_group_id uuid,\\n    asset_code text NOT NULL,\\n    wallet_type text NOT NULL DEFAULT 'default'::text,\\n    conversion_group_id uuid,\\n    conversion_rate numeric(20,10)\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "app_wallet",
    "object_name": "transactions_audit",
    "definition": "CREATE TABLE app_wallet.transactions_audit (\\n    audit_id bigint NOT NULL DEFAULT nextval('app_wallet.transactions_audit_audit_id_seq'::regclass),\\n    transaction_id uuid NOT NULL,\\n    operation character(1) NOT NULL,\\n    changed_by uuid,\\n    changed_at timestamp with time zone NOT NULL DEFAULT now(),\\n    old_data jsonb,\\n    new_data jsonb,\\n    request_id uuid,\\n    trace_id uuid,\\n    ip inet,\\n    user_agent text\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "app_wallet",
    "object_name": "user_asset_balance",
    "definition": "CREATE TABLE app_wallet.user_asset_balance (\\n    internal_user_id uuid NOT NULL,\\n    asset_code text NOT NULL,\\n    total numeric(20,6) NOT NULL DEFAULT 0,\\n    available numeric(20,6) NOT NULL DEFAULT 0,\\n    frozen numeric(20,6) NOT NULL DEFAULT 0,\\n    pending_outgoing numeric(20,6) NOT NULL DEFAULT 0,\\n    pending_incoming numeric(20,6) NOT NULL DEFAULT 0,\\n    version bigint NOT NULL DEFAULT 1,\\n    calculated_at timestamp with time zone NOT NULL DEFAULT now(),\\n    updated_at timestamp with time zone NOT NULL DEFAULT now(),\\n    wallet_type text NOT NULL DEFAULT 'default'::text\\n);",
    "sort_order": 4
  },
  {
    "object_type": "TABLE",
    "schema_name": "app_wallet",
    "object_name": "wallet_recalc_queue",
    "definition": "CREATE TABLE app_wallet.wallet_recalc_queue (\\n    id bigint NOT NULL DEFAULT nextval('app_wallet.wallet_recalc_queue_id_seq'::regclass),\\n    internal_user_id uuid NOT NULL,\\n    created_at timestamp with time zone NOT NULL DEFAULT now(),\\n    processed_at timestamp with time zone,\\n    priority integer NOT NULL DEFAULT 0,\\n    retry_count integer NOT NULL DEFAULT 0,\\n    failed_at timestamp with time zone,\\n    last_error text,\\n    status text NOT NULL DEFAULT 'pending'::text\\n);",
    "sort_order": 4
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "assets_pkey",
    "definition": "ALTER TABLE app_wallet.assets ADD CONSTRAINT assets_pkey PRIMARY KEY (code);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "exchange_rates_pkey",
    "definition": "ALTER TABLE app_wallet.exchange_rates ADD CONSTRAINT exchange_rates_pkey PRIMARY KEY (from_asset, to_asset, effective_from);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "transactions_audit_pkey",
    "definition": "ALTER TABLE app_wallet.transactions_audit ADD CONSTRAINT transactions_audit_pkey PRIMARY KEY (audit_id);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "transactions_pkey",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "user_asset_balance_pkey",
    "definition": "ALTER TABLE app_wallet.user_asset_balance ADD CONSTRAINT user_asset_balance_pkey PRIMARY KEY (internal_user_id, asset_code, wallet_type);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "wallet_recalc_queue_pkey",
    "definition": "ALTER TABLE app_wallet.wallet_recalc_queue ADD CONSTRAINT wallet_recalc_queue_pkey PRIMARY KEY (id);",
    "sort_order": 5
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_asset_balance_non_negative",
    "definition": "ALTER TABLE app_wallet.user_asset_balance ADD CONSTRAINT chk_asset_balance_non_negative CHECK (((total >= (0)::numeric) AND (available >= (0)::numeric) AND (frozen >= (0)::numeric) AND (pending_outgoing >= (0)::numeric) AND (pending_incoming >= (0)::numeric)));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_asset_kind",
    "definition": "ALTER TABLE app_wallet.assets ADD CONSTRAINT chk_asset_kind CHECK ((asset_kind = ANY (ARRAY['fiat'::text, 'virtual'::text, 'reward'::text, 'crypto'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_balance_direction_consistency",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_balance_direction_consistency CHECK ((((direction = 'credit'::text) AND ((balance_before IS NULL) OR (balance_after IS NULL) OR (balance_after >= balance_before))) OR ((direction = 'debit'::text) AND ((balance_before IS NULL) OR (balance_after IS NULL) OR (balance_after <= balance_before)))));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_balance_wallet_type",
    "definition": "ALTER TABLE app_wallet.user_asset_balance ADD CONSTRAINT chk_balance_wallet_type CHECK ((wallet_type = ANY (ARRAY['default'::text, 'cash'::text, 'escrow'::text, 'bonus'::text, 'rewards'::text, 'investment'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_completed_integrity",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_completed_integrity CHECK (((status <> 'completed'::text) OR ((balance_before IS NOT NULL) AND (balance_after IS NOT NULL) AND (completed_at IS NOT NULL))));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_effective_at_not_before_creation",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_effective_at_not_before_creation CHECK (((effective_at IS NULL) OR (effective_at >= created_at)));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_escrow_transaction_requires_source",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_escrow_transaction_requires_source CHECK ((NOT ((transaction_type = ANY (ARRAY['escrow_hold'::text, 'escrow_release'::text, 'escrow_penalty'::text])) AND (source_type IS NULL))));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_recalc_queue_status",
    "definition": "ALTER TABLE app_wallet.wallet_recalc_queue ADD CONSTRAINT chk_recalc_queue_status CHECK ((status = ANY (ARRAY['pending'::text, 'processing'::text, 'completed'::text, 'failed'::text, 'permanent_failed'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_reversal_status_and_ref",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_reversal_status_and_ref CHECK ((NOT ((event_name = 'reversal'::text) AND ((ledger_reference_id IS NULL) OR (status <> 'completed'::text)))));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_reversed_consistency",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_reversed_consistency CHECK ((((is_reversed = false) AND (reversed_at IS NULL)) OR ((is_reversed = true) AND (reversed_at IS NOT NULL))));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_source_consistency",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_source_consistency CHECK ((((source_type IS NULL) AND (source_id IS NULL)) OR ((source_type IS NOT NULL) AND (source_id IS NOT NULL))));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_source_type_values",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_source_type_values CHECK (((source_type IS NULL) OR (source_type = ANY (ARRAY['order'::text, 'reward'::text, 'referral'::text, 'booking'::text, 'invoice'::text]))));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_transaction_amount_positive",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_transaction_amount_positive CHECK ((amount > (0)::numeric));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_transaction_balance_after_non_negative",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_transaction_balance_after_non_negative CHECK ((balance_after >= (0)::numeric));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_transaction_type_values",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_transaction_type_values CHECK (((transaction_type IS NULL) OR (transaction_type = ANY (ARRAY['transfer'::text, 'purchase'::text, 'escrow_hold'::text, 'escrow_release'::text, 'escrow_refund'::text, 'escrow_penalty'::text, 'platform_fee'::text, 'settlement'::text, 'exchange'::text, 'bonus'::text, 'payout'::text, 'fee'::text, 'adjustment'::text, 'refund'::text]))));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_wallet_transaction_direction",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_wallet_transaction_direction CHECK ((direction = ANY (ARRAY['credit'::text, 'debit'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_wallet_transaction_event_name",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_wallet_transaction_event_name CHECK (((event_name IS NULL) OR (event_name = ANY (ARRAY['reversal'::text, 'payment'::text, 'refund'::text, 'adjustment'::text, 'reward'::text, 'deposit'::text, 'withdrawal'::text]))));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_wallet_transaction_payment_method",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_wallet_transaction_payment_method CHECK (((payment_method IS NULL) OR (payment_method = ANY (ARRAY['card'::text, 'cash'::text, 'wallet'::text, 'bank'::text, 'apple_pay'::text, 'google_pay'::text, 'paypal'::text, 'crypto'::text]))));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_wallet_transaction_status",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_wallet_transaction_status CHECK ((status = ANY (ARRAY['pending'::text, 'completed'::text, 'failed'::text, 'cancelled'::text, 'reversed'::text, 'frozen'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "chk_wallet_type",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT chk_wallet_type CHECK ((wallet_type = ANY (ARRAY['default'::text, 'cash'::text, 'escrow'::text, 'bonus'::text, 'rewards'::text, 'investment'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "transactions_actor_role_check",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT transactions_actor_role_check CHECK ((actor_role = ANY (ARRAY['owner'::text, 'sender'::text, 'receiver'::text, 'system'::text])));",
    "sort_order": 7
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "exchange_rates_from_asset_fkey",
    "definition": "ALTER TABLE app_wallet.exchange_rates ADD CONSTRAINT exchange_rates_from_asset_fkey FOREIGN KEY (from_asset) REFERENCES app_wallet.assets(code);",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "exchange_rates_to_asset_fkey",
    "definition": "ALTER TABLE app_wallet.exchange_rates ADD CONSTRAINT exchange_rates_to_asset_fkey FOREIGN KEY (to_asset) REFERENCES app_wallet.assets(code);",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "fk_transactions_actor_user",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT fk_transactions_actor_user FOREIGN KEY (actor_user_id) REFERENCES user_identity_root(internal_user_id) ON DELETE CASCADE;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "fk_transactions_asset_code",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT fk_transactions_asset_code FOREIGN KEY (asset_code) REFERENCES app_wallet.assets(code) ON DELETE RESTRICT;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "fk_transactions_audit_transaction_id",
    "definition": "ALTER TABLE app_wallet.transactions_audit ADD CONSTRAINT fk_transactions_audit_transaction_id FOREIGN KEY (transaction_id) REFERENCES app_wallet.transactions(id) ON DELETE CASCADE;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "fk_transactions_counterparty_user",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT fk_transactions_counterparty_user FOREIGN KEY (counterparty_user_id) REFERENCES user_identity_root(internal_user_id) ON DELETE SET NULL;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "fk_transactions_created_by",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT fk_transactions_created_by FOREIGN KEY (created_by) REFERENCES user_identity_root(internal_user_id) ON DELETE SET NULL;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "fk_transactions_ledger_reference",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT fk_transactions_ledger_reference FOREIGN KEY (ledger_reference_id) REFERENCES app_wallet.transactions(id) ON DELETE SET NULL;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "fk_transactions_updated_by",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT fk_transactions_updated_by FOREIGN KEY (updated_by) REFERENCES user_identity_root(internal_user_id) ON DELETE SET NULL;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "fk_user_asset_balance_asset_code",
    "definition": "ALTER TABLE app_wallet.user_asset_balance ADD CONSTRAINT fk_user_asset_balance_asset_code FOREIGN KEY (asset_code) REFERENCES app_wallet.assets(code) ON DELETE RESTRICT;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "transactions_admin_user_id_fkey",
    "definition": "ALTER TABLE app_wallet.transactions ADD CONSTRAINT transactions_admin_user_id_fkey FOREIGN KEY (admin_user_id) REFERENCES user_identity_root(internal_user_id) ON DELETE SET NULL;",
    "sort_order": 8
  },
  {
    "object_type": "CONSTRAINT",
    "schema_name": "app_wallet",
    "object_name": "user_asset_balance_user_fk",
    "definition": "ALTER TABLE app_wallet.user_asset_balance ADD CONSTRAINT user_asset_balance_user_fk FOREIGN KEY (internal_user_id) REFERENCES user_identity_root(internal_user_id) ON DELETE CASCADE;",
    "sort_order": 8
  },
  {
    "object_type": "SEQUENCE OWNERSHIP",
    "schema_name": "app_wallet",
    "object_name": "transactions_audit_audit_id_seq",
    "definition": "ALTER SEQUENCE app_wallet.transactions_audit_audit_id_seq OWNED BY transactions_audit.audit_id;",
    "sort_order": 9
  },
  {
    "object_type": "SEQUENCE OWNERSHIP",
    "schema_name": "app_wallet",
    "object_name": "wallet_recalc_queue_id_seq",
    "definition": "ALTER SEQUENCE app_wallet.wallet_recalc_queue_id_seq OWNED BY wallet_recalc_queue.id;",
    "sort_order": 9
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "app_wallet",
    "object_name": "assets",
    "definition": "ALTER TABLE app_wallet.assets OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "app_wallet",
    "object_name": "exchange_rates",
    "definition": "ALTER TABLE app_wallet.exchange_rates OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "app_wallet",
    "object_name": "transactions",
    "definition": "ALTER TABLE app_wallet.transactions OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "app_wallet",
    "object_name": "transactions_audit",
    "definition": "ALTER TABLE app_wallet.transactions_audit OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "app_wallet",
    "object_name": "user_asset_balance",
    "definition": "ALTER TABLE app_wallet.user_asset_balance OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "OWNERSHIP",
    "schema_name": "app_wallet",
    "object_name": "wallet_recalc_queue",
    "definition": "ALTER TABLE app_wallet.wallet_recalc_queue OWNER TO postgres;",
    "sort_order": 10
  },
  {
    "object_type": "RLS",
    "schema_name": "app_wallet",
    "object_name": "assets",
    "definition": "ALTER TABLE app_wallet.assets ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "app_wallet",
    "object_name": "exchange_rates",
    "definition": "ALTER TABLE app_wallet.exchange_rates ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "app_wallet",
    "object_name": "transactions",
    "definition": "ALTER TABLE app_wallet.transactions ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "app_wallet",
    "object_name": "transactions_audit",
    "definition": "ALTER TABLE app_wallet.transactions_audit ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "app_wallet",
    "object_name": "user_asset_balance",
    "definition": "ALTER TABLE app_wallet.user_asset_balance ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "RLS",
    "schema_name": "app_wallet",
    "object_name": "wallet_recalc_queue",
    "definition": "ALTER TABLE app_wallet.wallet_recalc_queue ENABLE ROW LEVEL SECURITY;",
    "sort_order": 11
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "transactions.balance_after",
    "definition": "COMMENT ON COLUMN app_wallet.transactions.balance_after IS 'Ledger balance after this transaction. Only meaningful for completed transactions (otherwise NULL).';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "transactions.balance_before",
    "definition": "COMMENT ON COLUMN app_wallet.transactions.balance_before IS 'Ledger balance before this transaction. Only meaningful for completed transactions (otherwise NULL).';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "transactions.effective_at",
    "definition": "COMMENT ON COLUMN app_wallet.transactions.effective_at IS 'Accounting effective date/time. Used for ordering and balance calculations when status = completed. If NULL, defaults to created_at.';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "transactions.source_id",
    "definition": "COMMENT ON COLUMN app_wallet.transactions.source_id IS 'ID of the source entity, must exist in respective table (enforced by application).';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "transactions.source_type",
    "definition": "COMMENT ON COLUMN app_wallet.transactions.source_type IS 'Polymorphic source type: order, reward, referral, booking, invoice. Null if not applicable.';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "transactions.transaction_type",
    "definition": "COMMENT ON COLUMN app_wallet.transactions.transaction_type IS 'Semantic type of transaction: transfer, purchase, escrow_hold, escrow_release, refund, bonus, payout, fee, adjustment.';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "transactions.transfer_group_id",
    "definition": "COMMENT ON COLUMN app_wallet.transactions.transfer_group_id IS 'Links multiple transactions that together form a single financial event (e.g., debit and credit legs of a transfer). Used for double-entry consistency.';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "transactions_audit.ip",
    "definition": "COMMENT ON COLUMN app_wallet.transactions_audit.ip IS 'Client IP address (from X-Forwarded-For or direct).';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "transactions_audit.request_id",
    "definition": "COMMENT ON COLUMN app_wallet.transactions_audit.request_id IS 'Client-generated request ID for idempotency and debugging.';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "transactions_audit.trace_id",
    "definition": "COMMENT ON COLUMN app_wallet.transactions_audit.trace_id IS 'Distributed tracing ID for cross-service correlation.';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "transactions_audit.user_agent",
    "definition": "COMMENT ON COLUMN app_wallet.transactions_audit.user_agent IS 'Client User-Agent string.';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "user_asset_balance.available",
    "definition": "COMMENT ON COLUMN app_wallet.user_asset_balance.available IS 'Available for spending = total - frozen - pending_outgoing. pending_incoming does NOT affect available.';",
    "sort_order": 13
  },
  {
    "object_type": "COLUMN COMMENT",
    "schema_name": "app_wallet",
    "object_name": "user_asset_balance.pending_incoming",
    "definition": "COMMENT ON COLUMN app_wallet.user_asset_balance.pending_incoming IS 'Incoming credit not yet completed. Not included in available, but included in total.';",
    "sort_order": 13
  }
]