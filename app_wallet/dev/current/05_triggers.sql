/*
|--------------------------------------------------------------------------
| FILE: 05_triggers.sql
|--------------------------------------------------------------------------
|
| PURPOSE:
| يحتوي على جميع الـ Triggers المرتبطة بالجداول.
|
| CONTENTS:
| - CREATE TRIGGER
| - BEFORE INSERT
| - AFTER UPDATE
| - Trigger Bindings
|
| EXAMPLES:
| - contract_state_transition_trigger
| - contracts_search_vector_update
|
| WHY IMPORTANT:
| يشغل منطق تلقائي عند تعديل البيانات.
|
|--------------------------------------------------------------------------
*/

CREATE TRIGGER trigger_prevent_escrow_immutable_fields BEFORE UPDATE ON app_wallet.escrow_cases FOR EACH ROW EXECUTE FUNCTION app_wallet.trg_prevent_escrow_immutable_fields();
CREATE TRIGGER trigger_prevent_immutable_fields BEFORE UPDATE ON app_wallet.transactions FOR EACH ROW EXECUTE FUNCTION app_wallet.trg_prevent_immutable_fields();
CREATE TRIGGER trigger_transactions_audit AFTER INSERT OR DELETE OR UPDATE ON app_wallet.transactions FOR EACH ROW EXECUTE FUNCTION app_wallet.trg_transactions_audit();
CREATE TRIGGER trigger_transactions_realtime AFTER INSERT OR DELETE OR UPDATE ON app_wallet.transactions FOR EACH ROW EXECUTE FUNCTION app_events.broadcast_user_change();
CREATE TRIGGER trigger_validate_reversal_parent BEFORE INSERT OR UPDATE ON app_wallet.transactions FOR EACH ROW WHEN ((new.event_name = 'reversal'::text)) EXECUTE FUNCTION app_wallet.trg_validate_reversal_parent();