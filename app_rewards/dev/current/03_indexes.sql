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

CREATE UNIQUE INDEX reward_rule_audit_log_pkey ON app_rewards.reward_rule_audit_log USING btree (id);
CREATE UNIQUE INDEX one_active_reward_rule_per_event ON app_rewards.reward_rule_versions USING btree (event_name) WHERE (is_active = true);
CREATE UNIQUE INDEX uq_event_version ON app_rewards.reward_rule_versions USING btree (event_name, version);
CREATE UNIQUE INDEX reward_rule_versions_pkey ON app_rewards.reward_rule_versions USING btree (id);
CREATE UNIQUE INDEX uq_reward_transactions_idempotency ON app_rewards.reward_transactions USING btree (idempotency_key);
CREATE UNIQUE INDEX reward_transactions_pkey ON app_rewards.reward_transactions USING btree (id);