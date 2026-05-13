/*
|--------------------------------------------------------------------------
| FILE: 04_functions.sql
|--------------------------------------------------------------------------
|
| PURPOSE:
| يحتوي على جميع PostgreSQL Functions و RPC logic.
|
| CONTENTS:
| - CREATE FUNCTION
| - PL/pgSQL
| - Business Logic
| - RPC Functions
|
| EXAMPLES:
| - check_contract_permission
| - can_transition
| - apply_ownership_transfer_to_permissions
|
| WHY IMPORTANT:
| يحتوي على منطق الباك إند الحقيقي داخل قاعدة البيانات.
|
|--------------------------------------------------------------------------
*/

CREATE OR REPLACE FUNCTION app_wallet.recalculate_user_wallet_summary(p_actor_user_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app_wallet', 'public'
AS $function$
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
    -- Ø§Ø³ØªØ¹Ù„Ø§Ù… ÙˆØ§Ø­Ø¯ ÙŠØ¬Ù…Ø¹ ÙƒÙ„ Ù…Ø§ Ù†Ø­ØªØ§Ø¬Ù‡
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
        -- Coins (Ù…Ø´Ø§Ø¨Ù‡)
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

    -- ØªØ­Ø¯ÙŠØ« Ø§Ù„Ù…Ù„Ø®Øµ Ù…Ø¹ Ø§Ø³ØªØ®Ø¯Ø§Ù… pending_incoming
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
$function$

CREATE OR REPLACE FUNCTION app_wallet.trg_prevent_escrow_immutable_fields()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    immutable_fields TEXT[] := ARRAY[
        'service_amount', 'client_deposit_amount', 'provider_deposit_amount',
        'released_to_provider', 'released_to_client', 'released_penalty_to_provider',
        'released_penalty_to_client', 'service_released'
    ];
    field TEXT;
BEGIN
    IF TG_OP = 'UPDATE' THEN
        -- Ø¥Ø°Ø§ ÙƒØ§Ù† Ø§Ù„ØµÙ Ù…Ù‚ÙÙ„Ø§Ù‹ØŒ Ù„Ø§ Ù†Ø³Ù…Ø­ Ø¨Ø£ÙŠ ØªØ¹Ø¯ÙŠÙ„ (Ø¨Ø§Ø³ØªØ«Ù†Ø§Ø¡ Ø±Ø¨Ù…Ø§ statusØŸ)
        IF OLD.is_locked THEN
            RAISE EXCEPTION 'Escrow case is locked, cannot modify any field';
        END IF;

        -- Ø­ØªÙ‰ ÙˆØ¥Ù† Ù„Ù… ÙŠÙƒÙ† Ù…Ù‚ÙÙ„Ø§Ù‹ØŒ Ù„Ø§ Ù†Ø³Ù…Ø­ Ø¨ØªØ¹Ø¯ÙŠÙ„ Ø§Ù„Ø­Ù‚ÙˆÙ„ Ø§Ù„Ù…Ø§Ù„ÙŠØ© Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ©
        FOREACH field IN ARRAY immutable_fields
        LOOP
            IF OLD[field] IS DISTINCT FROM NEW[field] THEN
                RAISE EXCEPTION 'Cannot update field "%" after escrow case creation (use dedicated functions)', field;
            END IF;
        END LOOP;
    END IF;
    RETURN NEW;
END;
$function$

CREATE OR REPLACE FUNCTION app_wallet.cleanup_recalc_queue(p_retention_days integer DEFAULT 180)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_deleted_count INT;
BEGIN
    DELETE FROM app_wallet.wallet_recalc_queue
    WHERE processed = TRUE
      AND processed_at < NOW() - (p_retention_days || ' days')::INTERVAL;
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    RETURN v_deleted_count;
END;
$function$

CREATE OR REPLACE FUNCTION app_wallet.enqueue_wallet_recalc(p_internal_user_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    INSERT INTO app_wallet.wallet_recalc_queue (internal_user_id)
    VALUES (p_internal_user_id)
    ON CONFLICT DO NOTHING; -- ÙŠÙ…ÙƒÙ† ØªØ¹Ø¯ÙŠÙ„ Ø­Ø³Ø¨ Ø§Ù„Ø­Ø§Ø¬Ø©
END;
$function$

CREATE OR REPLACE FUNCTION app_wallet.get_user_wallet_summary(p_internal_user_id uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app_wallet', 'public'
AS $function$
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
$function$

CREATE OR REPLACE FUNCTION app_wallet.give_signup_bonus_v3(p_user_uid uuid, p_source_app text, p_description text, p_rewards jsonb, p_currency text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare
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

    -- ðŸ§  normalize wallet key
    v_key := lower(v_key);

    -- ðŸ”‘ event id per wallet
    v_event_id := 'signup_bonus_' || v_key || '_' || p_user_uid::text;

    -- ðŸ”’ idempotency check (SAFE)
    if exists (
      select 1
      from public.processed_events
      where event_id = v_event_id
    ) then
      v_any_skipped := true;
      continue;
    end if;

    -- ðŸ“ mark event (protected by unique constraint)
    insert into public.processed_events (event_id, event_type, user_uid)
    values (v_event_id, 'signup_bonus', p_user_uid)
    on conflict (event_id) do nothing;

    v_any_processed := true;

    -- ðŸ§® balanceBefore
    select coalesce(sum("transactionAmount"), 0)
    into v_balance_before
    from public."centerTransactions"
    where "transactionUserUID" = p_user_uid::text
      and lower("transactionWallet") = v_key;

    v_balance_after := v_balance_before + v_amount;

    -- ðŸ’° insert transaction
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

  -- ðŸ§  FINAL RESPONSE LOGIC
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

end;$function$

CREATE OR REPLACE FUNCTION app_wallet.helper_insert_wallet_summary(p_internal_user_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
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
    NULL,     -- currency = null (ÙƒÙ…Ø§ Ø·Ù„Ø¨Øª)
    0,        -- version = 0 (ÙƒÙ…Ø§ Ø·Ù„Ø¨Øª)
    NOW(),
    NOW()
  )
  ON CONFLICT (internal_user_id) DO NOTHING;
END;
$function$

CREATE OR REPLACE FUNCTION app_wallet.prevent_escrow_manual_updates()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$

CREATE OR REPLACE FUNCTION app_wallet.process_recalc_queue(p_batch_size integer DEFAULT 100)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app_wallet', 'public'
AS $function$
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
$function$

CREATE OR REPLACE FUNCTION app_wallet.process_recalc_queue(p_batch_size integer DEFAULT 100, p_max_retries integer DEFAULT 10)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app_wallet', 'public'
AS $function$
DECLARE
    v_record RECORD;
BEGIN
    FOR v_record IN
        SELECT id, internal_user_id, retry_count
        FROM app_wallet.wallet_recalc_queue
        WHERE status IN ('pending', 'failed')   -- âœ… Ø¥Ø¶Ø§ÙØ© 'failed'
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
$function$

CREATE OR REPLACE FUNCTION app_wallet.recalculate_user_balances(p_actor_user_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app_wallet', 'public'
AS $function$
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

    -- Ø­Ø°Ù Ø§Ù„Ø£ØµÙˆÙ„ Ø§Ù„ØªÙŠ Ù„Ù… ØªØ¹Ø¯ Ù…ÙˆØ¬ÙˆØ¯Ø© ÙÙŠ Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø§Øª
    DELETE FROM app_wallet.user_asset_balance
    WHERE internal_user_id = p_actor_user_id
      AND asset_code NOT IN (SELECT DISTINCT asset_code FROM app_wallet.transactions WHERE actor_user_id = p_actor_user_id);
END;
$function$

CREATE OR REPLACE FUNCTION app_wallet.trg_prevent_escrow_modification()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$

CREATE OR REPLACE FUNCTION app_wallet.reward_engine(p_user_uid text, p_event_name text, p_source_app text, p_description text, p_metadata jsonb DEFAULT '{}'::jsonb, p_currency text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare
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

  -- ðŸ” get reward config (LATEST ACTIVE VERSION)
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

  -- ðŸ§  extract referral context (if exists)
  v_ref_key := p_metadata->>'referral_key';

  -- ðŸ” loop rewards
  for v_key, v_amount in
    select * from jsonb_each_text(v_rewards)
  loop

    v_key := lower(v_key);

    -- ðŸ”‘ idempotency (context-aware)
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

    -- ðŸ§® balance
    select coalesce(sum("transactionAmount"), 0)
    into v_balance_before
    from public."centerTransactions"
    where "transactionUserUID" = p_user_uid
      and lower("transactionWallet") = v_key;

    v_balance_after := v_balance_before + v_amount;

    -- ðŸ’° transaction insert
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

  -- ðŸ§  response
  if v_any_processed and v_any_skipped then
    return jsonb_build_object('success', true, 'message', 'partial_processed');
  elsif v_any_processed then
    return jsonb_build_object('success', true, 'message', 'processed');
  else
    return jsonb_build_object('success', true, 'message', 'skipped');
  end if;

end;$function$

CREATE OR REPLACE FUNCTION app_wallet.reward_engine(p_user_uid uuid, p_event_name text, p_source_app text, p_description text, p_metadata jsonb DEFAULT '{}'::jsonb, p_currency text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare
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

  -- ðŸ” get reward config
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

  -- ðŸ§  extract referral context (if exists)
  v_ref_key := p_metadata->>'referral_key';

  -- ðŸ” loop rewards
  for v_key, v_amount in
    select * from jsonb_each_text(v_rewards)
  loop

    v_key := lower(v_key);

    -- ðŸ”‘ idempotency (context-aware)
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

    -- ðŸ§® balance
    select coalesce(sum("transactionAmount"), 0)
    into v_balance_before
    from public."centerTransactions"
    where "transactionUserUID" = p_user_uid::text
      and lower("transactionWallet") = v_key;

    v_balance_after := v_balance_before + v_amount;

    -- ðŸ’° transaction insert
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

  -- ðŸ§  response
  if v_any_processed and v_any_skipped then
    return jsonb_build_object('success', true, 'message', 'partial_processed');
  elsif v_any_processed then
    return jsonb_build_object('success', true, 'message', 'processed');
  else
    return jsonb_build_object('success', true, 'message', 'skipped');
  end if;

end;$function$

CREATE OR REPLACE FUNCTION app_wallet.reward_engine_v2(p_user_uid uuid, p_event_name text, p_source_app text, p_description text, p_currency text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare
  v_rewards jsonb;

  v_key text;
  v_amount numeric;

  v_balance_before numeric;
  v_balance_after numeric;

  v_event_id text;

  v_any_processed boolean := false;
  v_any_skipped boolean := false;
begin

  -- ðŸ§  1. get ACTIVE rule version
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

  -- ðŸ” 2. loop rewards
  for v_key, v_amount in
    select * from jsonb_each_text(v_rewards)
  loop

    v_key := lower(v_key);

    -- ðŸ”‘ idempotency per event + wallet
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

    -- ðŸ§® 3. balance before (legacy tracking only)
    select coalesce(sum("transactionAmount"), 0)
    into v_balance_before
    from public."centerTransactions"
    where "transactionUserUID" = p_user_uid::text
      and lower("transactionWallet") = v_key;

    v_balance_after := v_balance_before + v_amount;

    -- ðŸ’° 4. insert transaction
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

  -- ðŸ”„ 5. SYNC USER WALLET (NEW ADDITION ðŸ”¥)
  perform public.sync_user_wallets(p_user_uid::text);

  -- ðŸ§  6. response logic
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

end;$function$

CREATE OR REPLACE FUNCTION app_wallet.trg_prevent_balance_modification()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$

CREATE OR REPLACE FUNCTION app_wallet.trg_prevent_completed_modification()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$

CREATE OR REPLACE FUNCTION app_wallet.trg_prevent_escrow_hold_modification()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF OLD.transaction_type = 'escrow_hold' THEN
        RAISE EXCEPTION 'Direct modification of escrow hold transactions is not allowed. Use complete_escrow_case instead.';
    END IF;
    RETURN NEW;
END;
$function$

CREATE OR REPLACE FUNCTION app_wallet.trg_prevent_immutable_fields()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- 1. Ù…Ù†Ø¹ ØªØ¹Ø¯ÙŠÙ„ balance_before / balance_after (Ø£Ø¨Ø¯Ù‹Ø§)
    IF OLD.balance_before IS DISTINCT FROM NEW.balance_before OR
       OLD.balance_after IS DISTINCT FROM NEW.balance_after THEN
        RAISE EXCEPTION 'balance_before and balance_after cannot be updated';
    END IF;

    -- 2. Ù…Ù†Ø¹ ØªØ¹Ø¯ÙŠÙ„ amount, direction, asset_code, wallet_type, conversion_rate, transfer_group_id
    --    Ø¥Ø°Ø§ ÙƒØ§Ù†Øª Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø© Ù†Ù‡Ø§Ø¦ÙŠØ© (completed, frozen, cancelled) Ø£Ùˆ Ù…Ù† Ù†ÙˆØ¹ escrow_hold
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
$function$

CREATE OR REPLACE FUNCTION app_wallet.trg_sync_user_wallets()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$begin

  -- ðŸ§  skip if no real change on UPDATE
  if TG_OP = 'UPDATE' then

    if NEW."transactionStatus" = OLD."transactionStatus"
       and NEW."transactionAmount" = OLD."transactionAmount"
    then
      return NEW;
    end if;

  end if;

  -- ðŸ§  call wallet sync
  perform public.sync_user_wallets(NEW."transactionUserUID");

  return NEW;
end;$function$

CREATE OR REPLACE FUNCTION app_wallet.trg_transactions_audit()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app_wallet', 'public'
AS $function$
DECLARE
    v_changed_by UUID;
    v_request_id UUID;
    v_trace_id UUID;
    v_ip INET;
    v_user_agent TEXT;
BEGIN
    v_changed_by := COALESCE(NEW.updated_by, NEW.created_by, OLD.updated_by, OLD.created_by);
    -- Ù‚Ø±Ø§Ø¡Ø© Ù‚ÙŠÙ… Ø§Ù„ØªØªØ¨Ø¹ Ù…Ù† Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ø¬Ù„Ø³Ø© (ÙŠÙ…ÙƒÙ† Ø¶Ø¨Ø·Ù‡Ø§ Ù…Ù† Ù‚Ø¨Ù„ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚)
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
$function$

CREATE OR REPLACE FUNCTION app_wallet.trg_validate_reversal_parent()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app_wallet', 'public'
AS $function$
DECLARE
    v_parent_id UUID;
BEGIN
    IF NEW.event_name = 'reversal' THEN
        -- Ù‚ÙÙ„ ØµÙ Ø§Ù„Ù…Ø¹Ø§Ù…Ù„Ø© Ø§Ù„Ø£ØµÙ„ÙŠØ© Ù„Ù…Ù†Ø¹ Ø§Ù„ØªØ¹Ø¯ÙŠÙ„ Ø§Ù„Ù…ØªØ²Ø§Ù…Ù†
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
$function$