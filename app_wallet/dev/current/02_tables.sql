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

\restrict 5WhxaRRXyL5BNobodOYTApKmpOt8vGwPwAnrffDgtoiSHLazkE2ZqRkyLaxpxkA

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
-- Name: app_wallet; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA app_wallet;


--
-- Name: cleanup_recalc_queue(integer); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.cleanup_recalc_queue(p_retention_days integer DEFAULT 180) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_deleted_count INT;
BEGIN
    DELETE FROM app_wallet.wallet_recalc_queue
    WHERE processed = TRUE
      AND processed_at < NOW() - (p_retention_days || ' days')::INTERVAL;
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    RETURN v_deleted_count;
END;
$$;


--
-- Name: enqueue_wallet_recalc(uuid); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.enqueue_wallet_recalc(p_internal_user_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    INSERT INTO app_wallet.wallet_recalc_queue (internal_user_id)
    VALUES (p_internal_user_id)
    ON CONFLICT DO NOTHING; -- يمكن تعديل حسب الحاجة
END;
$$;


--
-- Name: get_user_wallet_summary(uuid); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.get_user_wallet_summary(p_internal_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app_wallet', 'public'
    AS $$
DECLARE
    v_wallets JSONB;
BEGIN
    SELECT jsonb_build_object(
        'cash_total', ws.cash_total,
        'cash_available', ws.cash_available,
        'cash_frozen', ws.cash_frozen,
        'cash_pending', ws.cash_pending,
        'coins_total', ws.coins_total,
        'coins_available', ws.coins_available,
        'coins_frozen', ws.coins_frozen,
        'coins_pending', ws.coins_pending,
        'points_total', ws.points_total,
        'points_available', ws.points_available,
        'points_frozen', ws.points_frozen,
        'points_pending', ws.points_pending,
        'currency', COALESCE(ws.currency, 'EGP'),
        'version', ws.version,
        'calculated_at', ws.calculated_at,
        'updated_at', ws.updated_at
    )
    INTO v_wallets
    FROM user_wallet_summary ws
    WHERE ws.internal_user_id = p_internal_user_id;

    IF v_wallets IS NULL THEN
        RETURN jsonb_build_object(
            'success', true,
            'data', jsonb_build_object(
                'internal_user_id', p_internal_user_id,
                'wallets', '{}'::jsonb
            )
        );
    ELSE
        RETURN jsonb_build_object(
            'success', true,
            'data', jsonb_build_object(
                'internal_user_id', p_internal_user_id,
                'wallets', v_wallets
            )
        );
    END IF;
END;
$$;


--
-- Name: give_signup_bonus_v3(uuid, text, text, jsonb, text); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.give_signup_bonus_v3(p_user_uid uuid, p_source_app text, p_description text, p_rewards jsonb, p_currency text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$declare
  v_event_id text;

  v_key text;
  v_amount numeric;

  v_balance_before numeric;
  v_balance_after numeric;

  v_any_processed boolean := false;
  v_any_skipped boolean := false;
begin

  for v_key, v_amount in
    select * from jsonb_each_text(p_rewards)
  loop

    -- 🧠 normalize wallet key
    v_key := lower(v_key);

    -- 🔑 event id per wallet
    v_event_id := 'signup_bonus_' || v_key || '_' || p_user_uid::text;

    -- 🔒 idempotency check (SAFE)
    if exists (
      select 1
      from public.processed_events
      where event_id = v_event_id
    ) then
      v_any_skipped := true;
      continue;
    end if;

    -- 📝 mark event (protected by unique constraint)
    insert into public.processed_events (event_id, event_type, user_uid)
    values (v_event_id, 'signup_bonus', p_user_uid)
    on conflict (event_id) do nothing;

    v_any_processed := true;

    -- 🧮 balanceBefore
    select coalesce(sum("transactionAmount"), 0)
    into v_balance_before
    from public."centerTransactions"
    where "transactionUserUID" = p_user_uid::text
      and lower("transactionWallet") = v_key;

    v_balance_after := v_balance_before + v_amount;

    -- 💰 insert transaction
    insert into public."centerTransactions" (
      "transactionId",
      "transactionUserUID",
      "transactionAmount",
      "transactionDirection",
      "transactionStatus",
      "balanceBefore",
      "balanceAfter",
      "sourceApp",
      "transactionWallet",
      "transactionTitle",
      "transactionDescription",
      "currency",
      "fromActorType",
      "toActorType",
      "toUID",
      "createdAt",
      "updatedAt",
      "completedAt"
    )
    values (
      gen_random_uuid()::text,
      p_user_uid::text,
      v_amount,
      'credit',
      'completed',
      v_balance_before,
      v_balance_after,
      p_source_app,
      v_key,
      'signup_bonus',
      p_description,
      case when v_key = 'cash' then p_currency else null end,
      'system',
      'user',
      p_user_uid::text,
      now(),
      now(),
      now()
    );

  end loop;

  -- 🧠 FINAL RESPONSE LOGIC
  if v_any_processed and v_any_skipped then
    return jsonb_build_object(
      'success', true,
      'message', 'partial_processed'
    );

  elsif v_any_processed then
    return jsonb_build_object(
      'success', true,
      'message', 'processed'
    );

  else
    return jsonb_build_object(
      'success', true,
      'message', 'skipped'
    );
  end if;

end;$$;


--
-- Name: helper_insert_wallet_summary(uuid); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.helper_insert_wallet_summary(p_internal_user_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO app_wallet.user_wallet_summary (
    internal_user_id,
    cash_total,
    cash_available,
    cash_frozen,
    cash_pending,
    coins_total,
    coins_available,
    coins_frozen,
    coins_pending,
    points_total,
    points_available,
    points_frozen,
    points_pending,
    currency,
    version,
    calculated_at,
    updated_at
  ) VALUES (
    p_internal_user_id,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    NULL,     -- currency = null (كما طلبت)
    0,        -- version = 0 (كما طلبت)
    NOW(),
    NOW()
  )
  ON CONFLICT (internal_user_id) DO NOTHING;
END;
$$;


--
-- Name: prevent_escrow_manual_updates(); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.prevent_escrow_manual_updates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    IF (
      NEW.released_to_provider <> OLD.released_to_provider OR
      NEW.released_to_client <> OLD.released_to_client OR
      NEW.platform_fee_taken <> OLD.platform_fee_taken
    ) THEN
      RAISE EXCEPTION 'Direct modification of escrow financial fields is not allowed';
    END IF;
  END IF;

  RETURN NEW;
END;
$$;


--
-- Name: process_recalc_queue(integer); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.process_recalc_queue(p_batch_size integer DEFAULT 100) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app_wallet', 'public'
    AS $$
DECLARE
    v_record RECORD;
BEGIN
    FOR v_record IN
        SELECT id, internal_user_id, retry_count
        FROM app_wallet.wallet_recalc_queue
        WHERE processed = FALSE
        ORDER BY priority DESC, created_at ASC
        LIMIT p_batch_size
        FOR UPDATE SKIP LOCKED
    LOOP
        BEGIN
            PERFORM app_wallet.recalculate_user_wallet_summary(v_record.internal_user_id);
            UPDATE app_wallet.wallet_recalc_queue
            SET processed = TRUE, processed_at = NOW()
            WHERE id = v_record.id;
        EXCEPTION WHEN OTHERS THEN
            RAISE WARNING 'Failed to recalc user % (id %): %', v_record.internal_user_id, v_record.id, SQLERRM;
            UPDATE app_wallet.wallet_recalc_queue
            SET retry_count = retry_count + 1,
                failed_at = NOW()
            WHERE id = v_record.id;
        END;
    END LOOP;
END;
$$;


--
-- Name: process_recalc_queue(integer, integer); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.process_recalc_queue(p_batch_size integer DEFAULT 100, p_max_retries integer DEFAULT 10) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app_wallet', 'public'
    AS $$
DECLARE
    v_record RECORD;
BEGIN
    FOR v_record IN
        SELECT id, internal_user_id, retry_count
        FROM app_wallet.wallet_recalc_queue
        WHERE status IN ('pending', 'failed')   -- ✅ إضافة 'failed'
          AND retry_count < p_max_retries
        ORDER BY priority DESC, created_at ASC
        LIMIT p_batch_size
        FOR UPDATE SKIP LOCKED
    LOOP
        BEGIN
            UPDATE app_wallet.wallet_recalc_queue SET status = 'processing' WHERE id = v_record.id;
            PERFORM app_wallet.recalculate_user_balances(v_record.internal_user_id);
            UPDATE app_wallet.wallet_recalc_queue
            SET status = 'completed', processed_at = NOW(), last_error = NULL
            WHERE id = v_record.id;
        EXCEPTION WHEN OTHERS THEN
            UPDATE app_wallet.wallet_recalc_queue
            SET retry_count = retry_count + 1,
                failed_at = NOW(),
                last_error = LEFT(SQLERRM, 500),
                status = CASE
                    WHEN v_record.retry_count + 1 >= p_max_retries THEN 'permanent_failed'
                    ELSE 'failed'
                END
            WHERE id = v_record.id;

            IF v_record.retry_count + 1 >= p_max_retries THEN
                RAISE WARNING 'Permanent failure for user % after % attempts: %', v_record.internal_user_id, p_max_retries, SQLERRM;
            ELSE
                RAISE WARNING 'Failed to recalc user % (attempt %): %', v_record.internal_user_id, v_record.retry_count + 1, SQLERRM;
            END IF;
        END;
    END LOOP;
END;
$$;


--
-- Name: recalculate_user_balances(uuid); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.recalculate_user_balances(p_actor_user_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app_wallet', 'public'
    AS $$
DECLARE
    v_asset TEXT;
    v_total NUMERIC; v_frozen NUMERIC; v_pending_out NUMERIC; v_pending_in NUMERIC;
BEGIN
    FOR v_asset IN
        SELECT DISTINCT asset_code
        FROM app_wallet.transactions
        WHERE actor_user_id = p_actor_user_id
    LOOP
        SELECT
            COALESCE(SUM(CASE WHEN direction = 'credit' AND status = 'completed' THEN amount ELSE 0 END), 0) -
            COALESCE(SUM(CASE WHEN direction = 'debit' AND status = 'completed' THEN amount ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN direction = 'debit' AND status = 'frozen' THEN amount ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN direction = 'debit' AND status = 'pending' THEN amount ELSE 0 END), 0),
            COALESCE(SUM(CASE WHEN direction = 'credit' AND status = 'pending' THEN amount ELSE 0 END), 0)
        INTO v_total, v_frozen, v_pending_out, v_pending_in
        FROM app_wallet.transactions
        WHERE actor_user_id = p_actor_user_id AND asset_code = v_asset;

        INSERT INTO app_wallet.user_asset_balance (
            internal_user_id, asset_code,
            total, available, frozen, pending_outgoing, pending_incoming,
            calculated_at, updated_at
        ) VALUES (
            p_actor_user_id, v_asset,
            v_total,
            v_total - v_frozen - v_pending_out,
            v_frozen,
            v_pending_out,
            v_pending_in,
            NOW(), NOW()
        )
        ON CONFLICT (internal_user_id, asset_code) DO UPDATE SET
            total = EXCLUDED.total,
            available = EXCLUDED.available,
            frozen = EXCLUDED.frozen,
            pending_outgoing = EXCLUDED.pending_outgoing,
            pending_incoming = EXCLUDED.pending_incoming,
            calculated_at = EXCLUDED.calculated_at,
            updated_at = EXCLUDED.updated_at,
            version = user_asset_balance.version + 1;
    END LOOP;

    -- حذف الأصول التي لم تعد موجودة في المعاملات
    DELETE FROM app_wallet.user_asset_balance
    WHERE internal_user_id = p_actor_user_id
      AND asset_code NOT IN (SELECT DISTINCT asset_code FROM app_wallet.transactions WHERE actor_user_id = p_actor_user_id);
END;
$$;


--
-- Name: recalculate_user_wallet_summary(uuid); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.recalculate_user_wallet_summary(p_actor_user_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app_wallet', 'public'
    AS $$
DECLARE
    v_cash_total NUMERIC := 0;
    v_cash_frozen NUMERIC := 0;
    v_cash_pending_outgoing NUMERIC := 0;
    v_cash_pending_incoming NUMERIC := 0;
    v_coins_total NUMERIC := 0;
    v_coins_frozen NUMERIC := 0;
    v_coins_pending_outgoing NUMERIC := 0;
    v_coins_pending_incoming NUMERIC := 0;
    v_points_total NUMERIC := 0;
    v_points_frozen NUMERIC := 0;
    v_points_pending_outgoing NUMERIC := 0;
    v_points_pending_incoming NUMERIC := 0;
BEGIN
    -- استعلام واحد يجمع كل ما نحتاجه
    SELECT
        -- Cash: total (completed credits - completed debits)
        COALESCE(SUM(CASE WHEN wallet_type = 'cash' AND direction = 'credit' AND status = 'completed' THEN amount ELSE 0 END), 0) -
        COALESCE(SUM(CASE WHEN wallet_type = 'cash' AND direction = 'debit' AND status = 'completed' THEN amount ELSE 0 END), 0),
        -- Cash frozen (debit frozen)
        COALESCE(SUM(CASE WHEN wallet_type = 'cash' AND direction = 'debit' AND status = 'frozen' THEN amount ELSE 0 END), 0),
        -- Cash pending outgoing (debit pending)
        COALESCE(SUM(CASE WHEN wallet_type = 'cash' AND direction = 'debit' AND status = 'pending' THEN amount ELSE 0 END), 0),
        -- Cash pending incoming (credit pending)
        COALESCE(SUM(CASE WHEN wallet_type = 'cash' AND direction = 'credit' AND status = 'pending' THEN amount ELSE 0 END), 0),
        -- Coins (مشابه)
        COALESCE(SUM(CASE WHEN wallet_type = 'coins' AND direction = 'credit' AND status = 'completed' THEN amount ELSE 0 END), 0) -
        COALESCE(SUM(CASE WHEN wallet_type = 'coins' AND direction = 'debit' AND status = 'completed' THEN amount ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN wallet_type = 'coins' AND direction = 'debit' AND status = 'frozen' THEN amount ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN wallet_type = 'coins' AND direction = 'debit' AND status = 'pending' THEN amount ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN wallet_type = 'coins' AND direction = 'credit' AND status = 'pending' THEN amount ELSE 0 END), 0),
        -- Points
        COALESCE(SUM(CASE WHEN wallet_type = 'points' AND direction = 'credit' AND status = 'completed' THEN amount ELSE 0 END), 0) -
        COALESCE(SUM(CASE WHEN wallet_type = 'points' AND direction = 'debit' AND status = 'completed' THEN amount ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN wallet_type = 'points' AND direction = 'debit' AND status = 'frozen' THEN amount ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN wallet_type = 'points' AND direction = 'debit' AND status = 'pending' THEN amount ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN wallet_type = 'points' AND direction = 'credit' AND status = 'pending' THEN amount ELSE 0 END), 0)
    INTO
        v_cash_total, v_cash_frozen, v_cash_pending_outgoing, v_cash_pending_incoming,
        v_coins_total, v_coins_frozen, v_coins_pending_outgoing, v_coins_pending_incoming,
        v_points_total, v_points_frozen, v_points_pending_outgoing, v_points_pending_incoming
    FROM app_wallet.transactions
    WHERE actor_user_id = p_actor_user_id;

    -- تحديث الملخص مع استخدام pending_incoming
    INSERT INTO app_wallet.user_wallet_summary (
        internal_user_id,
        cash_total, cash_available, cash_frozen, cash_pending, cash_pending_incoming,
        coins_total, coins_available, coins_frozen, coins_pending, coins_pending_incoming,
        points_total, points_available, points_frozen, points_pending, points_pending_incoming,
        calculated_at, updated_at
    ) VALUES (
        p_actor_user_id,
        v_cash_total,
        v_cash_total - v_cash_frozen - v_cash_pending_outgoing,
        v_cash_frozen,
        v_cash_pending_outgoing,
        v_cash_pending_incoming,
        v_coins_total,
        v_coins_total - v_coins_frozen - v_coins_pending_outgoing,
        v_coins_frozen,
        v_coins_pending_outgoing,
        v_coins_pending_incoming,
        v_points_total,
        v_points_total - v_points_frozen - v_points_pending_outgoing,
        v_points_frozen,
        v_points_pending_outgoing,
        v_points_pending_incoming,
        NOW(), NOW()
    )
    ON CONFLICT (internal_user_id) DO UPDATE SET
        cash_total = EXCLUDED.cash_total,
        cash_available = EXCLUDED.cash_available,
        cash_frozen = EXCLUDED.cash_frozen,
        cash_pending = EXCLUDED.cash_pending,
        cash_pending_incoming = EXCLUDED.cash_pending_incoming,
        coins_total = EXCLUDED.coins_total,
        coins_available = EXCLUDED.coins_available,
        coins_frozen = EXCLUDED.coins_frozen,
        coins_pending = EXCLUDED.coins_pending,
        coins_pending_incoming = EXCLUDED.coins_pending_incoming,
        points_total = EXCLUDED.points_total,
        points_available = EXCLUDED.points_available,
        points_frozen = EXCLUDED.points_frozen,
        points_pending = EXCLUDED.points_pending,
        points_pending_incoming = EXCLUDED.points_pending_incoming,
        calculated_at = EXCLUDED.calculated_at,
        updated_at = EXCLUDED.updated_at,
        version = user_wallet_summary.version + 1;
END;
$$;


--
-- Name: reward_engine(text, text, text, text, jsonb, text); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.reward_engine(p_user_uid text, p_event_name text, p_source_app text, p_description text, p_metadata jsonb DEFAULT '{}'::jsonb, p_currency text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$declare
  v_rewards jsonb;

  v_key text;
  v_amount numeric;

  v_balance_before numeric;
  v_balance_after numeric;

  v_event_id text;

  v_any_processed boolean := false;
  v_any_skipped boolean := false;

  v_ref_key text;
begin

  -- 🔍 get reward config (LATEST ACTIVE VERSION)
  select reward_config::jsonb
  into v_rewards
  from public.reward_rule_versions
  where event_name = p_event_name
    and is_active = true
  order by created_at desc
  limit 1;

  if v_rewards is null then
    return jsonb_build_object(
      'success', false,
      'message', 'event_not_found'
    );
  end if;

  -- 🧠 extract referral context (if exists)
  v_ref_key := p_metadata->>'referral_key';

  -- 🔁 loop rewards
  for v_key, v_amount in
    select * from jsonb_each_text(v_rewards)
  loop

    v_key := lower(v_key);

    -- 🔑 idempotency (context-aware)
    v_event_id :=
      p_event_name || '_' || v_key || '_' ||
      coalesce(v_ref_key, p_user_uid);

    if exists (
      select 1
      from public.processed_events
      where event_id = v_event_id
    ) then
      v_any_skipped := true;
      continue;
    end if;

    insert into public.processed_events (event_id, event_type, user_uid)
    values (v_event_id, p_event_name, p_user_uid)
    on conflict (event_id) do nothing;

    v_any_processed := true;

    -- 🧮 balance
    select coalesce(sum("transactionAmount"), 0)
    into v_balance_before
    from public."centerTransactions"
    where "transactionUserUID" = p_user_uid
      and lower("transactionWallet") = v_key;

    v_balance_after := v_balance_before + v_amount;

    -- 💰 transaction insert
    insert into public."centerTransactions" (
      "transactionId",
      "transactionUserUID",
      "transactionAmount",
      "transactionDirection",
      "transactionStatus",
      "balanceBefore",
      "balanceAfter",
      "sourceApp",
      "transactionWallet",
      "transactionTitle",
      "transactionDescription",
      "currency",
      "fromActorType",
      "toActorType",
      "toUID",
      "createdAt",
      "updatedAt",
      "completedAt"
    )
    values (
      gen_random_uuid()::text,
      p_user_uid,
      v_amount,
      'credit',
      'completed',
      v_balance_before,
      v_balance_after,
      p_source_app,
      v_key,
      p_event_name,
      p_description,
      case when v_key = 'cash' then p_currency else null end,
      'system',
      'user',
      p_user_uid,
      now(),
      now(),
      now()
    );

  end loop;

  -- 🧠 response
  if v_any_processed and v_any_skipped then
    return jsonb_build_object('success', true, 'message', 'partial_processed');
  elsif v_any_processed then
    return jsonb_build_object('success', true, 'message', 'processed');
  else
    return jsonb_build_object('success', true, 'message', 'skipped');
  end if;

end;$$;


--
-- Name: reward_engine(uuid, text, text, text, jsonb, text); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.reward_engine(p_user_uid uuid, p_event_name text, p_source_app text, p_description text, p_metadata jsonb DEFAULT '{}'::jsonb, p_currency text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$declare
  v_rewards jsonb;

  v_key text;
  v_amount numeric;

  v_balance_before numeric;
  v_balance_after numeric;

  v_event_id text;

  v_any_processed boolean := false;
  v_any_skipped boolean := false;

  v_ref_key text;
begin

  -- 🔍 get reward config
  select reward_config
  into v_rewards
  from public.reward_rules
  where event_name = p_event_name
    and is_active = true;

  if v_rewards is null then
    return jsonb_build_object(
      'success', false,
      'message', 'event_not_found'
    );
  end if;

  -- 🧠 extract referral context (if exists)
  v_ref_key := p_metadata->>'referral_key';

  -- 🔁 loop rewards
  for v_key, v_amount in
    select * from jsonb_each_text(v_rewards)
  loop

    v_key := lower(v_key);

    -- 🔑 idempotency (context-aware)
    v_event_id :=
      p_event_name || '_' || v_key || '_' ||
      coalesce(v_ref_key, p_user_uid::text);

    if exists (
      select 1
      from public.processed_events
      where event_id = v_event_id
    ) then
      v_any_skipped := true;
      continue;
    end if;

    insert into public.processed_events (event_id, event_type, user_uid)
    values (v_event_id, p_event_name, p_user_uid)
    on conflict (event_id) do nothing;

    v_any_processed := true;

    -- 🧮 balance
    select coalesce(sum("transactionAmount"), 0)
    into v_balance_before
    from public."centerTransactions"
    where "transactionUserUID" = p_user_uid::text
      and lower("transactionWallet") = v_key;

    v_balance_after := v_balance_before + v_amount;

    -- 💰 transaction insert
    insert into public."centerTransactions" (
      "transactionId",
      "transactionUserUID",
      "transactionAmount",
      "transactionDirection",
      "transactionStatus",
      "balanceBefore",
      "balanceAfter",
      "sourceApp",
      "transactionWallet",
      "transactionTitle",
      "transactionDescription",
      "currency",
      "fromActorType",
      "toActorType",
      "toUID",
      "createdAt",
      "updatedAt",
      "completedAt"
    )
    values (
      gen_random_uuid()::text,
      p_user_uid::text,
      v_amount,
      'credit',
      'completed',
      v_balance_before,
      v_balance_after,
      p_source_app,
      v_key,
      p_event_name,
      p_description,
      case when v_key = 'cash' then p_currency else null end,
      'system',
      'user',
      p_user_uid::text,
      now(),
      now(),
      now()
    );

  end loop;

  -- 🧠 response
  if v_any_processed and v_any_skipped then
    return jsonb_build_object('success', true, 'message', 'partial_processed');
  elsif v_any_processed then
    return jsonb_build_object('success', true, 'message', 'processed');
  else
    return jsonb_build_object('success', true, 'message', 'skipped');
  end if;

end;$$;


--
-- Name: reward_engine_v2(uuid, text, text, text, text); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.reward_engine_v2(p_user_uid uuid, p_event_name text, p_source_app text, p_description text, p_currency text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$declare
  v_rewards jsonb;

  v_key text;
  v_amount numeric;

  v_balance_before numeric;
  v_balance_after numeric;

  v_event_id text;

  v_any_processed boolean := false;
  v_any_skipped boolean := false;
begin

  -- 🧠 1. get ACTIVE rule version
  select reward_config
  into v_rewards
  from public.reward_rule_versions
  where event_name = p_event_name
    and is_active = true
  limit 1;

  if v_rewards is null then
    return jsonb_build_object(
      'success', false,
      'message', 'event_not_found'
    );
  end if;

  -- 🔁 2. loop rewards
  for v_key, v_amount in
    select * from jsonb_each_text(v_rewards)
  loop

    v_key := lower(v_key);

    -- 🔑 idempotency per event + wallet
    v_event_id := p_event_name || '_' || v_key || '_' || p_user_uid::text;

    if exists (
      select 1
      from public.processed_events
      where event_id = v_event_id
    ) then
      v_any_skipped := true;
      continue;
    end if;

    insert into public.processed_events (event_id, event_type, user_uid)
    values (v_event_id, p_event_name, p_user_uid)
    on conflict (event_id) do nothing;

    v_any_processed := true;

    -- 🧮 3. balance before (legacy tracking only)
    select coalesce(sum("transactionAmount"), 0)
    into v_balance_before
    from public."centerTransactions"
    where "transactionUserUID" = p_user_uid::text
      and lower("transactionWallet") = v_key;

    v_balance_after := v_balance_before + v_amount;

    -- 💰 4. insert transaction
    insert into public."centerTransactions" (
      "transactionId",
      "transactionUserUID",
      "transactionAmount",
      "transactionDirection",
      "transactionStatus",
      "balanceBefore",
      "balanceAfter",
      "sourceApp",
      "transactionWallet",
      "transactionTitle",
      "transactionDescription",
      "currency",
      "fromActorType",
      "toActorType",
      "toUID",
      "createdAt",
      "updatedAt",
      "completedAt"
    )
    values (
      gen_random_uuid()::text,
      p_user_uid::text,
      v_amount,
      'credit',
      'completed',
      v_balance_before,
      v_balance_after,
      p_source_app,
      v_key,
      p_event_name,
      p_description,
      case when v_key = 'cash' then p_currency else null end,
      'system',
      'user',
      p_user_uid::text,
      now(),
      now(),
      now()
    );

  end loop;

  -- 🔄 5. SYNC USER WALLET (NEW ADDITION 🔥)
  perform public.sync_user_wallets(p_user_uid::text);

  -- 🧠 6. response logic
  if v_any_processed and v_any_skipped then
    return jsonb_build_object(
      'success', true,
      'message', 'partial_processed'
    );

  elsif v_any_processed then
    return jsonb_build_object(
      'success', true,
      'message', 'processed'
    );

  else
    return jsonb_build_object(
      'success', true,
      'message', 'skipped'
    );
  end if;

end;$$;


--
-- Name: trg_prevent_balance_modification(); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.trg_prevent_balance_modification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        IF OLD.balance_before IS DISTINCT FROM NEW.balance_before THEN
            RAISE EXCEPTION 'balance_before cannot be updated';
        END IF;
        IF OLD.balance_after IS DISTINCT FROM NEW.balance_after THEN
            RAISE EXCEPTION 'balance_after cannot be updated';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: trg_prevent_completed_modification(); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.trg_prevent_completed_modification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'UPDATE' AND OLD.status IN ('completed', 'frozen', 'cancelled') THEN
        IF (OLD.amount IS DISTINCT FROM NEW.amount)
            OR (OLD.direction IS DISTINCT FROM NEW.direction)
            OR (OLD.wallet_type IS DISTINCT FROM NEW.wallet_type)
            OR (OLD.actor_user_id IS DISTINCT FROM NEW.actor_user_id)
            OR (OLD.event_name IS DISTINCT FROM NEW.event_name)
            OR (OLD.ledger_reference_id IS DISTINCT FROM NEW.ledger_reference_id)
            OR (OLD.transaction_type IS DISTINCT FROM NEW.transaction_type)
            OR (OLD.effective_at IS DISTINCT FROM NEW.effective_at)
            OR (OLD.status IS DISTINCT FROM NEW.status)
        THEN
            RAISE EXCEPTION 'Completed/frozen/cancelled transaction is immutable: cannot modify core fields.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: trg_prevent_escrow_hold_modification(); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.trg_prevent_escrow_hold_modification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD.transaction_type = 'escrow_hold' THEN
        RAISE EXCEPTION 'Direct modification of escrow hold transactions is not allowed. Use complete_escrow_case instead.';
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: trg_prevent_escrow_immutable_fields(); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.trg_prevent_escrow_immutable_fields() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    immutable_fields TEXT[] := ARRAY[
        'service_amount', 'client_deposit_amount', 'provider_deposit_amount',
        'released_to_provider', 'released_to_client', 'released_penalty_to_provider',
        'released_penalty_to_client', 'service_released'
    ];
    field TEXT;
BEGIN
    IF TG_OP = 'UPDATE' THEN
        -- إذا كان الصف مقفلاً، لا نسمح بأي تعديل (باستثناء ربما status؟)
        IF OLD.is_locked THEN
            RAISE EXCEPTION 'Escrow case is locked, cannot modify any field';
        END IF;

        -- حتى وإن لم يكن مقفلاً، لا نسمح بتعديل الحقول المالية الأساسية
        FOREACH field IN ARRAY immutable_fields
        LOOP
            IF OLD[field] IS DISTINCT FROM NEW[field] THEN
                RAISE EXCEPTION 'Cannot update field "%" after escrow case creation (use dedicated functions)', field;
            END IF;
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: trg_prevent_escrow_modification(); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.trg_prevent_escrow_modification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    immutable_columns TEXT[] := ARRAY[
        'service_amount', 'client_deposit_amount', 'provider_deposit_amount',
        'released_to_provider', 'released_to_client', 'released_penalty_to_provider',
        'released_penalty_to_client', 'service_released'
    ];
    col TEXT;
BEGIN
    IF TG_OP = 'UPDATE' THEN
        FOREACH col IN ARRAY immutable_columns
        LOOP
            EXECUTE format('IF (OLD.%I IS DISTINCT FROM NEW.%I) THEN RAISE EXCEPTION ''Column %% cannot be updated after case creation'', col; END IF;', col, col);
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: trg_prevent_immutable_fields(); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.trg_prevent_immutable_fields() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- 1. منع تعديل balance_before / balance_after (أبدًا)
    IF OLD.balance_before IS DISTINCT FROM NEW.balance_before OR
       OLD.balance_after IS DISTINCT FROM NEW.balance_after THEN
        RAISE EXCEPTION 'balance_before and balance_after cannot be updated';
    END IF;

    -- 2. منع تعديل amount, direction, asset_code, wallet_type, conversion_rate, transfer_group_id
    --    إذا كانت المعاملة نهائية (completed, frozen, cancelled) أو من نوع escrow_hold
    IF OLD.status IN ('completed', 'frozen', 'cancelled') OR OLD.transaction_type = 'escrow_hold' THEN
        IF OLD.amount IS DISTINCT FROM NEW.amount OR
           OLD.direction IS DISTINCT FROM NEW.direction OR
           OLD.asset_code IS DISTINCT FROM NEW.asset_code OR
           OLD.wallet_type IS DISTINCT FROM NEW.wallet_type OR
           OLD.conversion_rate IS DISTINCT FROM NEW.conversion_rate OR
           OLD.transfer_group_id IS DISTINCT FROM NEW.transfer_group_id THEN
            RAISE EXCEPTION 'Amount, direction, asset_code, wallet_type, conversion_rate, and transfer_group_id cannot be updated for immutable or escrow_hold transactions';
        END IF;
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: trg_sync_user_wallets(); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.trg_sync_user_wallets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$begin

  -- 🧠 skip if no real change on UPDATE
  if TG_OP = 'UPDATE' then

    if NEW."transactionStatus" = OLD."transactionStatus"
       and NEW."transactionAmount" = OLD."transactionAmount"
    then
      return NEW;
    end if;

  end if;

  -- 🧠 call wallet sync
  perform public.sync_user_wallets(NEW."transactionUserUID");

  return NEW;
end;$$;


--
-- Name: trg_transactions_audit(); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.trg_transactions_audit() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app_wallet', 'public'
    AS $$
DECLARE
    v_changed_by UUID;
    v_request_id UUID;
    v_trace_id UUID;
    v_ip INET;
    v_user_agent TEXT;
BEGIN
    v_changed_by := COALESCE(NEW.updated_by, NEW.created_by, OLD.updated_by, OLD.created_by);
    -- قراءة قيم التتبع من إعدادات الجلسة (يمكن ضبطها من قبل التطبيق)
    v_request_id := current_setting('app.request_id', true)::UUID;
    v_trace_id := current_setting('app.trace_id', true)::UUID;
    v_ip := current_setting('app.client_ip', true)::INET;
    v_user_agent := current_setting('app.user_agent', true);

    IF TG_OP = 'INSERT' THEN
        INSERT INTO app_wallet.transactions_audit (
            transaction_id, operation, changed_by, old_data, new_data,
            request_id, trace_id, ip, user_agent
        ) VALUES (
            NEW.id, 'I', v_changed_by, NULL, to_jsonb(NEW),
            v_request_id, v_trace_id, v_ip, v_user_agent
        );
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO app_wallet.transactions_audit (
            transaction_id, operation, changed_by, old_data, new_data,
            request_id, trace_id, ip, user_agent
        ) VALUES (
            NEW.id, 'U', v_changed_by, to_jsonb(OLD), to_jsonb(NEW),
            v_request_id, v_trace_id, v_ip, v_user_agent
        );
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO app_wallet.transactions_audit (
            transaction_id, operation, changed_by, old_data, new_data,
            request_id, trace_id, ip, user_agent
        ) VALUES (
            OLD.id, 'D', v_changed_by, to_jsonb(OLD), NULL,
            v_request_id, v_trace_id, v_ip, v_user_agent
        );
    END IF;
    RETURN COALESCE(NEW, OLD);
END;
$$;


--
-- Name: trg_validate_reversal_parent(); Type: FUNCTION; Schema: app_wallet; Owner: -
--

CREATE FUNCTION app_wallet.trg_validate_reversal_parent() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app_wallet', 'public'
    AS $$
DECLARE
    v_parent_id UUID;
BEGIN
    IF NEW.event_name = 'reversal' THEN
        -- قفل صف المعاملة الأصلية لمنع التعديل المتزامن
        SELECT id INTO v_parent_id
        FROM app_wallet.transactions
        WHERE id = NEW.ledger_reference_id
        FOR UPDATE;

        IF NOT EXISTS (SELECT 1 FROM app_wallet.transactions WHERE id = NEW.ledger_reference_id AND status = 'completed') THEN
            RAISE EXCEPTION 'Cannot create reversal: parent transaction must be completed';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: assets; Type: TABLE; Schema: app_wallet; Owner: -
--

CREATE TABLE app_wallet.assets (
    code text NOT NULL,
    asset_kind text NOT NULL,
    decimals integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_asset_kind CHECK ((asset_kind = ANY (ARRAY['fiat'::text, 'virtual'::text, 'reward'::text, 'crypto'::text])))
);


--
-- Name: escrow_cases; Type: TABLE; Schema: app_wallet; Owner: -
--

CREATE TABLE app_wallet.escrow_cases (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    task_id uuid,
    client_user_id uuid NOT NULL,
    provider_user_id uuid NOT NULL,
    asset_code text NOT NULL,
    service_amount numeric(20,6) NOT NULL,
    client_deposit_amount numeric(20,6) DEFAULT 0 NOT NULL,
    provider_deposit_amount numeric(20,6) DEFAULT 0 NOT NULL,
    client_fee_amount numeric(20,6) DEFAULT 0 NOT NULL,
    provider_fee_amount numeric(20,6) DEFAULT 0 NOT NULL,
    status text DEFAULT 'pending_funding'::text NOT NULL,
    transfer_group_id uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    completed_at timestamp with time zone,
    cancelled_at timestamp with time zone,
    disputed_at timestamp with time zone,
    metadata jsonb,
    provider_released_amount numeric(20,6) DEFAULT 0 NOT NULL,
    client_released_amount numeric(20,6) DEFAULT 0 NOT NULL,
    provider_penalty_released numeric(20,6) DEFAULT 0 NOT NULL,
    client_penalty_released numeric(20,6) DEFAULT 0 NOT NULL,
    platform_fee_taken numeric(20,6) DEFAULT 0 NOT NULL,
    service_released numeric(20,6) DEFAULT 0 NOT NULL,
    is_locked boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_provider_released_leq_service CHECK ((provider_released_amount <= service_amount)),
    CONSTRAINT escrow_cases_service_amount_check CHECK ((service_amount > (0)::numeric)),
    CONSTRAINT escrow_cases_status_check CHECK ((status = ANY (ARRAY['pending_funding'::text, 'active'::text, 'completed'::text, 'disputed'::text, 'cancelled'::text, 'refunded'::text])))
);


--
-- Name: escrow_movements; Type: TABLE; Schema: app_wallet; Owner: -
--

CREATE TABLE app_wallet.escrow_movements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    escrow_case_id uuid NOT NULL,
    movement_type text NOT NULL,
    amount numeric(20,6) NOT NULL,
    applicable_to text NOT NULL,
    reference_transaction_id uuid,
    description text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now(),
    actor_user_id uuid,
    CONSTRAINT chk_escrow_movement_amount_non_negative CHECK ((amount >= (0)::numeric)),
    CONSTRAINT chk_escrow_movement_platform_fee_applicable CHECK ((NOT ((movement_type = 'platform_fee_taken'::text) AND (applicable_to <> 'platform'::text)))),
    CONSTRAINT chk_escrow_movement_rules CHECK ((((movement_type = 'service_release'::text) AND (applicable_to = ANY (ARRAY['client'::text, 'provider'::text, 'platform'::text]))) OR ((movement_type = 'platform_fee_taken'::text) AND (applicable_to = 'platform'::text)) OR ((movement_type = ANY (ARRAY['deposit_frozen_client'::text, 'deposit_frozen_provider'::text, 'penalty_applied'::text, 'partial_refund_client'::text])) AND (applicable_to <> 'none'::text)) OR ((movement_type = ANY (ARRAY['case_created'::text, 'case_completed'::text, 'case_cancelled'::text, 'case_disputed'::text, 'case_refunded'::text])) AND (applicable_to = 'none'::text)))),
    CONSTRAINT escrow_movements_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT escrow_movements_applicable_to_check CHECK ((applicable_to = ANY (ARRAY['client'::text, 'provider'::text, 'platform'::text, 'none'::text]))),
    CONSTRAINT escrow_movements_movement_type_check CHECK ((movement_type = ANY (ARRAY['case_created'::text, 'deposit_frozen_client'::text, 'deposit_frozen_provider'::text, 'service_release'::text, 'penalty_applied'::text, 'partial_refund_client'::text, 'platform_fee_taken'::text, 'case_completed'::text, 'case_cancelled'::text, 'case_disputed'::text, 'case_refunded'::text])))
);


--
-- Name: escrow_penalty_allocations; Type: TABLE; Schema: app_wallet; Owner: -
--

CREATE TABLE app_wallet.escrow_penalty_allocations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    penalty_item_id uuid NOT NULL,
    recipient text NOT NULL,
    amount numeric(20,6) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    reference_movement_id uuid,
    CONSTRAINT escrow_penalty_allocations_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT escrow_penalty_allocations_recipient_check CHECK ((recipient = ANY (ARRAY['client'::text, 'provider'::text, 'platform'::text])))
);


--
-- Name: escrow_penalty_items; Type: TABLE; Schema: app_wallet; Owner: -
--

CREATE TABLE app_wallet.escrow_penalty_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    escrow_case_id uuid NOT NULL,
    rule_id uuid,
    description text NOT NULL,
    amount numeric(20,6) NOT NULL,
    applied boolean DEFAULT false NOT NULL,
    applied_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT escrow_penalty_items_amount_check CHECK ((amount > (0)::numeric))
);


--
-- Name: escrow_service_releases; Type: TABLE; Schema: app_wallet; Owner: -
--

CREATE TABLE app_wallet.escrow_service_releases (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    escrow_case_id uuid NOT NULL,
    amount numeric(20,6) NOT NULL,
    released_by uuid NOT NULL,
    description text,
    status text DEFAULT 'pending'::text NOT NULL,
    approved_at timestamp with time zone,
    approved_by uuid,
    reference_transaction_id uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT escrow_service_releases_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT escrow_service_releases_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])))
);


--
-- Name: exchange_rates; Type: TABLE; Schema: app_wallet; Owner: -
--

CREATE TABLE app_wallet.exchange_rates (
    from_asset text NOT NULL,
    to_asset text NOT NULL,
    rate numeric(20,10) NOT NULL,
    effective_from timestamp with time zone DEFAULT now() NOT NULL,
    effective_until timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: transactions; Type: TABLE; Schema: app_wallet; Owner: -
--

CREATE TABLE app_wallet.transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    balance_before numeric(20,6),
    balance_after numeric(20,6),
    amount numeric(20,6) NOT NULL,
    app_id text,
    direction text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    completed_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    title text,
    meta jsonb,
    notes text,
    payment_provider text,
    payment_method text,
    payment_source text,
    payment_fee_amount numeric(20,6),
    payment_net_amount numeric(20,6),
    payment_gross_amount numeric(20,6),
    payment_idempotency_key text,
    payment_reference_id text,
    admin_user_id uuid,
    event_name text,
    source_type text,
    source_id uuid,
    ledger_reference_id uuid,
    created_by uuid,
    updated_by uuid,
    actor_user_id uuid NOT NULL,
    actor_role text DEFAULT 'owner'::text NOT NULL,
    counterparty_user_id uuid,
    is_reversed boolean DEFAULT false NOT NULL,
    reversed_at timestamp with time zone,
    transaction_type text,
    effective_at timestamp with time zone,
    transfer_group_id uuid,
    asset_code text NOT NULL,
    wallet_type text DEFAULT 'default'::text NOT NULL,
    conversion_group_id uuid,
    conversion_rate numeric(20,10),
    CONSTRAINT chk_balance_direction_consistency CHECK ((((direction = 'credit'::text) AND ((balance_before IS NULL) OR (balance_after IS NULL) OR (balance_after >= balance_before))) OR ((direction = 'debit'::text) AND ((balance_before IS NULL) OR (balance_after IS NULL) OR (balance_after <= balance_before))))),
    CONSTRAINT chk_completed_integrity CHECK (((status <> 'completed'::text) OR ((balance_before IS NOT NULL) AND (balance_after IS NOT NULL) AND (completed_at IS NOT NULL)))),
    CONSTRAINT chk_effective_at_not_before_creation CHECK (((effective_at IS NULL) OR (effective_at >= created_at))),
    CONSTRAINT chk_escrow_transaction_requires_source CHECK ((NOT ((transaction_type = ANY (ARRAY['escrow_hold'::text, 'escrow_release'::text, 'escrow_penalty'::text])) AND (source_type IS NULL)))),
    CONSTRAINT chk_reversal_status_and_ref CHECK ((NOT ((event_name = 'reversal'::text) AND ((ledger_reference_id IS NULL) OR (status <> 'completed'::text))))),
    CONSTRAINT chk_reversed_consistency CHECK ((((is_reversed = false) AND (reversed_at IS NULL)) OR ((is_reversed = true) AND (reversed_at IS NOT NULL)))),
    CONSTRAINT chk_source_consistency CHECK ((((source_type IS NULL) AND (source_id IS NULL)) OR ((source_type IS NOT NULL) AND (source_id IS NOT NULL)))),
    CONSTRAINT chk_source_type_values CHECK (((source_type IS NULL) OR (source_type = ANY (ARRAY['order'::text, 'reward'::text, 'referral'::text, 'booking'::text, 'invoice'::text])))),
    CONSTRAINT chk_transaction_amount_positive CHECK ((amount > (0)::numeric)),
    CONSTRAINT chk_transaction_balance_after_non_negative CHECK ((balance_after >= (0)::numeric)),
    CONSTRAINT chk_transaction_type_values CHECK (((transaction_type IS NULL) OR (transaction_type = ANY (ARRAY['transfer'::text, 'purchase'::text, 'escrow_hold'::text, 'escrow_release'::text, 'escrow_refund'::text, 'escrow_penalty'::text, 'platform_fee'::text, 'settlement'::text, 'exchange'::text, 'bonus'::text, 'payout'::text, 'fee'::text, 'adjustment'::text, 'refund'::text])))),
    CONSTRAINT chk_wallet_transaction_direction CHECK ((direction = ANY (ARRAY['credit'::text, 'debit'::text]))),
    CONSTRAINT chk_wallet_transaction_event_name CHECK (((event_name IS NULL) OR (event_name = ANY (ARRAY['reversal'::text, 'payment'::text, 'refund'::text, 'adjustment'::text, 'reward'::text, 'deposit'::text, 'withdrawal'::text])))),
    CONSTRAINT chk_wallet_transaction_payment_method CHECK (((payment_method IS NULL) OR (payment_method = ANY (ARRAY['card'::text, 'cash'::text, 'wallet'::text, 'bank'::text, 'apple_pay'::text, 'google_pay'::text, 'paypal'::text, 'crypto'::text])))),
    CONSTRAINT chk_wallet_transaction_status CHECK ((status = ANY (ARRAY['pending'::text, 'completed'::text, 'failed'::text, 'cancelled'::text, 'reversed'::text, 'frozen'::text]))),
    CONSTRAINT chk_wallet_type CHECK ((wallet_type = ANY (ARRAY['default'::text, 'cash'::text, 'escrow'::text, 'bonus'::text, 'rewards'::text, 'investment'::text]))),
    CONSTRAINT transactions_actor_role_check CHECK ((actor_role = ANY (ARRAY['owner'::text, 'sender'::text, 'receiver'::text, 'system'::text])))
);


--
-- Name: transactions_audit; Type: TABLE; Schema: app_wallet; Owner: -
--

CREATE TABLE app_wallet.transactions_audit (
    audit_id bigint NOT NULL,
    transaction_id uuid NOT NULL,
    operation character(1) NOT NULL,
    changed_by uuid,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    old_data jsonb,
    new_data jsonb,
    request_id uuid,
    trace_id uuid,
    ip inet,
    user_agent text
);


--
-- Name: transactions_audit_audit_id_seq; Type: SEQUENCE; Schema: app_wallet; Owner: -
--

CREATE SEQUENCE app_wallet.transactions_audit_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_audit_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: app_wallet; Owner: -
--

ALTER SEQUENCE app_wallet.transactions_audit_audit_id_seq OWNED BY app_wallet.transactions_audit.audit_id;


--
-- Name: user_asset_balance; Type: TABLE; Schema: app_wallet; Owner: -
--

CREATE TABLE app_wallet.user_asset_balance (
    internal_user_id uuid NOT NULL,
    asset_code text NOT NULL,
    total numeric(20,6) DEFAULT 0 NOT NULL,
    available numeric(20,6) DEFAULT 0 NOT NULL,
    frozen numeric(20,6) DEFAULT 0 NOT NULL,
    pending_outgoing numeric(20,6) DEFAULT 0 NOT NULL,
    pending_incoming numeric(20,6) DEFAULT 0 NOT NULL,
    version bigint DEFAULT 1 NOT NULL,
    calculated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    wallet_type text DEFAULT 'default'::text NOT NULL,
    CONSTRAINT chk_asset_balance_non_negative CHECK (((total >= (0)::numeric) AND (available >= (0)::numeric) AND (frozen >= (0)::numeric) AND (pending_outgoing >= (0)::numeric) AND (pending_incoming >= (0)::numeric))),
    CONSTRAINT chk_balance_wallet_type CHECK ((wallet_type = ANY (ARRAY['default'::text, 'cash'::text, 'escrow'::text, 'bonus'::text, 'rewards'::text, 'investment'::text])))
);


--
-- Name: wallet_recalc_queue; Type: TABLE; Schema: app_wallet; Owner: -
--

CREATE TABLE app_wallet.wallet_recalc_queue (
    id bigint NOT NULL,
    internal_user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    processed_at timestamp with time zone,
    priority integer DEFAULT 0 NOT NULL,
    retry_count integer DEFAULT 0 NOT NULL,
    failed_at timestamp with time zone,
    last_error text,
    status text DEFAULT 'pending'::text NOT NULL,
    CONSTRAINT chk_recalc_queue_status CHECK ((status = ANY (ARRAY['pending'::text, 'processing'::text, 'completed'::text, 'failed'::text, 'permanent_failed'::text])))
);


--
-- Name: wallet_recalc_queue_id_seq; Type: SEQUENCE; Schema: app_wallet; Owner: -
--

CREATE SEQUENCE app_wallet.wallet_recalc_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wallet_recalc_queue_id_seq; Type: SEQUENCE OWNED BY; Schema: app_wallet; Owner: -
--

ALTER SEQUENCE app_wallet.wallet_recalc_queue_id_seq OWNED BY app_wallet.wallet_recalc_queue.id;


--
-- Name: transactions_audit audit_id; Type: DEFAULT; Schema: app_wallet; Owner: -
--

ALTER TABLE ONLY app_wallet.transactions_audit ALTER COLUMN audit_id SET DEFAULT nextval('app_wallet.transactions_audit_audit_id_seq'::regclass);


--
-- Name: wallet_recalc_queue id; Type: DEFAULT; Schema: app_wallet; Owner: -
--

ALTER TABLE ONLY app_wallet.wallet_recalc_queue ALTER COLUMN id SET DEFAULT nextval('app_wallet.wallet_recalc_queue_id_seq'::regclass);


--
-- PostgreSQL database dump complete
--

\unrestrict 5WhxaRRXyL5BNobodOYTApKmpOt8vGwPwAnrffDgtoiSHLazkE2ZqRkyLaxpxkA

