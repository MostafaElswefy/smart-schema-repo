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

CREATE UNIQUE INDEX contract_approvals_pkey ON work.contract_approvals USING btree (id);
CREATE UNIQUE INDEX contract_links_pkey ON work.contract_links USING btree (id);
CREATE UNIQUE INDEX contract_messages_pkey ON work.contract_messages USING btree (id);
CREATE UNIQUE INDEX contract_milestones_pkey ON work.contract_milestones USING btree (id);
CREATE UNIQUE INDEX contract_permissions_pkey ON work.contract_permissions USING btree (id);
CREATE UNIQUE INDEX execution_logs_pkey ON work.execution_logs USING btree (id);
CREATE UNIQUE INDEX uq_contract_version ON work.work_contract_versions USING btree (contract_id, version_no);
CREATE UNIQUE INDEX work_contract_versions_pkey ON work.work_contract_versions USING btree (id);
CREATE UNIQUE INDEX work_execution_units_pkey ON work.work_execution_units USING btree (id);
CREATE UNIQUE INDEX work_financial_routes_pkey ON work.work_financial_routes USING btree (id);
CREATE UNIQUE INDEX work_ownership_transfers_pkey ON work.work_ownership_transfers USING btree (id);
CREATE UNIQUE INDEX work_visibility_pkey ON work.work_visibility USING btree (id);
CREATE UNIQUE INDEX contracts_pkey ON work.contracts USING btree (id);
CREATE UNIQUE INDEX contract_participants_pkey ON work.contract_participants USING btree (id);
CREATE UNIQUE INDEX work_assignments_pkey ON work.work_assignments USING btree (id);