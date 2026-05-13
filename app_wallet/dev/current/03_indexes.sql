/*
|--------------------------------------------------------------------------
| FILE: 03_indexes.sql
|--------------------------------------------------------------------------
|
| PURPOSE:
| يحتوي على جميع الـ Indexes الخاصة بتحسين الأداء.
|
| CONTENTS:
| - CREATE INDEX
| - CREATE UNIQUE INDEX
| - GIN Indexes
| - BTREE Indexes
|
| EXAMPLES:
| - search indexes
| - foreign key indexes
|
| WHY IMPORTANT:
| يحسن سرعة البحث والاستعلامات بشكل كبير.
|
|--------------------------------------------------------------------------
*/

CREATE INDEX idx_escrow_cases_client ON app_wallet.escrow_cases USING btree (client_user_id);
CREATE INDEX idx_escrow_cases_provider ON app_wallet.escrow_cases USING btree (provider_user_id);
CREATE INDEX idx_escrow_cases_status ON app_wallet.escrow_cases USING btree (status);
CREATE INDEX idx_escrow_cases_transfer_group ON app_wallet.escrow_cases USING btree (transfer_group_id);
CREATE UNIQUE INDEX escrow_cases_pkey ON app_wallet.escrow_cases USING btree (id);
CREATE INDEX idx_escrow_movements_actor ON app_wallet.escrow_movements USING btree (actor_user_id);
CREATE INDEX idx_escrow_movements_case ON app_wallet.escrow_movements USING btree (escrow_case_id);
CREATE INDEX idx_escrow_movements_type ON app_wallet.escrow_movements USING btree (movement_type);
CREATE UNIQUE INDEX escrow_movements_pkey ON app_wallet.escrow_movements USING btree (id);
CREATE INDEX idx_penalty_allocations_item ON app_wallet.escrow_penalty_allocations USING btree (penalty_item_id);
CREATE UNIQUE INDEX escrow_penalty_allocations_pkey ON app_wallet.escrow_penalty_allocations USING btree (id);
CREATE INDEX idx_escrow_penalty_items_case ON app_wallet.escrow_penalty_items USING btree (escrow_case_id);
CREATE UNIQUE INDEX escrow_penalty_items_pkey ON app_wallet.escrow_penalty_items USING btree (id);
CREATE INDEX idx_escrow_service_releases_case ON app_wallet.escrow_service_releases USING btree (escrow_case_id);
CREATE INDEX idx_escrow_service_releases_status ON app_wallet.escrow_service_releases USING btree (status);
CREATE UNIQUE INDEX escrow_service_releases_pkey ON app_wallet.escrow_service_releases USING btree (id);
CREATE INDEX idx_exchange_rates_pairs ON app_wallet.exchange_rates USING btree (from_asset, to_asset, effective_from);
CREATE UNIQUE INDEX uq_exchange_rates_current ON app_wallet.exchange_rates USING btree (from_asset, to_asset) WHERE (effective_until IS NULL);
CREATE UNIQUE INDEX exchange_rates_pkey ON app_wallet.exchange_rates USING btree (from_asset, to_asset, effective_from);
CREATE INDEX idx_audit_transaction_time ON app_wallet.transactions_audit USING btree (transaction_id, changed_at DESC);
CREATE INDEX idx_transactions_audit_changed_at ON app_wallet.transactions_audit USING btree (changed_at);
CREATE INDEX idx_transactions_audit_transaction_id ON app_wallet.transactions_audit USING btree (transaction_id);
CREATE UNIQUE INDEX transactions_audit_pkey ON app_wallet.transactions_audit USING btree (audit_id);
CREATE UNIQUE INDEX user_asset_balance_pkey ON app_wallet.user_asset_balance USING btree (internal_user_id, asset_code, wallet_type);
CREATE INDEX idx_recalc_queue_status_priority ON app_wallet.wallet_recalc_queue USING btree (status, priority DESC, created_at);
CREATE INDEX idx_wallet_recalc_queue_priority ON app_wallet.wallet_recalc_queue USING btree (priority DESC, created_at) WHERE (status = 'pending'::text);
CREATE INDEX idx_wallet_recalc_queue_status ON app_wallet.wallet_recalc_queue USING btree (status, created_at);
CREATE UNIQUE INDEX uq_wallet_recalc_queue_pending ON app_wallet.wallet_recalc_queue USING btree (internal_user_id) WHERE (status = 'pending'::text);
CREATE UNIQUE INDEX wallet_recalc_queue_pkey ON app_wallet.wallet_recalc_queue USING btree (id);
CREATE UNIQUE INDEX assets_pkey ON app_wallet.assets USING btree (code);
CREATE INDEX idx_wallet_transactions_source_type ON app_wallet.transactions USING btree (source_type);
CREATE INDEX idx_wallet_transactions_status ON app_wallet.transactions USING btree (status);
CREATE INDEX idx_active_transactions_asset ON app_wallet.transactions USING btree (actor_user_id, asset_code) WHERE (status = ANY (ARRAY['pending'::text, 'frozen'::text]));
CREATE UNIQUE INDEX idx_reversal_unique ON app_wallet.transactions USING btree (ledger_reference_id) WHERE ((event_name = 'reversal'::text) AND (ledger_reference_id IS NOT NULL));
CREATE INDEX idx_transactions_asset_code ON app_wallet.transactions USING btree (asset_code);
CREATE INDEX idx_transactions_conversion_group ON app_wallet.transactions USING btree (conversion_group_id);
CREATE INDEX idx_transactions_created_by ON app_wallet.transactions USING btree (created_by);
CREATE INDEX idx_transactions_effective_at ON app_wallet.transactions USING btree (effective_at);
CREATE INDEX idx_transactions_ledger_ref_event ON app_wallet.transactions USING btree (ledger_reference_id, event_name);
CREATE INDEX idx_transactions_reversed ON app_wallet.transactions USING btree (is_reversed, reversed_at);
CREATE INDEX idx_transactions_source_lookup ON app_wallet.transactions USING btree (source_type, source_id);
CREATE INDEX idx_transactions_type ON app_wallet.transactions USING btree (transaction_type);
CREATE INDEX idx_transactions_updated_by ON app_wallet.transactions USING btree (updated_by);
CREATE INDEX idx_transactions_wallet_type ON app_wallet.transactions USING btree (wallet_type);
CREATE INDEX idx_transfer_group_id ON app_wallet.transactions USING btree (transfer_group_id);
CREATE INDEX idx_tx_actor_status_asset ON app_wallet.transactions USING btree (actor_user_id, status, asset_code);
CREATE INDEX idx_wallet_transactions_created_at ON app_wallet.transactions USING btree (created_at DESC);
CREATE INDEX idx_wallet_transactions_event_name ON app_wallet.transactions USING btree (event_name);
CREATE INDEX idx_wallet_transactions_source_id ON app_wallet.transactions USING btree (source_id);
CREATE UNIQUE INDEX uq_ledger_reference_event ON app_wallet.transactions USING btree (ledger_reference_id, event_name) WHERE (ledger_reference_id IS NOT NULL);
CREATE UNIQUE INDEX uq_payment_idempotency_per_user ON app_wallet.transactions USING btree (actor_user_id, payment_idempotency_key);
CREATE UNIQUE INDEX transactions_pkey ON app_wallet.transactions USING btree (id);