--
-- PostgreSQL database dump
--

\restrict yrcLeubxn4HZwaEzkGttZqPZH7MGkJi1b84BCYKA7DOJbSCZW4AXfVbls65U6D4

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
-- Name: api_auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA api_auth;


--
-- Name: create_user_identity(); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.create_user_identity() RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$declare 
  new_id uuid;
begin
  insert into user_identity_map default values
  returning internal_user_id into new_id;
  return new_id;
end;$$;


--
-- Name: get_internal_id_by_auth_source_and_uid(text, text); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.get_internal_id_by_auth_source_and_uid(p_auth_source text, p_provider_uid text) RETURNS uuid
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'app_auth'
    AS $$select internal_user_id
  from app_auth.user_auth_identities
  where auth_source = p_auth_source
    and provider_uid = p_provider_uid
  limit 1;$$;


--
-- Name: get_user_on_demand_bundle(uuid); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.get_user_on_demand_bundle(p_internal_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
declare
  result jsonb;
begin

  select jsonb_build_object(

    -- 🖼 media
    'media', (
      select coalesce(jsonb_agg(to_jsonb(um)), '[]'::jsonb)
      from app_users.user_media um
      where um.internal_user_id = p_internal_user_id
    ),

    -- 💰 wallets
    'wallets', (
      select coalesce(jsonb_agg(to_jsonb(uw)), '[]'::jsonb)
      from app_wallet.user_wallets uw
      where uw.internal_user_id = p_internal_user_id
    ),

    -- 🎁 referrals
    'referrals', (
      select coalesce(jsonb_agg(to_jsonb(ur)), '[]'::jsonb)
      from app_users.user_referrals ur
      where ur.internal_user_id = p_internal_user_id
    ),

    -- ⚙️ settings (full)
    'settings_full', (
      select to_jsonb(us)
      from app_users.user_settings us
      where us.internal_user_id = p_internal_user_id
    )

  )
  into result;

  return result;

end;
$$;


--
-- Name: request_email_lookup_token(text); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.request_email_lookup_token(email_to_search text) RETURNS jsonb
    LANGUAGE sql
    AS $$select api_v1.request_email_lookup_token(email_to_search);$$;


--
-- Name: resolve_user_identity(text, text, text, text, boolean, boolean, timestamp with time zone, timestamp with time zone, timestamp with time zone, timestamp with time zone, timestamp with time zone, text, uuid, text, text, text); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.resolve_user_identity(p_provider text, p_provider_uid text, p_email text DEFAULT NULL::text, p_normalized_phone text DEFAULT NULL::text, p_is_verified_email boolean DEFAULT false, p_is_verified_phone boolean DEFAULT false, p_email_verified_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_phone_verified_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_last_login_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_created_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_updated_at timestamp with time zone DEFAULT NULL::timestamp with time zone, p_auth_source text DEFAULT NULL::text, p_existing_internal_id uuid DEFAULT NULL::uuid, p_registration_app text DEFAULT NULL::text, p_display_name text DEFAULT NULL::text, p_role text DEFAULT 'user'::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$DECLARE
    v_internal_user_id UUID;
    v_now TIMESTAMPTZ := NOW();
    v_created_at TIMESTAMPTZ;
    v_updated_at TIMESTAMPTZ;
    v_verified_email BOOLEAN;
    v_verified_phone BOOLEAN;
    v_found_internal_user_id UUID;
    v_reg_app TEXT;
BEGIN
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'Unauthorized: You must be logged in to call this function.';
    END IF;

    v_verified_email := COALESCE(p_is_verified_email, FALSE);
    v_verified_phone := COALESCE(p_is_verified_phone, FALSE);
    v_created_at := COALESCE(p_created_at, v_now);
    v_updated_at := COALESCE(p_updated_at, v_now);
    v_reg_app := COALESCE(p_registration_app, 'unknown');

    IF v_created_at < (v_now - INTERVAL '10 years') OR v_created_at > (v_now + INTERVAL '1 day') THEN
        RAISE EXCEPTION 'created_at out of allowed range';
    END IF;
    IF v_updated_at < (v_now - INTERVAL '10 years') OR v_updated_at > (v_now + INTERVAL '1 day') THEN
        RAISE EXCEPTION 'updated_at out of allowed range';
    END IF;

    -- الربط
    IF p_existing_internal_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM public.user_identity_root WHERE internal_user_id = p_existing_internal_id) THEN
            RAISE EXCEPTION 'Cannot link: internal_user_id % does not exist.', p_existing_internal_id;
        END IF;
        IF EXISTS (SELECT 1 FROM app_auth.user_auth_identities WHERE provider = p_provider AND provider_uid = p_provider_uid) THEN
            RAISE EXCEPTION 'Identity already exists and cannot be linked again.';
        END IF;

        INSERT INTO app_auth.user_auth_identities (
            internal_user_id, provider, provider_uid,
            email, normalized_phone,
            is_verified_email, email_verified_at,
            is_verified_phone, phone_verified_at,
            is_linked, linked_at, created_at, updated_at,
            auth_source
        ) VALUES (
            p_existing_internal_id, p_provider, p_provider_uid,
            p_email, p_normalized_phone,
            v_verified_email, p_email_verified_at,
            v_verified_phone, p_phone_verified_at,
            TRUE, v_created_at, v_created_at, v_updated_at,
            p_auth_source
        );
        RETURN jsonb_build_object('internal_user_id', p_existing_internal_id, 'is_linked', TRUE);
    END IF;

    -- البحث مباشرة
    SELECT internal_user_id INTO v_internal_user_id
    FROM app_auth.user_auth_identities
    WHERE provider = p_provider AND provider_uid = p_provider_uid;

    IF v_internal_user_id IS NOT NULL THEN
        UPDATE app_auth.user_auth_identities
        SET last_login_at = COALESCE(p_last_login_at, v_now),
            updated_at = v_updated_at,
            auth_source = COALESCE(p_auth_source, auth_source)
        WHERE provider = p_provider AND provider_uid = p_provider_uid;
        RETURN jsonb_build_object('internal_user_id', v_internal_user_id, 'is_linked', FALSE);
    END IF;

    -- بريد إلكتروني
    IF p_provider = 'email' AND p_email IS NOT NULL THEN
        SELECT internal_user_id INTO v_found_internal_user_id
        FROM app_auth.user_auth_identities
        WHERE provider = 'email' AND email = p_email AND auth_source = p_auth_source
        LIMIT 1;

        IF v_found_internal_user_id IS NOT NULL THEN
            UPDATE app_auth.user_auth_identities
            SET last_login_at = COALESCE(p_last_login_at, v_now), updated_at = v_updated_at
            WHERE provider = 'email' AND email = p_email AND auth_source = p_auth_source;
            RETURN jsonb_build_object('internal_user_id', v_found_internal_user_id, 'is_linked', FALSE);
        END IF;

        SELECT internal_user_id INTO v_found_internal_user_id
        FROM app_auth.user_auth_identities
        WHERE provider = 'email' AND email = p_email
        LIMIT 1;

        IF v_found_internal_user_id IS NOT NULL THEN
            RETURN jsonb_build_object('internal_user_id', v_found_internal_user_id, 'is_linked', FALSE, 'link_required', TRUE);
        END IF;

        -- إنشاء مستخدم جديد
        INSERT INTO public.user_identity_root DEFAULT VALUES RETURNING internal_user_id INTO v_internal_user_id;
        INSERT INTO app_auth.user_auth_identities (
            internal_user_id, provider, provider_uid, email, normalized_phone,
            is_verified_email, email_verified_at,
            is_verified_phone, phone_verified_at,
            last_login_at, is_linked, linked_at, created_at, updated_at, auth_source
        ) VALUES (
            v_internal_user_id, p_provider, p_provider_uid, p_email, p_normalized_phone,
            v_verified_email, p_email_verified_at,
            v_verified_phone, p_phone_verified_at,
            p_last_login_at, FALSE, NULL, v_created_at, v_updated_at, p_auth_source
        );
        PERFORM app_auth.on_sign_up(v_internal_user_id, p_provider, v_reg_app, p_email, p_display_name, p_role);
        RETURN jsonb_build_object('internal_user_id', v_internal_user_id, 'is_linked', FALSE, 'is_new_user', TRUE);
    END IF;

    -- رقم الهاتف
    IF p_provider = 'phone' AND p_normalized_phone IS NOT NULL THEN
        SELECT internal_user_id INTO v_found_internal_user_id
        FROM app_auth.user_auth_identities
        WHERE provider = 'phone' AND normalized_phone = p_normalized_phone AND auth_source = p_auth_source
        LIMIT 1;

        IF v_found_internal_user_id IS NOT NULL THEN
            UPDATE app_auth.user_auth_identities
            SET last_login_at = COALESCE(p_last_login_at, v_now), updated_at = v_updated_at
            WHERE provider = 'phone' AND normalized_phone = p_normalized_phone AND auth_source = p_auth_source;
            RETURN jsonb_build_object('internal_user_id', v_found_internal_user_id, 'is_linked', FALSE);
        END IF;

        SELECT internal_user_id INTO v_found_internal_user_id
        FROM app_auth.user_auth_identities
        WHERE provider = 'phone' AND normalized_phone = p_normalized_phone
        LIMIT 1;

        IF v_found_internal_user_id IS NOT NULL THEN
            RETURN jsonb_build_object('internal_user_id', v_found_internal_user_id, 'is_linked', FALSE, 'link_required', TRUE);
        END IF;

        INSERT INTO public.user_identity_root DEFAULT VALUES RETURNING internal_user_id INTO v_internal_user_id;
        INSERT INTO app_auth.user_auth_identities (
            internal_user_id, provider, provider_uid, email, normalized_phone,
            is_verified_email, email_verified_at,
            is_verified_phone, phone_verified_at,
            last_login_at, is_linked, linked_at, created_at, updated_at, auth_source
        ) VALUES (
            v_internal_user_id, p_provider, p_provider_uid, p_email, p_normalized_phone,
            v_verified_email, p_email_verified_at,
            v_verified_phone, p_phone_verified_at,
            p_last_login_at, FALSE, NULL, v_created_at, v_updated_at, p_auth_source
        );
        PERFORM app_auth.on_sign_up(v_internal_user_id, p_provider, v_reg_app, p_email, p_display_name, p_role);
        RETURN jsonb_build_object('internal_user_id', v_internal_user_id, 'is_linked', FALSE, 'is_new_user', TRUE);
    END IF;

    -- Providers أخرى
    INSERT INTO public.user_identity_root DEFAULT VALUES RETURNING internal_user_id INTO v_internal_user_id;
    INSERT INTO app_auth.user_auth_identities (
        internal_user_id, provider, provider_uid, email, normalized_phone,
        is_verified_email, email_verified_at,
        is_verified_phone, phone_verified_at,
        last_login_at, is_linked, linked_at, created_at, updated_at, auth_source
    ) VALUES (
        v_internal_user_id, p_provider, p_provider_uid, p_email, p_normalized_phone,
        v_verified_email, p_email_verified_at,
        v_verified_phone, p_phone_verified_at,
        p_last_login_at, FALSE, NULL, v_created_at, v_updated_at, p_auth_source
    );
    PERFORM app_auth.on_sign_up(v_internal_user_id, p_provider, v_reg_app, p_email, p_display_name, p_role);
    RETURN jsonb_build_object('internal_user_id', v_internal_user_id, 'is_linked', FALSE, 'is_new_user', TRUE);
END;$$;


--
-- Name: rpc_auth_lookup(text, text, text, text, text); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.rpc_auth_lookup(p_provider text, p_auth_source text, p_email text, p_phone text, p_provider_uid text) RETURNS TABLE(internal_user_id uuid, provider text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'app_auth', 'public'
    AS $$
  select internal_user_id, provider
  from user_auth_identities
  where
    (p_provider = 'email' and email = p_email and auth_source = p_auth_source)
    or
    (p_provider = 'phone' and normalized_phone = p_phone and auth_source = p_auth_source)
    or
    (p_provider in ('google','apple','facebook') and provider = p_provider and provider_uid = p_provider_uid)
  limit 1;
$$;


--
-- Name: rpc_find_by_email_any(text); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.rpc_find_by_email_any(p_email text) RETURNS TABLE(internal_user_id uuid, auth_source text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'app_auth', 'public'
    AS $$
  SELECT internal_user_id, auth_source
  FROM user_auth_identities
  WHERE email = p_email
  LIMIT 1;
$$;


--
-- Name: rpc_find_by_phone_any(text); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.rpc_find_by_phone_any(p_phone text) RETURNS TABLE(internal_user_id uuid, auth_source text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'app_auth', 'public'
    AS $$
  SELECT internal_user_id, auth_source
  FROM user_auth_identities
  WHERE normalized_phone = p_phone
  LIMIT 1;
$$;


--
-- Name: rpc_find_identity_exact(text, text, text, text, text); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.rpc_find_identity_exact(p_provider text, p_auth_source text, p_email text, p_phone text, p_provider_uid text) RETURNS TABLE(internal_user_id uuid, provider text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'app_auth', 'public'
    AS $$
  SELECT internal_user_id, provider
  FROM user_auth_identities
  WHERE
    (p_provider = 'email' AND email = p_email AND auth_source = p_auth_source)
    OR
    (p_provider = 'phone' AND normalized_phone = p_phone AND auth_source = p_auth_source)
    OR
    (p_provider IN ('google','apple','facebook') AND provider = p_provider AND provider_uid = p_provider_uid)
  LIMIT 1;
$$;


--
-- Name: rpc_get_linked_providers(uuid); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.rpc_get_linked_providers(p_internal_user_id uuid) RETURNS TABLE(provider text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'app_auth', 'public'
    AS $$
  SELECT DISTINCT provider
  FROM user_auth_identities
  WHERE internal_user_id = p_internal_user_id;
$$;


--
-- Name: update_user_device(uuid, jsonb); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.update_user_device(p_internal_user_id uuid, p_data jsonb) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app_auth', 'public'
    AS $$
DECLARE
    v_device_id TEXT;
    v_updated JSONB;
    v_exists BOOLEAN;
BEGIN
    -- استخراج device_id الإجباري
    v_device_id := p_data->>'device_id';
    IF v_device_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'device_id is required');
    END IF;

    -- التحقق من وجود السجل
    SELECT EXISTS (
        SELECT 1 FROM user_devices
        WHERE internal_user_id = p_internal_user_id AND device_id = v_device_id
    ) INTO v_exists;

    IF NOT v_exists THEN
        -- INSERT
        INSERT INTO user_devices (
            internal_user_id,
            device_id,
            device_platform,
            device_name,
            device_nickname,
            device_manufacturer,
            device_model,
            is_emulator,
            sdk_version,
            os_version,
            app_version,
            created_at,
            updated_at,
            last_seen_at,
            last_login_at,
            device_features
        ) VALUES (
            p_internal_user_id,
            v_device_id,
            p_data->>'device_platform',
            p_data->>'device_name',
            p_data->>'device_nickname',
            p_data->>'device_manufacturer',
            p_data->>'device_model',
            COALESCE((p_data->>'is_emulator')::BOOLEAN, FALSE),
            (p_data->>'sdk_version')::INT,
            p_data->>'os_version',
            p_data->>'app_version',
            NOW(),
            NOW(),
            COALESCE((p_data->>'last_seen_at')::TIMESTAMPTZ, NOW()),
            COALESCE((p_data->>'last_login_at')::TIMESTAMPTZ, NOW()),
            p_data->'device_features'
        )
        RETURNING to_jsonb(user_devices) INTO v_updated;

        RETURN jsonb_build_object('success', true, 'action', 'inserted', 'data', v_updated);
    ELSE
        -- UPDATE
        UPDATE user_devices
        SET
            device_platform = COALESCE(p_data->>'device_platform', device_platform),
            device_name = COALESCE(p_data->>'device_name', device_name),
            device_nickname = COALESCE(p_data->>'device_nickname', device_nickname),
            device_manufacturer = COALESCE(p_data->>'device_manufacturer', device_manufacturer),
            device_model = COALESCE(p_data->>'device_model', device_model),
            is_emulator = COALESCE((p_data->>'is_emulator')::BOOLEAN, is_emulator),
            sdk_version = COALESCE((p_data->>'sdk_version')::INT, sdk_version),
            os_version = COALESCE(p_data->>'os_version', os_version),
            app_version = COALESCE(p_data->>'app_version', app_version),
            updated_at = NOW(),
            last_seen_at = COALESCE((p_data->>'last_seen_at')::TIMESTAMPTZ, NOW()),
            last_login_at = COALESCE((p_data->>'last_login_at')::TIMESTAMPTZ, last_login_at),
            device_features = COALESCE(p_data->'device_features', device_features)
        WHERE internal_user_id = p_internal_user_id AND device_id = v_device_id
        RETURNING to_jsonb(user_devices) INTO v_updated;

        RETURN jsonb_build_object('success', true, 'action', 'updated', 'data', v_updated);
    END IF;
END;
$$;


--
-- Name: use_email_lookup_token(text); Type: FUNCTION; Schema: api_auth; Owner: -
--

CREATE FUNCTION api_auth.use_email_lookup_token(token_email text) RETURNS jsonb
    LANGUAGE sql
    AS $$select api_v1.use_email_lookup_token(token_email);$$;


--
-- PostgreSQL database dump complete
--

\unrestrict yrcLeubxn4HZwaEzkGttZqPZH7MGkJi1b84BCYKA7DOJbSCZW4AXfVbls65U6D4

