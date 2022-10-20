--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: accounts_after_insert_row_tr(); Type: FUNCTION; Schema: public; Owner: chatwoot
--

CREATE FUNCTION public.accounts_after_insert_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    execute format('create sequence IF NOT EXISTS conv_dpid_seq_%s', NEW.id);
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.accounts_after_insert_row_tr() OWNER TO chatwoot;

--
-- Name: camp_dpid_before_insert(); Type: FUNCTION; Schema: public; Owner: chatwoot
--

CREATE FUNCTION public.camp_dpid_before_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    execute format('create sequence IF NOT EXISTS camp_dpid_seq_%s', NEW.id);
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.camp_dpid_before_insert() OWNER TO chatwoot;

--
-- Name: campaigns_before_insert_row_tr(); Type: FUNCTION; Schema: public; Owner: chatwoot
--

CREATE FUNCTION public.campaigns_before_insert_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.display_id := nextval('camp_dpid_seq_' || NEW.account_id);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.campaigns_before_insert_row_tr() OWNER TO chatwoot;

--
-- Name: conversations_before_insert_row_tr(); Type: FUNCTION; Schema: public; Owner: chatwoot
--

CREATE FUNCTION public.conversations_before_insert_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.display_id := nextval('conv_dpid_seq_' || NEW.account_id);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.conversations_before_insert_row_tr() OWNER TO chatwoot;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_tokens; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.access_tokens (
    id bigint NOT NULL,
    owner_type character varying,
    owner_id bigint,
    token character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.access_tokens OWNER TO chatwoot;

--
-- Name: access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_tokens_id_seq OWNER TO chatwoot;

--
-- Name: access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.access_tokens_id_seq OWNED BY public.access_tokens.id;


--
-- Name: account_users; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.account_users (
    id bigint NOT NULL,
    account_id bigint,
    user_id bigint,
    role integer DEFAULT 0,
    inviter_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active_at timestamp without time zone,
    availability integer DEFAULT 0 NOT NULL,
    auto_offline boolean DEFAULT true NOT NULL
);


ALTER TABLE public.account_users OWNER TO chatwoot;

--
-- Name: account_users_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.account_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_users_id_seq OWNER TO chatwoot;

--
-- Name: account_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.account_users_id_seq OWNED BY public.account_users.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locale integer DEFAULT 0,
    domain character varying(100),
    support_email character varying(100),
    settings_flags integer DEFAULT 0 NOT NULL,
    feature_flags integer DEFAULT 0 NOT NULL,
    auto_resolve_duration integer,
    limits jsonb DEFAULT '{}'::jsonb,
    custom_attributes jsonb DEFAULT '{}'::jsonb,
    status integer DEFAULT 0
);


ALTER TABLE public.accounts OWNER TO chatwoot;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO chatwoot;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: action_mailbox_inbound_emails; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.action_mailbox_inbound_emails (
    id bigint NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    message_id character varying NOT NULL,
    message_checksum character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.action_mailbox_inbound_emails OWNER TO chatwoot;

--
-- Name: action_mailbox_inbound_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.action_mailbox_inbound_emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.action_mailbox_inbound_emails_id_seq OWNER TO chatwoot;

--
-- Name: action_mailbox_inbound_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.action_mailbox_inbound_emails_id_seq OWNED BY public.action_mailbox_inbound_emails.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO chatwoot;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_attachments_id_seq OWNER TO chatwoot;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    service_name character varying NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO chatwoot;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_blobs_id_seq OWNER TO chatwoot;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO chatwoot;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_variant_records_id_seq OWNER TO chatwoot;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: agent_bot_inboxes; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.agent_bot_inboxes (
    id bigint NOT NULL,
    inbox_id integer,
    agent_bot_id integer,
    status integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    account_id integer
);


ALTER TABLE public.agent_bot_inboxes OWNER TO chatwoot;

--
-- Name: agent_bot_inboxes_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.agent_bot_inboxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_bot_inboxes_id_seq OWNER TO chatwoot;

--
-- Name: agent_bot_inboxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.agent_bot_inboxes_id_seq OWNED BY public.agent_bot_inboxes.id;


--
-- Name: agent_bots; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.agent_bots (
    id bigint NOT NULL,
    name character varying,
    description character varying,
    outgoing_url character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    account_id bigint,
    bot_type integer DEFAULT 0,
    bot_config jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.agent_bots OWNER TO chatwoot;

--
-- Name: agent_bots_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.agent_bots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.agent_bots_id_seq OWNER TO chatwoot;

--
-- Name: agent_bots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.agent_bots_id_seq OWNED BY public.agent_bots.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO chatwoot;

--
-- Name: articles; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.articles (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    portal_id integer NOT NULL,
    category_id integer,
    folder_id integer,
    title character varying,
    description text,
    content text,
    status integer,
    views integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    author_id bigint,
    associated_article_id bigint,
    meta jsonb DEFAULT '{}'::jsonb,
    slug character varying NOT NULL
);


ALTER TABLE public.articles OWNER TO chatwoot;

--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.articles_id_seq OWNER TO chatwoot;

--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.attachments (
    id integer NOT NULL,
    file_type integer DEFAULT 0,
    external_url character varying,
    coordinates_lat double precision DEFAULT 0.0,
    coordinates_long double precision DEFAULT 0.0,
    message_id integer NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fallback_title character varying,
    extension character varying
);


ALTER TABLE public.attachments OWNER TO chatwoot;

--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.attachments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attachments_id_seq OWNER TO chatwoot;

--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.attachments_id_seq OWNED BY public.attachments.id;


--
-- Name: automation_rules; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.automation_rules (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    event_name character varying NOT NULL,
    conditions jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    actions jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.automation_rules OWNER TO chatwoot;

--
-- Name: automation_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.automation_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.automation_rules_id_seq OWNER TO chatwoot;

--
-- Name: automation_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.automation_rules_id_seq OWNED BY public.automation_rules.id;


--
-- Name: camp_dpid_seq_2; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.camp_dpid_seq_2
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.camp_dpid_seq_2 OWNER TO chatwoot;

--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.campaigns (
    id bigint NOT NULL,
    display_id integer NOT NULL,
    title character varying NOT NULL,
    description text,
    message text NOT NULL,
    sender_id integer,
    enabled boolean DEFAULT true,
    account_id bigint NOT NULL,
    inbox_id bigint NOT NULL,
    trigger_rules jsonb DEFAULT '{}'::jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    campaign_type integer DEFAULT 0 NOT NULL,
    campaign_status integer DEFAULT 0 NOT NULL,
    audience jsonb DEFAULT '[]'::jsonb,
    scheduled_at timestamp without time zone,
    trigger_only_during_business_hours boolean DEFAULT false
);


ALTER TABLE public.campaigns OWNER TO chatwoot;

--
-- Name: campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.campaigns_id_seq OWNER TO chatwoot;

--
-- Name: campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.campaigns_id_seq OWNED BY public.campaigns.id;


--
-- Name: canned_responses; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.canned_responses (
    id integer NOT NULL,
    account_id integer NOT NULL,
    short_code character varying,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.canned_responses OWNER TO chatwoot;

--
-- Name: canned_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.canned_responses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.canned_responses_id_seq OWNER TO chatwoot;

--
-- Name: canned_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.canned_responses_id_seq OWNED BY public.canned_responses.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    portal_id integer NOT NULL,
    name character varying,
    description text,
    "position" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    locale character varying DEFAULT 'en'::character varying,
    slug character varying NOT NULL,
    parent_category_id bigint,
    associated_category_id bigint
);


ALTER TABLE public.categories OWNER TO chatwoot;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO chatwoot;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: channel_api; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.channel_api (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    webhook_url character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    identifier character varying,
    hmac_token character varying,
    hmac_mandatory boolean DEFAULT false,
    additional_attributes jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.channel_api OWNER TO chatwoot;

--
-- Name: channel_api_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.channel_api_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_api_id_seq OWNER TO chatwoot;

--
-- Name: channel_api_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.channel_api_id_seq OWNED BY public.channel_api.id;


--
-- Name: channel_email; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.channel_email (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    email character varying NOT NULL,
    forward_to_email character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    imap_enabled boolean DEFAULT false,
    imap_address character varying DEFAULT ''::character varying,
    imap_port integer DEFAULT 0,
    imap_login character varying DEFAULT ''::character varying,
    imap_password character varying DEFAULT ''::character varying,
    imap_enable_ssl boolean DEFAULT true,
    imap_inbox_synced_at timestamp without time zone,
    smtp_enabled boolean DEFAULT false,
    smtp_address character varying DEFAULT ''::character varying,
    smtp_port integer DEFAULT 0,
    smtp_login character varying DEFAULT ''::character varying,
    smtp_password character varying DEFAULT ''::character varying,
    smtp_domain character varying DEFAULT ''::character varying,
    smtp_enable_starttls_auto boolean DEFAULT true,
    smtp_authentication character varying DEFAULT 'login'::character varying,
    smtp_openssl_verify_mode character varying DEFAULT 'none'::character varying,
    smtp_enable_ssl_tls boolean DEFAULT false
);


ALTER TABLE public.channel_email OWNER TO chatwoot;

--
-- Name: channel_email_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.channel_email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_email_id_seq OWNER TO chatwoot;

--
-- Name: channel_email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.channel_email_id_seq OWNED BY public.channel_email.id;


--
-- Name: channel_facebook_pages; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.channel_facebook_pages (
    id integer NOT NULL,
    page_id character varying NOT NULL,
    user_access_token character varying NOT NULL,
    page_access_token character varying NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    instagram_id character varying
);


ALTER TABLE public.channel_facebook_pages OWNER TO chatwoot;

--
-- Name: channel_facebook_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.channel_facebook_pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_facebook_pages_id_seq OWNER TO chatwoot;

--
-- Name: channel_facebook_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.channel_facebook_pages_id_seq OWNED BY public.channel_facebook_pages.id;


--
-- Name: channel_line; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.channel_line (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    line_channel_id character varying NOT NULL,
    line_channel_secret character varying NOT NULL,
    line_channel_token character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.channel_line OWNER TO chatwoot;

--
-- Name: channel_line_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.channel_line_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_line_id_seq OWNER TO chatwoot;

--
-- Name: channel_line_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.channel_line_id_seq OWNED BY public.channel_line.id;


--
-- Name: channel_sms; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.channel_sms (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    phone_number character varying NOT NULL,
    provider character varying DEFAULT 'default'::character varying,
    provider_config jsonb DEFAULT '{}'::jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.channel_sms OWNER TO chatwoot;

--
-- Name: channel_sms_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.channel_sms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_sms_id_seq OWNER TO chatwoot;

--
-- Name: channel_sms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.channel_sms_id_seq OWNED BY public.channel_sms.id;


--
-- Name: channel_telegram; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.channel_telegram (
    id bigint NOT NULL,
    bot_name character varying,
    account_id integer NOT NULL,
    bot_token character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.channel_telegram OWNER TO chatwoot;

--
-- Name: channel_telegram_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.channel_telegram_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_telegram_id_seq OWNER TO chatwoot;

--
-- Name: channel_telegram_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.channel_telegram_id_seq OWNED BY public.channel_telegram.id;


--
-- Name: channel_twilio_sms; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.channel_twilio_sms (
    id bigint NOT NULL,
    phone_number character varying,
    auth_token character varying NOT NULL,
    account_sid character varying NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    medium integer DEFAULT 0,
    messaging_service_sid character varying
);


ALTER TABLE public.channel_twilio_sms OWNER TO chatwoot;

--
-- Name: channel_twilio_sms_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.channel_twilio_sms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_twilio_sms_id_seq OWNER TO chatwoot;

--
-- Name: channel_twilio_sms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.channel_twilio_sms_id_seq OWNED BY public.channel_twilio_sms.id;


--
-- Name: channel_twitter_profiles; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.channel_twitter_profiles (
    id bigint NOT NULL,
    profile_id character varying NOT NULL,
    twitter_access_token character varying NOT NULL,
    twitter_access_token_secret character varying NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    tweets_enabled boolean DEFAULT true
);


ALTER TABLE public.channel_twitter_profiles OWNER TO chatwoot;

--
-- Name: channel_twitter_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.channel_twitter_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_twitter_profiles_id_seq OWNER TO chatwoot;

--
-- Name: channel_twitter_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.channel_twitter_profiles_id_seq OWNED BY public.channel_twitter_profiles.id;


--
-- Name: channel_web_widgets; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.channel_web_widgets (
    id integer NOT NULL,
    website_url character varying,
    account_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    website_token character varying,
    widget_color character varying DEFAULT '#ebb22f'::character varying,
    welcome_title character varying,
    welcome_tagline character varying,
    feature_flags integer DEFAULT 7 NOT NULL,
    reply_time integer DEFAULT 0,
    hmac_token character varying,
    pre_chat_form_enabled boolean DEFAULT false,
    pre_chat_form_options jsonb DEFAULT '{}'::jsonb,
    hmac_mandatory boolean DEFAULT false,
    continuity_via_email boolean DEFAULT true NOT NULL
);


ALTER TABLE public.channel_web_widgets OWNER TO chatwoot;

--
-- Name: channel_web_widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.channel_web_widgets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_web_widgets_id_seq OWNER TO chatwoot;

--
-- Name: channel_web_widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.channel_web_widgets_id_seq OWNED BY public.channel_web_widgets.id;


--
-- Name: channel_whatsapp; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.channel_whatsapp (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    phone_number character varying NOT NULL,
    provider character varying DEFAULT 'default'::character varying,
    provider_config jsonb DEFAULT '{}'::jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    message_templates jsonb DEFAULT '{}'::jsonb,
    message_templates_last_updated timestamp without time zone
);


ALTER TABLE public.channel_whatsapp OWNER TO chatwoot;

--
-- Name: channel_whatsapp_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.channel_whatsapp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_whatsapp_id_seq OWNER TO chatwoot;

--
-- Name: channel_whatsapp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.channel_whatsapp_id_seq OWNED BY public.channel_whatsapp.id;


--
-- Name: contact_inboxes; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.contact_inboxes (
    id bigint NOT NULL,
    contact_id bigint,
    inbox_id bigint,
    source_id character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    hmac_verified boolean DEFAULT false,
    pubsub_token character varying
);


ALTER TABLE public.contact_inboxes OWNER TO chatwoot;

--
-- Name: contact_inboxes_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.contact_inboxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_inboxes_id_seq OWNER TO chatwoot;

--
-- Name: contact_inboxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.contact_inboxes_id_seq OWNED BY public.contact_inboxes.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.contacts (
    id integer NOT NULL,
    name character varying,
    email character varying,
    phone_number character varying,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional_attributes jsonb DEFAULT '{}'::jsonb,
    identifier character varying,
    custom_attributes jsonb DEFAULT '{}'::jsonb,
    last_activity_at timestamp without time zone
);


ALTER TABLE public.contacts OWNER TO chatwoot;

--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.contacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contacts_id_seq OWNER TO chatwoot;

--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;


--
-- Name: conv_dpid_seq_2; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.conv_dpid_seq_2
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conv_dpid_seq_2 OWNER TO chatwoot;

--
-- Name: conversations; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.conversations (
    id integer NOT NULL,
    account_id integer NOT NULL,
    inbox_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    assignee_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    contact_id bigint,
    display_id integer NOT NULL,
    contact_last_seen_at timestamp without time zone,
    agent_last_seen_at timestamp without time zone,
    additional_attributes jsonb DEFAULT '{}'::jsonb,
    contact_inbox_id bigint,
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    identifier character varying,
    last_activity_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    team_id bigint,
    campaign_id bigint,
    snoozed_until timestamp without time zone,
    custom_attributes jsonb DEFAULT '{}'::jsonb,
    assignee_last_seen_at timestamp without time zone,
    first_reply_created_at timestamp without time zone
);


ALTER TABLE public.conversations OWNER TO chatwoot;

--
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.conversations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversations_id_seq OWNER TO chatwoot;

--
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;


--
-- Name: csat_survey_responses; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.csat_survey_responses (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    message_id bigint NOT NULL,
    rating integer NOT NULL,
    feedback_message text,
    contact_id bigint NOT NULL,
    assigned_agent_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.csat_survey_responses OWNER TO chatwoot;

--
-- Name: csat_survey_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.csat_survey_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.csat_survey_responses_id_seq OWNER TO chatwoot;

--
-- Name: csat_survey_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.csat_survey_responses_id_seq OWNED BY public.csat_survey_responses.id;


--
-- Name: custom_attribute_definitions; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.custom_attribute_definitions (
    id bigint NOT NULL,
    attribute_display_name character varying,
    attribute_key character varying,
    attribute_display_type integer DEFAULT 0,
    default_value integer,
    attribute_model integer DEFAULT 0,
    account_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    attribute_description text,
    attribute_values jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE public.custom_attribute_definitions OWNER TO chatwoot;

--
-- Name: custom_attribute_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.custom_attribute_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.custom_attribute_definitions_id_seq OWNER TO chatwoot;

--
-- Name: custom_attribute_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.custom_attribute_definitions_id_seq OWNED BY public.custom_attribute_definitions.id;


--
-- Name: custom_filters; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.custom_filters (
    id bigint NOT NULL,
    name character varying NOT NULL,
    filter_type integer DEFAULT 0 NOT NULL,
    query jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    account_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.custom_filters OWNER TO chatwoot;

--
-- Name: custom_filters_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.custom_filters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.custom_filters_id_seq OWNER TO chatwoot;

--
-- Name: custom_filters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.custom_filters_id_seq OWNED BY public.custom_filters.id;


--
-- Name: dashboard_apps; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.dashboard_apps (
    id bigint NOT NULL,
    title character varying NOT NULL,
    content jsonb DEFAULT '[]'::jsonb,
    account_id bigint NOT NULL,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.dashboard_apps OWNER TO chatwoot;

--
-- Name: dashboard_apps_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.dashboard_apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dashboard_apps_id_seq OWNER TO chatwoot;

--
-- Name: dashboard_apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.dashboard_apps_id_seq OWNED BY public.dashboard_apps.id;


--
-- Name: data_imports; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.data_imports (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    data_type character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    processing_errors text,
    total_records integer,
    processed_records integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.data_imports OWNER TO chatwoot;

--
-- Name: data_imports_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.data_imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.data_imports_id_seq OWNER TO chatwoot;

--
-- Name: data_imports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.data_imports_id_seq OWNED BY public.data_imports.id;


--
-- Name: email_templates; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.email_templates (
    id bigint NOT NULL,
    name character varying NOT NULL,
    body text NOT NULL,
    account_id integer,
    template_type integer DEFAULT 1,
    locale integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.email_templates OWNER TO chatwoot;

--
-- Name: email_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.email_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_templates_id_seq OWNER TO chatwoot;

--
-- Name: email_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.email_templates_id_seq OWNED BY public.email_templates.id;


--
-- Name: folders; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.folders (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    category_id integer NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.folders OWNER TO chatwoot;

--
-- Name: folders_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.folders_id_seq OWNER TO chatwoot;

--
-- Name: folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.folders_id_seq OWNED BY public.folders.id;


--
-- Name: inbox_members; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.inbox_members (
    id integer NOT NULL,
    user_id integer NOT NULL,
    inbox_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.inbox_members OWNER TO chatwoot;

--
-- Name: inbox_members_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.inbox_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inbox_members_id_seq OWNER TO chatwoot;

--
-- Name: inbox_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.inbox_members_id_seq OWNED BY public.inbox_members.id;


--
-- Name: inboxes; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.inboxes (
    id integer NOT NULL,
    channel_id integer NOT NULL,
    account_id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    channel_type character varying,
    enable_auto_assignment boolean DEFAULT true,
    greeting_enabled boolean DEFAULT false,
    greeting_message character varying,
    email_address character varying,
    working_hours_enabled boolean DEFAULT false,
    out_of_office_message character varying,
    timezone character varying DEFAULT 'UTC'::character varying,
    enable_email_collect boolean DEFAULT true,
    csat_survey_enabled boolean DEFAULT false,
    allow_messages_after_resolved boolean DEFAULT true,
    auto_assignment_config jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.inboxes OWNER TO chatwoot;

--
-- Name: inboxes_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.inboxes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inboxes_id_seq OWNER TO chatwoot;

--
-- Name: inboxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.inboxes_id_seq OWNED BY public.inboxes.id;


--
-- Name: installation_configs; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.installation_configs (
    id bigint NOT NULL,
    name character varying NOT NULL,
    serialized_value jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    locked boolean DEFAULT true NOT NULL
);


ALTER TABLE public.installation_configs OWNER TO chatwoot;

--
-- Name: installation_configs_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.installation_configs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.installation_configs_id_seq OWNER TO chatwoot;

--
-- Name: installation_configs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.installation_configs_id_seq OWNED BY public.installation_configs.id;


--
-- Name: integrations_hooks; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.integrations_hooks (
    id bigint NOT NULL,
    status integer DEFAULT 0,
    inbox_id integer,
    account_id integer,
    app_id character varying,
    hook_type integer DEFAULT 0,
    reference_id character varying,
    access_token character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    settings jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.integrations_hooks OWNER TO chatwoot;

--
-- Name: integrations_hooks_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.integrations_hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.integrations_hooks_id_seq OWNER TO chatwoot;

--
-- Name: integrations_hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.integrations_hooks_id_seq OWNED BY public.integrations_hooks.id;


--
-- Name: labels; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.labels (
    id bigint NOT NULL,
    title character varying,
    description text,
    color character varying DEFAULT '#ebb22f'::character varying NOT NULL,
    show_on_sidebar boolean,
    account_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.labels OWNER TO chatwoot;

--
-- Name: labels_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labels_id_seq OWNER TO chatwoot;

--
-- Name: labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.labels_id_seq OWNED BY public.labels.id;


--
-- Name: macros; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.macros (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    name character varying NOT NULL,
    visibility integer DEFAULT 0,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    actions jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.macros OWNER TO chatwoot;

--
-- Name: macros_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.macros_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.macros_id_seq OWNER TO chatwoot;

--
-- Name: macros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.macros_id_seq OWNED BY public.macros.id;


--
-- Name: mentions; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.mentions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    account_id bigint NOT NULL,
    mentioned_at timestamp without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.mentions OWNER TO chatwoot;

--
-- Name: mentions_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mentions_id_seq OWNER TO chatwoot;

--
-- Name: mentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.mentions_id_seq OWNED BY public.mentions.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    content text,
    account_id integer NOT NULL,
    inbox_id integer NOT NULL,
    conversation_id integer NOT NULL,
    message_type integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    private boolean DEFAULT false,
    status integer DEFAULT 0,
    source_id character varying,
    content_type integer DEFAULT 0 NOT NULL,
    content_attributes json DEFAULT '{}'::json,
    sender_type character varying,
    sender_id bigint,
    external_source_ids jsonb DEFAULT '{}'::jsonb,
    additional_attributes jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.messages OWNER TO chatwoot;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.messages_id_seq OWNER TO chatwoot;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.notes (
    id bigint NOT NULL,
    content text NOT NULL,
    account_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.notes OWNER TO chatwoot;

--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notes_id_seq OWNER TO chatwoot;

--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- Name: notification_settings; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.notification_settings (
    id bigint NOT NULL,
    account_id integer,
    user_id integer,
    email_flags integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    push_flags integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.notification_settings OWNER TO chatwoot;

--
-- Name: notification_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.notification_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_settings_id_seq OWNER TO chatwoot;

--
-- Name: notification_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.notification_settings_id_seq OWNED BY public.notification_settings.id;


--
-- Name: notification_subscriptions; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.notification_subscriptions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    subscription_type integer NOT NULL,
    subscription_attributes jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    identifier character varying
);


ALTER TABLE public.notification_subscriptions OWNER TO chatwoot;

--
-- Name: notification_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.notification_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_subscriptions_id_seq OWNER TO chatwoot;

--
-- Name: notification_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.notification_subscriptions_id_seq OWNED BY public.notification_subscriptions.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    user_id bigint NOT NULL,
    notification_type integer NOT NULL,
    primary_actor_type character varying NOT NULL,
    primary_actor_id bigint NOT NULL,
    secondary_actor_type character varying,
    secondary_actor_id bigint,
    read_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.notifications OWNER TO chatwoot;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO chatwoot;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: platform_app_permissibles; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.platform_app_permissibles (
    id bigint NOT NULL,
    platform_app_id bigint NOT NULL,
    permissible_type character varying NOT NULL,
    permissible_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.platform_app_permissibles OWNER TO chatwoot;

--
-- Name: platform_app_permissibles_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.platform_app_permissibles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.platform_app_permissibles_id_seq OWNER TO chatwoot;

--
-- Name: platform_app_permissibles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.platform_app_permissibles_id_seq OWNED BY public.platform_app_permissibles.id;


--
-- Name: platform_apps; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.platform_apps (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.platform_apps OWNER TO chatwoot;

--
-- Name: platform_apps_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.platform_apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.platform_apps_id_seq OWNER TO chatwoot;

--
-- Name: platform_apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.platform_apps_id_seq OWNED BY public.platform_apps.id;


--
-- Name: portal_members; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.portal_members (
    id bigint NOT NULL,
    portal_id bigint,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.portal_members OWNER TO chatwoot;

--
-- Name: portal_members_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.portal_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.portal_members_id_seq OWNER TO chatwoot;

--
-- Name: portal_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.portal_members_id_seq OWNED BY public.portal_members.id;


--
-- Name: portals; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.portals (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    custom_domain character varying,
    color character varying,
    homepage_link character varying,
    page_title character varying,
    header_text text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    config jsonb DEFAULT '{"allowed_locales": ["en"]}'::jsonb,
    archived boolean DEFAULT false
);


ALTER TABLE public.portals OWNER TO chatwoot;

--
-- Name: portals_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.portals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.portals_id_seq OWNER TO chatwoot;

--
-- Name: portals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.portals_id_seq OWNED BY public.portals.id;


--
-- Name: portals_members; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.portals_members (
    portal_id bigint NOT NULL,
    user_id bigint NOT NULL
);


ALTER TABLE public.portals_members OWNER TO chatwoot;

--
-- Name: related_categories; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.related_categories (
    id bigint NOT NULL,
    category_id bigint,
    related_category_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.related_categories OWNER TO chatwoot;

--
-- Name: related_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.related_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.related_categories_id_seq OWNER TO chatwoot;

--
-- Name: related_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.related_categories_id_seq OWNED BY public.related_categories.id;


--
-- Name: reporting_events; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.reporting_events (
    id bigint NOT NULL,
    name character varying,
    value double precision,
    account_id integer,
    inbox_id integer,
    user_id integer,
    conversation_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    value_in_business_hours double precision,
    event_start_time timestamp without time zone,
    event_end_time timestamp without time zone
);


ALTER TABLE public.reporting_events OWNER TO chatwoot;

--
-- Name: reporting_events_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.reporting_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reporting_events_id_seq OWNER TO chatwoot;

--
-- Name: reporting_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.reporting_events_id_seq OWNED BY public.reporting_events.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO chatwoot;

--
-- Name: taggings; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_type character varying,
    taggable_id integer,
    tagger_type character varying,
    tagger_id integer,
    context character varying(128),
    created_at timestamp without time zone
);


ALTER TABLE public.taggings OWNER TO chatwoot;

--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.taggings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taggings_id_seq OWNER TO chatwoot;

--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0
);


ALTER TABLE public.tags OWNER TO chatwoot;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO chatwoot;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.team_members (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.team_members OWNER TO chatwoot;

--
-- Name: team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.team_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_members_id_seq OWNER TO chatwoot;

--
-- Name: team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.team_members_id_seq OWNED BY public.team_members.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    allow_auto_assign boolean DEFAULT true,
    account_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.teams OWNER TO chatwoot;

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_id_seq OWNER TO chatwoot;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: telegram_bots; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.telegram_bots (
    id integer NOT NULL,
    name character varying,
    auth_key character varying,
    account_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.telegram_bots OWNER TO chatwoot;

--
-- Name: telegram_bots_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.telegram_bots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.telegram_bots_id_seq OWNER TO chatwoot;

--
-- Name: telegram_bots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.telegram_bots_id_seq OWNED BY public.telegram_bots.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.users (
    id integer NOT NULL,
    provider character varying DEFAULT 'email'::character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    name character varying NOT NULL,
    display_name character varying,
    email character varying,
    tokens json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    pubsub_token character varying,
    availability integer DEFAULT 0,
    ui_settings jsonb DEFAULT '{}'::jsonb,
    custom_attributes jsonb DEFAULT '{}'::jsonb,
    type character varying,
    message_signature text
);


ALTER TABLE public.users OWNER TO chatwoot;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO chatwoot;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: webhooks; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.webhooks (
    id bigint NOT NULL,
    account_id integer,
    inbox_id integer,
    url character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    webhook_type integer DEFAULT 0,
    subscriptions jsonb DEFAULT '["conversation_status_changed", "conversation_updated", "conversation_created", "message_created", "message_updated", "webwidget_triggered"]'::jsonb
);


ALTER TABLE public.webhooks OWNER TO chatwoot;

--
-- Name: webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webhooks_id_seq OWNER TO chatwoot;

--
-- Name: webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.webhooks_id_seq OWNED BY public.webhooks.id;


--
-- Name: working_hours; Type: TABLE; Schema: public; Owner: chatwoot
--

CREATE TABLE public.working_hours (
    id bigint NOT NULL,
    inbox_id bigint,
    account_id bigint,
    day_of_week integer NOT NULL,
    closed_all_day boolean DEFAULT false,
    open_hour integer,
    open_minutes integer,
    close_hour integer,
    close_minutes integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    open_all_day boolean DEFAULT false
);


ALTER TABLE public.working_hours OWNER TO chatwoot;

--
-- Name: working_hours_id_seq; Type: SEQUENCE; Schema: public; Owner: chatwoot
--

CREATE SEQUENCE public.working_hours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.working_hours_id_seq OWNER TO chatwoot;

--
-- Name: working_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: chatwoot
--

ALTER SEQUENCE public.working_hours_id_seq OWNED BY public.working_hours.id;


--
-- Name: access_tokens id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.access_tokens ALTER COLUMN id SET DEFAULT nextval('public.access_tokens_id_seq'::regclass);


--
-- Name: account_users id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.account_users ALTER COLUMN id SET DEFAULT nextval('public.account_users_id_seq'::regclass);


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: action_mailbox_inbound_emails id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.action_mailbox_inbound_emails ALTER COLUMN id SET DEFAULT nextval('public.action_mailbox_inbound_emails_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: agent_bot_inboxes id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.agent_bot_inboxes ALTER COLUMN id SET DEFAULT nextval('public.agent_bot_inboxes_id_seq'::regclass);


--
-- Name: agent_bots id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.agent_bots ALTER COLUMN id SET DEFAULT nextval('public.agent_bots_id_seq'::regclass);


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.attachments ALTER COLUMN id SET DEFAULT nextval('public.attachments_id_seq'::regclass);


--
-- Name: automation_rules id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.automation_rules ALTER COLUMN id SET DEFAULT nextval('public.automation_rules_id_seq'::regclass);


--
-- Name: campaigns id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.campaigns ALTER COLUMN id SET DEFAULT nextval('public.campaigns_id_seq'::regclass);


--
-- Name: canned_responses id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.canned_responses ALTER COLUMN id SET DEFAULT nextval('public.canned_responses_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: channel_api id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_api ALTER COLUMN id SET DEFAULT nextval('public.channel_api_id_seq'::regclass);


--
-- Name: channel_email id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_email ALTER COLUMN id SET DEFAULT nextval('public.channel_email_id_seq'::regclass);


--
-- Name: channel_facebook_pages id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_facebook_pages ALTER COLUMN id SET DEFAULT nextval('public.channel_facebook_pages_id_seq'::regclass);


--
-- Name: channel_line id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_line ALTER COLUMN id SET DEFAULT nextval('public.channel_line_id_seq'::regclass);


--
-- Name: channel_sms id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_sms ALTER COLUMN id SET DEFAULT nextval('public.channel_sms_id_seq'::regclass);


--
-- Name: channel_telegram id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_telegram ALTER COLUMN id SET DEFAULT nextval('public.channel_telegram_id_seq'::regclass);


--
-- Name: channel_twilio_sms id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_twilio_sms ALTER COLUMN id SET DEFAULT nextval('public.channel_twilio_sms_id_seq'::regclass);


--
-- Name: channel_twitter_profiles id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_twitter_profiles ALTER COLUMN id SET DEFAULT nextval('public.channel_twitter_profiles_id_seq'::regclass);


--
-- Name: channel_web_widgets id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_web_widgets ALTER COLUMN id SET DEFAULT nextval('public.channel_web_widgets_id_seq'::regclass);


--
-- Name: channel_whatsapp id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_whatsapp ALTER COLUMN id SET DEFAULT nextval('public.channel_whatsapp_id_seq'::regclass);


--
-- Name: contact_inboxes id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.contact_inboxes ALTER COLUMN id SET DEFAULT nextval('public.contact_inboxes_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: conversations id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.conversations ALTER COLUMN id SET DEFAULT nextval('public.conversations_id_seq'::regclass);


--
-- Name: csat_survey_responses id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.csat_survey_responses ALTER COLUMN id SET DEFAULT nextval('public.csat_survey_responses_id_seq'::regclass);


--
-- Name: custom_attribute_definitions id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.custom_attribute_definitions ALTER COLUMN id SET DEFAULT nextval('public.custom_attribute_definitions_id_seq'::regclass);


--
-- Name: custom_filters id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.custom_filters ALTER COLUMN id SET DEFAULT nextval('public.custom_filters_id_seq'::regclass);


--
-- Name: dashboard_apps id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.dashboard_apps ALTER COLUMN id SET DEFAULT nextval('public.dashboard_apps_id_seq'::regclass);


--
-- Name: data_imports id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.data_imports ALTER COLUMN id SET DEFAULT nextval('public.data_imports_id_seq'::regclass);


--
-- Name: email_templates id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.email_templates ALTER COLUMN id SET DEFAULT nextval('public.email_templates_id_seq'::regclass);


--
-- Name: folders id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.folders ALTER COLUMN id SET DEFAULT nextval('public.folders_id_seq'::regclass);


--
-- Name: inbox_members id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.inbox_members ALTER COLUMN id SET DEFAULT nextval('public.inbox_members_id_seq'::regclass);


--
-- Name: inboxes id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.inboxes ALTER COLUMN id SET DEFAULT nextval('public.inboxes_id_seq'::regclass);


--
-- Name: installation_configs id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.installation_configs ALTER COLUMN id SET DEFAULT nextval('public.installation_configs_id_seq'::regclass);


--
-- Name: integrations_hooks id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.integrations_hooks ALTER COLUMN id SET DEFAULT nextval('public.integrations_hooks_id_seq'::regclass);


--
-- Name: labels id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.labels ALTER COLUMN id SET DEFAULT nextval('public.labels_id_seq'::regclass);


--
-- Name: macros id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.macros ALTER COLUMN id SET DEFAULT nextval('public.macros_id_seq'::regclass);


--
-- Name: mentions id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.mentions ALTER COLUMN id SET DEFAULT nextval('public.mentions_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: notification_settings id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.notification_settings ALTER COLUMN id SET DEFAULT nextval('public.notification_settings_id_seq'::regclass);


--
-- Name: notification_subscriptions id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.notification_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.notification_subscriptions_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: platform_app_permissibles id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.platform_app_permissibles ALTER COLUMN id SET DEFAULT nextval('public.platform_app_permissibles_id_seq'::regclass);


--
-- Name: platform_apps id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.platform_apps ALTER COLUMN id SET DEFAULT nextval('public.platform_apps_id_seq'::regclass);


--
-- Name: portal_members id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.portal_members ALTER COLUMN id SET DEFAULT nextval('public.portal_members_id_seq'::regclass);


--
-- Name: portals id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.portals ALTER COLUMN id SET DEFAULT nextval('public.portals_id_seq'::regclass);


--
-- Name: related_categories id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.related_categories ALTER COLUMN id SET DEFAULT nextval('public.related_categories_id_seq'::regclass);


--
-- Name: reporting_events id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.reporting_events ALTER COLUMN id SET DEFAULT nextval('public.reporting_events_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: team_members id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.team_members ALTER COLUMN id SET DEFAULT nextval('public.team_members_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: telegram_bots id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.telegram_bots ALTER COLUMN id SET DEFAULT nextval('public.telegram_bots_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: webhooks id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.webhooks ALTER COLUMN id SET DEFAULT nextval('public.webhooks_id_seq'::regclass);


--
-- Name: working_hours id; Type: DEFAULT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.working_hours ALTER COLUMN id SET DEFAULT nextval('public.working_hours_id_seq'::regclass);


--
-- Data for Name: access_tokens; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.access_tokens (id, owner_type, owner_id, token, created_at, updated_at) FROM stdin;
2	User	2	yh1JgnPcSBedyDGkpS5RWzA7	2022-10-17 09:38:14.944502	2022-10-17 09:38:14.944502
3	User	3	pZHGzS5tw9Nbkpb6mY6Lbqm9	2022-10-17 09:48:11.016006	2022-10-17 09:48:11.016006
4	User	4	pzz5A8AYi18sCYRBVYqmWtcQ	2022-10-17 13:29:06.389006	2022-10-17 13:29:06.389006
5	User	5	KgqjVncbP5B9pc6mvQys33vP	2022-10-17 14:41:32.052054	2022-10-17 14:41:32.052054
6	User	6	kPrjasrmx5ZVGHZEhx2tf8TQ	2022-10-17 14:50:15.878911	2022-10-17 14:50:15.878911
\.


--
-- Data for Name: account_users; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.account_users (id, account_id, user_id, role, inviter_id, created_at, updated_at, active_at, availability, auto_offline) FROM stdin;
1	2	2	1	\N	2022-10-17 09:38:14.973912	2022-10-17 09:38:14.973912	\N	0	t
7	2	4	1	2	2022-10-17 14:01:30.740798	2022-10-17 14:01:30.740798	\N	0	t
8	2	3	0	2	2022-10-17 14:11:48.220786	2022-10-17 14:11:48.220786	\N	0	t
10	2	5	0	2	2022-10-17 14:44:01.744636	2022-10-17 14:44:01.744636	\N	0	t
11	2	6	1	2	2022-10-17 14:50:15.888927	2022-10-17 14:50:15.888927	\N	0	t
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.accounts (id, name, created_at, updated_at, locale, domain, support_email, settings_flags, feature_flags, auto_resolve_duration, limits, custom_attributes, status) FROM stdin;
2	Ellixar Chat	2022-10-17 09:38:14.848437	2022-10-17 09:38:14.848437	0	\N	\N	0	143	\N	{}	{}	0
\.


--
-- Data for Name: action_mailbox_inbound_emails; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.action_mailbox_inbound_emails (id, status, message_id, message_checksum, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
1	file	Attachment	1	1	2022-10-18 05:36:03.906092
2	file	Attachment	2	2	2022-10-18 05:36:03.909499
3	file	Attachment	3	3	2022-10-18 05:36:03.911964
4	file	Attachment	4	4	2022-10-18 05:36:03.914477
5	file	Attachment	5	5	2022-10-18 06:23:03.087066
6	file	Attachment	6	6	2022-10-18 06:23:03.090121
7	file	Attachment	7	7	2022-10-18 06:23:03.092904
8	file	Attachment	8	8	2022-10-18 06:23:03.095397
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, byte_size, checksum, created_at, service_name) FROM stdin;
2	4kompxtr6iuxcczzbopa5dtbduk6	carddav-chat@ellixar.com.mobileconfig	application/octet-stream	{"identified":true,"analyzed":true}	6627	xUV0GtqB/Im7uR/v1pX0WQ==	2022-10-18 05:36:03.881358	local
3	h13ye2izvflqy7slt9s4sy9el171	email-chat@ellixar.com.mobileconfig	application/octet-stream	{"identified":true,"analyzed":true}	7688	oFPOs6YfLx4dO7bJRkfswg==	2022-10-18 05:36:03.883932	local
4	wdus51l8yqa3yy339gtty074bixt	caldav-chat@ellixar.com.mobileconfig	application/octet-stream	{"identified":true,"analyzed":true}	6787	08p+LbIFZtLd50DN0MiI3g==	2022-10-18 05:36:03.885494	local
1	3ezi6aa15j0bggs3sx73osz0s36b	cpanel-logo-tiny.png	image/png	{"identified":true,"width":25,"height":25,"analyzed":true}	18341	vJMld8Kfa4xSeyXiruh8SA==	2022-10-18 05:36:03.877343	local
6	otjyyhn8npngmsbcma329prs4gx7	caldav-support@ellixar.com.mobileconfig	application/octet-stream	{"identified":true,"analyzed":true}	6817	pGXGMiawLOtTyNkEkAnDlg==	2022-10-18 06:23:03.073738	local
7	yqky9do742ehjtywj8ovbsgwr3sw	email-support@ellixar.com.mobileconfig	application/octet-stream	{"identified":true,"analyzed":true}	7724	2HRV3j1hLlVF6OG/NiVDcA==	2022-10-18 06:23:03.075554	local
8	2oywnzvpahfifpaqdgbx6jim269h	carddav-support@ellixar.com.mobileconfig	application/octet-stream	{"identified":true,"analyzed":true}	6651	KmpU+TI/4P4huAktAHc4hQ==	2022-10-18 06:23:03.077051	local
5	lkn8m2jdirbpma6yevtcffodvcth	cpanel-logo-tiny.png	image/png	{"identified":true,"width":25,"height":25,"analyzed":true}	18341	vJMld8Kfa4xSeyXiruh8SA==	2022-10-18 06:23:03.07164	local
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
\.


--
-- Data for Name: agent_bot_inboxes; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.agent_bot_inboxes (id, inbox_id, agent_bot_id, status, created_at, updated_at, account_id) FROM stdin;
\.


--
-- Data for Name: agent_bots; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.agent_bots (id, name, description, outgoing_url, created_at, updated_at, account_id, bot_type, bot_config) FROM stdin;
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	production	2022-10-17 09:33:37.64631	2022-10-17 09:33:37.64631
schema_sha1	51bbefd55d7b027370731df8689d0322612555c0	2022-10-17 09:33:37.650719	2022-10-17 09:33:37.650719
\.


--
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.articles (id, account_id, portal_id, category_id, folder_id, title, description, content, status, views, created_at, updated_at, author_id, associated_article_id, meta, slug) FROM stdin;
\.


--
-- Data for Name: attachments; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.attachments (id, file_type, external_url, coordinates_lat, coordinates_long, message_id, account_id, created_at, updated_at, fallback_title, extension) FROM stdin;
1	3	\N	0	0	10	2	2022-10-18 05:36:03.90346	2022-10-18 05:36:03.907337	\N	\N
2	3	\N	0	0	10	2	2022-10-18 05:36:03.907945	2022-10-18 05:36:03.910078	\N	\N
3	3	\N	0	0	10	2	2022-10-18 05:36:03.910557	2022-10-18 05:36:03.912527	\N	\N
4	3	\N	0	0	10	2	2022-10-18 05:36:03.912985	2022-10-18 05:36:03.915038	\N	\N
5	3	\N	0	0	13	2	2022-10-18 06:23:03.084943	2022-10-18 06:23:03.087906	\N	\N
6	3	\N	0	0	13	2	2022-10-18 06:23:03.088609	2022-10-18 06:23:03.090718	\N	\N
7	3	\N	0	0	13	2	2022-10-18 06:23:03.091189	2022-10-18 06:23:03.093512	\N	\N
8	3	\N	0	0	13	2	2022-10-18 06:23:03.093983	2022-10-18 06:23:03.095945	\N	\N
\.


--
-- Data for Name: automation_rules; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.automation_rules (id, account_id, name, description, event_name, conditions, actions, created_at, updated_at, active) FROM stdin;
\.


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.campaigns (id, display_id, title, description, message, sender_id, enabled, account_id, inbox_id, trigger_rules, created_at, updated_at, campaign_type, campaign_status, audience, scheduled_at, trigger_only_during_business_hours) FROM stdin;
\.


--
-- Data for Name: canned_responses; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.canned_responses (id, account_id, short_code, content, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.categories (id, account_id, portal_id, name, description, "position", created_at, updated_at, locale, slug, parent_category_id, associated_category_id) FROM stdin;
\.


--
-- Data for Name: channel_api; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.channel_api (id, account_id, webhook_url, created_at, updated_at, identifier, hmac_token, hmac_mandatory, additional_attributes) FROM stdin;
\.


--
-- Data for Name: channel_email; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.channel_email (id, account_id, email, forward_to_email, created_at, updated_at, imap_enabled, imap_address, imap_port, imap_login, imap_password, imap_enable_ssl, imap_inbox_synced_at, smtp_enabled, smtp_address, smtp_port, smtp_login, smtp_password, smtp_domain, smtp_enable_starttls_auto, smtp_authentication, smtp_openssl_verify_mode, smtp_enable_ssl_tls) FROM stdin;
3	2	chat@ellixar.com	b7c92b9752c1c13768636b79e44befcb@	2022-10-18 05:30:48.015416	2022-10-18 05:37:19.562202	t	mail.ellixar.com	993	chat@ellixar.com	SG.EfARVODGSBqf1H	t	2022-10-18 05:35:49.634	t	mail.ellixar.com	465	chat@ellixar.com	SG.EfARVODGSBqf1H	ellixar.com	f	login	none	t
4	2	support@ellixar.com	a325ec446822f258de7dd5d6ac5116ab@	2022-10-18 05:51:23.257454	2022-10-18 06:22:42.769224	t	mail.ellixar.com	993	support@ellixar.com	LC^fRaMPWJh}	t	2022-10-18 06:22:19.355	t	mail.ellixar.com	465	support@ellixar.com	LC^fRaMPWJh}	ellixar.com	f	login	none	t
\.


--
-- Data for Name: channel_facebook_pages; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.channel_facebook_pages (id, page_id, user_access_token, page_access_token, account_id, created_at, updated_at, instagram_id) FROM stdin;
\.


--
-- Data for Name: channel_line; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.channel_line (id, account_id, line_channel_id, line_channel_secret, line_channel_token, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: channel_sms; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.channel_sms (id, account_id, phone_number, provider, provider_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: channel_telegram; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.channel_telegram (id, bot_name, account_id, bot_token, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: channel_twilio_sms; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.channel_twilio_sms (id, phone_number, auth_token, account_sid, account_id, created_at, updated_at, medium, messaging_service_sid) FROM stdin;
\.


--
-- Data for Name: channel_twitter_profiles; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.channel_twitter_profiles (id, profile_id, twitter_access_token, twitter_access_token_secret, account_id, created_at, updated_at, tweets_enabled) FROM stdin;
\.


--
-- Data for Name: channel_web_widgets; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.channel_web_widgets (id, website_url, account_id, created_at, updated_at, website_token, widget_color, welcome_title, welcome_tagline, feature_flags, reply_time, hmac_token, pre_chat_form_enabled, pre_chat_form_options, hmac_mandatory, continuity_via_email) FROM stdin;
1	ellixar.com	2	2022-10-17 16:33:21.713885	2022-10-17 16:33:21.713885	K5R2PJFZgLjSyQDLkbdzn1N7	#009CE0	Hi there!	We make it simple to connect to us. Ask us anything or share your feedback.	7	0	nyxmCTbp3mdbS7kzf69cbaYu	f	{"pre_chat_fields": [{"name": "emailAddress", "type": "email", "label": "Email Id", "enabled": false, "required": true, "field_type": "standard"}, {"name": "fullName", "type": "text", "label": "Full name", "enabled": false, "required": false, "field_type": "standard"}, {"name": "phoneNumber", "type": "text", "label": "Phone number", "enabled": false, "required": false, "field_type": "standard"}], "pre_chat_message": "Share your queries or comments here."}	f	t
\.


--
-- Data for Name: channel_whatsapp; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.channel_whatsapp (id, account_id, phone_number, provider, provider_config, created_at, updated_at, message_templates, message_templates_last_updated) FROM stdin;
3	2	+15550931288	whatsapp_cloud	{"api_key": "EAATqlfCpEKUBANg6chmw7kLn9kYJ8VK1rOysSIthRHKQJVQOQ5FJaeu83OcRGZBrZAqNzPvsw5JZBHWZBEypi5TlIvlsZAMZCfh05hOVQQdn8ZCLn9ZCAOcvK9GQW6yiwxQNQvvfltQUiNnQ4qsNPINFi3apNB1ZAyK2j2ZBWQ6R80ZAB8EuyJApx5E", "phone_number_id": "107228432178473", "business_account_id": "107878462113145", "webhook_verify_token": "dsvkj^eBVvCv#TkzsQWS^MfZMAMT&Ve0X&Xe6BRhQ8v!fz6S^U"}	2022-10-19 10:51:47.326118	2022-10-19 18:30:06.75269	[{"id": "1181866002749753", "name": "alert_updates", "status": "APPROVED", "category": "TRANSACTIONAL", "language": "en_US", "components": [{"text": "Thankyou", "type": "BODY"}, {"text": "Sent using Pabbly Connect", "type": "FOOTER"}, {"type": "BUTTONS", "buttons": [{"url": "https://ellixar.com/", "text": "Visit", "type": "URL"}]}]}, {"id": "506262304439878", "name": "hello_world", "status": "APPROVED", "category": "ACCOUNT_UPDATE", "language": "en_US", "components": [{"text": "Hello World", "type": "HEADER", "format": "TEXT"}, {"text": "Welcome and congratulations!! This message demonstrates your ability to send a message notification from WhatsApp Business Platform’s Cloud API. Thank you for taking the time to test with us.", "type": "BODY"}, {"text": "WhatsApp Business API Team", "type": "FOOTER"}]}]	2022-10-19 18:30:06.595283
\.


--
-- Data for Name: contact_inboxes; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.contact_inboxes (id, contact_id, inbox_id, source_id, created_at, updated_at, hmac_verified, pubsub_token) FROM stdin;
6	6	4	cpanel@ellixar.com	2022-10-18 05:36:03.803427	2022-10-18 05:36:03.803427	f	PmyeCVVEYRdeRshqVd9zJtm4
7	7	4	eric@ellixar.com	2022-10-18 05:40:03.992208	2022-10-18 05:40:03.992208	f	sgxVdvmVbng1YLEM2F1LkJEy
8	6	5	cpanel@ellixar.com	2022-10-18 06:23:03.009155	2022-10-18 06:23:03.009155	f	vfxoWqbTTg2c65nUSoC9DvxB
9	7	5	eric@ellixar.com	2022-10-18 06:23:03.285063	2022-10-18 06:23:03.285063	f	UmvAmwedAQy4nq6fg5K5akns
10	8	4	noreply@md.getsentry.com	2022-10-18 07:06:04.364204	2022-10-18 07:06:04.364204	f	DwVeAGegt1Kt8syCCFFzuNex
11	9	4	support@sentry.io	2022-10-18 07:06:04.522627	2022-10-18 07:06:04.522627	f	3ddTRQLS9XaNF69QTuR2ek9k
\.


--
-- Data for Name: contacts; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.contacts (id, name, email, phone_number, account_id, created_at, updated_at, additional_attributes, identifier, custom_attributes, last_activity_at) FROM stdin;
1	Munyingi Ian	munyingi.mike@gmail.com	\N	2	2022-10-17 16:18:03.561256	2022-10-17 16:18:03.720368	{"source_id": "email:CAEuwMpWXQc_n_A9Su=EayLEb3c+ye4s7UBetcROust8-Et4ZeA@mail.gmail.com"}	\N	{}	2022-10-17 16:18:03.714879
3	Sendgrid Support	support@sendgrid.com	\N	2	2022-10-17 16:18:04.213276	2022-10-17 16:18:04.480739	{"source_id": "email:sTwVpoJ3RLWcj_OxkQGIOQ@geopod-ismtpd-2-4"}	\N	{}	2022-10-17 16:18:04.477224
4	EllixarChat	ian@ellixar.com	\N	2	2022-10-17 16:18:04.509644	2022-10-17 16:18:04.679357	{"source_id": "email:634d62a43a626_1e021b760919de@bonga.ellixar.com.mail"}	\N	{}	2022-10-17 16:18:04.668221
5	Dan Ricky	devricky000@gmail.com	\N	2	2022-10-17 16:18:04.817469	2022-10-17 16:18:04.911917	{"source_id": "email:CALgj_FvfiB3nN+D369_eFJ1FkvavRVK6vz3CZraq-Jwq7s2KAQ@mail.gmail.com"}	\N	{}	2022-10-17 16:18:04.900856
2	Erick Chumama	chumamaeric@gmail.com	\N	2	2022-10-17 16:18:03.761354	2022-10-17 16:21:02.207227	{"source_id": "email:CAPt8tKscmnZp1TRB4mMr=PiyoCCCh8RAcYFfYQOGOpgR295jww@mail.gmail.com"}	\N	{}	2022-10-17 16:21:02.191769
6	cPanel on ellixar.com	cpanel@ellixar.com	\N	2	2022-10-18 05:36:03.787559	2022-10-18 06:23:03.201798	{"source_id": "email:1665432171.ZvwZMRnjs3KiRQvK@185-219-132-48.cprapid.com"}	\N	{}	2022-10-18 06:23:03.196116
7	eric	eric@ellixar.com	\N	2	2022-10-18 05:40:03.984787	2022-10-18 06:23:03.368068	{"source_id": "email:6cbd4e438574ec50160bcca8e89b7dc4@ellixar.com"}	\N	{}	2022-10-18 06:23:03.361837
8	Sentry	noreply@md.getsentry.com	\N	2	2022-10-18 07:06:04.359108	2022-10-18 07:06:04.467172	{"source_id": "email:20221018070437.87469.90874@md.getsentry.com"}	\N	{}	2022-10-18 07:06:04.458333
9	support	support@sentry.io	\N	2	2022-10-18 07:06:04.505866	2022-10-18 07:06:04.660007	{"source_id": "email:1122905438.2428638.1666076696977@abmktmail-trigger1h.marketo.org"}	\N	{}	2022-10-18 07:06:04.653758
\.


--
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.conversations (id, account_id, inbox_id, status, assignee_id, created_at, updated_at, contact_id, display_id, contact_last_seen_at, agent_last_seen_at, additional_attributes, contact_inbox_id, uuid, identifier, last_activity_at, team_id, campaign_id, snoozed_until, custom_attributes, assignee_last_seen_at, first_reply_created_at) FROM stdin;
13	2	5	0	4	2022-10-18 06:23:03.296192	2022-10-18 06:23:03.310372	7	13	\N	2022-10-19 11:30:58.666544	{"source": "email", "in_reply_to": "37e9980b4a033e3a7e49fc95731033af@ellixar.com", "initiated_at": {"timestamp": "2022-10-18T06:23:03.291Z"}, "mail_subject": "Re: dfs"}	9	9f8a551e-7e85-4bac-8f8d-1a1368d8734a	\N	2022-10-18 06:23:03.30926	\N	\N	\N	{}	2022-10-18 17:44:14.896701	\N
14	2	4	0	4	2022-10-18 07:06:04.36817	2022-10-18 07:06:04.393754	8	14	\N	2022-10-19 17:36:24.39699	{"source": "email", "in_reply_to": null, "initiated_at": {"timestamp": "2022-10-18T07:06:04.365Z"}, "mail_subject": "Confirm Email"}	10	04775716-de99-4ccc-8d5d-ea31b22623ea	\N	2022-10-18 07:06:04.390664	\N	\N	\N	{}	2022-10-18 17:43:57.78059	\N
10	2	4	0	4	2022-10-18 05:36:03.812051	2022-10-18 05:36:03.867435	6	10	\N	2022-10-19 17:37:38.330106	{"source": "email", "in_reply_to": null, "initiated_at": {"timestamp": "2022-10-18T05:36:03.805Z"}, "mail_subject": "[ellixar.com] Client configuration settings for “chat@ellixar.com”."}	6	dd428573-3376-4379-b3fa-0339677fdb59	\N	2022-10-18 05:36:03.861446	\N	\N	\N	{}	2022-10-18 05:37:37.744576	\N
15	2	4	0	4	2022-10-18 07:06:04.527644	2022-10-18 07:06:04.563874	9	15	\N	2022-10-19 18:11:31.704172	{"source": "email", "in_reply_to": null, "initiated_at": {"timestamp": "2022-10-18T07:06:04.523Z"}, "mail_subject": "Welcome to Sentry - get the most out of your 14 day trial"}	11	c7c5c264-4b92-4267-a434-10b25e462f62	\N	2022-10-18 07:06:04.559752	\N	\N	\N	{}	2022-10-18 17:44:46.698931	\N
11	2	4	0	4	2022-10-18 05:40:03.997899	2022-10-18 05:42:26.042255	7	11	\N	2022-10-18 05:42:19.68193	{"source": "email", "in_reply_to": null, "initiated_at": {"timestamp": "2022-10-18T05:40:03.993Z"}, "mail_subject": "Test Email"}	7	e051ca37-6106-48d9-afbe-d6631ad217e2	\N	2022-10-18 05:42:19.652714	\N	\N	\N	{}	2022-10-18 05:42:19.687158	2022-10-18 05:42:19.652714
12	2	5	0	4	2022-10-18 06:23:03.014739	2022-10-18 06:23:03.070113	6	12	\N	2022-10-18 17:44:16.487456	{"source": "email", "in_reply_to": null, "initiated_at": {"timestamp": "2022-10-18T06:23:03.010Z"}, "mail_subject": "[ellixar.com] Client configuration settings for “support@ellixar.com”."}	8	3f102ffb-72b6-4671-b9d8-f4e2b0508367	\N	2022-10-18 06:23:03.059953	\N	\N	\N	{}	2022-10-18 17:44:16.489169	\N
\.


--
-- Data for Name: csat_survey_responses; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.csat_survey_responses (id, account_id, conversation_id, message_id, rating, feedback_message, contact_id, assigned_agent_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: custom_attribute_definitions; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.custom_attribute_definitions (id, attribute_display_name, attribute_key, attribute_display_type, default_value, attribute_model, account_id, created_at, updated_at, attribute_description, attribute_values) FROM stdin;
\.


--
-- Data for Name: custom_filters; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.custom_filters (id, name, filter_type, query, account_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: dashboard_apps; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.dashboard_apps (id, title, content, account_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: data_imports; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.data_imports (id, account_id, data_type, status, processing_errors, total_records, processed_records, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: email_templates; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.email_templates (id, name, body, account_id, template_type, locale, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: folders; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.folders (id, account_id, category_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: inbox_members; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.inbox_members (id, user_id, inbox_id, created_at, updated_at) FROM stdin;
4	3	3	2022-10-17 16:33:34.593935	2022-10-17 16:33:34.593935
5	4	3	2022-10-17 16:33:34.597136	2022-10-17 16:33:34.597136
6	3	4	2022-10-18 05:33:33.909801	2022-10-18 05:33:33.909801
7	4	4	2022-10-18 05:33:33.911777	2022-10-18 05:33:33.911777
8	5	4	2022-10-18 05:33:33.913405	2022-10-18 05:33:33.913405
9	2	4	2022-10-18 05:33:33.915097	2022-10-18 05:33:33.915097
10	6	4	2022-10-18 05:33:33.916851	2022-10-18 05:33:33.916851
11	4	5	2022-10-18 05:51:34.299815	2022-10-18 05:51:34.299815
12	3	5	2022-10-18 05:51:34.302694	2022-10-18 05:51:34.302694
13	5	5	2022-10-18 05:51:34.305177	2022-10-18 05:51:34.305177
14	6	5	2022-10-18 05:51:34.307387	2022-10-18 05:51:34.307387
15	2	5	2022-10-18 05:51:34.308992	2022-10-18 05:51:34.308992
26	3	8	2022-10-19 10:52:16.87482	2022-10-19 10:52:16.87482
27	5	8	2022-10-19 10:52:16.876872	2022-10-19 10:52:16.876872
28	6	8	2022-10-19 10:52:16.878516	2022-10-19 10:52:16.878516
29	2	8	2022-10-19 10:52:16.880287	2022-10-19 10:52:16.880287
30	4	8	2022-10-19 10:52:16.881939	2022-10-19 10:52:16.881939
\.


--
-- Data for Name: inboxes; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.inboxes (id, channel_id, account_id, name, created_at, updated_at, channel_type, enable_auto_assignment, greeting_enabled, greeting_message, email_address, working_hours_enabled, out_of_office_message, timezone, enable_email_collect, csat_survey_enabled, allow_messages_after_resolved, auto_assignment_config) FROM stdin;
3	1	2	Ellixar	2022-10-17 16:33:21.717343	2022-10-17 16:33:21.717343	Channel::WebWidget	t	t	Need any help, chat with Us.	\N	f	\N	UTC	t	f	t	{}
4	3	2	Ellixar Chat Support Emails	2022-10-18 05:30:48.017239	2022-10-18 05:30:48.017239	Channel::Email	t	f	\N	\N	f	\N	UTC	t	f	t	{}
5	4	2	Ellixar Support Emails	2022-10-18 05:51:23.259626	2022-10-18 05:51:23.259626	Channel::Email	t	f	\N	\N	f	\N	UTC	t	f	t	{}
8	3	2	Whatsapp	2022-10-19 10:51:47.505399	2022-10-19 10:51:47.505399	Channel::Whatsapp	t	f	\N	\N	f	\N	UTC	t	f	t	{}
\.


--
-- Data for Name: installation_configs; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.installation_configs (id, name, serialized_value, created_at, updated_at, locked) FROM stdin;
1	INSTALLATION_NAME	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: Ellixar Chat\\n"	2022-10-20 11:01:37.868202	2022-10-20 11:01:37.871424	t
2	LOGO_THUMBNAIL	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\"/brand-assets/logo_thumbnail.svg\\"\\n"	2022-10-20 11:01:37.87451	2022-10-20 11:01:37.875995	t
3	LOGO	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\"/brand-assets/logo.svg\\"\\n"	2022-10-20 11:01:37.878204	2022-10-20 11:01:37.879767	t
4	BRAND_URL	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: https://chat.ellixar.com\\n"	2022-10-20 11:01:37.882023	2022-10-20 11:01:37.88359	t
5	WIDGET_BRAND_URL	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: https://chat.ellixar.com\\n"	2022-10-20 11:01:37.885847	2022-10-20 11:01:37.887359	t
6	BRAND_NAME	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: Ellixar Chat\\n"	2022-10-20 11:01:37.889515	2022-10-20 11:01:37.891055	t
7	TERMS_URL	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: https://chat.chatwoot.com/terms-of-service\\n"	2022-10-20 11:01:37.893255	2022-10-20 11:01:37.894719	t
8	PRIVACY_URL	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: https://chat.chatwoot.com/privacy-policy\\n"	2022-10-20 11:01:37.896932	2022-10-20 11:01:37.898391	t
9	DISPLAY_MANIFEST	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: true\\n"	2022-10-20 11:01:37.900536	2022-10-20 11:01:37.902071	t
10	MAILER_INBOUND_EMAIL_DOMAIN	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.904327	2022-10-20 11:01:37.905842	f
11	MAILER_SUPPORT_EMAIL	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.908117	2022-10-20 11:01:37.909605	f
12	CREATE_NEW_ACCOUNT_FROM_DASHBOARD	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: false\\n"	2022-10-20 11:01:37.911827	2022-10-20 11:01:37.913297	f
13	INSTALLATION_EVENTS_WEBHOOK_URL	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.915519	2022-10-20 11:01:37.917009	f
14	CHATWOOT_INBOX_TOKEN	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.919231	2022-10-20 11:01:37.920686	f
15	CHATWOOT_INBOX_HMAC_KEY	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.92284	2022-10-20 11:01:37.924357	f
16	API_CHANNEL_NAME	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.926523	2022-10-20 11:01:37.928014	t
17	API_CHANNEL_THUMBNAIL	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.930207	2022-10-20 11:01:37.931739	t
18	ANALYTICS_TOKEN	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.933905	2022-10-20 11:01:37.935409	t
19	ANALYTICS_HOST	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.937571	2022-10-20 11:01:37.939133	t
20	DIRECT_UPLOADS_ENABLED	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: false\\n"	2022-10-20 11:01:37.94161	2022-10-20 11:01:37.943235	f
21	HCAPTCHA_SITE_KEY	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.945452	2022-10-20 11:01:37.94702	f
22	HCAPTCHA_SERVER_KEY	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.949234	2022-10-20 11:01:37.95071	f
23	LOGOUT_REDIRECT_LINK	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\"/app/login\\"\\n"	2022-10-20 11:01:37.952977	2022-10-20 11:01:37.954466	f
24	DISABLE_USER_PROFILE_UPDATE	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: false\\n"	2022-10-20 11:01:37.956653	2022-10-20 11:01:37.958163	f
25	ENABLE_MESSENGER_CHANNEL_HUMAN_AGENT	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: false\\n"	2022-10-20 11:01:37.960902	2022-10-20 11:01:37.962801	f
26	CSML_BOT_HOST	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.965833	2022-10-20 11:01:37.967582	f
27	CSML_BOT_API_KEY	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.969795	2022-10-20 11:01:37.971383	f
28	CHATWOOT_CLOUD_PLANS	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: \\n"	2022-10-20 11:01:37.973567	2022-10-20 11:01:37.975041	t
29	DEPLOYMENT_ENV	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: self-hosted\\n"	2022-10-20 11:01:37.977805	2022-10-20 11:01:37.979745	t
30	ACCOUNT_LEVEL_FEATURE_DEFAULTS	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue:\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: inbound_emails\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: channel_email\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: channel_facebook\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: channel_twitter\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: ip_lookup\\n  enabled: false\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: disable_branding\\n  enabled: false\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: email_continuity_on_api_channel\\n  enabled: false\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: help_center\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: agent_bots\\n  enabled: false\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: macros\\n  enabled: false\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: agent_management\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: team_management\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: inbox_management\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: labels\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: custom_attributes\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: automations\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: canned_responses\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: integrations\\n  enabled: true\\n- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  name: voice_recorder\\n  enabled: true\\n"	2022-10-20 11:01:37.9834	2022-10-20 11:01:37.98606	t
31	VAPID_KEYS	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\n  public_key: BOqA1dgYSDNcYM5YBjySrb_UBGReE0wd_RO9cynL1fmCsSXJ-lHG_GDbUEGPkXF7IXOv_JfrV3sVfBEK2312cDQ=\\n  private_key: IXZpKxbW64cCUkGMH670MD3d0v0fD7j5avCbQsW9GDA=\\n"	2022-10-20 11:02:18.809187	2022-10-20 11:02:18.809187	t
32	INSTALLATION_IDENTIFIER	"--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\\nvalue: 85a27287-35cc-44c4-bef8-516227c9d90a\\n"	2022-10-20 11:07:23.46503	2022-10-20 11:07:23.46503	t
\.


--
-- Data for Name: integrations_hooks; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.integrations_hooks (id, status, inbox_id, account_id, app_id, hook_type, reference_id, access_token, created_at, updated_at, settings) FROM stdin;
\.


--
-- Data for Name: labels; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.labels (id, title, description, color, show_on_sidebar, account_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: macros; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.macros (id, account_id, name, visibility, created_by_id, updated_by_id, actions, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mentions; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.mentions (id, user_id, conversation_id, account_id, mentioned_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.messages (id, content, account_id, inbox_id, conversation_id, message_type, created_at, updated_at, private, status, source_id, content_type, content_attributes, sender_type, sender_id, external_source_ids, additional_attributes) FROM stdin;
10	Client Configuration settings for “chat@ellixar.com”.\n\n\nMail Client Manual Settings\n---------------------------\n\nSecure SSL/TLS Settings (Recommended)\n\nUsername:\n\nchat@ellixar.com\n\nPassword:\n\nUse the email account’s password.\n\nIncoming Server:\n\nmail.ellixar.com\n\n  * IMAP Port: 993\n\n  * POP3 Port: 995\n\nOutgoing Server:\n\nmail.ellixar.com\n\n  * SMTP Port: 465\n\nIMAP, POP3, and SMTP require authentication.\n\nNon-SSL Settings (NOT Recommended)\n\nUsername:\n\nchat@ellixar.com\n\nPassword:\n\nUse the email account’s password.\n\nIncoming Server:\n\nmail.ellixar.com\n\n  * IMAP Port: 143\n\n  * POP3 Port: 110\n\nOutgoing Server:\n\nmail.ellixar.com\n\n  * SMTP Port: 587\n\nIMAP, POP3, and SMTP require authentication.\n\n\nCalendar & Contacts Manual Settings\n-----------------------------------\n\nSecure SSL/TLS Settings (Recommended).\n\nUsername:\n\nchat@ellixar.com\n\nPassword:\n\nUse the email account’s password.\n\nServer:\n\nhttps://mail.ellixar.com:2080\n\n  * Port: 2080\n\nFull Calendar URL(s):\n\n  * Calendar:\n\n  * https://mail.ellixar.com:2080/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\n\nFull Contact List URL(s):\n\n  * Address Book:\n\n  * https://mail.ellixar.com:2080/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\n\nNon-SSL Settings (NOT Recommended).\n\nUsername:\n\nchat@ellixar.com\n\nPassword:\n\nUse the email account’s password.\n\nServer:\n\nhttp://mail.ellixar.com:2079\n\n  * Port: 2079\n\nFull Calendar URL(s):\n\n  * Calendar:\n\n  * http://mail.ellixar.com:2079/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\n\nFull Contact List URL(s):\n\n  * Address Book:\n\n  * http://mail.ellixar.com:2079/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\n\nA .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\n\nThis notice is the result of a request made by a computer with the IP address of “196.216.92.153” through the “cpanel” service on the server.\n\nThe remote computer’s location appears to be: Kenya (KE).\n\nThe remote computer’s IP address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\n\nThe remote computer’s network link type appears to be: “IPIP or SIT”.\n\nThe remote computer’s operating system appears to be: “Mac OS X”.\n\nThe system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\n\nDo not reply to this automated message.\n\ncP\n\nCopyright© 2022 cPanel, L.L.C.	2	4	10	0	2022-10-18 05:36:03.861446	2022-10-18 05:36:03.861446	f	0	1665432171.ZvwZMRnjs3KiRQvK@185-219-132-48.cprapid.com	8	"{\\"email\\":{\\"bcc\\":null,\\"cc\\":null,\\"content_type\\":\\"multipart/mixed; boundary=\\\\\\"mixed-Cpanel::Email::Object-2945122-1665432171-0.675535923510211\\\\\\"\\",\\"date\\":\\"2022-10-10T20:02:51+00:00\\",\\"from\\":[\\"cpanel@ellixar.com\\"],\\"html_content\\":{\\"full\\":\\"\\u003cbody style=\\\\\\"background:#F4F4F4\\\\\\"\\u003e\\\\r\\\\n    \\u003cdiv style=\\\\\\"margin:0;padding:0;background:#F4F4F4\\\\\\"\\u003e\\\\r\\\\n        \\u003ctable cellpadding=\\\\\\"10\\\\\\" cellspacing=\\\\\\"0\\\\\\" border=\\\\\\"0\\\\\\" width=\\\\\\"100%\\\\\\" style=\\\\\\"width:0 auto;\\\\\\"\\u003e\\\\r\\\\n            \\u003ctbody\\u003e\\\\r\\\\n                \\u003ctr\\u003e\\\\r\\\\n                    \\u003ctd align=\\\\\\"center\\\\\\"\\u003e\\\\r\\\\n                        \\u003ctable cellpadding=\\\\\\"0\\\\\\" cellspacing=\\\\\\"0\\\\\\" border=\\\\\\"0\\\\\\" width=\\\\\\"680\\\\\\" style=\\\\\\"border:0;width:0 auto;max-width:680px;\\\\\\"\\u003e\\\\r\\\\n                            \\u003ctbody\\u003e\\\\r\\\\n                                \\u003ctr\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                    \\u003ctd width=\\\\\\"680\\\\\\" height=\\\\\\"25\\\\\\" style=\\\\\\"font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;font-size:16px;color:#333333\\\\\\"\\u003e\\\\r\\\\n                                        \\\\r\\\\n                                            \\\\r\\\\n                                            Client Configuration settings for “chat@ellixar.com”.\\\\r\\\\n                                        \\\\r\\\\n                                    \\u003c/td\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                \\u003c/tr\\u003e\\\\r\\\\n                                \\u003ctr\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                    \\u003ctd style=\\\\\\"padding: 15px 0 20px 0; background-color: #FFFFFF; border: 2px solid #E8E8E8; border-bottom: 2px solid #FF6C2C;\\\\\\"\\u003e\\\\r\\\\n                                        \\u003ctable width=\\\\\\"680\\\\\\" border=\\\\\\"0\\\\\\" cellpadding=\\\\\\"0\\\\\\" cellspacing=\\\\\\"0\\\\\\" style=\\\\\\"background:#FFFFFF;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;\\\\\\"\\u003e\\\\r\\\\n                                            \\u003ctbody\\u003e\\\\r\\\\n                                                \\u003ctr\\u003e\\\\r\\\\n                                                    \\u003ctd width=\\\\\\"15\\\\\\"\\u003e\\\\r\\\\n                                                    \\u003c/td\\u003e\\\\r\\\\n                                                    \\u003ctd width=\\\\\\"650\\\\\\"\\u003e\\\\r\\\\n                                                        \\u003ctable cellpadding=\\\\\\"0\\\\\\" cellspacing=\\\\\\"0\\\\\\" border=\\\\\\"0\\\\\\" width=\\\\\\"100%\\\\\\"\\u003e\\\\r\\\\n                                                            \\u003ctbody\\u003e\\\\r\\\\n                                                                \\u003ctr\\u003e\\\\r\\\\n                                                                    \\u003ctd\\u003e\\\\r\\\\n                                                                        \\u003cdiv id=\\\\\\"manual_settings_area\\\\\\" class=\\\\\\"section\\\\\\"\\u003e\\\\r\\\\n        \\u003ch2 id=\\\\\\"hdrManualSettings\\\\\\"\\u003eMail Client Manual Settings\\u003c/h2\\u003e\\\\r\\\\n        \\\\r\\\\n        \\u003cdiv class=\\\\\\"row\\\\\\"\\u003e\\\\r\\\\n         \\u003cdiv class=\\\\\\"col-md-6\\\\\\"\\u003e\\\\r\\\\n          \\u003cdiv id=\\\\\\"ssl_settings_area\\\\\\"\\\\r\\\\n            \\\\r\\\\n            style=\\\\\\"background-color: #fff;  border: 1px solid transparent; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05); margin-bottom: 20px; border-color: #428bca;\\\\\\"\\\\r\\\\n            \\\\r\\\\n            class=\\\\\\"preferred-selection panel panel-primary\\\\\\"\\u003e\\\\r\\\\n               \\u003cdiv\\\\r\\\\n                \\\\r\\\\n                style=\\\\\\"border-top-left-radius: 3px; border-top-right-radius: 3px; padding: 10px 15px; background-color: #428bca; border-color: #428bca; color: #fff;\\\\\\"\\\\r\\\\n                \\\\r\\\\n                class=\\\\\\"panel-heading\\\\\\"\\u003e\\\\r\\\\n                Secure \\u003cabbr title=\\\\\\"Secure Sockets Layer\\\\\\"\\u003eSSL\\u003c/abbr\\u003e/\\u003cabbr title=\\\\\\"Transport Layer Security\\\\\\"\\u003eTLS\\u003c/abbr\\u003e Settings\\\\r\\\\n                (Recommended)\\\\r\\\\n              \\u003c/div\\u003e\\\\r\\\\n              \\u003ctable class=\\\\\\"table manual_settings_table\\\\\\" style=\\\\\\"border-collapse: collapse; border-spacing: 0; margin-bottom: 0; width: 100%; background-color: transparent; max-width: 100%;\\\\\\"\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblSSLSettingsAreaUsername\\\\\\"\\u003eUsername:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valSSLSettingsAreaUsername\\\\\\" class=\\\\\\"data wrap-text\\\\\\"\\u003echat@ellixar.com\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblSettingsAreaPassword\\\\\\"\\u003ePassword:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valSettingsAreaPassword\\\\\\" class=\\\\\\"escape-note\\\\\\"\\u003e Use the email account’s password.\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblSettingsAreaIncomingServer\\\\\\"\\u003eIncoming Server:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valSettingsAreaIncomingServer\\\\\\" class=\\\\\\"data\\\\\\"\\u003email.ellixar.com\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Internet Message Access Protocol\\\\\\" class=\\\\\\"initialism\\\\\\"\\u003eIMAP\\u003c/abbr\\u003e Port: 993\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Post Office Protocol 3\\\\\\" class=\\\\\\"initialism\\\\\\"\\u003ePOP3\\u003c/abbr\\u003e Port: 995\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblSettingsAreaOutgoingServer\\\\\\"\\u003eOutgoing Server:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valSettingsAreaOutGoingServer\\\\\\" class=\\\\\\"data\\\\\\"\\u003email.ellixar.com\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Simple Mail Transfer Protocol\\\\\\"\\u003eSMTP\\u003c/abbr\\u003e Port: 465\\u003c/li\\u003e\\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" colspan=\\\\\\"2\\\\\\" class=\\\\\\"notes\\\\\\"\\u003e\\\\r\\\\n                                                    \\\\r\\\\n                                                                                \\u003cdiv id=\\\\\\"lblSettingsAreaSmallNote1\\\\\\" class=\\\\\\"small_note\\\\\\"\\u003eIMAP, POP3, and SMTP require authentication.\\u003c/div\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n              \\u003c/table\\u003e\\\\r\\\\n          \\u003c/div\\u003e\\\\r\\\\n         \\u003c/div\\u003e\\\\r\\\\n  \\\\r\\\\n      \\u003c/div\\u003e\\\\r\\\\n        \\\\r\\\\n\\\\r\\\\n        \\u003cdiv class=\\\\\\"row\\\\\\" id=\\\\\\"nonSSL\\\\\\" style=\\\\\\"display: none\\\\\\"\\u003e\\\\r\\\\n         \\u003cdiv class=\\\\\\"col-md-6\\\\\\"\\u003e\\\\r\\\\n           \\u003cdiv id=\\\\\\"non_ssl_settings_area\\\\\\"\\\\r\\\\n            \\\\r\\\\n            style=\\\\\\"background-color: #fff;  border: 1px solid transparent; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05); margin-bottom: 20px; border-color: #f6c342;\\\\\\"\\\\r\\\\n            \\\\r\\\\n           class=\\\\\\"panel panel-default panel-warning\\\\\\"\\u003e\\\\r\\\\n               \\u003cdiv\\\\r\\\\n                \\\\r\\\\n                style=\\\\\\"border-top-left-radius: 3px; border-top-right-radius: 3px; padding: 10px 15px; background-color: #fcf8e1; border-color: #f6c342; color: #333;\\\\\\"\\\\r\\\\n                \\\\r\\\\n                class=\\\\\\"panel-heading\\\\\\"\\u003e\\\\r\\\\n                \\u003cspan id=\\\\\\"descNonSSLSettings\\\\\\" class=\\\\\\"caption not-recommended\\\\\\"\\u003eNon-SSL Settings (NOT Recommended)\\u003c/span\\u003e\\\\r\\\\n              \\u003c/div\\u003e\\\\r\\\\n              \\u003ctable id=\\\\\\"tblManualSettingsTable\\\\\\" class=\\\\\\"table manual_settings_table\\\\\\" style=\\\\\\"border-collapse: collapse; border-spacing: 0; margin-bottom: 0; width: 100%; background-color: transparent; max-width: 100%;\\\\\\"\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblNonSSLSettingsUsername\\\\\\"\\u003eUsername:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valNonSSLSettingsUsername\\\\\\" class=\\\\\\"data wrap-text\\\\\\"\\u003echat@ellixar.com\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblNonSSLSettingsPassword\\\\\\"\\u003ePassword:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valNonSSLSettingsPassword\\\\\\" class=\\\\\\"escape-note\\\\\\"\\u003eUse the email account’s password.\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblNonSSLSettingsIncomingServer\\\\\\"\\u003eIncoming Server:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valNonSSLSettingsIncomingServer\\\\\\" class=\\\\\\"data\\\\\\"\\u003email.ellixar.com                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Internet Message Access Protocol\\\\\\" class=\\\\\\"initialism\\\\\\"\\u003eIMAP\\u003c/abbr\\u003e Port: 143\\u003c/li\\u003e\\\\r\\\\n                               \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Post Office Protocol 3\\\\\\" class=\\\\\\"initialism\\\\\\"\\u003ePOP3\\u003c/abbr\\u003e Port: 110\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                   \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"NonSSLSettingsOutgoingServer\\\\\\"\\u003eOutgoing Server:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"NonSSLSettingsOutgoingServerData\\\\\\" class=\\\\\\"data\\\\\\"\\u003email.ellixar.com                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Simple Mail Transfer Protocol\\\\\\"\\u003eSMTP\\u003c/abbr\\u003e Port: 587\\u003c/li\\u003e\\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" colspan=\\\\\\"2\\\\\\" class=\\\\\\"notes\\\\\\"\\u003e\\\\r\\\\n                                                    \\\\r\\\\n                                                                                \\u003cdiv id=\\\\\\"descNonSSLSettingsAuthenticationIsRequiredForIMAPPOP3SMTP1\\\\\\" class=\\\\\\"small_note\\\\\\"\\u003eIMAP, POP3, and SMTP require authentication.\\u003c/div\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n              \\u003c/table\\u003e\\\\r\\\\n          \\u003c/div\\u003e\\\\r\\\\n        \\u003c/div\\u003e\\\\r\\\\n      \\u003c/div\\u003e\\\\r\\\\n\\\\r\\\\n    \\u003c/div\\u003e\\u003cdiv class=\\\\\\"section\\\\\\"\\u003e\\\\r\\\\n        \\u003ch2\\u003eCalendar \\u0026amp; Contacts Manual Settings\\u003c/h2\\u003e\\\\r\\\\n        \\u003cdiv class=\\\\\\"row\\\\\\"\\u003e\\\\r\\\\n         \\\\r\\\\n         \\u003cdiv class=\\\\\\"col-md-6\\\\\\"\\u003e\\\\r\\\\n          \\u003cdiv style=\\\\\\"background-color: #fff;  border: 1px solid transparent; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05); margin-bottom: 20px; border-color: #428bca;\\\\\\" class=\\\\\\"preferred-selection panel panel-primary\\\\\\"\\u003e\\\\r\\\\n               \\u003cdiv style=\\\\\\"border-top-left-radius: 3px; border-top-right-radius: 3px; padding: 10px 15px; background-color: #428bca; border-color: #428bca; color: #fff;\\\\\\" class=\\\\\\"panel-heading\\\\\\"\\u003e\\\\r\\\\n                Secure \\u003cabbr title=\\\\\\"Secure Sockets Layer\\\\\\"\\u003eSSL\\u003c/abbr\\u003e/\\u003cabbr title=\\\\\\"Transport Layer Security\\\\\\"\\u003eTLS\\u003c/abbr\\u003e Settings (Recommended).\\\\r\\\\n              \\u003c/div\\u003e\\\\r\\\\n              \\u003ctable class=\\\\\\"table manual_settings_table\\\\\\" style=\\\\\\"border-collapse: collapse; border-spacing: 0; margin-bottom: 0; width: 100%; background-color: transparent; max-width: 100%;\\\\\\"\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eUsername:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data wrap-text\\\\\\"\\u003echat@ellixar.com\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003ePassword:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"escape-note\\\\\\"\\u003e Use the email account’s password.\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eServer:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003ehttps://mail.ellixar.com:2080\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ePort: 2080\\u003c/li\\u003e\\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eFull Calendar URL(s):\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003e\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cb\\u003eCalendar\\u003c/b\\u003e:\\u003c/li\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ehttps://mail.ellixar.com:2080/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eFull Contact List URL(s):\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003e\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cb\\u003eAddress Book\\u003c/b\\u003e:\\u003c/li\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ehttps://mail.ellixar.com:2080/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n              \\u003c/table\\u003e\\\\r\\\\n          \\u003c/div\\u003e\\\\r\\\\n         \\u003c/div\\u003e\\\\r\\\\n         \\\\r\\\\n         \\u003cdiv class=\\\\\\"col-md-6\\\\\\"\\u003e\\\\r\\\\n          \\u003cdiv style=\\\\\\"background-color: #fff;  border: 1px solid transparent; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05); margin-bottom: 20px; border-color: #f6c342;\\\\\\" class=\\\\\\"preferred-selection panel panel-primary\\\\\\"\\u003e\\\\r\\\\n               \\u003cdiv style=\\\\\\"border-top-left-radius: 3px; border-top-right-radius: 3px; padding: 10px 15px; background-color: #fcf8e1; border-color: #f6c342; color: #333;\\\\\\" class=\\\\\\"panel-heading\\\\\\"\\u003e\\\\r\\\\n                Non-SSL Settings (NOT Recommended).\\\\r\\\\n              \\u003c/div\\u003e\\\\r\\\\n              \\u003ctable class=\\\\\\"table manual_settings_table\\\\\\" style=\\\\\\"border-collapse: collapse; border-spacing: 0; margin-bottom: 0; width: 100%; background-color: transparent; max-width: 100%;\\\\\\"\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eUsername:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data wrap-text\\\\\\"\\u003echat@ellixar.com\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003ePassword:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"escape-note\\\\\\"\\u003e Use the email account’s password.\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eServer:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003ehttp://mail.ellixar.com:2079\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ePort: 2079\\u003c/li\\u003e\\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eFull Calendar URL(s):\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003e\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cb\\u003eCalendar\\u003c/b\\u003e:\\u003c/li\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ehttp://mail.ellixar.com:2079/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eFull Contact List URL(s):\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003e\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cb\\u003eAddress Book\\u003c/b\\u003e:\\u003c/li\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ehttp://mail.ellixar.com:2079/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n              \\u003c/table\\u003e\\\\r\\\\n          \\u003c/div\\u003e\\\\r\\\\n         \\u003c/div\\u003e\\\\r\\\\n         \\\\r\\\\n        \\u003c/div\\u003e\\\\r\\\\n      \\u003c/div\\u003e\\\\r\\\\n    \\u003c/div\\u003e\\u003cp\\u003e\\\\r\\\\n A .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\\\\r\\\\n\\u003c/p\\u003e\\\\r\\\\n                                                                    \\u003c/td\\u003e\\\\r\\\\n                                                                \\u003c/tr\\u003e\\\\r\\\\n                                                                \\u003ctr\\u003e\\\\r\\\\n                                                                    \\u003ctd\\u003e\\\\r\\\\n                                                                        \\u003cdiv style=\\\\\\"font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;border-top: 2px solid #E8E8E8; padding-top:5px; margin-top: 5px; font-size:12px; color: #666666;\\\\\\"\\u003e\\\\r\\\\n        \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n        \\\\r\\\\n          This notice is the result of a request made by a computer with the \\u003cabbr title=\\\\\\"Internet Protocol\\\\\\"\\u003eIP\\u003c/abbr\\u003e address of “196.216.92.153” through the “cpanel” service on the server.\\\\r\\\\n        \\\\r\\\\n    \\u003c/p\\u003e\\\\r\\\\n\\\\r\\\\n                    \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n                            The remote computer’s location appears to be: Kenya (KE).\\\\r\\\\n                    \\u003c/p\\u003e\\\\r\\\\n        \\\\r\\\\n            \\\\r\\\\n                \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n                  The remote computer’s \\u003cabbr title=\\\\\\"Internet Protocol\\\\\\"\\u003eIP\\u003c/abbr\\u003e address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\\\\r\\\\n                \\u003c/p\\u003e\\\\r\\\\n            \\\\r\\\\n            \\\\r\\\\n\\\\r\\\\n         \\\\r\\\\n                            \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n          The remote computer’s network link type appears to be: “IPIP or SIT”.\\\\r\\\\n        \\u003c/p\\u003e\\\\r\\\\n                          \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n          \\\\r\\\\n            The remote computer’s operating system appears to be: “Mac OS X”.\\\\r\\\\n          \\\\r\\\\n        \\u003c/p\\u003e\\\\r\\\\n          \\\\r\\\\n    \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n        The system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\\\\r\\\\n    \\u003c/p\\u003e\\\\r\\\\n\\u003c/div\\u003e                                                                        \\\\r\\\\n                                                                           \\u003c!-- --\\u003e\\\\r\\\\n                                                                        \\\\r\\\\n\\u003cp\\u003e\\\\r\\\\n    Do not reply to this automated message.\\\\r\\\\n\\u003c/p\\u003e\\\\r\\\\n                                                                    \\u003c/td\\u003e\\\\r\\\\n                                                                \\u003c/tr\\u003e\\\\r\\\\n                                                            \\u003c/tbody\\u003e\\\\r\\\\n                                                        \\u003c/table\\u003e\\\\r\\\\n\\\\r\\\\n                                                    \\u003c/td\\u003e\\\\r\\\\n                                                    \\u003ctd width=\\\\\\"15\\\\\\"\\u003e\\\\r\\\\n                                                    \\u003c/td\\u003e\\\\r\\\\n                                                \\u003c/tr\\u003e\\\\r\\\\n                                            \\u003c/tbody\\u003e\\\\r\\\\n                                        \\u003c/table\\u003e\\\\r\\\\n                                    \\u003c/td\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                \\u003c/tr\\u003e\\\\r\\\\n                                \\u003ctr\\u003e\\\\r\\\\n                                    \\u003ctd align=\\\\\\"center\\\\\\" style=\\\\\\"padding-top: 10px;\\\\\\"\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                        \\u003cimg src=\\\\\\"cid:auto_cid_1191374650\\\\\\" height=\\\\\\"25\\\\\\" width=\\\\\\"25\\\\\\" style=\\\\\\"border:0;line-height:100%;border:0\\\\\\" alt=\\\\\\"cP\\\\\\"\\u003e\\\\r\\\\n                                        \\u003cp style=\\\\\\"font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;font-size:12px;color:#666666; padding: 0; margin: 0;\\\\\\"\\u003eCopyright© 2022 cPanel, L.L.C.\\u003cp\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                    \\u003c/td\\u003e\\\\r\\\\n                                \\u003c/tr\\u003e\\\\r\\\\n                            \\u003c/tbody\\u003e\\\\r\\\\n                        \\u003c/table\\u003e\\\\r\\\\n                    \\u003c/td\\u003e\\\\r\\\\n                \\u003c/tr\\u003e\\\\r\\\\n            \\u003c/tbody\\u003e\\\\r\\\\n        \\u003c/table\\u003e\\\\r\\\\n    \\u003c/div\\u003e\\\\r\\\\n\\u003c/body\\u003e\\",\\"reply\\":\\"Client Configuration settings for “chat@ellixar.com”.\\\\n\\\\nMail Client Manual Settings\\\\n\\\\nSecure SSL/TLS Settings (Recommended)\\\\n\\\\nUsername:\\\\tchat@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nIncoming Server:\\\\tmail.ellixar.com\\\\n-  IMAP Port: 993\\\\n-  POP3 Port: 995\\\\n\\\\nOutgoing Server:\\\\tmail.ellixar.com\\\\n-  SMTP Port: 465\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\nNon-SSL Settings (NOT Recommended)\\\\n\\\\nUsername:\\\\tchat@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nIncoming Server:\\\\tmail.ellixar.com\\\\n-  IMAP Port: 143\\\\n-  POP3 Port: 110\\\\n\\\\nOutgoing Server:\\\\tmail.ellixar.com\\\\n-  SMTP Port: 587\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\nCalendar \\u0026 Contacts Manual Settings\\\\n\\\\nSecure SSL/TLS Settings (Recommended).\\\\n\\\\nUsername:\\\\tchat@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nServer:\\\\thttps://mail.ellixar.com:2080\\\\n- Port: 2080\\\\n\\\\nFull Calendar URL(s):\\\\n-  Calendar:\\\\n- https://mail.ellixar.com:2080/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\\\\n\\\\nFull Contact List URL(s):\\\\n-  Address Book:\\\\n- https://mail.ellixar.com:2080/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\\\\n\\\\nNon-SSL Settings (NOT Recommended).\\\\n\\\\nUsername:\\\\tchat@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nServer:\\\\thttp://mail.ellixar.com:2079\\\\n- Port: 2079\\\\n\\\\nFull Calendar URL(s):\\\\n-  Calendar:\\\\n- http://mail.ellixar.com:2079/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\\\\n\\\\nFull Contact List URL(s):\\\\n-  Address Book:\\\\n- http://mail.ellixar.com:2079/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\\\\n\\\\nA .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\\\\n\\\\nThis notice is the result of a request made by a computer with the IP address of “196.216.92.153” through the “cpanel” service on the server.\\\\n\\\\nThe remote computer’s location appears to be: Kenya (KE).\\\\n\\\\nThe remote computer’s IP address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\\\\n\\\\nThe remote computer’s network link type appears to be: “IPIP or SIT”.\\\\n\\\\nThe remote computer’s operating system appears to be: “Mac OS X”.\\\\n\\\\nThe system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\\\\n\\\\nDo not reply to this automated message.\\\\n\\\\n[cP]\\\\nCopyright© 2022 cPanel, L.L.C.\\",\\"quoted\\":\\"Client Configuration settings for “chat@ellixar.com”.\\\\n\\\\nMail Client Manual Settings\\\\n\\\\nSecure SSL/TLS Settings (Recommended)\\\\n\\\\nUsername:\\\\tchat@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nIncoming Server:\\\\tmail.ellixar.com\\\\n-  IMAP Port: 993\\\\n-  POP3 Port: 995\\\\n\\\\nOutgoing Server:\\\\tmail.ellixar.com\\\\n-  SMTP Port: 465\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\nNon-SSL Settings (NOT Recommended)\\\\n\\\\nUsername:\\\\tchat@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nIncoming Server:\\\\tmail.ellixar.com\\\\n-  IMAP Port: 143\\\\n-  POP3 Port: 110\\\\n\\\\nOutgoing Server:\\\\tmail.ellixar.com\\\\n-  SMTP Port: 587\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\nCalendar \\u0026 Contacts Manual Settings\\\\n\\\\nSecure SSL/TLS Settings (Recommended).\\\\n\\\\nUsername:\\\\tchat@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nServer:\\\\thttps://mail.ellixar.com:2080\\\\n- Port: 2080\\\\n\\\\nFull Calendar URL(s):\\\\n-  Calendar:\\\\n- https://mail.ellixar.com:2080/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\\\\n\\\\nFull Contact List URL(s):\\\\n-  Address Book:\\\\n- https://mail.ellixar.com:2080/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\\\\n\\\\nNon-SSL Settings (NOT Recommended).\\\\n\\\\nUsername:\\\\tchat@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nServer:\\\\thttp://mail.ellixar.com:2079\\\\n- Port: 2079\\\\n\\\\nFull Calendar URL(s):\\\\n-  Calendar:\\\\n- http://mail.ellixar.com:2079/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\\\\n\\\\nFull Contact List URL(s):\\\\n-  Address Book:\\\\n- http://mail.ellixar.com:2079/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\\\\n\\\\nA .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\\\\n\\\\nThis notice is the result of a request made by a computer with the IP address of “196.216.92.153” through the “cpanel” service on the server.\\\\n\\\\nThe remote computer’s location appears to be: Kenya (KE).\\\\n\\\\nThe remote computer’s IP address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\\\\n\\\\nThe remote computer’s network link type appears to be: “IPIP or SIT”.\\\\n\\\\nThe remote computer’s operating system appears to be: “Mac OS X”.\\\\n\\\\nThe system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\\\\n\\\\nDo not reply to this automated message.\\\\n\\\\n[cP]\\\\nCopyright© 2022 cPanel, L.L.C.\\"},\\"in_reply_to\\":null,\\"message_id\\":\\"1665432171.ZvwZMRnjs3KiRQvK@185-219-132-48.cprapid.com\\",\\"multipart\\":true,\\"number_of_attachments\\":4,\\"subject\\":\\"[ellixar.com] Client configuration settings for “chat@ellixar.com”.\\",\\"text_content\\":{\\"full\\":\\"Client Configuration settings for “chat@ellixar.com”.\\\\r\\\\n\\\\r\\\\n\\\\r\\\\nMail Client Manual Settings\\\\r\\\\n---------------------------\\\\r\\\\n\\\\r\\\\nSecure SSL/TLS Settings (Recommended)\\\\r\\\\n\\\\r\\\\nUsername:\\\\r\\\\n\\\\r\\\\nchat@ellixar.com\\\\r\\\\n\\\\r\\\\nPassword:\\\\r\\\\n\\\\r\\\\nUse the email account’s password.\\\\r\\\\n\\\\r\\\\nIncoming Server:\\\\r\\\\n\\\\r\\\\nmail.ellixar.com\\\\r\\\\n\\\\r\\\\n  * IMAP Port: 993\\\\r\\\\n\\\\r\\\\n  * POP3 Port: 995\\\\r\\\\n\\\\r\\\\nOutgoing Server:\\\\r\\\\n\\\\r\\\\nmail.ellixar.com\\\\r\\\\n\\\\r\\\\n  * SMTP Port: 465\\\\r\\\\n\\\\r\\\\nIMAP, POP3, and SMTP require authentication.\\\\r\\\\n\\\\r\\\\nNon-SSL Settings (NOT Recommended)\\\\r\\\\n\\\\r\\\\nUsername:\\\\r\\\\n\\\\r\\\\nchat@ellixar.com\\\\r\\\\n\\\\r\\\\nPassword:\\\\r\\\\n\\\\r\\\\nUse the email account’s password.\\\\r\\\\n\\\\r\\\\nIncoming Server:\\\\r\\\\n\\\\r\\\\nmail.ellixar.com\\\\r\\\\n\\\\r\\\\n  * IMAP Port: 143\\\\r\\\\n\\\\r\\\\n  * POP3 Port: 110\\\\r\\\\n\\\\r\\\\nOutgoing Server:\\\\r\\\\n\\\\r\\\\nmail.ellixar.com\\\\r\\\\n\\\\r\\\\n  * SMTP Port: 587\\\\r\\\\n\\\\r\\\\nIMAP, POP3, and SMTP require authentication.\\\\r\\\\n\\\\r\\\\n\\\\r\\\\nCalendar \\u0026 Contacts Manual Settings\\\\r\\\\n-----------------------------------\\\\r\\\\n\\\\r\\\\nSecure SSL/TLS Settings (Recommended).\\\\r\\\\n\\\\r\\\\nUsername:\\\\r\\\\n\\\\r\\\\nchat@ellixar.com\\\\r\\\\n\\\\r\\\\nPassword:\\\\r\\\\n\\\\r\\\\nUse the email account’s password.\\\\r\\\\n\\\\r\\\\nServer:\\\\r\\\\n\\\\r\\\\nhttps://mail.ellixar.com:2080\\\\r\\\\n\\\\r\\\\n  * Port: 2080\\\\r\\\\n\\\\r\\\\nFull Calendar URL(s):\\\\r\\\\n\\\\r\\\\n  * Calendar:\\\\r\\\\n\\\\r\\\\n  * https://mail.ellixar.com:2080/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\\\\r\\\\n\\\\r\\\\nFull Contact List URL(s):\\\\r\\\\n\\\\r\\\\n  * Address Book:\\\\r\\\\n\\\\r\\\\n  * https://mail.ellixar.com:2080/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\\\\r\\\\n\\\\r\\\\nNon-SSL Settings (NOT Recommended).\\\\r\\\\n\\\\r\\\\nUsername:\\\\r\\\\n\\\\r\\\\nchat@ellixar.com\\\\r\\\\n\\\\r\\\\nPassword:\\\\r\\\\n\\\\r\\\\nUse the email account’s password.\\\\r\\\\n\\\\r\\\\nServer:\\\\r\\\\n\\\\r\\\\nhttp://mail.ellixar.com:2079\\\\r\\\\n\\\\r\\\\n  * Port: 2079\\\\r\\\\n\\\\r\\\\nFull Calendar URL(s):\\\\r\\\\n\\\\r\\\\n  * Calendar:\\\\r\\\\n\\\\r\\\\n  * http://mail.ellixar.com:2079/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\\\\r\\\\n\\\\r\\\\nFull Contact List URL(s):\\\\r\\\\n\\\\r\\\\n  * Address Book:\\\\r\\\\n\\\\r\\\\n  * http://mail.ellixar.com:2079/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\\\\r\\\\n\\\\r\\\\nA .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\\\\r\\\\n\\\\r\\\\nThis notice is the result of a request made by a computer with the IP address of “196.216.92.153” through the “cpanel” service on the server.\\\\r\\\\n\\\\r\\\\nThe remote computer’s location appears to be: Kenya (KE).\\\\r\\\\n\\\\r\\\\nThe remote computer’s IP address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\\\\r\\\\n\\\\r\\\\nThe remote computer’s network link type appears to be: “IPIP or SIT”.\\\\r\\\\n\\\\r\\\\nThe remote computer’s operating system appears to be: “Mac OS X”.\\\\r\\\\n\\\\r\\\\nThe system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\\\\r\\\\n\\\\r\\\\nDo not reply to this automated message.\\\\r\\\\n\\\\r\\\\ncP\\\\r\\\\n\\\\r\\\\nCopyright© 2022 cPanel, L.L.C.\\",\\"reply\\":\\"Client Configuration settings for “chat@ellixar.com”.\\\\n\\\\n\\\\nMail Client Manual Settings\\\\n---------------------------\\\\n\\\\nSecure SSL/TLS Settings (Recommended)\\\\n\\\\nUsername:\\\\n\\\\nchat@ellixar.com\\\\n\\\\nPassword:\\\\n\\\\nUse the email account’s password.\\\\n\\\\nIncoming Server:\\\\n\\\\nmail.ellixar.com\\\\n\\\\n  * IMAP Port: 993\\\\n\\\\n  * POP3 Port: 995\\\\n\\\\nOutgoing Server:\\\\n\\\\nmail.ellixar.com\\\\n\\\\n  * SMTP Port: 465\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\nNon-SSL Settings (NOT Recommended)\\\\n\\\\nUsername:\\\\n\\\\nchat@ellixar.com\\\\n\\\\nPassword:\\\\n\\\\nUse the email account’s password.\\\\n\\\\nIncoming Server:\\\\n\\\\nmail.ellixar.com\\\\n\\\\n  * IMAP Port: 143\\\\n\\\\n  * POP3 Port: 110\\\\n\\\\nOutgoing Server:\\\\n\\\\nmail.ellixar.com\\\\n\\\\n  * SMTP Port: 587\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\n\\\\nCalendar \\u0026 Contacts Manual Settings\\\\n-----------------------------------\\\\n\\\\nSecure SSL/TLS Settings (Recommended).\\\\n\\\\nUsername:\\\\n\\\\nchat@ellixar.com\\\\n\\\\nPassword:\\\\n\\\\nUse the email account’s password.\\\\n\\\\nServer:\\\\n\\\\nhttps://mail.ellixar.com:2080\\\\n\\\\n  * Port: 2080\\\\n\\\\nFull Calendar URL(s):\\\\n\\\\n  * Calendar:\\\\n\\\\n  * https://mail.ellixar.com:2080/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\\\\n\\\\nFull Contact List URL(s):\\\\n\\\\n  * Address Book:\\\\n\\\\n  * https://mail.ellixar.com:2080/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\\\\n\\\\nNon-SSL Settings (NOT Recommended).\\\\n\\\\nUsername:\\\\n\\\\nchat@ellixar.com\\\\n\\\\nPassword:\\\\n\\\\nUse the email account’s password.\\\\n\\\\nServer:\\\\n\\\\nhttp://mail.ellixar.com:2079\\\\n\\\\n  * Port: 2079\\\\n\\\\nFull Calendar URL(s):\\\\n\\\\n  * Calendar:\\\\n\\\\n  * http://mail.ellixar.com:2079/rpc/calendars/chat@ellixar.com/calendar:57ddda60-91e4-b2f1-ef4a-8c70f011623a\\\\n\\\\nFull Contact List URL(s):\\\\n\\\\n  * Address Book:\\\\n\\\\n  * http://mail.ellixar.com:2079/rpc/addressbooks/chat@ellixar.com/contacts~6c18e2a6-6f46-21cb-951c-e15f6cde99fa\\\\n\\\\nA .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\\\\n\\\\nThis notice is the result of a request made by a computer with the IP address of “196.216.92.153” through the “cpanel” service on the server.\\\\n\\\\nThe remote computer’s location appears to be: Kenya (KE).\\\\n\\\\nThe remote computer’s IP address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\\\\n\\\\nThe remote computer’s network link type appears to be: “IPIP or SIT”.\\\\n\\\\nThe remote computer’s operating system appears to be: “Mac OS X”.\\\\n\\\\nThe system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\\\\n\\\\nDo not reply to this automated message.\\\\n\\\\ncP\\\\n\\\\nCopyright© 2022 cPanel, L.L.C.\\",\\"quoted\\":\\"Client Configuration settings for “chat@ellixar.com”.\\\\n\\\\n\\\\nMail Client Manual Settings\\"},\\"to\\":[\\"chat@ellixar.com\\"]},\\"cc_email\\":null,\\"bcc_email\\":null}"	Contact	6	{}	{}
11	This is a test email.	2	4	11	0	2022-10-18 05:40:04.013947	2022-10-18 05:40:04.013947	f	0	6cbd4e438574ec50160bcca8e89b7dc4@ellixar.com	8	"{\\"email\\":{\\"bcc\\":null,\\"cc\\":null,\\"content_type\\":\\"text/plain; charset=US-ASCII; format=flowed\\",\\"date\\":\\"2022-10-18T08:39:36+03:00\\",\\"from\\":[\\"eric@ellixar.com\\"],\\"html_content\\":{},\\"in_reply_to\\":null,\\"message_id\\":\\"6cbd4e438574ec50160bcca8e89b7dc4@ellixar.com\\",\\"multipart\\":false,\\"number_of_attachments\\":0,\\"subject\\":\\"Test Email\\",\\"text_content\\":{\\"full\\":\\"This is a test email.\\\\n\\",\\"reply\\":\\"This is a test email.\\",\\"quoted\\":\\"This is a test email.\\"},\\"to\\":[\\"chat@ellixar.com\\"]},\\"cc_email\\":null,\\"bcc_email\\":null}"	Contact	7	{}	{}
12	It is working correctly.	2	4	11	1	2022-10-18 05:42:19.652714	2022-10-18 05:42:26.041165	f	0	conversation/e051ca37-6106-48d9-afbe-d6631ad217e2/messages/12@ellixar.com	0	"{\\"cc_emails\\":[],\\"bcc_emails\\":[]}"	User	4	{}	{}
13	Client Configuration settings for “support@ellixar.com”.\n\n\nMail Client Manual Settings\n---------------------------\n\nSecure SSL/TLS Settings (Recommended)\n\nUsername:\n\nsupport@ellixar.com\n\nPassword:\n\nUse the email account’s password.\n\nIncoming Server:\n\nmail.ellixar.com\n\n  * IMAP Port: 993\n\n  * POP3 Port: 995\n\nOutgoing Server:\n\nmail.ellixar.com\n\n  * SMTP Port: 465\n\nIMAP, POP3, and SMTP require authentication.\n\nNon-SSL Settings (NOT Recommended)\n\nUsername:\n\nsupport@ellixar.com\n\nPassword:\n\nUse the email account’s password.\n\nIncoming Server:\n\nmail.ellixar.com\n\n  * IMAP Port: 143\n\n  * POP3 Port: 110\n\nOutgoing Server:\n\nmail.ellixar.com\n\n  * SMTP Port: 587\n\nIMAP, POP3, and SMTP require authentication.\n\n\nCalendar & Contacts Manual Settings\n-----------------------------------\n\nSecure SSL/TLS Settings (Recommended).\n\nUsername:\n\nsupport@ellixar.com\n\nPassword:\n\nUse the email account’s password.\n\nServer:\n\nhttps://mail.ellixar.com:2080\n\n  * Port: 2080\n\nFull Calendar URL(s):\n\n  * Calendar:\n\n  * https://mail.ellixar.com:2080/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\n\nFull Contact List URL(s):\n\n  * Address Book:\n\n  * https://mail.ellixar.com:2080/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\n\nNon-SSL Settings (NOT Recommended).\n\nUsername:\n\nsupport@ellixar.com\n\nPassword:\n\nUse the email account’s password.\n\nServer:\n\nhttp://mail.ellixar.com:2079\n\n  * Port: 2079\n\nFull Calendar URL(s):\n\n  * Calendar:\n\n  * http://mail.ellixar.com:2079/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\n\nFull Contact List URL(s):\n\n  * Address Book:\n\n  * http://mail.ellixar.com:2079/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\n\nA .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\n\nThis notice is the result of a request made by a computer with the IP address of “196.216.92.153” through the “cpanel” service on the server.\n\nThe remote computer’s location appears to be: Kenya (KE).\n\nThe remote computer’s IP address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\n\nThe remote computer’s network link type appears to be: “IPIP or SIT”.\n\nThe remote computer’s operating system appears to be: “Linux” with version “2.2.x-3.x”.\n\nThe system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\n\nDo not reply to this automated message.\n\ncP\n\nCopyright© 2022 cPanel, L.L.C.	2	5	12	0	2022-10-18 06:23:03.059953	2022-10-18 06:23:03.059953	f	0	1665432171.DL6lHEVJ6Mj8sgfm@185-219-132-48.cprapid.com	8	"{\\"email\\":{\\"bcc\\":null,\\"cc\\":null,\\"content_type\\":\\"multipart/mixed; boundary=\\\\\\"mixed-Cpanel::Email::Object-3532349-1665432171-0.675535923510211\\\\\\"\\",\\"date\\":\\"2022-10-10T20:02:51+00:00\\",\\"from\\":[\\"cpanel@ellixar.com\\"],\\"html_content\\":{\\"full\\":\\"\\u003cbody style=\\\\\\"background:#F4F4F4\\\\\\"\\u003e\\\\r\\\\n    \\u003cdiv style=\\\\\\"margin:0;padding:0;background:#F4F4F4\\\\\\"\\u003e\\\\r\\\\n        \\u003ctable cellpadding=\\\\\\"10\\\\\\" cellspacing=\\\\\\"0\\\\\\" border=\\\\\\"0\\\\\\" width=\\\\\\"100%\\\\\\" style=\\\\\\"width:0 auto;\\\\\\"\\u003e\\\\r\\\\n            \\u003ctbody\\u003e\\\\r\\\\n                \\u003ctr\\u003e\\\\r\\\\n                    \\u003ctd align=\\\\\\"center\\\\\\"\\u003e\\\\r\\\\n                        \\u003ctable cellpadding=\\\\\\"0\\\\\\" cellspacing=\\\\\\"0\\\\\\" border=\\\\\\"0\\\\\\" width=\\\\\\"680\\\\\\" style=\\\\\\"border:0;width:0 auto;max-width:680px;\\\\\\"\\u003e\\\\r\\\\n                            \\u003ctbody\\u003e\\\\r\\\\n                                \\u003ctr\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                    \\u003ctd width=\\\\\\"680\\\\\\" height=\\\\\\"25\\\\\\" style=\\\\\\"font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;font-size:16px;color:#333333\\\\\\"\\u003e\\\\r\\\\n                                        \\\\r\\\\n                                            \\\\r\\\\n                                            Client Configuration settings for “support@ellixar.com”.\\\\r\\\\n                                        \\\\r\\\\n                                    \\u003c/td\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                \\u003c/tr\\u003e\\\\r\\\\n                                \\u003ctr\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                    \\u003ctd style=\\\\\\"padding: 15px 0 20px 0; background-color: #FFFFFF; border: 2px solid #E8E8E8; border-bottom: 2px solid #FF6C2C;\\\\\\"\\u003e\\\\r\\\\n                                        \\u003ctable width=\\\\\\"680\\\\\\" border=\\\\\\"0\\\\\\" cellpadding=\\\\\\"0\\\\\\" cellspacing=\\\\\\"0\\\\\\" style=\\\\\\"background:#FFFFFF;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;\\\\\\"\\u003e\\\\r\\\\n                                            \\u003ctbody\\u003e\\\\r\\\\n                                                \\u003ctr\\u003e\\\\r\\\\n                                                    \\u003ctd width=\\\\\\"15\\\\\\"\\u003e\\\\r\\\\n                                                    \\u003c/td\\u003e\\\\r\\\\n                                                    \\u003ctd width=\\\\\\"650\\\\\\"\\u003e\\\\r\\\\n                                                        \\u003ctable cellpadding=\\\\\\"0\\\\\\" cellspacing=\\\\\\"0\\\\\\" border=\\\\\\"0\\\\\\" width=\\\\\\"100%\\\\\\"\\u003e\\\\r\\\\n                                                            \\u003ctbody\\u003e\\\\r\\\\n                                                                \\u003ctr\\u003e\\\\r\\\\n                                                                    \\u003ctd\\u003e\\\\r\\\\n                                                                        \\u003cdiv id=\\\\\\"manual_settings_area\\\\\\" class=\\\\\\"section\\\\\\"\\u003e\\\\r\\\\n        \\u003ch2 id=\\\\\\"hdrManualSettings\\\\\\"\\u003eMail Client Manual Settings\\u003c/h2\\u003e\\\\r\\\\n        \\\\r\\\\n        \\u003cdiv class=\\\\\\"row\\\\\\"\\u003e\\\\r\\\\n         \\u003cdiv class=\\\\\\"col-md-6\\\\\\"\\u003e\\\\r\\\\n          \\u003cdiv id=\\\\\\"ssl_settings_area\\\\\\"\\\\r\\\\n            \\\\r\\\\n            style=\\\\\\"background-color: #fff;  border: 1px solid transparent; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05); margin-bottom: 20px; border-color: #428bca;\\\\\\"\\\\r\\\\n            \\\\r\\\\n            class=\\\\\\"preferred-selection panel panel-primary\\\\\\"\\u003e\\\\r\\\\n               \\u003cdiv\\\\r\\\\n                \\\\r\\\\n                style=\\\\\\"border-top-left-radius: 3px; border-top-right-radius: 3px; padding: 10px 15px; background-color: #428bca; border-color: #428bca; color: #fff;\\\\\\"\\\\r\\\\n                \\\\r\\\\n                class=\\\\\\"panel-heading\\\\\\"\\u003e\\\\r\\\\n                Secure \\u003cabbr title=\\\\\\"Secure Sockets Layer\\\\\\"\\u003eSSL\\u003c/abbr\\u003e/\\u003cabbr title=\\\\\\"Transport Layer Security\\\\\\"\\u003eTLS\\u003c/abbr\\u003e Settings\\\\r\\\\n                (Recommended)\\\\r\\\\n              \\u003c/div\\u003e\\\\r\\\\n              \\u003ctable class=\\\\\\"table manual_settings_table\\\\\\" style=\\\\\\"border-collapse: collapse; border-spacing: 0; margin-bottom: 0; width: 100%; background-color: transparent; max-width: 100%;\\\\\\"\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblSSLSettingsAreaUsername\\\\\\"\\u003eUsername:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valSSLSettingsAreaUsername\\\\\\" class=\\\\\\"data wrap-text\\\\\\"\\u003esupport@ellixar.com\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblSettingsAreaPassword\\\\\\"\\u003ePassword:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valSettingsAreaPassword\\\\\\" class=\\\\\\"escape-note\\\\\\"\\u003e Use the email account’s password.\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblSettingsAreaIncomingServer\\\\\\"\\u003eIncoming Server:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valSettingsAreaIncomingServer\\\\\\" class=\\\\\\"data\\\\\\"\\u003email.ellixar.com\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Internet Message Access Protocol\\\\\\" class=\\\\\\"initialism\\\\\\"\\u003eIMAP\\u003c/abbr\\u003e Port: 993\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Post Office Protocol 3\\\\\\" class=\\\\\\"initialism\\\\\\"\\u003ePOP3\\u003c/abbr\\u003e Port: 995\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblSettingsAreaOutgoingServer\\\\\\"\\u003eOutgoing Server:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valSettingsAreaOutGoingServer\\\\\\" class=\\\\\\"data\\\\\\"\\u003email.ellixar.com\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Simple Mail Transfer Protocol\\\\\\"\\u003eSMTP\\u003c/abbr\\u003e Port: 465\\u003c/li\\u003e\\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" colspan=\\\\\\"2\\\\\\" class=\\\\\\"notes\\\\\\"\\u003e\\\\r\\\\n                                                    \\\\r\\\\n                                                                                \\u003cdiv id=\\\\\\"lblSettingsAreaSmallNote1\\\\\\" class=\\\\\\"small_note\\\\\\"\\u003eIMAP, POP3, and SMTP require authentication.\\u003c/div\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n              \\u003c/table\\u003e\\\\r\\\\n          \\u003c/div\\u003e\\\\r\\\\n         \\u003c/div\\u003e\\\\r\\\\n  \\\\r\\\\n      \\u003c/div\\u003e\\\\r\\\\n        \\\\r\\\\n\\\\r\\\\n        \\u003cdiv class=\\\\\\"row\\\\\\" id=\\\\\\"nonSSL\\\\\\" style=\\\\\\"display: none\\\\\\"\\u003e\\\\r\\\\n         \\u003cdiv class=\\\\\\"col-md-6\\\\\\"\\u003e\\\\r\\\\n           \\u003cdiv id=\\\\\\"non_ssl_settings_area\\\\\\"\\\\r\\\\n            \\\\r\\\\n            style=\\\\\\"background-color: #fff;  border: 1px solid transparent; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05); margin-bottom: 20px; border-color: #f6c342;\\\\\\"\\\\r\\\\n            \\\\r\\\\n           class=\\\\\\"panel panel-default panel-warning\\\\\\"\\u003e\\\\r\\\\n               \\u003cdiv\\\\r\\\\n                \\\\r\\\\n                style=\\\\\\"border-top-left-radius: 3px; border-top-right-radius: 3px; padding: 10px 15px; background-color: #fcf8e1; border-color: #f6c342; color: #333;\\\\\\"\\\\r\\\\n                \\\\r\\\\n                class=\\\\\\"panel-heading\\\\\\"\\u003e\\\\r\\\\n                \\u003cspan id=\\\\\\"descNonSSLSettings\\\\\\" class=\\\\\\"caption not-recommended\\\\\\"\\u003eNon-SSL Settings (NOT Recommended)\\u003c/span\\u003e\\\\r\\\\n              \\u003c/div\\u003e\\\\r\\\\n              \\u003ctable id=\\\\\\"tblManualSettingsTable\\\\\\" class=\\\\\\"table manual_settings_table\\\\\\" style=\\\\\\"border-collapse: collapse; border-spacing: 0; margin-bottom: 0; width: 100%; background-color: transparent; max-width: 100%;\\\\\\"\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblNonSSLSettingsUsername\\\\\\"\\u003eUsername:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valNonSSLSettingsUsername\\\\\\" class=\\\\\\"data wrap-text\\\\\\"\\u003esupport@ellixar.com\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblNonSSLSettingsPassword\\\\\\"\\u003ePassword:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valNonSSLSettingsPassword\\\\\\" class=\\\\\\"escape-note\\\\\\"\\u003eUse the email account’s password.\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"lblNonSSLSettingsIncomingServer\\\\\\"\\u003eIncoming Server:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"valNonSSLSettingsIncomingServer\\\\\\" class=\\\\\\"data\\\\\\"\\u003email.ellixar.com                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Internet Message Access Protocol\\\\\\" class=\\\\\\"initialism\\\\\\"\\u003eIMAP\\u003c/abbr\\u003e Port: 143\\u003c/li\\u003e\\\\r\\\\n                               \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Post Office Protocol 3\\\\\\" class=\\\\\\"initialism\\\\\\"\\u003ePOP3\\u003c/abbr\\u003e Port: 110\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                   \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"NonSSLSettingsOutgoingServer\\\\\\"\\u003eOutgoing Server:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" id=\\\\\\"NonSSLSettingsOutgoingServerData\\\\\\" class=\\\\\\"data\\\\\\"\\u003email.ellixar.com                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cabbr title=\\\\\\"Simple Mail Transfer Protocol\\\\\\"\\u003eSMTP\\u003c/abbr\\u003e Port: 587\\u003c/li\\u003e\\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" colspan=\\\\\\"2\\\\\\" class=\\\\\\"notes\\\\\\"\\u003e\\\\r\\\\n                                                    \\\\r\\\\n                                                                                \\u003cdiv id=\\\\\\"descNonSSLSettingsAuthenticationIsRequiredForIMAPPOP3SMTP1\\\\\\" class=\\\\\\"small_note\\\\\\"\\u003eIMAP, POP3, and SMTP require authentication.\\u003c/div\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n              \\u003c/table\\u003e\\\\r\\\\n          \\u003c/div\\u003e\\\\r\\\\n        \\u003c/div\\u003e\\\\r\\\\n      \\u003c/div\\u003e\\\\r\\\\n\\\\r\\\\n    \\u003c/div\\u003e\\u003cdiv class=\\\\\\"section\\\\\\"\\u003e\\\\r\\\\n        \\u003ch2\\u003eCalendar \\u0026amp; Contacts Manual Settings\\u003c/h2\\u003e\\\\r\\\\n        \\u003cdiv class=\\\\\\"row\\\\\\"\\u003e\\\\r\\\\n         \\\\r\\\\n         \\u003cdiv class=\\\\\\"col-md-6\\\\\\"\\u003e\\\\r\\\\n          \\u003cdiv style=\\\\\\"background-color: #fff;  border: 1px solid transparent; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05); margin-bottom: 20px; border-color: #428bca;\\\\\\" class=\\\\\\"preferred-selection panel panel-primary\\\\\\"\\u003e\\\\r\\\\n               \\u003cdiv style=\\\\\\"border-top-left-radius: 3px; border-top-right-radius: 3px; padding: 10px 15px; background-color: #428bca; border-color: #428bca; color: #fff;\\\\\\" class=\\\\\\"panel-heading\\\\\\"\\u003e\\\\r\\\\n                Secure \\u003cabbr title=\\\\\\"Secure Sockets Layer\\\\\\"\\u003eSSL\\u003c/abbr\\u003e/\\u003cabbr title=\\\\\\"Transport Layer Security\\\\\\"\\u003eTLS\\u003c/abbr\\u003e Settings (Recommended).\\\\r\\\\n              \\u003c/div\\u003e\\\\r\\\\n              \\u003ctable class=\\\\\\"table manual_settings_table\\\\\\" style=\\\\\\"border-collapse: collapse; border-spacing: 0; margin-bottom: 0; width: 100%; background-color: transparent; max-width: 100%;\\\\\\"\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eUsername:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data wrap-text\\\\\\"\\u003esupport@ellixar.com\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003ePassword:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"escape-note\\\\\\"\\u003e Use the email account’s password.\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eServer:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003ehttps://mail.ellixar.com:2080\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ePort: 2080\\u003c/li\\u003e\\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eFull Calendar URL(s):\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003e\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cb\\u003eCalendar\\u003c/b\\u003e:\\u003c/li\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ehttps://mail.ellixar.com:2080/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eFull Contact List URL(s):\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003e\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cb\\u003eAddress Book\\u003c/b\\u003e:\\u003c/li\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ehttps://mail.ellixar.com:2080/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n              \\u003c/table\\u003e\\\\r\\\\n          \\u003c/div\\u003e\\\\r\\\\n         \\u003c/div\\u003e\\\\r\\\\n         \\\\r\\\\n         \\u003cdiv class=\\\\\\"col-md-6\\\\\\"\\u003e\\\\r\\\\n          \\u003cdiv style=\\\\\\"background-color: #fff;  border: 1px solid transparent; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05); margin-bottom: 20px; border-color: #f6c342;\\\\\\" class=\\\\\\"preferred-selection panel panel-primary\\\\\\"\\u003e\\\\r\\\\n               \\u003cdiv style=\\\\\\"border-top-left-radius: 3px; border-top-right-radius: 3px; padding: 10px 15px; background-color: #fcf8e1; border-color: #f6c342; color: #333;\\\\\\" class=\\\\\\"panel-heading\\\\\\"\\u003e\\\\r\\\\n                Non-SSL Settings (NOT Recommended).\\\\r\\\\n              \\u003c/div\\u003e\\\\r\\\\n              \\u003ctable class=\\\\\\"table manual_settings_table\\\\\\" style=\\\\\\"border-collapse: collapse; border-spacing: 0; margin-bottom: 0; width: 100%; background-color: transparent; max-width: 100%;\\\\\\"\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eUsername:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data wrap-text\\\\\\"\\u003esupport@ellixar.com\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003ePassword:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"escape-note\\\\\\"\\u003e Use the email account’s password.\\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eServer:\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003ehttp://mail.ellixar.com:2079\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ePort: 2079\\u003c/li\\u003e\\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eFull Calendar URL(s):\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003e\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cb\\u003eCalendar\\u003c/b\\u003e:\\u003c/li\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ehttp://mail.ellixar.com:2079/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n                  \\\\r\\\\n                  \\u003ctr\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\"\\u003eFull Contact List URL(s):\\u003c/td\\u003e\\\\r\\\\n                      \\u003ctd style=\\\\\\"border-top: 1px solid #ddd; padding: 8px;\\\\\\" class=\\\\\\"data\\\\\\"\\u003e\\\\r\\\\n                          \\u003cul\\\\r\\\\n                          style=\\\\\\"margin-bottom: 10px; margin-top: 0; list-style: outside none none; margin-left: -5px; padding-left: 0;\\\\\\"\\\\r\\\\n                          class=\\\\\\"port_list list-inline\\\\\\"\\u003e\\\\r\\\\n                              \\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003e\\u003cb\\u003eAddress Book\\u003c/b\\u003e:\\u003c/li\\u003e\\\\r\\\\n                              \\u003cli style=\\\\\\"display: inline-block; padding-left: 5px; padding-right: 5px;\\\\\\"\\u003ehttp://mail.ellixar.com:2079/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\\u003c/li\\u003e\\\\r\\\\n                              \\\\r\\\\n                          \\u003c/ul\\u003e\\\\r\\\\n                      \\u003c/td\\u003e\\\\r\\\\n                  \\u003c/tr\\u003e\\\\r\\\\n                  \\\\r\\\\n              \\u003c/table\\u003e\\\\r\\\\n          \\u003c/div\\u003e\\\\r\\\\n         \\u003c/div\\u003e\\\\r\\\\n         \\\\r\\\\n        \\u003c/div\\u003e\\\\r\\\\n      \\u003c/div\\u003e\\\\r\\\\n    \\u003c/div\\u003e\\u003cp\\u003e\\\\r\\\\n A .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\\\\r\\\\n\\u003c/p\\u003e\\\\r\\\\n                                                                    \\u003c/td\\u003e\\\\r\\\\n                                                                \\u003c/tr\\u003e\\\\r\\\\n                                                                \\u003ctr\\u003e\\\\r\\\\n                                                                    \\u003ctd\\u003e\\\\r\\\\n                                                                        \\u003cdiv style=\\\\\\"font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;border-top: 2px solid #E8E8E8; padding-top:5px; margin-top: 5px; font-size:12px; color: #666666;\\\\\\"\\u003e\\\\r\\\\n        \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n        \\\\r\\\\n          This notice is the result of a request made by a computer with the \\u003cabbr title=\\\\\\"Internet Protocol\\\\\\"\\u003eIP\\u003c/abbr\\u003e address of “196.216.92.153” through the “cpanel” service on the server.\\\\r\\\\n        \\\\r\\\\n    \\u003c/p\\u003e\\\\r\\\\n\\\\r\\\\n                    \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n                            The remote computer’s location appears to be: Kenya (KE).\\\\r\\\\n                    \\u003c/p\\u003e\\\\r\\\\n        \\\\r\\\\n            \\\\r\\\\n                \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n                  The remote computer’s \\u003cabbr title=\\\\\\"Internet Protocol\\\\\\"\\u003eIP\\u003c/abbr\\u003e address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\\\\r\\\\n                \\u003c/p\\u003e\\\\r\\\\n            \\\\r\\\\n            \\\\r\\\\n\\\\r\\\\n         \\\\r\\\\n                            \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n          The remote computer’s network link type appears to be: “IPIP or SIT”.\\\\r\\\\n        \\u003c/p\\u003e\\\\r\\\\n                          \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n          \\\\r\\\\n            The remote computer’s operating system appears to be: “Linux” with version “2.2.x-3.x”.\\\\r\\\\n          \\\\r\\\\n        \\u003c/p\\u003e\\\\r\\\\n          \\\\r\\\\n    \\u003cp style=\\\\\\"padding:0 0 0 0; margin: 5px 0 0 0;\\\\\\"\\u003e\\\\r\\\\n        The system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\\\\r\\\\n    \\u003c/p\\u003e\\\\r\\\\n\\u003c/div\\u003e                                                                        \\\\r\\\\n                                                                           \\u003c!-- --\\u003e\\\\r\\\\n                                                                        \\\\r\\\\n\\u003cp\\u003e\\\\r\\\\n    Do not reply to this automated message.\\\\r\\\\n\\u003c/p\\u003e\\\\r\\\\n                                                                    \\u003c/td\\u003e\\\\r\\\\n                                                                \\u003c/tr\\u003e\\\\r\\\\n                                                            \\u003c/tbody\\u003e\\\\r\\\\n                                                        \\u003c/table\\u003e\\\\r\\\\n\\\\r\\\\n                                                    \\u003c/td\\u003e\\\\r\\\\n                                                    \\u003ctd width=\\\\\\"15\\\\\\"\\u003e\\\\r\\\\n                                                    \\u003c/td\\u003e\\\\r\\\\n                                                \\u003c/tr\\u003e\\\\r\\\\n                                            \\u003c/tbody\\u003e\\\\r\\\\n                                        \\u003c/table\\u003e\\\\r\\\\n                                    \\u003c/td\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                \\u003c/tr\\u003e\\\\r\\\\n                                \\u003ctr\\u003e\\\\r\\\\n                                    \\u003ctd align=\\\\\\"center\\\\\\" style=\\\\\\"padding-top: 10px;\\\\\\"\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                        \\u003cimg src=\\\\\\"cid:auto_cid_1191374650\\\\\\" height=\\\\\\"25\\\\\\" width=\\\\\\"25\\\\\\" style=\\\\\\"border:0;line-height:100%;border:0\\\\\\" alt=\\\\\\"cP\\\\\\"\\u003e\\\\r\\\\n                                        \\u003cp style=\\\\\\"font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;font-size:12px;color:#666666; padding: 0; margin: 0;\\\\\\"\\u003eCopyright© 2022 cPanel, L.L.C.\\u003cp\\u003e\\\\r\\\\n                                    \\\\r\\\\n                                    \\u003c/td\\u003e\\\\r\\\\n                                \\u003c/tr\\u003e\\\\r\\\\n                            \\u003c/tbody\\u003e\\\\r\\\\n                        \\u003c/table\\u003e\\\\r\\\\n                    \\u003c/td\\u003e\\\\r\\\\n                \\u003c/tr\\u003e\\\\r\\\\n            \\u003c/tbody\\u003e\\\\r\\\\n        \\u003c/table\\u003e\\\\r\\\\n    \\u003c/div\\u003e\\\\r\\\\n\\u003c/body\\u003e\\",\\"reply\\":\\"Client Configuration settings for “support@ellixar.com”.\\\\n\\\\nMail Client Manual Settings\\\\n\\\\nSecure SSL/TLS Settings (Recommended)\\\\n\\\\nUsername:\\\\tsupport@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nIncoming Server:\\\\tmail.ellixar.com\\\\n-  IMAP Port: 993\\\\n-  POP3 Port: 995\\\\n\\\\nOutgoing Server:\\\\tmail.ellixar.com\\\\n-  SMTP Port: 465\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\nNon-SSL Settings (NOT Recommended)\\\\n\\\\nUsername:\\\\tsupport@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nIncoming Server:\\\\tmail.ellixar.com\\\\n-  IMAP Port: 143\\\\n-  POP3 Port: 110\\\\n\\\\nOutgoing Server:\\\\tmail.ellixar.com\\\\n-  SMTP Port: 587\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\nCalendar \\u0026 Contacts Manual Settings\\\\n\\\\nSecure SSL/TLS Settings (Recommended).\\\\n\\\\nUsername:\\\\tsupport@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nServer:\\\\thttps://mail.ellixar.com:2080\\\\n- Port: 2080\\\\n\\\\nFull Calendar URL(s):\\\\n-  Calendar:\\\\n- https://mail.ellixar.com:2080/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\\\\n\\\\nFull Contact List URL(s):\\\\n-  Address Book:\\\\n- https://mail.ellixar.com:2080/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\\\\n\\\\nNon-SSL Settings (NOT Recommended).\\\\n\\\\nUsername:\\\\tsupport@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nServer:\\\\thttp://mail.ellixar.com:2079\\\\n- Port: 2079\\\\n\\\\nFull Calendar URL(s):\\\\n-  Calendar:\\\\n- http://mail.ellixar.com:2079/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\\\\n\\\\nFull Contact List URL(s):\\\\n-  Address Book:\\\\n- http://mail.ellixar.com:2079/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\\\\n\\\\nA .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\\\\n\\\\nThis notice is the result of a request made by a computer with the IP address of “196.216.92.153” through the “cpanel” service on the server.\\\\n\\\\nThe remote computer’s location appears to be: Kenya (KE).\\\\n\\\\nThe remote computer’s IP address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\\\\n\\\\nThe remote computer’s network link type appears to be: “IPIP or SIT”.\\\\n\\\\nThe remote computer’s operating system appears to be: “Linux” with version “2.2.x-3.x”.\\\\n\\\\nThe system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\\\\n\\\\nDo not reply to this automated message.\\\\n\\\\n[cP]\\\\nCopyright© 2022 cPanel, L.L.C.\\",\\"quoted\\":\\"Client Configuration settings for “support@ellixar.com”.\\\\n\\\\nMail Client Manual Settings\\\\n\\\\nSecure SSL/TLS Settings (Recommended)\\\\n\\\\nUsername:\\\\tsupport@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nIncoming Server:\\\\tmail.ellixar.com\\\\n-  IMAP Port: 993\\\\n-  POP3 Port: 995\\\\n\\\\nOutgoing Server:\\\\tmail.ellixar.com\\\\n-  SMTP Port: 465\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\nNon-SSL Settings (NOT Recommended)\\\\n\\\\nUsername:\\\\tsupport@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nIncoming Server:\\\\tmail.ellixar.com\\\\n-  IMAP Port: 143\\\\n-  POP3 Port: 110\\\\n\\\\nOutgoing Server:\\\\tmail.ellixar.com\\\\n-  SMTP Port: 587\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\nCalendar \\u0026 Contacts Manual Settings\\\\n\\\\nSecure SSL/TLS Settings (Recommended).\\\\n\\\\nUsername:\\\\tsupport@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nServer:\\\\thttps://mail.ellixar.com:2080\\\\n- Port: 2080\\\\n\\\\nFull Calendar URL(s):\\\\n-  Calendar:\\\\n- https://mail.ellixar.com:2080/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\\\\n\\\\nFull Contact List URL(s):\\\\n-  Address Book:\\\\n- https://mail.ellixar.com:2080/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\\\\n\\\\nNon-SSL Settings (NOT Recommended).\\\\n\\\\nUsername:\\\\tsupport@ellixar.com\\\\nPassword:\\\\tUse the email account’s password.\\\\nServer:\\\\thttp://mail.ellixar.com:2079\\\\n- Port: 2079\\\\n\\\\nFull Calendar URL(s):\\\\n-  Calendar:\\\\n- http://mail.ellixar.com:2079/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\\\\n\\\\nFull Contact List URL(s):\\\\n-  Address Book:\\\\n- http://mail.ellixar.com:2079/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\\\\n\\\\nA .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\\\\n\\\\nThis notice is the result of a request made by a computer with the IP address of “196.216.92.153” through the “cpanel” service on the server.\\\\n\\\\nThe remote computer’s location appears to be: Kenya (KE).\\\\n\\\\nThe remote computer’s IP address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\\\\n\\\\nThe remote computer’s network link type appears to be: “IPIP or SIT”.\\\\n\\\\nThe remote computer’s operating system appears to be: “Linux” with version “2.2.x-3.x”.\\\\n\\\\nThe system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\\\\n\\\\nDo not reply to this automated message.\\\\n\\\\n[cP]\\\\nCopyright© 2022 cPanel, L.L.C.\\"},\\"in_reply_to\\":null,\\"message_id\\":\\"1665432171.DL6lHEVJ6Mj8sgfm@185-219-132-48.cprapid.com\\",\\"multipart\\":true,\\"number_of_attachments\\":4,\\"subject\\":\\"[ellixar.com] Client configuration settings for “support@ellixar.com”.\\",\\"text_content\\":{\\"full\\":\\"Client Configuration settings for “support@ellixar.com”.\\\\r\\\\n\\\\r\\\\n\\\\r\\\\nMail Client Manual Settings\\\\r\\\\n---------------------------\\\\r\\\\n\\\\r\\\\nSecure SSL/TLS Settings (Recommended)\\\\r\\\\n\\\\r\\\\nUsername:\\\\r\\\\n\\\\r\\\\nsupport@ellixar.com\\\\r\\\\n\\\\r\\\\nPassword:\\\\r\\\\n\\\\r\\\\nUse the email account’s password.\\\\r\\\\n\\\\r\\\\nIncoming Server:\\\\r\\\\n\\\\r\\\\nmail.ellixar.com\\\\r\\\\n\\\\r\\\\n  * IMAP Port: 993\\\\r\\\\n\\\\r\\\\n  * POP3 Port: 995\\\\r\\\\n\\\\r\\\\nOutgoing Server:\\\\r\\\\n\\\\r\\\\nmail.ellixar.com\\\\r\\\\n\\\\r\\\\n  * SMTP Port: 465\\\\r\\\\n\\\\r\\\\nIMAP, POP3, and SMTP require authentication.\\\\r\\\\n\\\\r\\\\nNon-SSL Settings (NOT Recommended)\\\\r\\\\n\\\\r\\\\nUsername:\\\\r\\\\n\\\\r\\\\nsupport@ellixar.com\\\\r\\\\n\\\\r\\\\nPassword:\\\\r\\\\n\\\\r\\\\nUse the email account’s password.\\\\r\\\\n\\\\r\\\\nIncoming Server:\\\\r\\\\n\\\\r\\\\nmail.ellixar.com\\\\r\\\\n\\\\r\\\\n  * IMAP Port: 143\\\\r\\\\n\\\\r\\\\n  * POP3 Port: 110\\\\r\\\\n\\\\r\\\\nOutgoing Server:\\\\r\\\\n\\\\r\\\\nmail.ellixar.com\\\\r\\\\n\\\\r\\\\n  * SMTP Port: 587\\\\r\\\\n\\\\r\\\\nIMAP, POP3, and SMTP require authentication.\\\\r\\\\n\\\\r\\\\n\\\\r\\\\nCalendar \\u0026 Contacts Manual Settings\\\\r\\\\n-----------------------------------\\\\r\\\\n\\\\r\\\\nSecure SSL/TLS Settings (Recommended).\\\\r\\\\n\\\\r\\\\nUsername:\\\\r\\\\n\\\\r\\\\nsupport@ellixar.com\\\\r\\\\n\\\\r\\\\nPassword:\\\\r\\\\n\\\\r\\\\nUse the email account’s password.\\\\r\\\\n\\\\r\\\\nServer:\\\\r\\\\n\\\\r\\\\nhttps://mail.ellixar.com:2080\\\\r\\\\n\\\\r\\\\n  * Port: 2080\\\\r\\\\n\\\\r\\\\nFull Calendar URL(s):\\\\r\\\\n\\\\r\\\\n  * Calendar:\\\\r\\\\n\\\\r\\\\n  * https://mail.ellixar.com:2080/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\\\\r\\\\n\\\\r\\\\nFull Contact List URL(s):\\\\r\\\\n\\\\r\\\\n  * Address Book:\\\\r\\\\n\\\\r\\\\n  * https://mail.ellixar.com:2080/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\\\\r\\\\n\\\\r\\\\nNon-SSL Settings (NOT Recommended).\\\\r\\\\n\\\\r\\\\nUsername:\\\\r\\\\n\\\\r\\\\nsupport@ellixar.com\\\\r\\\\n\\\\r\\\\nPassword:\\\\r\\\\n\\\\r\\\\nUse the email account’s password.\\\\r\\\\n\\\\r\\\\nServer:\\\\r\\\\n\\\\r\\\\nhttp://mail.ellixar.com:2079\\\\r\\\\n\\\\r\\\\n  * Port: 2079\\\\r\\\\n\\\\r\\\\nFull Calendar URL(s):\\\\r\\\\n\\\\r\\\\n  * Calendar:\\\\r\\\\n\\\\r\\\\n  * http://mail.ellixar.com:2079/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\\\\r\\\\n\\\\r\\\\nFull Contact List URL(s):\\\\r\\\\n\\\\r\\\\n  * Address Book:\\\\r\\\\n\\\\r\\\\n  * http://mail.ellixar.com:2079/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\\\\r\\\\n\\\\r\\\\nA .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\\\\r\\\\n\\\\r\\\\nThis notice is the result of a request made by a computer with the IP address of “196.216.92.153” through the “cpanel” service on the server.\\\\r\\\\n\\\\r\\\\nThe remote computer’s location appears to be: Kenya (KE).\\\\r\\\\n\\\\r\\\\nThe remote computer’s IP address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\\\\r\\\\n\\\\r\\\\nThe remote computer’s network link type appears to be: “IPIP or SIT”.\\\\r\\\\n\\\\r\\\\nThe remote computer’s operating system appears to be: “Linux” with version “2.2.x-3.x”.\\\\r\\\\n\\\\r\\\\nThe system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\\\\r\\\\n\\\\r\\\\nDo not reply to this automated message.\\\\r\\\\n\\\\r\\\\ncP\\\\r\\\\n\\\\r\\\\nCopyright© 2022 cPanel, L.L.C.\\",\\"reply\\":\\"Client Configuration settings for “support@ellixar.com”.\\\\n\\\\n\\\\nMail Client Manual Settings\\\\n---------------------------\\\\n\\\\nSecure SSL/TLS Settings (Recommended)\\\\n\\\\nUsername:\\\\n\\\\nsupport@ellixar.com\\\\n\\\\nPassword:\\\\n\\\\nUse the email account’s password.\\\\n\\\\nIncoming Server:\\\\n\\\\nmail.ellixar.com\\\\n\\\\n  * IMAP Port: 993\\\\n\\\\n  * POP3 Port: 995\\\\n\\\\nOutgoing Server:\\\\n\\\\nmail.ellixar.com\\\\n\\\\n  * SMTP Port: 465\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\nNon-SSL Settings (NOT Recommended)\\\\n\\\\nUsername:\\\\n\\\\nsupport@ellixar.com\\\\n\\\\nPassword:\\\\n\\\\nUse the email account’s password.\\\\n\\\\nIncoming Server:\\\\n\\\\nmail.ellixar.com\\\\n\\\\n  * IMAP Port: 143\\\\n\\\\n  * POP3 Port: 110\\\\n\\\\nOutgoing Server:\\\\n\\\\nmail.ellixar.com\\\\n\\\\n  * SMTP Port: 587\\\\n\\\\nIMAP, POP3, and SMTP require authentication.\\\\n\\\\n\\\\nCalendar \\u0026 Contacts Manual Settings\\\\n-----------------------------------\\\\n\\\\nSecure SSL/TLS Settings (Recommended).\\\\n\\\\nUsername:\\\\n\\\\nsupport@ellixar.com\\\\n\\\\nPassword:\\\\n\\\\nUse the email account’s password.\\\\n\\\\nServer:\\\\n\\\\nhttps://mail.ellixar.com:2080\\\\n\\\\n  * Port: 2080\\\\n\\\\nFull Calendar URL(s):\\\\n\\\\n  * Calendar:\\\\n\\\\n  * https://mail.ellixar.com:2080/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\\\\n\\\\nFull Contact List URL(s):\\\\n\\\\n  * Address Book:\\\\n\\\\n  * https://mail.ellixar.com:2080/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\\\\n\\\\nNon-SSL Settings (NOT Recommended).\\\\n\\\\nUsername:\\\\n\\\\nsupport@ellixar.com\\\\n\\\\nPassword:\\\\n\\\\nUse the email account’s password.\\\\n\\\\nServer:\\\\n\\\\nhttp://mail.ellixar.com:2079\\\\n\\\\n  * Port: 2079\\\\n\\\\nFull Calendar URL(s):\\\\n\\\\n  * Calendar:\\\\n\\\\n  * http://mail.ellixar.com:2079/rpc/calendars/support@ellixar.com/calendar:c704f2a5-b6e2-2d7a-47d7-4d8748a4b710\\\\n\\\\nFull Contact List URL(s):\\\\n\\\\n  * Address Book:\\\\n\\\\n  * http://mail.ellixar.com:2079/rpc/addressbooks/support@ellixar.com/contacts~927b1990-0194-e90b-a53d-0853ba4397da\\\\n\\\\nA .mobileconfig file for use with iOS for iPhone/iPad/iPod and MacOS® Mail.app® for Mountain Lion (10.8+) is attached to this message.\\\\n\\\\nThis notice is the result of a request made by a computer with the IP address of “196.216.92.153” through the “cpanel” service on the server.\\\\n\\\\nThe remote computer’s location appears to be: Kenya (KE).\\\\n\\\\nThe remote computer’s IP address is assigned to the provider: “SWIFT-LIQUID Maintainer Liquid Telecommunications Operations Limited”\\\\n\\\\nThe remote computer’s network link type appears to be: “IPIP or SIT”.\\\\n\\\\nThe remote computer’s operating system appears to be: “Linux” with version “2.2.x-3.x”.\\\\n\\\\nThe system generated this notice on Monday, October 10, 2022 at 8:02:51 PM UTC.\\\\n\\\\nDo not reply to this automated message.\\\\n\\\\ncP\\\\n\\\\nCopyright© 2022 cPanel, L.L.C.\\",\\"quoted\\":\\"Client Configuration settings for “support@ellixar.com”.\\\\n\\\\n\\\\nMail Client Manual Settings\\"},\\"to\\":[\\"support@ellixar.com\\"]},\\"cc_email\\":null,\\"bcc_email\\":null}"	Contact	6	{}	{}
14	On 2022-10-18 08:55, support@ellixar.com wrote:\n> LC^fRaMPWJh}\nReceived.	2	5	13	0	2022-10-18 06:23:03.30926	2022-10-18 06:23:03.30926	f	0	499a737258889ed097a99d35c1ef94bf@ellixar.com	8	"{\\"email\\":{\\"bcc\\":null,\\"cc\\":null,\\"content_type\\":\\"text/plain; charset=US-ASCII; format=flowed\\",\\"date\\":\\"2022-10-18T09:20:22+03:00\\",\\"from\\":[\\"eric@ellixar.com\\"],\\"html_content\\":{},\\"in_reply_to\\":\\"37e9980b4a033e3a7e49fc95731033af@ellixar.com\\",\\"message_id\\":\\"499a737258889ed097a99d35c1ef94bf@ellixar.com\\",\\"multipart\\":false,\\"number_of_attachments\\":0,\\"subject\\":\\"Re: dfs\\",\\"text_content\\":{\\"full\\":\\"On 2022-10-18 08:55, support@ellixar.com wrote:\\\\n\\u003e LC^fRaMPWJh}\\\\nReceived.\\\\n\\",\\"reply\\":\\"On 2022-10-18 08:55, support@ellixar.com wrote:\\\\n\\u003e LC^fRaMPWJh}\\\\nReceived.\\",\\"quoted\\":\\"Received.\\"},\\"to\\":[\\"support@ellixar.com\\"]},\\"cc_email\\":null,\\"bcc_email\\":null}"	Contact	7	{}	{}
15	Thanks for signing up for Sentry!\n\n\nPlease confirm your email (chat@ellixar.com) by clicking the link below:\n\nhttps://sentry.io/account/confirm-email/2282677/Az24kt30J9mIWpsk5LXYo8Nl1iKi4rDQ/\n\nThis link will expire in 48 hours.\n\n\nIf you did not sign up, you may simply ignore this email.	2	4	14	0	2022-10-18 07:06:04.390664	2022-10-18 07:06:04.390664	f	0	20221018070437.87469.90874@md.getsentry.com	8	"{\\"email\\":{\\"bcc\\":null,\\"cc\\":null,\\"content_type\\":\\"multipart/alternative; boundary=\\\\\\"===============5455320535052954282==\\\\\\"\\",\\"date\\":\\"2022-10-18T07:04:38+00:00\\",\\"from\\":[\\"noreply@md.getsentry.com\\"],\\"html_content\\":{\\"full\\":\\"\\u003c!DOCTYPE html\\u003e\\\\n\\u003chtml style=\\\\\\"font-weight: 300\\\\\\"\\u003e\\\\n\\u003chead style=\\\\\\"font-weight: 300\\\\\\"\\u003e\\\\n  \\u003cmeta charset=\\\\\\"utf-8\\\\\\" style=\\\\\\"font-weight: 300\\\\\\"\\u003e\\\\n  \\u003cmeta name=\\\\\\"viewport\\\\\\" content=\\\\\\"width=device-width, initial-scale=1\\\\\\" style=\\\\\\"font-weight: 300\\\\\\"\\u003e\\\\n\\\\n  \\\\n\\\\n\\u003cstyle type=\\\\\\"text/css\\\\\\" style=\\\\\\"font-weight: 300\\\\\\"\\u003e\\\\n  @import url(https://fonts.googleapis.com/css?family=Lato:400,700);\\\\n\\u003c/style\\u003e\\\\n\\\\n\\\\n  \\\\n\\\\n\\u003c/head\\u003e\\\\n\\u003cbody class=\\\\\\"\\\\\\" style='font-weight: 300; background-image: url(https://s1.sentry-cdn.com/_static/06540f67e7b2ecbf55193d242d11606a/sentry/images/email/sentry-pattern.png); width: 100%; font-size: 16px; font-family: \\\\\\"Lato\\\\\\", \\\\\\"Helvetica Neue\\\\\\", helvetica, sans-serif; background-color: #fff; color: #2f2936; -webkit-font-smoothing: antialiased; margin: 0; padding: 0'\\u003e\\\\n\\u003cdiv class=\\\\\\"preheader\\\\\\" style=\\\\\\"font-weight: 300; display: none; font-size: 0; max-height: 0; line-height: 0; mso-hide: all; padding: 0\\\\\\"\\u003e\\u003c/div\\u003e\\\\n\\u003ctable class=\\\\\\"main\\\\\\" style='font-weight: 300; width: 100%; border-collapse: separate; font-size: 16px; font-family: \\\\\\"Lato\\\\\\", \\\\\\"Helvetica Neue\\\\\\", helvetica, sans-serif; background-color: #fff; color: #2f2936; -webkit-font-smoothing: antialiased; max-width: 700px; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); border-radius: 4px; border: 1px solid #c7d0d4; border-spacing: 0; margin: 15px auto; padding: 0'\\u003e\\\\n  \\u003ctr style=\\\\\\"font-weight: 300\\\\\\"\\u003e\\\\n    \\u003ctd style=\\\\\\"font-weight: 300; text-align: center; margin: 0; padding: 0\\\\\\"\\u003e\\\\n      \\u003cdiv class=\\\\\\"header\\\\\\" style=\\\\\\"font-weight: 300; font-size: 14px; border-bottom: 1px solid #dee7eb; padding: 23px 0\\\\\\"\\u003e\\\\n        \\u003cdiv class=\\\\\\"container\\\\\\" style=\\\\\\"font-weight: 300; max-width: 600px; text-align: left; margin: 0 auto; padding: 0 20px\\\\\\"\\u003e\\\\n          \\\\n          \\u003ch1 style=\\\\\\"font-weight: normal; font-size: 38px; line-height: 42px; color: #000; letter-spacing: -1px; margin: 0; padding: 0\\\\\\"\\u003e\\\\n            \\u003ca href=\\\\\\"https://sentry.io\\\\\\" style=\\\\\\"font-weight: 500; color: #4674ca; text-decoration: none\\\\\\"\\u003e\\u003cimg src=\\\\\\"https://s1.sentry-cdn.com/_static/06540f67e7b2ecbf55193d242d11606a/sentry/images/email/sentry_logo_full.png\\\\\\" width=\\\\\\"125px\\\\\\" height=\\\\\\"29px\\\\\\" alt=\\\\\\"Sentry\\\\\\" style=\\\\\\"font-weight: 300\\\\\\"\\u003e\\u003c/a\\u003e\\\\n          \\u003c/h1\\u003e\\\\n          \\\\n        \\u003c/div\\u003e\\\\n      \\u003c/div\\u003e\\\\n    \\u003c/td\\u003e\\\\n  \\u003c/tr\\u003e\\\\n  \\u003ctr style=\\\\\\"font-weight: 300\\\\\\"\\u003e\\\\n    \\u003ctd style=\\\\\\"font-weight: 300; text-align: center; margin: 0; padding: 0\\\\\\"\\u003e\\\\n      \\\\n      \\u003cdiv class=\\\\\\"container\\\\\\" style=\\\\\\"font-weight: 300; max-width: 600px; text-align: left; margin: 0 auto; padding: 0 20px\\\\\\"\\u003e\\\\n        \\u003cdiv class=\\\\\\"inner\\\\\\" style=\\\\\\"font-weight: 300; background-color: #fff; padding: 30px 0 20px\\\\\\"\\u003e\\\\n          \\\\n    \\u003ch3 style=\\\\\\"font-weight: 700; font-size: 18px; margin: 0 0 20px\\\\\\"\\u003eConfirm Email\\u003c/h3\\u003e\\\\n    \\\\n        \\u003cp style=\\\\\\"font-weight: 300; font-size: 16px; line-height: 24px; margin: 0 0 15px\\\\\\"\\u003eThanks for signing up for Sentry!\\u003c/p\\u003e\\\\n    \\\\n    \\u003cp style=\\\\\\"font-weight: 300; font-size: 16px; line-height: 24px; margin: 0 0 15px\\\\\\"\\u003ePlease confirm your email (chat@ellixar.com) by clicking the button below. This link will expire in 48 hours.\\u003c/p\\u003e\\\\n    \\u003ca href=\\\\\\"https://sentry.io/account/confirm-email/2282677/Az24kt30J9mIWpsk5LXYo8Nl1iKi4rDQ/\\\\\\" class=\\\\\\"btn\\\\\\" style=\\\\\\"font-weight: 600; color: #fff; text-decoration: none; background-color: #6C5FC7; border: 1px solid #413496; box-shadow: 0 2px 0 rgba(0, 0, 0, 0.08); line-height: 18px; border-radius: 4px; display: inline-block; font-size: 16px; padding: 8px 15px\\\\\\"\\u003eConfirm\\u003c/a\\u003e\\\\n\\\\n        \\u003c/div\\u003e\\\\n      \\u003c/div\\u003e\\\\n      \\\\n      \\u003cdiv class=\\\\\\"container\\\\\\" style=\\\\\\"font-weight: 300; max-width: 600px; text-align: left; margin: 0 auto; padding: 0 20px\\\\\\"\\u003e\\\\n        \\u003cdiv class=\\\\\\"footer\\\\\\" style=\\\\\\"font-weight: 300; border-top: 1px solid #E7EBEE; padding: 35px 0\\\\\\"\\u003e\\\\n          \\\\n          \\u003ca href=\\\\\\"https://sentry.io\\\\\\" style=\\\\\\"font-weight: 500; color: #687276; text-decoration: none; float: right\\\\\\"\\u003eHome\\u003c/a\\u003e\\\\n          \\\\n          \\u003ca href=\\\\\\"https://sentry.io/settings/account/notifications/\\\\\\" style=\\\\\\"font-weight: 500; color: #687276; text-decoration: none\\\\\\"\\u003eNotification Settings\\u003c/a\\u003e\\\\n          \\\\n          \\\\n        \\u003c/div\\u003e\\\\n      \\u003c/div\\u003e\\\\n    \\u003c/td\\u003e\\\\n  \\u003c/tr\\u003e\\\\n\\u003c/table\\u003e\\\\n\\u003cimg src=\\\\\\"https://u2307627.ct.sendgrid.net/wf/open?upn=FBISxeAxB8nWtkEsoUAXWChxUQVl4hCl9hTFwyPkuZcVAE4XYjo8-2B77g9yUqVJjat0GyPNjw9Q2-2ByUp0YJzeeXwqgcQ-2FXkB3Xwii2iew4rep9z0fOb40JTwtmg-2BkguaJj-2Fl-2BBOMYZvffdQp6M4VFPAmW9doeFfFrMq4trneZC-2BlZ9uVbc59xQOSxhNSDB4KfTycdbR-2F6OUynslwUi8n6hw-3D-3D\\\\\\" alt=\\\\\\"\\\\\\" width=\\\\\\"1\\\\\\" height=\\\\\\"1\\\\\\" border=\\\\\\"0\\\\\\" style=\\\\\\"height:1px !important;width:1px !important;border-width:0 !important;margin-top:0 !important;margin-bottom:0 !important;margin-right:0 !important;margin-left:0 !important;padding-top:0 !important;padding-bottom:0 !important;padding-right:0 !important;padding-left:0 !important;\\\\\\"/\\u003e\\u003c/body\\u003e\\\\n\\u003c/html\\u003e\\",\\"reply\\":\\"[Sentry](https://sentry.io)\\\\n\\\\nConfirm Email\\\\n\\\\nThanks for signing up for Sentry!\\\\n\\\\nPlease confirm your email (chat@ellixar.com) by clicking the button below. This link will expire in 48 hours.\\\\n[Confirm](https://sentry.io/account/confirm-email/2282677/Az24kt30J9mIWpsk5LXYo8Nl1iKi4rDQ/)\\\\n\\\\n[Home](https://sentry.io) [Notification Settings](https://sentry.io/settings/account/notifications/)      []\\",\\"quoted\\":\\"[Sentry](https://sentry.io)\\\\n\\\\nConfirm Email\\\\n\\\\nThanks for signing up for Sentry!\\\\n\\\\nPlease confirm your email (chat@ellixar.com) by clicking the button below. This link will expire in 48 hours.\\\\n[Confirm](https://sentry.io/account/confirm-email/2282677/Az24kt30J9mIWpsk5LXYo8Nl1iKi4rDQ/)\\\\n\\\\n[Home](https://sentry.io) [Notification Settings](https://sentry.io/settings/account/notifications/)      []\\"},\\"in_reply_to\\":null,\\"message_id\\":\\"20221018070437.87469.90874@md.getsentry.com\\",\\"multipart\\":true,\\"number_of_attachments\\":0,\\"subject\\":\\"Confirm Email\\",\\"text_content\\":{\\"full\\":\\"\\\\nThanks for signing up for Sentry!\\\\n\\\\n\\\\nPlease confirm your email (chat@ellixar.com) by clicking the link below:\\\\n\\\\nhttps://sentry.io/account/confirm-email/2282677/Az24kt30J9mIWpsk5LXYo8Nl1iKi4rDQ/\\\\n\\\\nThis link will expire in 48 hours.\\\\n\\\\n\\\\nIf you did not sign up, you may simply ignore this email.\\\\n\\\\n\\",\\"reply\\":\\"Thanks for signing up for Sentry!\\\\n\\\\n\\\\nPlease confirm your email (chat@ellixar.com) by clicking the link below:\\\\n\\\\nhttps://sentry.io/account/confirm-email/2282677/Az24kt30J9mIWpsk5LXYo8Nl1iKi4rDQ/\\\\n\\\\nThis link will expire in 48 hours.\\\\n\\\\n\\\\nIf you did not sign up, you may simply ignore this email.\\",\\"quoted\\":\\"Thanks for signing up for Sentry!\\\\n\\\\n\\\\nPlease confirm your email (chat@ellixar.com) by clicking the link below:\\\\n\\\\nhttps://sentry.io/account/confirm-email/2282677/Az24kt30J9mIWpsk5LXYo8Nl1iKi4rDQ/\\\\n\\\\nThis link will expire in 48 hours.\\\\n\\\\n\\\\nIf you did not sign up, you may simply ignore this email.\\"},\\"to\\":[\\"chat@ellixar.com\\"]},\\"cc_email\\":null,\\"bcc_email\\":null}"	Contact	8	{}	{}
16	Welcome. \n\nCrashes. Errors. Latency issues. While different (and not good) for your users, it’s all the same to us. From the front end, to the back end, and all the microservices in between, we exist to help you see clearer, solve quicker, and learn continuously about your applications. \n\nOver the next few days, we’ll share best practices so you get the most of your 14-day Business trial. \n\n \t- Fix what’s broken: Once you’ve installed your SDK(s) <https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj7Bk-0vqdcS_PNZLsigZ_RaSAU9t6J-vvXbr6PYZIqcOZRa1PfXbcwkswHLB9FPmatM=>, view the issues page <https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjxX7dBaNYyvXXTaVW62-q1PKbq1-m3WqN7ZjTlGubvwRuRYTOqvab7KZ2HdbaWhCGd8=> to get rich context on errors and pinpoint exactly what to solve. \t- Get ahead of latency issues: We don’t just show you when you’re slow, we show you where and how <https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj5YyyTzkkkmmLAr_C_EVvobsDN_KhhH7lKkFQuLMFKMuiu0Y_9kgbLQSH1XYpVPZ4bQ=> to solve it. \t- Invite your friends teammates: One really is the loneliest number - so invite your teammates <https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj0PicWdpPY503Zy3qkXtWWWJjn4_u6ZJbQ6j9gXPff8eCAquwlH_17AXY3uRiND9bJ0=> and create Teams with custom Alerts <https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjwOUmCkdjoGRKHMKE-3oGLSoIwy5n4JI3S-5XOCWOQ-66mqblz3e36Zulb_RpDQgTb4=> to automatically route the problem to the right person at the right time. \t- Integrate into your existing workflow: Get real-time visibility into issues and workflow changes from over 45 tools your team uses every day <https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj4uTekVQBar2qd3FxGYOvaxu0xaxdZFtrRRl_hQ4HZrmtuK7T5F_-14CAtidm_PtLUs=>. Get alerted in Slack, escalate critical performance challenges via PagerDuty, or automatically add them to your Jira projects. \n\n \n\nNeed help? Check out our (very thorough) help center <https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj-Ee4JkMjdfSpM6CBxRJBfBwM8EVrMAg1kBDRV_kQZs7AzStx9pUsh4wl9UK7HoWmWs=> and docs <https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj8PWNz4wZdEeCwUTslgS89z_3T0xTxgYlaRkB1zM_iQlZfHJb0YkqGLcrheeSnVrm3M=> to get how-to guides, learn best practices, and browse many other features. \n\nAll new accounts come with 30 days of email support. Drop us a line at support@sentry.io <https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj_fSML5kEw73sz_2B4GyqS7C1PzBc9ZTo4JbPr9pXk9MWdekk_LKWwanFw6-iqQsMf0=>. Don't forget to unplug and plug it back in first. \n\nGood luck, have fun. \nThe Sentry Team\n \n\n\n \nThese folks get it.\n\nThis email was sent to chat@ellixar.com. If you no longer wish to receive these emails you may unsubscribe here: https://marketing.sentry.io/UnsubscribePage.html?mkt_unsubscribe=1&mkt_tok=Nzc2LU1KTi01MDEAAAGHiOGRj3r4E9xRsp8XP4yAXTp5TmsN9b5M3c_xGWe9VJeLg2n7oO1S3CAHWAcIqDXh3wL5dgV7nB2VMnWR7dbwnMqgda_6whnjLr9Ob6ege14.	2	4	15	0	2022-10-18 07:06:04.559752	2022-10-18 07:06:04.559752	f	0	1122905438.2428638.1666076696977@abmktmail-trigger1h.marketo.org	8	"{\\"email\\":{\\"bcc\\":null,\\"cc\\":null,\\"content_type\\":\\"multipart/alternative; boundary=\\\\\\"----=_Part_2428637_775271953.1666076696977\\\\\\"\\",\\"date\\":\\"2022-10-18T02:04:56-05:00\\",\\"from\\":[\\"support@sentry.io\\"],\\"html_content\\":{\\"full\\":\\"\\u003c!doctype html\\u003e\\\\r\\\\n\\u003chtml lang=\\\\\\"en\\\\\\" style=\\\\\\"\\\\r\\\\n    min-height: 100vh;\\\\r\\\\n    font-family: 'Rubik', Helvetica, Arial, sans-serif;\\\\r\\\\n    font-size: 1rem;\\\\r\\\\n  \\\\\\"\\u003e\\\\r\\\\n\\u003chead\\u003e \\\\r\\\\n\\u003cmeta charset=\\\\\\"UTF-8\\\\\\"\\u003e \\\\r\\\\n\\u003cmeta http-equiv=\\\\\\"X-UA-Compatible\\\\\\" content=\\\\\\"IE=edge\\\\\\"\\u003e \\\\r\\\\n\\u003cmeta name=\\\\\\"viewport\\\\\\" content=\\\\\\"width=device-width, initial-scale=1.0\\\\\\"\\u003e \\\\r\\\\n\\u003ctitle\\u003eDocument\\u003c/title\\u003e   \\\\r\\\\n\\u003cstyle type=\\\\\\"text/css\\\\\\"\\u003e\\\\r\\\\n      a,\\\\r\\\\n      a[href] {\\\\r\\\\n        color: #e1557c;\\\\r\\\\n      }\\\\r\\\\n\\\\r\\\\n      u + #body a {\\\\r\\\\n        color: #e1557c;\\\\r\\\\n        font-size: inherit;\\\\r\\\\n        font-family: inherit;\\\\r\\\\n        font-weight: inherit;\\\\r\\\\n        line-height: inherit;\\\\r\\\\n      }\\\\r\\\\n\\\\r\\\\n      h1,\\\\r\\\\n      h2,\\\\r\\\\n      h3,\\\\r\\\\n      h4,\\\\r\\\\n      h5,\\\\r\\\\n      h6 {\\\\r\\\\n        font-weight: 600;\\\\r\\\\n        margin: 1rem 0;\\\\r\\\\n      }\\\\r\\\\n\\\\r\\\\n      p {\\\\r\\\\n        line-height: 1.5;\\\\r\\\\n        margin: 0 0 1em;\\\\r\\\\n      }\\\\r\\\\n\\\\r\\\\n      img {\\\\r\\\\n        margin: 0 0 1rem;\\\\r\\\\n        width: 100%;\\\\r\\\\n      }\\\\r\\\\n    \\u003c/style\\u003e \\\\r\\\\n\\u003c/head\\u003e \\\\r\\\\n\\u003cbody id=\\\\\\"body\\\\\\" style=\\\\\\"\\\\r\\\\n      background-color: #f0eef3;\\\\r\\\\n      min-height: 100%;\\\\r\\\\n      margin: 0;\\\\r\\\\n      background-image: url('https://storage.googleapis.com/sentryio-assets/img/email/sentry-subtle-randogeo-pattern-transparent.png');\\\\r\\\\n      padding: 1rem 0.25rem 2rem;\\\\r\\\\n    \\\\\\"\\u003e\\u003cstyle type=\\\\\\"text/css\\\\\\"\\u003ediv#emailPreHeader{ display: none !important; }\\u003c/style\\u003e\\u003cdiv id=\\\\\\"emailPreHeader\\\\\\" style=\\\\\\"mso-hide:all; visibility:hidden; opacity:0; color:transparent; mso-line-height-rule:exactly; line-height:0; font-size:0px; overflow:hidden; border-width:0; display:none !important;\\\\\\"\\u003eInstall an SDK to see issues that actually matter. Get started with your trial today.\\u003c/div\\u003e \\\\r\\\\n\\u003cdiv id=\\\\\\"layout-wrapper-div\\\\\\" style=\\\\\\"margin: 0 auto; max-width: 600px\\\\\\"\\u003e \\\\r\\\\n\\u003cdiv style=\\\\\\"background: #584774; padding: 0.5rem 0; text-align: center\\\\\\"\\u003e \\\\r\\\\n\\u003cimg src=\\\\\\"https://storage.googleapis.com/sentryio-assets/img/email/sentry-wordmark-light-322x96.png\\\\\\" style=\\\\\\"max-height: 3rem; width: auto; margin: 0 auto\\\\\\"\\u003e \\\\r\\\\n\\u003c/div\\u003e \\\\r\\\\n\\u003cdiv id=\\\\\\"content-wrapper-div\\\\\\" style=\\\\\\"background: #fff; font-size: 1rem\\\\\\"\\u003e \\\\r\\\\n\\u003cdiv class=\\\\\\"mktoImg\\\\\\" id=\\\\\\"hero-element-image\\\\\\" mktolockimgsize=\\\\\\"true\\\\\\"\\u003e\\\\r\\\\n\\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj9UDSUcI_MPe9fvYPCkP_ST8JOTAYr51bXlqmPBnaFBrrUVDGDw0SSEtDOi4FH9J4-Q=\\\\\\" target=\\\\\\"_blank\\\\\\"\\\\r\\\\n\\u003e\\u003cimg src=\\\\\\"https://marketing.sentry.io/rs/776-MJN-501/images/Errors1-hero.jpg\\\\\\" alt=\\\\\\"Get the most out of your trial today\\\\\\" style=\\\\\\"\\\\\\"\\u003e\\u003c/a\\u003e\\\\r\\\\n\\u003c/div\\u003e \\\\r\\\\n\\u003ctable style=\\\\\\"width: 100%\\\\\\"\\u003e \\\\r\\\\n\\u003ctbody\\u003e \\\\r\\\\n\\u003ctr\\u003e \\\\r\\\\n\\u003ctd id=\\\\\\"mainContentContainer\\\\\\" class=\\\\\\"mktoContainer\\\\\\" style=\\\\\\"padding: 0.5rem 1.5rem 1rem\\\\\\"\\u003e\\\\r\\\\n\\u003ctable id=\\\\\\"rich-text-block\\\\\\" class=\\\\\\"mktoModule\\\\\\" style=\\\\\\"width: 100%\\\\\\"\\u003e \\\\r\\\\n\\u003ctbody\\u003e \\\\r\\\\n\\u003ctr\\u003e \\\\r\\\\n\\u003ctd\\u003e \\\\r\\\\n\\u003cdiv id=\\\\\\"rich-text-block-body\\\\\\" class=\\\\\\"mktoText\\\\\\" style=\\\\\\"line-height: 1.5\\\\\\"\\u003e\\\\r\\\\n\\u003cp\\u003eWelcome.\\u003c/p\\u003e \\\\r\\\\n\\u003cp\\u003eCrashes. Errors. Latency issues. While different (and not good) for your users, it’s all the same to us. From the front end, to the back end, and all the microservices in between, we exist to help you see clearer, solve quicker, and learn continuously about your applications.\\u003c/p\\u003e \\\\r\\\\n\\u003cp\\u003eOver the next few days, we’ll share best practices so you get the most of your 14-day Business trial.\\u003c/p\\u003e \\\\r\\\\n\\u003cul\\u003e \\\\r\\\\n\\u003cli\\u003e\\u003cstrong\\u003eFix what’s broken:\\u003c/strong\\u003e Once you’ve \\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjx1dEJqFyUtP_4CqRQhHZmm2X9g3tkWkV3mPIWcUzpbt3lvHhgAWj5f6R-oCSdr1Eck=\\\\\\" target=\\\\\\"_blank\\\\\\" id=\\\\\\"\\\\\\"\\\\r\\\\n\\u003einstalled your SDK(s)\\u003c/a\\u003e, view the \\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj4p2PTWV9gp9g-Xnqp6Z9tv287zqR2uvvd5pgct1RisvbYx5_98U32CTbdmZOXvm_1c=\\\\\\" target=\\\\\\"_blank\\\\\\" id=\\\\\\"\\\\\\"\\\\r\\\\n\\u003eissues page\\u003c/a\\u003e to get rich context on errors and pinpoint exactly what to solve.\\u003c/li\\u003e \\\\r\\\\n\\u003cli\\u003e\\u003cstrong\\u003eGet ahead of latency issues:\\u003c/strong\\u003e We don’t just show you when you’re slow, we show you \\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj58uWN1igyhOpemaa-CU9CtghPOSadDn4QWz9OMCRfVoCMjr_6qp7wy52ztjpBEwnSE=\\\\\\" target=\\\\\\"_blank\\\\\\" id=\\\\\\"\\\\\\"\\\\r\\\\n\\u003ewhere and how\\u003c/a\\u003e to solve it.\\u003c/li\\u003e \\\\r\\\\n\\u003cli\\u003e\\u003cstrong\\u003eInvite your \\u003cspan style=\\\\\\"text-decoration: line-through;\\\\\\"\\u003efriends\\u003c/span\\u003e teammates:\\u003c/strong\\u003e One really is the loneliest number - so \\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj4lFVddGkBgRzr_GJCMFHJJ23of-XAcWefoutmXSEyUMkOpyTgdiw4wnaKHigKwpG10=\\\\\\" target=\\\\\\"_blank\\\\\\" id=\\\\\\"\\\\\\"\\\\r\\\\n\\u003einvite your teammates\\u003c/a\\u003e and create Teams with custom \\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj2Eue97qKvdOJt60vmO-1fWtashJED5xk25GqHOqzdYRcvsvtqkp8k5hdw9FncTzbCs=\\\\\\" target=\\\\\\"_blank\\\\\\" id=\\\\\\"\\\\\\"\\\\r\\\\n\\u003eAlerts\\u003c/a\\u003e to automatically route the problem to the right person at the right time.\\u003c/li\\u003e \\\\r\\\\n\\u003cli\\u003e\\u003cstrong\\u003eIntegrate into your existing workflow:\\u003c/strong\\u003e Get real-time visibility into issues and workflow changes from over \\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjz_tey8ks78QMaf1WfrN1mo0gNBVguB8-BPM40teSIwvWoMYymowsc4cwsLh9C_l9ws=\\\\\\" target=\\\\\\"_blank\\\\\\" id=\\\\\\"\\\\\\"\\\\r\\\\n\\u003e45 tools your team uses every day\\u003c/a\\u003e. Get alerted in Slack, escalate critical performance challenges via PagerDuty, or automatically add them to your Jira projects.\\u003c/li\\u003e \\\\r\\\\n\\u003c/ul\\u003e \\\\r\\\\n\\u003cp\\u003eNeed help? Check out our (very thorough) \\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj8t39wKniZypqXbMQqAsFDMpOziXKq93WYl6helq2vUHOTIxBGjbKCvt0p2s151UCok=\\\\\\" target=\\\\\\"_blank\\\\\\" id=\\\\\\"\\\\\\"\\\\r\\\\n\\u003ehelp center\\u003c/a\\u003e and \\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj-GfUo1w5okHfM-uuqdpULCKig2YDAPGbfKsIGHnS1WF9NU-vV5NO8W3Tu7hgpR-XqA=\\\\\\" target=\\\\\\"_blank\\\\\\" id=\\\\\\"\\\\\\"\\\\r\\\\n\\u003edocs\\u003c/a\\u003e to get how-to guides, learn best practices, and browse many other features.\\u003c/p\\u003e \\\\r\\\\n\\u003cp\\u003eAll new accounts come with 30 days of email support. Drop us a line at \\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj_fSML5kEw73sz_2B4GyqS7C1PzBc9ZTo4JbPr9pXk9MWdekk_LKWwanFw6-iqQsMf0=\\\\\\" target=\\\\\\"_blank\\\\\\" id=\\\\\\"\\\\\\"\\\\r\\\\n\\u003esupport@sentry.io\\u003c/a\\u003e. Don't forget to unplug and plug it back in first.\\u003c/p\\u003e \\\\r\\\\n\\u003cp\\u003eGood luck, have fun. \\u003cbr\\u003eThe Sentry Team\\u003cbr\\u003e\\u003c/p\\u003e \\\\r\\\\n\\u003cp\\u003e\\u003cbr\\u003e\\u003c/p\\u003e \\\\r\\\\n\\u003cp style=\\\\\\"text-align: center;\\\\\\"\\u003e\\u003cstrong\\u003e\\u003cem\\u003eThese folks get it.\\u003c/em\\u003e\\u003c/strong\\u003e\\u003c/p\\u003e\\\\r\\\\n\\u003c/div\\u003e \\u003c/td\\u003e \\\\r\\\\n\\u003c/tr\\u003e \\\\r\\\\n\\u003ctr\\u003e \\\\r\\\\n\\u003ctd style=\\\\\\"padding:0;font-size:24px;line-height:28px;font-weight:bold;\\\\\\"\\u003e \\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjtCu6knIx2j_e9EtloK9baUNtrgDZ9s9_ogc-JsiCo7jJGnzg4XGKX7i8XyL2KxW0Bc=\\\\\\" style=\\\\\\"text-decoration:none;\\\\\\"\\\\r\\\\n\\u003e\\u003cimg src=\\\\\\"https://marketing.sentry.io/rs/776-MJN-501/images/customer-logo-banner-round.png\\\\\\" width=\\\\\\"600\\\\\\" alt=\\\\\\"\\\\\\" style=\\\\\\"width:100%;height:auto;display:block;border:none;text-decoration:none;color:#363636;\\\\\\"\\u003e\\u003c/a\\u003e \\u003c/td\\u003e \\\\r\\\\n\\u003c/tr\\u003e \\\\r\\\\n\\u003c/tbody\\u003e \\\\r\\\\n\\u003c/table\\u003e\\u003c/td\\u003e \\\\r\\\\n\\u003c/tr\\u003e \\\\r\\\\n\\u003c/tbody\\u003e \\\\r\\\\n\\u003c/table\\u003e \\\\r\\\\n\\u003c/div\\u003e \\\\r\\\\n\\u003c/div\\u003e  \\\\r\\\\n\\u003ca href=\\\\r\\\\n\\\\\\"https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj7jIKgZ2x1YRHkVs18_CwXThAcfYi3RgGwqFXuBvaYiuPx1ozZXlTwIT1y60LY_VAEA=\\\\\\"\\\\r\\\\n\\u003e\\u003c/a\\u003e\\\\r\\\\n\\u003cimg src=\\\\\\"https://go.sentry.io/trk?t=1\\u0026mid=Nzc2LU1KTi01MDE6MDozMTE4OjEwNjE3OjA6MjcxNzo5OjExMTY1OjE0NjA1OTE3LTE6bnVsbA%3D%3D\\\\\\" width=\\\\\\"1\\\\\\" height=\\\\\\"1\\\\\\" style=\\\\\\"display:none !important;\\\\\\" alt=\\\\\\"\\\\\\" /\\u003e\\\\r\\\\n\\\\r\\\\n\\u003cdiv style=\\\\\\"text-align: center; max-width: 600px; min-height: 4rem; margin: 1rem auto 0;\\\\\\"\\u003e\\u003cfont face=\\\\\\"Verdana\\\\\\" size=\\\\\\"2\\\\\\"\\u003e\\\\r\\\\n\\u003cp style=\\\\\\"font-size: 0.8125rem;\\\\\\"\\u003eThis email was sent to \\u003ca style=\\\\\\"color: #e1557c;\\\\\\" href=\\\\r\\\\n\\\\\\"mailto:chat@ellixar.com\\\\\\" target=\\\\\\"_blank\\\\\\" class=\\\\\\"mktNoTrack\\\\\\"\\\\r\\\\n\\u003echat@ellixar.com\\u003c/a\\u003e. If you no longer wish to receive these emails you may \\u003ca style=\\\\\\"color: #e1557c;\\\\\\" href=\\\\r\\\\n\\\\\\"https://go.sentry.io/u/Nzc2LU1KTi01MDEAAAGHiOGRjhBSQTU4PXUiypdivLGiOj_tFwa01nmDBevJSik4dCprSNDLLQzT_H5uwdPxz3Snpoc=\\\\\\"\\\\r\\\\n\\u003eunsubscribe\\u003c/a\\u003e at any time.\\u003c/p\\u003e\\u003c/font\\u003e\\u003c/div\\u003e\\\\r\\\\n\\u003c/body\\u003e\\\\r\\\\n\\u003c/html\\u003e\\",\\"reply\\":\\"Install an SDK to see issues that actually matter. Get started with your trial today.\\\\n\\\\n[Get the most out of your trial today](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj9UDSUcI_MPe9fvYPCkP_ST8JOTAYr51bXlqmPBnaFBrrUVDGDw0SSEtDOi4FH9J4-Q=)\\\\n\\\\nWelcome.\\\\n\\\\nCrashes. Errors. Latency issues. While different (and not good) for your users, it’s all the same to us. From the front end, to the back end, and all the microservices in between, we exist to help you see clearer, solve quicker, and learn continuously about your applications.\\\\n\\\\nOver the next few days, we’ll share best practices so you get the most of your 14-day Business trial.\\\\n\\\\n-  Fix what’s broken: Once you’ve [installed your SDK(s)](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjx1dEJqFyUtP_4CqRQhHZmm2X9g3tkWkV3mPIWcUzpbt3lvHhgAWj5f6R-oCSdr1Eck=), view the [issues page](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj4p2PTWV9gp9g-Xnqp6Z9tv287zqR2uvvd5pgct1RisvbYx5_98U32CTbdmZOXvm_1c=) to get rich context on errors and pinpoint exactly what to solve.\\\\n-  Get ahead of latency issues: We don’t just show you when you’re slow, we show you [where and how](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj58uWN1igyhOpemaa-CU9CtghPOSadDn4QWz9OMCRfVoCMjr_6qp7wy52ztjpBEwnSE=) to solve it.\\\\n-  Invite your friends teammates: One really is the loneliest number - so [invite your teammates](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj4lFVddGkBgRzr_GJCMFHJJ23of-XAcWefoutmXSEyUMkOpyTgdiw4wnaKHigKwpG10=) and create Teams with custom [Alerts](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj2Eue97qKvdOJt60vmO-1fWtashJED5xk25GqHOqzdYRcvsvtqkp8k5hdw9FncTzbCs=) to automatically route the problem to the right person at the right time.\\\\n-  Integrate into your existing workflow: Get real-time visibility into issues and workflow changes from over [45 tools your team uses every day](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjz_tey8ks78QMaf1WfrN1mo0gNBVguB8-BPM40teSIwvWoMYymowsc4cwsLh9C_l9ws=). Get alerted in Slack, escalate critical performance challenges via PagerDuty, or automatically add them to your Jira projects.\\\\n\\\\nNeed help? Check out our (very thorough) [help center](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj8t39wKniZypqXbMQqAsFDMpOziXKq93WYl6helq2vUHOTIxBGjbKCvt0p2s151UCok=) and [docs](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj-GfUo1w5okHfM-uuqdpULCKig2YDAPGbfKsIGHnS1WF9NU-vV5NO8W3Tu7hgpR-XqA=) to get how-to guides, learn best practices, and browse many other features.\\\\n\\\\nAll new accounts come with 30 days of email support. Drop us a line at [support@sentry.io](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj_fSML5kEw73sz_2B4GyqS7C1PzBc9ZTo4JbPr9pXk9MWdekk_LKWwanFw6-iqQsMf0=). Don't forget to unplug and plug it back in first.\\\\n\\\\nGood luck, have fun.\\\\nThe Sentry Team\\\\n\\\\nThese folks get it.\\\\n\\\\nhttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjtCu6knIx2j_e9EtloK9baUNtrgDZ9s9_ogc-JsiCo7jJGnzg4XGKX7i8XyL2KxW0Bc=\\\\nhttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj7jIKgZ2x1YRHkVs18_CwXThAcfYi3RgGwqFXuBvaYiuPx1ozZXlTwIT1y60LY_VAEA= []\\\\n\\\\nThis email was sent to chat@ellixar.com. If you no longer wish to receive these emails you may [unsubscribe](https://go.sentry.io/u/Nzc2LU1KTi01MDEAAAGHiOGRjhBSQTU4PXUiypdivLGiOj_tFwa01nmDBevJSik4dCprSNDLLQzT_H5uwdPxz3Snpoc=) at any time.\\",\\"quoted\\":\\"Install an SDK to see issues that actually matter. Get started with your trial today.\\\\n\\\\n[Get the most out of your trial today](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj9UDSUcI_MPe9fvYPCkP_ST8JOTAYr51bXlqmPBnaFBrrUVDGDw0SSEtDOi4FH9J4-Q=)\\\\n\\\\nWelcome.\\\\n\\\\nCrashes. Errors. Latency issues. While different (and not good) for your users, it’s all the same to us. From the front end, to the back end, and all the microservices in between, we exist to help you see clearer, solve quicker, and learn continuously about your applications.\\\\n\\\\nOver the next few days, we’ll share best practices so you get the most of your 14-day Business trial.\\\\n\\\\n-  Fix what’s broken: Once you’ve [installed your SDK(s)](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjx1dEJqFyUtP_4CqRQhHZmm2X9g3tkWkV3mPIWcUzpbt3lvHhgAWj5f6R-oCSdr1Eck=), view the [issues page](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj4p2PTWV9gp9g-Xnqp6Z9tv287zqR2uvvd5pgct1RisvbYx5_98U32CTbdmZOXvm_1c=) to get rich context on errors and pinpoint exactly what to solve.\\\\n-  Get ahead of latency issues: We don’t just show you when you’re slow, we show you [where and how](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj58uWN1igyhOpemaa-CU9CtghPOSadDn4QWz9OMCRfVoCMjr_6qp7wy52ztjpBEwnSE=) to solve it.\\\\n-  Invite your friends teammates: One really is the loneliest number - so [invite your teammates](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj4lFVddGkBgRzr_GJCMFHJJ23of-XAcWefoutmXSEyUMkOpyTgdiw4wnaKHigKwpG10=) and create Teams with custom [Alerts](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj2Eue97qKvdOJt60vmO-1fWtashJED5xk25GqHOqzdYRcvsvtqkp8k5hdw9FncTzbCs=) to automatically route the problem to the right person at the right time.\\\\n-  Integrate into your existing workflow: Get real-time visibility into issues and workflow changes from over [45 tools your team uses every day](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjz_tey8ks78QMaf1WfrN1mo0gNBVguB8-BPM40teSIwvWoMYymowsc4cwsLh9C_l9ws=). Get alerted in Slack, escalate critical performance challenges via PagerDuty, or automatically add them to your Jira projects.\\\\n\\\\nNeed help? Check out our (very thorough) [help center](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj8t39wKniZypqXbMQqAsFDMpOziXKq93WYl6helq2vUHOTIxBGjbKCvt0p2s151UCok=) and [docs](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj-GfUo1w5okHfM-uuqdpULCKig2YDAPGbfKsIGHnS1WF9NU-vV5NO8W3Tu7hgpR-XqA=) to get how-to guides, learn best practices, and browse many other features.\\\\n\\\\nAll new accounts come with 30 days of email support. Drop us a line at [support@sentry.io](https://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj_fSML5kEw73sz_2B4GyqS7C1PzBc9ZTo4JbPr9pXk9MWdekk_LKWwanFw6-iqQsMf0=). Don't forget to unplug and plug it back in first.\\\\n\\\\nGood luck, have fun.\\\\nThe Sentry Team\\\\n\\\\nThese folks get it.\\\\n\\\\nhttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjtCu6knIx2j_e9EtloK9baUNtrgDZ9s9_ogc-JsiCo7jJGnzg4XGKX7i8XyL2KxW0Bc=\\\\nhttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj7jIKgZ2x1YRHkVs18_CwXThAcfYi3RgGwqFXuBvaYiuPx1ozZXlTwIT1y60LY_VAEA= []\\\\n\\\\nThis email was sent to chat@ellixar.com. If you no longer wish to receive these emails you may [unsubscribe](https://go.sentry.io/u/Nzc2LU1KTi01MDEAAAGHiOGRjhBSQTU4PXUiypdivLGiOj_tFwa01nmDBevJSik4dCprSNDLLQzT_H5uwdPxz3Snpoc=) at any time.\\"},\\"in_reply_to\\":null,\\"message_id\\":\\"1122905438.2428638.1666076696977@abmktmail-trigger1h.marketo.org\\",\\"multipart\\":true,\\"number_of_attachments\\":0,\\"subject\\":\\"Welcome to Sentry - get the most out of your 14 day trial\\",\\"text_content\\":{\\"full\\":\\"Welcome. \\\\r\\\\n\\\\r\\\\nCrashes. Errors. Latency issues. While different (and not good) for your users, it’s all the same to us. From the front end, to the back end, and all the microservices in between, we exist to help you see clearer, solve quicker, and learn continuously about your applications. \\\\r\\\\n\\\\r\\\\nOver the next few days, we’ll share best practices so you get the most of your 14-day Business trial. \\\\r\\\\n\\\\r\\\\n \\\\t- Fix what’s broken: Once you’ve installed your SDK(s) \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj7Bk-0vqdcS_PNZLsigZ_RaSAU9t6J-vvXbr6PYZIqcOZRa1PfXbcwkswHLB9FPmatM=\\u003e, view the issues page \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjxX7dBaNYyvXXTaVW62-q1PKbq1-m3WqN7ZjTlGubvwRuRYTOqvab7KZ2HdbaWhCGd8=\\u003e to get rich context on errors and pinpoint exactly what to solve. \\\\t- Get ahead of latency issues: We don’t just show you when you’re slow, we show you where and how \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj5YyyTzkkkmmLAr_C_EVvobsDN_KhhH7lKkFQuLMFKMuiu0Y_9kgbLQSH1XYpVPZ4bQ=\\u003e to solve it. \\\\t- Invite your friends teammates: One really is the loneliest number - so invite your teammates \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj0PicWdpPY503Zy3qkXtWWWJjn4_u6ZJbQ6j9gXPff8eCAquwlH_17AXY3uRiND9bJ0=\\u003e and create Teams with custom Alerts \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjwOUmCkdjoGRKHMKE-3oGLSoIwy5n4JI3S-5XOCWOQ-66mqblz3e36Zulb_RpDQgTb4=\\u003e to automatically route the problem to the right person at the right time. \\\\t- Integrate into your existing workflow: Get real-time visibility into issues and workflow changes from over 45 tools your team uses every day \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj4uTekVQBar2qd3FxGYOvaxu0xaxdZFtrRRl_hQ4HZrmtuK7T5F_-14CAtidm_PtLUs=\\u003e. Get alerted in Slack, escalate critical performance challenges via PagerDuty, or automatically add them to your Jira projects. \\\\r\\\\n\\\\r\\\\n \\\\r\\\\n\\\\r\\\\nNeed help? Check out our (very thorough) help center \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj-Ee4JkMjdfSpM6CBxRJBfBwM8EVrMAg1kBDRV_kQZs7AzStx9pUsh4wl9UK7HoWmWs=\\u003e and docs \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj8PWNz4wZdEeCwUTslgS89z_3T0xTxgYlaRkB1zM_iQlZfHJb0YkqGLcrheeSnVrm3M=\\u003e to get how-to guides, learn best practices, and browse many other features. \\\\r\\\\n\\\\r\\\\nAll new accounts come with 30 days of email support. Drop us a line at support@sentry.io \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj_fSML5kEw73sz_2B4GyqS7C1PzBc9ZTo4JbPr9pXk9MWdekk_LKWwanFw6-iqQsMf0=\\u003e. Don't forget to unplug and plug it back in first. \\\\r\\\\n\\\\r\\\\nGood luck, have fun. \\\\r\\\\nThe Sentry Team\\\\r\\\\n \\\\r\\\\n\\\\r\\\\n\\\\r\\\\n \\\\r\\\\nThese folks get it.\\\\r\\\\n\\\\r\\\\nThis email was sent to chat@ellixar.com. If you no longer wish to receive these emails you may unsubscribe here: https://marketing.sentry.io/UnsubscribePage.html?mkt_unsubscribe=1\\u0026mkt_tok=Nzc2LU1KTi01MDEAAAGHiOGRj3r4E9xRsp8XP4yAXTp5TmsN9b5M3c_xGWe9VJeLg2n7oO1S3CAHWAcIqDXh3wL5dgV7nB2VMnWR7dbwnMqgda_6whnjLr9Ob6ege14.\\\\r\\\\n\\",\\"reply\\":\\"Welcome. \\\\n\\\\nCrashes. Errors. Latency issues. While different (and not good) for your users, it’s all the same to us. From the front end, to the back end, and all the microservices in between, we exist to help you see clearer, solve quicker, and learn continuously about your applications. \\\\n\\\\nOver the next few days, we’ll share best practices so you get the most of your 14-day Business trial. \\\\n\\\\n \\\\t- Fix what’s broken: Once you’ve installed your SDK(s) \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj7Bk-0vqdcS_PNZLsigZ_RaSAU9t6J-vvXbr6PYZIqcOZRa1PfXbcwkswHLB9FPmatM=\\u003e, view the issues page \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjxX7dBaNYyvXXTaVW62-q1PKbq1-m3WqN7ZjTlGubvwRuRYTOqvab7KZ2HdbaWhCGd8=\\u003e to get rich context on errors and pinpoint exactly what to solve. \\\\t- Get ahead of latency issues: We don’t just show you when you’re slow, we show you where and how \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj5YyyTzkkkmmLAr_C_EVvobsDN_KhhH7lKkFQuLMFKMuiu0Y_9kgbLQSH1XYpVPZ4bQ=\\u003e to solve it. \\\\t- Invite your friends teammates: One really is the loneliest number - so invite your teammates \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj0PicWdpPY503Zy3qkXtWWWJjn4_u6ZJbQ6j9gXPff8eCAquwlH_17AXY3uRiND9bJ0=\\u003e and create Teams with custom Alerts \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjwOUmCkdjoGRKHMKE-3oGLSoIwy5n4JI3S-5XOCWOQ-66mqblz3e36Zulb_RpDQgTb4=\\u003e to automatically route the problem to the right person at the right time. \\\\t- Integrate into your existing workflow: Get real-time visibility into issues and workflow changes from over 45 tools your team uses every day \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj4uTekVQBar2qd3FxGYOvaxu0xaxdZFtrRRl_hQ4HZrmtuK7T5F_-14CAtidm_PtLUs=\\u003e. Get alerted in Slack, escalate critical performance challenges via PagerDuty, or automatically add them to your Jira projects. \\\\n\\\\n \\\\n\\\\nNeed help? Check out our (very thorough) help center \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj-Ee4JkMjdfSpM6CBxRJBfBwM8EVrMAg1kBDRV_kQZs7AzStx9pUsh4wl9UK7HoWmWs=\\u003e and docs \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj8PWNz4wZdEeCwUTslgS89z_3T0xTxgYlaRkB1zM_iQlZfHJb0YkqGLcrheeSnVrm3M=\\u003e to get how-to guides, learn best practices, and browse many other features. \\\\n\\\\nAll new accounts come with 30 days of email support. Drop us a line at support@sentry.io \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj_fSML5kEw73sz_2B4GyqS7C1PzBc9ZTo4JbPr9pXk9MWdekk_LKWwanFw6-iqQsMf0=\\u003e. Don't forget to unplug and plug it back in first. \\\\n\\\\nGood luck, have fun. \\\\nThe Sentry Team\\\\n \\\\n\\\\n\\\\n \\\\nThese folks get it.\\\\n\\\\nThis email was sent to chat@ellixar.com. If you no longer wish to receive these emails you may unsubscribe here: https://marketing.sentry.io/UnsubscribePage.html?mkt_unsubscribe=1\\u0026mkt_tok=Nzc2LU1KTi01MDEAAAGHiOGRj3r4E9xRsp8XP4yAXTp5TmsN9b5M3c_xGWe9VJeLg2n7oO1S3CAHWAcIqDXh3wL5dgV7nB2VMnWR7dbwnMqgda_6whnjLr9Ob6ege14.\\",\\"quoted\\":\\"Welcome. \\\\n\\\\nCrashes. Errors. Latency issues. While different (and not good) for your users, it’s all the same to us. From the front end, to the back end, and all the microservices in between, we exist to help you see clearer, solve quicker, and learn continuously about your applications. \\\\n\\\\nOver the next few days, we’ll share best practices so you get the most of your 14-day Business trial. \\\\n\\\\n \\\\t- Fix what’s broken: Once you’ve installed your SDK(s) \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj7Bk-0vqdcS_PNZLsigZ_RaSAU9t6J-vvXbr6PYZIqcOZRa1PfXbcwkswHLB9FPmatM=\\u003e, view the issues page \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjxX7dBaNYyvXXTaVW62-q1PKbq1-m3WqN7ZjTlGubvwRuRYTOqvab7KZ2HdbaWhCGd8=\\u003e to get rich context on errors and pinpoint exactly what to solve. \\\\t- Get ahead of latency issues: We don’t just show you when you’re slow, we show you where and how \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj5YyyTzkkkmmLAr_C_EVvobsDN_KhhH7lKkFQuLMFKMuiu0Y_9kgbLQSH1XYpVPZ4bQ=\\u003e to solve it. \\\\t- Invite your friends teammates: One really is the loneliest number - so invite your teammates \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj0PicWdpPY503Zy3qkXtWWWJjn4_u6ZJbQ6j9gXPff8eCAquwlH_17AXY3uRiND9bJ0=\\u003e and create Teams with custom Alerts \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRjwOUmCkdjoGRKHMKE-3oGLSoIwy5n4JI3S-5XOCWOQ-66mqblz3e36Zulb_RpDQgTb4=\\u003e to automatically route the problem to the right person at the right time. \\\\t- Integrate into your existing workflow: Get real-time visibility into issues and workflow changes from over 45 tools your team uses every day \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj4uTekVQBar2qd3FxGYOvaxu0xaxdZFtrRRl_hQ4HZrmtuK7T5F_-14CAtidm_PtLUs=\\u003e. Get alerted in Slack, escalate critical performance challenges via PagerDuty, or automatically add them to your Jira projects. \\\\n\\\\n \\\\n\\\\nNeed help? Check out our (very thorough) help center \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj-Ee4JkMjdfSpM6CBxRJBfBwM8EVrMAg1kBDRV_kQZs7AzStx9pUsh4wl9UK7HoWmWs=\\u003e and docs \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj8PWNz4wZdEeCwUTslgS89z_3T0xTxgYlaRkB1zM_iQlZfHJb0YkqGLcrheeSnVrm3M=\\u003e to get how-to guides, learn best practices, and browse many other features. \\\\n\\\\nAll new accounts come with 30 days of email support. Drop us a line at support@sentry.io \\u003chttps://go.sentry.io/Nzc2LU1KTi01MDEAAAGHiOGRj_fSML5kEw73sz_2B4GyqS7C1PzBc9ZTo4JbPr9pXk9MWdekk_LKWwanFw6-iqQsMf0=\\u003e. Don't forget to unplug and plug it back in first. \\\\n\\\\nGood luck, have fun. \\\\nThe Sentry Team\\\\n \\\\n\\\\n\\\\n \\\\nThese folks get it.\\\\n\\\\nThis email was sent to chat@ellixar.com. If you no longer wish to receive these emails you may unsubscribe here: https://marketing.sentry.io/UnsubscribePage.html?mkt_unsubscribe=1\\u0026mkt_tok=Nzc2LU1KTi01MDEAAAGHiOGRj3r4E9xRsp8XP4yAXTp5TmsN9b5M3c_xGWe9VJeLg2n7oO1S3CAHWAcIqDXh3wL5dgV7nB2VMnWR7dbwnMqgda_6whnjLr9Ob6ege14.\\"},\\"to\\":[\\"chat@ellixar.com\\"]},\\"cc_email\\":null,\\"bcc_email\\":null}"	Contact	9	{}	{}
\.


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.notes (id, content, account_id, contact_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notification_settings; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.notification_settings (id, account_id, user_id, email_flags, created_at, updated_at, push_flags) FROM stdin;
1	2	2	2	2022-10-17 09:38:14.990179	2022-10-17 09:38:14.990179	2
7	2	4	2	2022-10-17 14:01:30.744167	2022-10-17 14:01:30.744167	2
8	2	3	2	2022-10-17 14:11:48.224128	2022-10-17 14:11:48.224128	2
10	2	5	2	2022-10-17 14:44:01.747893	2022-10-17 14:44:01.747893	2
11	2	6	2	2022-10-17 14:50:15.892821	2022-10-17 14:50:15.892821	2
\.


--
-- Data for Name: notification_subscriptions; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.notification_subscriptions (id, user_id, subscription_type, subscription_attributes, created_at, updated_at, identifier) FROM stdin;
3	2	2	{"apiLevel": 28, "brandName": "samsung", "device_id": "35ca995b61e35bc4", "deviceName": "samsung SM-N960U", "push_token": "e30khWjUQPegmvcERTMUBU:APA91bFOEONq1C6XIXo02gYN2vsaGiw2itWvpk3TngVkua0zTV4zcrRF0NSK8yteUD3qsNjJwSx1QsCceCmd91DSpUMOkRSgzWzBdHhV0zXO2xlPMX6W94btpowemkEWAyts45CiNXtF", "buildNumber": "5048003", "devicePlatform": "Android"}	2022-10-19 11:12:03.328311	2022-10-19 11:12:03.328311	35ca995b61e35bc4
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.notifications (id, account_id, user_id, notification_type, primary_actor_type, primary_actor_id, secondary_actor_type, secondary_actor_id, read_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: platform_app_permissibles; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.platform_app_permissibles (id, platform_app_id, permissible_type, permissible_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: platform_apps; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.platform_apps (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: portal_members; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.portal_members (id, portal_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: portals; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.portals (id, account_id, name, slug, custom_domain, color, homepage_link, page_title, header_text, created_at, updated_at, config, archived) FROM stdin;
\.


--
-- Data for Name: portals_members; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.portals_members (portal_id, user_id) FROM stdin;
\.


--
-- Data for Name: related_categories; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.related_categories (id, category_id, related_category_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: reporting_events; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.reporting_events (id, name, value, account_id, inbox_id, user_id, conversation_id, created_at, updated_at, value_in_business_hours, event_start_time, event_end_time) FROM stdin;
1	first_response	136	2	4	4	11	2022-10-18 05:42:19.743402	2022-10-18 05:42:19.743402	0	2022-10-18 05:40:03.997899	2022-10-18 05:42:19.652714
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.schema_migrations (version) FROM stdin;
20221017201914
20200225162150
20200309170810
20200309213132
20200310062527
20200310070540
20200311083854
20200325210612
20200330071706
20200330115622
20200331095710
20200404092329
20200404135009
20200410145519
20200411125638
20200417093432
20200418124534
20200422130153
20200429082655
20200430163438
20200503151130
20200504144712
20200509044639
20200510112339
20200510154151
20200520125815
20200522115645
20200605130625
20200606132552
20200607140737
20200610143132
20200625124400
20200625154254
20200627115105
20200629122646
20200704135408
20200704135810
20200704140029
20200704140509
20200704173104
20200709145000
20200715124113
20200719171437
20200725131651
20200730080242
20200802170002
20200819190629
20200828175931
20200907094912
20200907171106
20200927135222
20201003105618
20201011152227
20201019173944
20201027135006
20201123195011
20201124101124
20201125121240
20201125123131
20210105185632
20210109211805
20210112174124
20210113045116
20210114202310
20210126121313
20210201150037
20210212154240
20210217154129
20210219085719
20210222131048
20210222131155
20210303192243
20210306170117
20210315101919
20210425093724
20210426191914
20210428135041
20210428151147
20210430095748
20210430100138
20210513083044
20210513143021
20210520200729
20210527173755
20210602182058
20210609133433
20210611180221
20210611180222
20210618073042
20210618095823
20210623150613
20210623155413
20210707142801
20210708140842
20210714110714
20210721182458
20210722095814
20210723094412
20210723095657
20210824152852
20210827120929
20210828124043
20210829124254
20210902181438
20210916060144
20210916112533
20210922082754
20210923132659
20210923190418
20210927062350
20211012135050
20211027073553
20211109143122
20211110101046
20211116131740
20211118100301
20211122061012
20211122112607
20211129120040
20211201224513
20211207113102
20211208081344
20211208085931
20211216110209
20211219031453
20211221125545
20220110090126
20220111200105
20220111223630
20220116103902
20220119051739
20220121055444
20220129024443
20220131081750
20220207124741
20220215060751
20220216151613
20220218120357
20220315204137
20220316054933
20220317171031
20220329131401
20220405092033
20220409044943
20220416203340
20220416205519
20220418094715
20220424081117
20220428101325
20220506061540
20220506064938
20220506072007
20220506080338
20220506080429
20220506163839
20220511072655
20220513145010
20220525141844
20220527040433
20220527080906
20220527120826
20220608084622
20220610091206
20220616154502
20220622090344
20220623113405
20220623113604
20220627135753
20220628124837
20220706085458
20220711090528
20220712145440
20220718123938
20220720080126
20220720123615
20220802133722
20220802193353
20220809104508
20220919225556
20220920014549
20220926164441
20220930025317
20221010212946
\.


--
-- Data for Name: taggings; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.taggings (id, tag_id, taggable_type, taggable_id, tagger_type, tagger_id, context, created_at) FROM stdin;
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.tags (id, name, taggings_count) FROM stdin;
\.


--
-- Data for Name: team_members; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.team_members (id, team_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.teams (id, name, description, allow_auto_assign, account_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: telegram_bots; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.telegram_bots (id, name, auth_key, account_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.users (id, provider, uid, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, name, display_name, email, tokens, created_at, updated_at, pubsub_token, availability, ui_settings, custom_attributes, type, message_signature) FROM stdin;
5	email	ian@ellixar.com	$2a$11$Pv9PmrB5jFEXzcG/QYQt2ulzZo/KvmU4qo8bVnpfU8iPtTpe37kd.	\N	\N	\N	0	\N	\N	\N	\N	rY82BsCyzssKyx9RQ3x5	2022-10-17 14:42:09.257084	2022-10-17 14:44:01.733325	\N	Ian	\N	ian@ellixar.com	\N	2022-10-17 14:41:32.050513	2022-10-19 17:55:48.002727	zwsyHApYYC1gSfLeuwErRhG8	0	{}	{}	\N	\N
3	email	eric@ellixar.com	$2a$11$EVzeL4nxU3ye0dkjx.N79u8/RCECmFppcTLIweOXmdywpvvKFJ9Ha	\N	\N	\N	0	\N	\N	\N	\N	\N	2022-10-17 14:13:51.827468	2022-10-17 09:48:11.013365	\N	Erick Chumama	\N	eric@ellixar.com	\N	2022-10-17 09:48:11.013189	2022-10-17 15:37:44.595247	GpeqrWcDXughQz3GSrifB5yw	0	{}	{}	\N	\N
4	email	chumamaeric@gmail.com	$2a$11$F0Ux8DGWrtFKJgUIlLKkLOOe4GxoQrYLet7dMvXjjkycfIkfCSsmK	\N	\N	\N	3	2022-10-19 18:06:34.006989	2022-10-17 15:38:04.639483	196.207.177.114	196.216.92.153	\N	2022-10-17 14:04:15.392797	2022-10-17 13:29:06.387788	\N	Eric	\N	chumamaeric@gmail.com	"{\\"2wOIK-nrnj9jXB3ctgCGIg\\":{\\"token\\":\\"$2a$10$9uJKnal/o50jCPosdLJ1SOvmDou22/6N.VTgDMFhCkWzpmbiKWvdi\\",\\"expiry\\":1671285897,\\"updated_at\\":\\"2022-10-17T14:04:57Z\\"},\\"RyegbdELLN7rpHVnqTgdKw\\":{\\"token\\":\\"$2a$10$d1ALyLZxxQcFT9eACz0RXe6be5fVfkLht/vW3UvPs57omoeVufe2y\\",\\"expiry\\":1671286931},\\"yxjImtDyOQNF9yZ3TgFlmQ\\":{\\"token\\":\\"$2a$10$Amw6ONX5GdjDjA7tDrPA3OloouM1KpHJaHX39beyuzatu2Dh8P34q\\",\\"expiry\\":1671473194}}"	2022-10-17 13:29:06.387005	2022-10-19 18:06:34.007226	Hd2SmhUC3FoSNfvzyXQoyF6f	0	{}	{}	\N	\N
6	email	kanini@ellixar.com	$2a$11$0S.edZyg61rUuAfO0lGkyudiPMTxP4Ae/SIuZzr397SqXZA6OjcIO	d7dddfeb37e58d3c850a7062376644806adaa65d40cd2701c25525322b23e1c7	2022-10-17 14:50:15.973375	\N	0	\N	\N	\N	\N	e-qcAqG5jJnAysu8snM9	\N	2022-10-17 14:50:15.87686	\N	Kanini	\N	kanini@ellixar.com	\N	2022-10-17 14:50:15.876569	2022-10-17 14:50:15.975708	QYSFSsJfAR7sNHrp2V8PYYTx	0	{}	{}	\N	\N
2	email	ellixar.host@gmail.com	$2a$11$xLbb45wMmHJbo9oj8gQvxegpquEgVoER6CoGy67ReT9aKYBQTYLbO	\N	\N	\N	15	2022-10-19 17:56:25.675291	2022-10-19 17:30:24.768523	196.216.93.151	196.216.93.151	\N	2022-10-17 09:38:14.943253	\N	\N	Munyingi Ian	\N	ellixar.host@gmail.com	"{\\"Nwg9A3uta4974ibFk8VWNA\\":{\\"token\\":\\"$2a$10$qqCBa9THN1KKoTWCw21eY.yHOk8curBiw5wgHOBAsaQyjvGq.C2vG\\",\\"expiry\\":1671465878},\\"GQFP4HhdplP40mjM7UncoQ\\":{\\"token\\":\\"$2a$10$DoJkxBa3QQG7TSEr9JYUeu3cZJUZ0c7kh6hf3bsId0aMtg22TIq4O\\",\\"expiry\\":1671466884},\\"OZQJAAWGMsVur4fOgizmyA\\":{\\"token\\":\\"$2a$10$hZ9pRKIMejsdFzjzS4GBBuooX04yCzgM4wFMi5AUTrenxyKeBdetK\\",\\"expiry\\":1671466889},\\"CIqs-mDFq7zJ4QJC-HVrEg\\":{\\"token\\":\\"$2a$10$pse0BOlL8L8Bjwt8nABnl.XAXm9P7q0X7CXxN/S.WxedguWinlt7u\\",\\"expiry\\":1671466944},\\"RLbe57aFMBBIFIkcmBZXXg\\":{\\"token\\":\\"$2a$10$D4O5E5vXLx9trpE8LxnxOeS5BWOlKzENPpyxCFaOJIYTK2d2.gLXm\\",\\"expiry\\":1671469558},\\"79a4CuT-Qp-2JPAynHobuw\\":{\\"token\\":\\"$2a$10$gCm/.iuS3Mc3NAPfuXqKHuB5BxjDGZgxx/zos9jJdeL5LQMYU7Iay\\",\\"expiry\\":1671469679},\\"x63BRAjbnXWPtWkw32vHLA\\":{\\"token\\":\\"$2a$10$mseJVtR6XFEKwQCigAKNde8mIEL5i6WEaR2kT/tX7tX8k4ifrl4TS\\",\\"expiry\\":1671470194},\\"5mmccrTenr-ojC3sPe1pYQ\\":{\\"token\\":\\"$2a$10$AdrTMBeJ4GiCzpFP0qIdquTNSSiEuM9SxJ.3aYxdDTwxAnX2gQFtC\\",\\"expiry\\":1671470897},\\"j5N241WfY2iRotJT1FOCRQ\\":{\\"token\\":\\"$2a$10$/GOodbwycUU30JjWdidoROfQpLXeR9d9h.dn8.2W6305XFsXdK8xG\\",\\"expiry\\":1671471024},\\"zeIvZAMJO8adIr2Y2LmQkA\\":{\\"token\\":\\"$2a$10$3oGPzzJuJxvb4kbvkv0qoev0STqufVt/l.5s8fLMvGlvRQaY/LYk.\\",\\"expiry\\":1671472585}}"	2022-10-17 09:38:14.943378	2022-10-19 17:56:25.675637	LUeEMsFd3avEB5vu6aAuVe2k	0	{"is_contact_sidebar_open": false}	{}	SuperAdmin	\N
\.


--
-- Data for Name: webhooks; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.webhooks (id, account_id, inbox_id, url, created_at, updated_at, webhook_type, subscriptions) FROM stdin;
\.


--
-- Data for Name: working_hours; Type: TABLE DATA; Schema: public; Owner: chatwoot
--

COPY public.working_hours (id, inbox_id, account_id, day_of_week, closed_all_day, open_hour, open_minutes, close_hour, close_minutes, created_at, updated_at, open_all_day) FROM stdin;
15	3	2	0	t	\N	\N	\N	\N	2022-10-17 16:33:21.718458	2022-10-17 16:33:21.718458	f
16	3	2	1	f	9	0	17	0	2022-10-17 16:33:21.719399	2022-10-17 16:33:21.719399	f
17	3	2	2	f	9	0	17	0	2022-10-17 16:33:21.720192	2022-10-17 16:33:21.720192	f
18	3	2	3	f	9	0	17	0	2022-10-17 16:33:21.721	2022-10-17 16:33:21.721	f
19	3	2	4	f	9	0	17	0	2022-10-17 16:33:21.721915	2022-10-17 16:33:21.721915	f
20	3	2	5	f	9	0	17	0	2022-10-17 16:33:21.722713	2022-10-17 16:33:21.722713	f
21	3	2	6	t	\N	\N	\N	\N	2022-10-17 16:33:21.723446	2022-10-17 16:33:21.723446	f
22	4	2	0	t	\N	\N	\N	\N	2022-10-18 05:30:48.018414	2022-10-18 05:30:48.018414	f
23	4	2	1	f	9	0	17	0	2022-10-18 05:30:48.019443	2022-10-18 05:30:48.019443	f
24	4	2	2	f	9	0	17	0	2022-10-18 05:30:48.0203	2022-10-18 05:30:48.0203	f
25	4	2	3	f	9	0	17	0	2022-10-18 05:30:48.021276	2022-10-18 05:30:48.021276	f
26	4	2	4	f	9	0	17	0	2022-10-18 05:30:48.022115	2022-10-18 05:30:48.022115	f
27	4	2	5	f	9	0	17	0	2022-10-18 05:30:48.022963	2022-10-18 05:30:48.022963	f
28	4	2	6	t	\N	\N	\N	\N	2022-10-18 05:30:48.023745	2022-10-18 05:30:48.023745	f
29	5	2	0	t	\N	\N	\N	\N	2022-10-18 05:51:23.260721	2022-10-18 05:51:23.260721	f
30	5	2	1	f	9	0	17	0	2022-10-18 05:51:23.261761	2022-10-18 05:51:23.261761	f
31	5	2	2	f	9	0	17	0	2022-10-18 05:51:23.262604	2022-10-18 05:51:23.262604	f
32	5	2	3	f	9	0	17	0	2022-10-18 05:51:23.26343	2022-10-18 05:51:23.26343	f
33	5	2	4	f	9	0	17	0	2022-10-18 05:51:23.264257	2022-10-18 05:51:23.264257	f
34	5	2	5	f	9	0	17	0	2022-10-18 05:51:23.265244	2022-10-18 05:51:23.265244	f
35	5	2	6	t	\N	\N	\N	\N	2022-10-18 05:51:23.266012	2022-10-18 05:51:23.266012	f
50	8	2	0	t	\N	\N	\N	\N	2022-10-19 10:51:47.507349	2022-10-19 10:51:47.507349	f
51	8	2	1	f	9	0	17	0	2022-10-19 10:51:47.508994	2022-10-19 10:51:47.508994	f
52	8	2	2	f	9	0	17	0	2022-10-19 10:51:47.510369	2022-10-19 10:51:47.510369	f
53	8	2	3	f	9	0	17	0	2022-10-19 10:51:47.511822	2022-10-19 10:51:47.511822	f
54	8	2	4	f	9	0	17	0	2022-10-19 10:51:47.513181	2022-10-19 10:51:47.513181	f
55	8	2	5	f	9	0	17	0	2022-10-19 10:51:47.514549	2022-10-19 10:51:47.514549	f
56	8	2	6	t	\N	\N	\N	\N	2022-10-19 10:51:47.515655	2022-10-19 10:51:47.515655	f
\.


--
-- Name: access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.access_tokens_id_seq', 6, true);


--
-- Name: account_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.account_users_id_seq', 11, true);


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.accounts_id_seq', 2, true);


--
-- Name: action_mailbox_inbound_emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.action_mailbox_inbound_emails_id_seq', 1, false);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 8, true);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 8, true);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);


--
-- Name: agent_bot_inboxes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.agent_bot_inboxes_id_seq', 1, false);


--
-- Name: agent_bots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.agent_bots_id_seq', 1, false);


--
-- Name: articles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.articles_id_seq', 1, false);


--
-- Name: attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.attachments_id_seq', 8, true);


--
-- Name: automation_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.automation_rules_id_seq', 1, false);


--
-- Name: camp_dpid_seq_2; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.camp_dpid_seq_2', 1, false);


--
-- Name: campaigns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.campaigns_id_seq', 1, false);


--
-- Name: canned_responses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.canned_responses_id_seq', 1, false);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.categories_id_seq', 1, false);


--
-- Name: channel_api_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.channel_api_id_seq', 1, false);


--
-- Name: channel_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.channel_email_id_seq', 4, true);


--
-- Name: channel_facebook_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.channel_facebook_pages_id_seq', 1, false);


--
-- Name: channel_line_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.channel_line_id_seq', 1, false);


--
-- Name: channel_sms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.channel_sms_id_seq', 1, false);


--
-- Name: channel_telegram_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.channel_telegram_id_seq', 1, false);


--
-- Name: channel_twilio_sms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.channel_twilio_sms_id_seq', 1, false);


--
-- Name: channel_twitter_profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.channel_twitter_profiles_id_seq', 1, false);


--
-- Name: channel_web_widgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.channel_web_widgets_id_seq', 1, true);


--
-- Name: channel_whatsapp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.channel_whatsapp_id_seq', 3, true);


--
-- Name: contact_inboxes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.contact_inboxes_id_seq', 11, true);


--
-- Name: contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.contacts_id_seq', 9, true);


--
-- Name: conv_dpid_seq_2; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.conv_dpid_seq_2', 15, true);


--
-- Name: conversations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.conversations_id_seq', 15, true);


--
-- Name: csat_survey_responses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.csat_survey_responses_id_seq', 1, false);


--
-- Name: custom_attribute_definitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.custom_attribute_definitions_id_seq', 1, false);


--
-- Name: custom_filters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.custom_filters_id_seq', 1, false);


--
-- Name: dashboard_apps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.dashboard_apps_id_seq', 1, false);


--
-- Name: data_imports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.data_imports_id_seq', 1, false);


--
-- Name: email_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.email_templates_id_seq', 1, false);


--
-- Name: folders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.folders_id_seq', 1, false);


--
-- Name: inbox_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.inbox_members_id_seq', 30, true);


--
-- Name: inboxes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.inboxes_id_seq', 8, true);


--
-- Name: installation_configs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.installation_configs_id_seq', 32, true);


--
-- Name: integrations_hooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.integrations_hooks_id_seq', 1, false);


--
-- Name: labels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.labels_id_seq', 1, false);


--
-- Name: macros_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.macros_id_seq', 1, false);


--
-- Name: mentions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.mentions_id_seq', 1, false);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.messages_id_seq', 16, true);


--
-- Name: notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.notes_id_seq', 1, false);


--
-- Name: notification_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.notification_settings_id_seq', 11, true);


--
-- Name: notification_subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.notification_subscriptions_id_seq', 3, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Name: platform_app_permissibles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.platform_app_permissibles_id_seq', 1, false);


--
-- Name: platform_apps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.platform_apps_id_seq', 1, false);


--
-- Name: portal_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.portal_members_id_seq', 1, false);


--
-- Name: portals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.portals_id_seq', 1, false);


--
-- Name: related_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.related_categories_id_seq', 1, false);


--
-- Name: reporting_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.reporting_events_id_seq', 1, true);


--
-- Name: taggings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.taggings_id_seq', 1, false);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.tags_id_seq', 1, false);


--
-- Name: team_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.team_members_id_seq', 1, false);


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.teams_id_seq', 1, false);


--
-- Name: telegram_bots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.telegram_bots_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.webhooks_id_seq', 1, false);


--
-- Name: working_hours_id_seq; Type: SEQUENCE SET; Schema: public; Owner: chatwoot
--

SELECT pg_catalog.setval('public.working_hours_id_seq', 56, true);


--
-- Name: access_tokens access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.access_tokens
    ADD CONSTRAINT access_tokens_pkey PRIMARY KEY (id);


--
-- Name: account_users account_users_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.account_users
    ADD CONSTRAINT account_users_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: action_mailbox_inbound_emails action_mailbox_inbound_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.action_mailbox_inbound_emails
    ADD CONSTRAINT action_mailbox_inbound_emails_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: agent_bot_inboxes agent_bot_inboxes_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.agent_bot_inboxes
    ADD CONSTRAINT agent_bot_inboxes_pkey PRIMARY KEY (id);


--
-- Name: agent_bots agent_bots_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.agent_bots
    ADD CONSTRAINT agent_bots_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: automation_rules automation_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.automation_rules
    ADD CONSTRAINT automation_rules_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: canned_responses canned_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.canned_responses
    ADD CONSTRAINT canned_responses_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: channel_api channel_api_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_api
    ADD CONSTRAINT channel_api_pkey PRIMARY KEY (id);


--
-- Name: channel_email channel_email_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_email
    ADD CONSTRAINT channel_email_pkey PRIMARY KEY (id);


--
-- Name: channel_facebook_pages channel_facebook_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_facebook_pages
    ADD CONSTRAINT channel_facebook_pages_pkey PRIMARY KEY (id);


--
-- Name: channel_line channel_line_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_line
    ADD CONSTRAINT channel_line_pkey PRIMARY KEY (id);


--
-- Name: channel_sms channel_sms_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_sms
    ADD CONSTRAINT channel_sms_pkey PRIMARY KEY (id);


--
-- Name: channel_telegram channel_telegram_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_telegram
    ADD CONSTRAINT channel_telegram_pkey PRIMARY KEY (id);


--
-- Name: channel_twilio_sms channel_twilio_sms_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_twilio_sms
    ADD CONSTRAINT channel_twilio_sms_pkey PRIMARY KEY (id);


--
-- Name: channel_twitter_profiles channel_twitter_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_twitter_profiles
    ADD CONSTRAINT channel_twitter_profiles_pkey PRIMARY KEY (id);


--
-- Name: channel_web_widgets channel_web_widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_web_widgets
    ADD CONSTRAINT channel_web_widgets_pkey PRIMARY KEY (id);


--
-- Name: channel_whatsapp channel_whatsapp_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.channel_whatsapp
    ADD CONSTRAINT channel_whatsapp_pkey PRIMARY KEY (id);


--
-- Name: contact_inboxes contact_inboxes_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.contact_inboxes
    ADD CONSTRAINT contact_inboxes_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: csat_survey_responses csat_survey_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.csat_survey_responses
    ADD CONSTRAINT csat_survey_responses_pkey PRIMARY KEY (id);


--
-- Name: custom_attribute_definitions custom_attribute_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.custom_attribute_definitions
    ADD CONSTRAINT custom_attribute_definitions_pkey PRIMARY KEY (id);


--
-- Name: custom_filters custom_filters_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.custom_filters
    ADD CONSTRAINT custom_filters_pkey PRIMARY KEY (id);


--
-- Name: dashboard_apps dashboard_apps_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.dashboard_apps
    ADD CONSTRAINT dashboard_apps_pkey PRIMARY KEY (id);


--
-- Name: data_imports data_imports_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.data_imports
    ADD CONSTRAINT data_imports_pkey PRIMARY KEY (id);


--
-- Name: email_templates email_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.email_templates
    ADD CONSTRAINT email_templates_pkey PRIMARY KEY (id);


--
-- Name: folders folders_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);


--
-- Name: inbox_members inbox_members_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.inbox_members
    ADD CONSTRAINT inbox_members_pkey PRIMARY KEY (id);


--
-- Name: inboxes inboxes_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.inboxes
    ADD CONSTRAINT inboxes_pkey PRIMARY KEY (id);


--
-- Name: installation_configs installation_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.installation_configs
    ADD CONSTRAINT installation_configs_pkey PRIMARY KEY (id);


--
-- Name: integrations_hooks integrations_hooks_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.integrations_hooks
    ADD CONSTRAINT integrations_hooks_pkey PRIMARY KEY (id);


--
-- Name: labels labels_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.labels
    ADD CONSTRAINT labels_pkey PRIMARY KEY (id);


--
-- Name: macros macros_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.macros
    ADD CONSTRAINT macros_pkey PRIMARY KEY (id);


--
-- Name: mentions mentions_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: notification_settings notification_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.notification_settings
    ADD CONSTRAINT notification_settings_pkey PRIMARY KEY (id);


--
-- Name: notification_subscriptions notification_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.notification_subscriptions
    ADD CONSTRAINT notification_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: platform_app_permissibles platform_app_permissibles_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.platform_app_permissibles
    ADD CONSTRAINT platform_app_permissibles_pkey PRIMARY KEY (id);


--
-- Name: platform_apps platform_apps_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.platform_apps
    ADD CONSTRAINT platform_apps_pkey PRIMARY KEY (id);


--
-- Name: portal_members portal_members_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.portal_members
    ADD CONSTRAINT portal_members_pkey PRIMARY KEY (id);


--
-- Name: portals portals_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.portals
    ADD CONSTRAINT portals_pkey PRIMARY KEY (id);


--
-- Name: related_categories related_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.related_categories
    ADD CONSTRAINT related_categories_pkey PRIMARY KEY (id);


--
-- Name: reporting_events reporting_events_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.reporting_events
    ADD CONSTRAINT reporting_events_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: telegram_bots telegram_bots_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.telegram_bots
    ADD CONSTRAINT telegram_bots_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webhooks webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.webhooks
    ADD CONSTRAINT webhooks_pkey PRIMARY KEY (id);


--
-- Name: working_hours working_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.working_hours
    ADD CONSTRAINT working_hours_pkey PRIMARY KEY (id);


--
-- Name: attribute_key_model_index; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX attribute_key_model_index ON public.custom_attribute_definitions USING btree (attribute_key, attribute_model, account_id);


--
-- Name: by_account_user; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX by_account_user ON public.notification_settings USING btree (account_id, user_id);


--
-- Name: index_access_tokens_on_owner_type_and_owner_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_access_tokens_on_owner_type_and_owner_id ON public.access_tokens USING btree (owner_type, owner_id);


--
-- Name: index_access_tokens_on_token; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_access_tokens_on_token ON public.access_tokens USING btree (token);


--
-- Name: index_account_users_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_account_users_on_account_id ON public.account_users USING btree (account_id);


--
-- Name: index_account_users_on_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_account_users_on_user_id ON public.account_users USING btree (user_id);


--
-- Name: index_accounts_on_status; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_accounts_on_status ON public.accounts USING btree (status);


--
-- Name: index_action_mailbox_inbound_emails_uniqueness; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_action_mailbox_inbound_emails_uniqueness ON public.action_mailbox_inbound_emails USING btree (message_id, message_checksum);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_agent_bots_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_agent_bots_on_account_id ON public.agent_bots USING btree (account_id);


--
-- Name: index_articles_on_associated_article_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_articles_on_associated_article_id ON public.articles USING btree (associated_article_id);


--
-- Name: index_articles_on_author_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_articles_on_author_id ON public.articles USING btree (author_id);


--
-- Name: index_articles_on_slug; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_articles_on_slug ON public.articles USING btree (slug);


--
-- Name: index_attachments_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_attachments_on_account_id ON public.attachments USING btree (account_id);


--
-- Name: index_attachments_on_message_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_attachments_on_message_id ON public.attachments USING btree (message_id);


--
-- Name: index_automation_rules_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_automation_rules_on_account_id ON public.automation_rules USING btree (account_id);


--
-- Name: index_campaigns_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_campaigns_on_account_id ON public.campaigns USING btree (account_id);


--
-- Name: index_campaigns_on_campaign_status; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_campaigns_on_campaign_status ON public.campaigns USING btree (campaign_status);


--
-- Name: index_campaigns_on_campaign_type; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_campaigns_on_campaign_type ON public.campaigns USING btree (campaign_type);


--
-- Name: index_campaigns_on_inbox_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_campaigns_on_inbox_id ON public.campaigns USING btree (inbox_id);


--
-- Name: index_campaigns_on_scheduled_at; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_campaigns_on_scheduled_at ON public.campaigns USING btree (scheduled_at);


--
-- Name: index_categories_on_associated_category_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_categories_on_associated_category_id ON public.categories USING btree (associated_category_id);


--
-- Name: index_categories_on_locale; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_categories_on_locale ON public.categories USING btree (locale);


--
-- Name: index_categories_on_locale_and_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_categories_on_locale_and_account_id ON public.categories USING btree (locale, account_id);


--
-- Name: index_categories_on_parent_category_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_categories_on_parent_category_id ON public.categories USING btree (parent_category_id);


--
-- Name: index_categories_on_slug_and_locale_and_portal_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_categories_on_slug_and_locale_and_portal_id ON public.categories USING btree (slug, locale, portal_id);


--
-- Name: index_channel_api_on_hmac_token; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_api_on_hmac_token ON public.channel_api USING btree (hmac_token);


--
-- Name: index_channel_api_on_identifier; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_api_on_identifier ON public.channel_api USING btree (identifier);


--
-- Name: index_channel_email_on_email; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_email_on_email ON public.channel_email USING btree (email);


--
-- Name: index_channel_email_on_forward_to_email; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_email_on_forward_to_email ON public.channel_email USING btree (forward_to_email);


--
-- Name: index_channel_facebook_pages_on_page_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_channel_facebook_pages_on_page_id ON public.channel_facebook_pages USING btree (page_id);


--
-- Name: index_channel_facebook_pages_on_page_id_and_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_facebook_pages_on_page_id_and_account_id ON public.channel_facebook_pages USING btree (page_id, account_id);


--
-- Name: index_channel_line_on_line_channel_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_line_on_line_channel_id ON public.channel_line USING btree (line_channel_id);


--
-- Name: index_channel_sms_on_phone_number; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_sms_on_phone_number ON public.channel_sms USING btree (phone_number);


--
-- Name: index_channel_telegram_on_bot_token; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_telegram_on_bot_token ON public.channel_telegram USING btree (bot_token);


--
-- Name: index_channel_twilio_sms_on_account_sid_and_phone_number; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_twilio_sms_on_account_sid_and_phone_number ON public.channel_twilio_sms USING btree (account_sid, phone_number);


--
-- Name: index_channel_twilio_sms_on_messaging_service_sid; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_twilio_sms_on_messaging_service_sid ON public.channel_twilio_sms USING btree (messaging_service_sid);


--
-- Name: index_channel_twilio_sms_on_phone_number; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_twilio_sms_on_phone_number ON public.channel_twilio_sms USING btree (phone_number);


--
-- Name: index_channel_twitter_profiles_on_account_id_and_profile_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_twitter_profiles_on_account_id_and_profile_id ON public.channel_twitter_profiles USING btree (account_id, profile_id);


--
-- Name: index_channel_web_widgets_on_hmac_token; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_web_widgets_on_hmac_token ON public.channel_web_widgets USING btree (hmac_token);


--
-- Name: index_channel_web_widgets_on_website_token; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_web_widgets_on_website_token ON public.channel_web_widgets USING btree (website_token);


--
-- Name: index_channel_whatsapp_on_phone_number; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_channel_whatsapp_on_phone_number ON public.channel_whatsapp USING btree (phone_number);


--
-- Name: index_contact_inboxes_on_contact_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_contact_inboxes_on_contact_id ON public.contact_inboxes USING btree (contact_id);


--
-- Name: index_contact_inboxes_on_inbox_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_contact_inboxes_on_inbox_id ON public.contact_inboxes USING btree (inbox_id);


--
-- Name: index_contact_inboxes_on_inbox_id_and_source_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_contact_inboxes_on_inbox_id_and_source_id ON public.contact_inboxes USING btree (inbox_id, source_id);


--
-- Name: index_contact_inboxes_on_pubsub_token; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_contact_inboxes_on_pubsub_token ON public.contact_inboxes USING btree (pubsub_token);


--
-- Name: index_contact_inboxes_on_source_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_contact_inboxes_on_source_id ON public.contact_inboxes USING btree (source_id);


--
-- Name: index_contacts_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_contacts_on_account_id ON public.contacts USING btree (account_id);


--
-- Name: index_contacts_on_phone_number_and_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_contacts_on_phone_number_and_account_id ON public.contacts USING btree (phone_number, account_id);


--
-- Name: index_conversations_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_conversations_on_account_id ON public.conversations USING btree (account_id);


--
-- Name: index_conversations_on_account_id_and_display_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_conversations_on_account_id_and_display_id ON public.conversations USING btree (account_id, display_id);


--
-- Name: index_conversations_on_assignee_id_and_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_conversations_on_assignee_id_and_account_id ON public.conversations USING btree (assignee_id, account_id);


--
-- Name: index_conversations_on_campaign_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_conversations_on_campaign_id ON public.conversations USING btree (campaign_id);


--
-- Name: index_conversations_on_contact_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_conversations_on_contact_id ON public.conversations USING btree (contact_id);


--
-- Name: index_conversations_on_contact_inbox_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_conversations_on_contact_inbox_id ON public.conversations USING btree (contact_inbox_id);


--
-- Name: index_conversations_on_first_reply_created_at; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_conversations_on_first_reply_created_at ON public.conversations USING btree (first_reply_created_at);


--
-- Name: index_conversations_on_inbox_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_conversations_on_inbox_id ON public.conversations USING btree (inbox_id);


--
-- Name: index_conversations_on_last_activity_at; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_conversations_on_last_activity_at ON public.conversations USING btree (last_activity_at);


--
-- Name: index_conversations_on_status_and_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_conversations_on_status_and_account_id ON public.conversations USING btree (status, account_id);


--
-- Name: index_conversations_on_team_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_conversations_on_team_id ON public.conversations USING btree (team_id);


--
-- Name: index_conversations_on_uuid; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_conversations_on_uuid ON public.conversations USING btree (uuid);


--
-- Name: index_csat_survey_responses_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_csat_survey_responses_on_account_id ON public.csat_survey_responses USING btree (account_id);


--
-- Name: index_csat_survey_responses_on_assigned_agent_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_csat_survey_responses_on_assigned_agent_id ON public.csat_survey_responses USING btree (assigned_agent_id);


--
-- Name: index_csat_survey_responses_on_contact_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_csat_survey_responses_on_contact_id ON public.csat_survey_responses USING btree (contact_id);


--
-- Name: index_csat_survey_responses_on_conversation_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_csat_survey_responses_on_conversation_id ON public.csat_survey_responses USING btree (conversation_id);


--
-- Name: index_csat_survey_responses_on_message_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_csat_survey_responses_on_message_id ON public.csat_survey_responses USING btree (message_id);


--
-- Name: index_custom_attribute_definitions_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_custom_attribute_definitions_on_account_id ON public.custom_attribute_definitions USING btree (account_id);


--
-- Name: index_custom_filters_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_custom_filters_on_account_id ON public.custom_filters USING btree (account_id);


--
-- Name: index_custom_filters_on_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_custom_filters_on_user_id ON public.custom_filters USING btree (user_id);


--
-- Name: index_dashboard_apps_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_dashboard_apps_on_account_id ON public.dashboard_apps USING btree (account_id);


--
-- Name: index_dashboard_apps_on_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_dashboard_apps_on_user_id ON public.dashboard_apps USING btree (user_id);


--
-- Name: index_data_imports_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_data_imports_on_account_id ON public.data_imports USING btree (account_id);


--
-- Name: index_email_templates_on_name_and_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_email_templates_on_name_and_account_id ON public.email_templates USING btree (name, account_id);


--
-- Name: index_inbox_members_on_inbox_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_inbox_members_on_inbox_id ON public.inbox_members USING btree (inbox_id);


--
-- Name: index_inbox_members_on_inbox_id_and_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_inbox_members_on_inbox_id_and_user_id ON public.inbox_members USING btree (inbox_id, user_id);


--
-- Name: index_inboxes_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_inboxes_on_account_id ON public.inboxes USING btree (account_id);


--
-- Name: index_installation_configs_on_name; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_installation_configs_on_name ON public.installation_configs USING btree (name);


--
-- Name: index_installation_configs_on_name_and_created_at; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_installation_configs_on_name_and_created_at ON public.installation_configs USING btree (name, created_at);


--
-- Name: index_labels_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_labels_on_account_id ON public.labels USING btree (account_id);


--
-- Name: index_labels_on_title_and_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_labels_on_title_and_account_id ON public.labels USING btree (title, account_id);


--
-- Name: index_macros_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_macros_on_account_id ON public.macros USING btree (account_id);


--
-- Name: index_macros_on_created_by_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_macros_on_created_by_id ON public.macros USING btree (created_by_id);


--
-- Name: index_macros_on_updated_by_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_macros_on_updated_by_id ON public.macros USING btree (updated_by_id);


--
-- Name: index_mentions_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_mentions_on_account_id ON public.mentions USING btree (account_id);


--
-- Name: index_mentions_on_conversation_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_mentions_on_conversation_id ON public.mentions USING btree (conversation_id);


--
-- Name: index_mentions_on_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_mentions_on_user_id ON public.mentions USING btree (user_id);


--
-- Name: index_mentions_on_user_id_and_conversation_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_mentions_on_user_id_and_conversation_id ON public.mentions USING btree (user_id, conversation_id);


--
-- Name: index_messages_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_messages_on_account_id ON public.messages USING btree (account_id);


--
-- Name: index_messages_on_additional_attributes_campaign_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_messages_on_additional_attributes_campaign_id ON public.messages USING gin (((additional_attributes -> 'campaign_id'::text)));


--
-- Name: index_messages_on_conversation_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_messages_on_conversation_id ON public.messages USING btree (conversation_id);


--
-- Name: index_messages_on_inbox_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_messages_on_inbox_id ON public.messages USING btree (inbox_id);


--
-- Name: index_messages_on_sender_type_and_sender_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_messages_on_sender_type_and_sender_id ON public.messages USING btree (sender_type, sender_id);


--
-- Name: index_messages_on_source_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_messages_on_source_id ON public.messages USING btree (source_id);


--
-- Name: index_notes_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_notes_on_account_id ON public.notes USING btree (account_id);


--
-- Name: index_notes_on_contact_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_notes_on_contact_id ON public.notes USING btree (contact_id);


--
-- Name: index_notes_on_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_notes_on_user_id ON public.notes USING btree (user_id);


--
-- Name: index_notification_subscriptions_on_identifier; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_notification_subscriptions_on_identifier ON public.notification_subscriptions USING btree (identifier);


--
-- Name: index_notification_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_notification_subscriptions_on_user_id ON public.notification_subscriptions USING btree (user_id);


--
-- Name: index_notifications_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_notifications_on_account_id ON public.notifications USING btree (account_id);


--
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_notifications_on_user_id ON public.notifications USING btree (user_id);


--
-- Name: index_platform_app_permissibles_on_permissibles; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_platform_app_permissibles_on_permissibles ON public.platform_app_permissibles USING btree (permissible_type, permissible_id);


--
-- Name: index_platform_app_permissibles_on_platform_app_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_platform_app_permissibles_on_platform_app_id ON public.platform_app_permissibles USING btree (platform_app_id);


--
-- Name: index_portal_members_on_portal_id_and_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_portal_members_on_portal_id_and_user_id ON public.portal_members USING btree (portal_id, user_id);


--
-- Name: index_portal_members_on_user_id_and_portal_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_portal_members_on_user_id_and_portal_id ON public.portal_members USING btree (user_id, portal_id);


--
-- Name: index_portals_members_on_portal_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_portals_members_on_portal_id ON public.portals_members USING btree (portal_id);


--
-- Name: index_portals_members_on_portal_id_and_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_portals_members_on_portal_id_and_user_id ON public.portals_members USING btree (portal_id, user_id);


--
-- Name: index_portals_members_on_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_portals_members_on_user_id ON public.portals_members USING btree (user_id);


--
-- Name: index_portals_on_custom_domain; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_portals_on_custom_domain ON public.portals USING btree (custom_domain);


--
-- Name: index_portals_on_slug; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_portals_on_slug ON public.portals USING btree (slug);


--
-- Name: index_related_categories_on_category_id_and_related_category_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_related_categories_on_category_id_and_related_category_id ON public.related_categories USING btree (category_id, related_category_id);


--
-- Name: index_related_categories_on_related_category_id_and_category_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_related_categories_on_related_category_id_and_category_id ON public.related_categories USING btree (related_category_id, category_id);


--
-- Name: index_reporting_events_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_reporting_events_on_account_id ON public.reporting_events USING btree (account_id);


--
-- Name: index_reporting_events_on_conversation_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_reporting_events_on_conversation_id ON public.reporting_events USING btree (conversation_id);


--
-- Name: index_reporting_events_on_created_at; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_reporting_events_on_created_at ON public.reporting_events USING btree (created_at);


--
-- Name: index_reporting_events_on_inbox_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_reporting_events_on_inbox_id ON public.reporting_events USING btree (inbox_id);


--
-- Name: index_reporting_events_on_name; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_reporting_events_on_name ON public.reporting_events USING btree (name);


--
-- Name: index_reporting_events_on_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_reporting_events_on_user_id ON public.reporting_events USING btree (user_id);


--
-- Name: index_taggings_on_context; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_taggings_on_context ON public.taggings USING btree (context);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_taggings_on_tag_id ON public.taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_taggings_on_taggable_id ON public.taggings USING btree (taggable_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_taggings_on_taggable_type; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_taggings_on_taggable_type ON public.taggings USING btree (taggable_type);


--
-- Name: index_taggings_on_tagger_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_taggings_on_tagger_id ON public.taggings USING btree (tagger_id);


--
-- Name: index_taggings_on_tagger_id_and_tagger_type; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_taggings_on_tagger_id_and_tagger_type ON public.taggings USING btree (tagger_id, tagger_type);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_team_members_on_team_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_team_members_on_team_id ON public.team_members USING btree (team_id);


--
-- Name: index_team_members_on_team_id_and_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_team_members_on_team_id_and_user_id ON public.team_members USING btree (team_id, user_id);


--
-- Name: index_team_members_on_user_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_team_members_on_user_id ON public.team_members USING btree (user_id);


--
-- Name: index_teams_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_teams_on_account_id ON public.teams USING btree (account_id);


--
-- Name: index_teams_on_name_and_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_teams_on_name_and_account_id ON public.teams USING btree (name, account_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_pubsub_token; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_users_on_pubsub_token ON public.users USING btree (pubsub_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_uid_and_provider; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_users_on_uid_and_provider ON public.users USING btree (uid, provider);


--
-- Name: index_webhooks_on_account_id_and_url; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX index_webhooks_on_account_id_and_url ON public.webhooks USING btree (account_id, url);


--
-- Name: index_working_hours_on_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_working_hours_on_account_id ON public.working_hours USING btree (account_id);


--
-- Name: index_working_hours_on_inbox_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX index_working_hours_on_inbox_id ON public.working_hours USING btree (inbox_id);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: taggings_idy; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX taggings_idy ON public.taggings USING btree (taggable_id, taggable_type, tagger_id, context);


--
-- Name: uniq_email_per_account_contact; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX uniq_email_per_account_contact ON public.contacts USING btree (email, account_id);


--
-- Name: uniq_identifier_per_account_contact; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX uniq_identifier_per_account_contact ON public.contacts USING btree (identifier, account_id);


--
-- Name: uniq_primary_actor_per_account_notifications; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX uniq_primary_actor_per_account_notifications ON public.notifications USING btree (primary_actor_type, primary_actor_id);


--
-- Name: uniq_secondary_actor_per_account_notifications; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE INDEX uniq_secondary_actor_per_account_notifications ON public.notifications USING btree (secondary_actor_type, secondary_actor_id);


--
-- Name: uniq_user_id_per_account_id; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX uniq_user_id_per_account_id ON public.account_users USING btree (account_id, user_id);


--
-- Name: unique_permissibles_index; Type: INDEX; Schema: public; Owner: chatwoot
--

CREATE UNIQUE INDEX unique_permissibles_index ON public.platform_app_permissibles USING btree (platform_app_id, permissible_id, permissible_type);


--
-- Name: accounts accounts_after_insert_row_tr; Type: TRIGGER; Schema: public; Owner: chatwoot
--

CREATE TRIGGER accounts_after_insert_row_tr AFTER INSERT ON public.accounts FOR EACH ROW EXECUTE FUNCTION public.accounts_after_insert_row_tr();


--
-- Name: accounts camp_dpid_before_insert; Type: TRIGGER; Schema: public; Owner: chatwoot
--

CREATE TRIGGER camp_dpid_before_insert AFTER INSERT ON public.accounts FOR EACH ROW EXECUTE FUNCTION public.camp_dpid_before_insert();


--
-- Name: campaigns campaigns_before_insert_row_tr; Type: TRIGGER; Schema: public; Owner: chatwoot
--

CREATE TRIGGER campaigns_before_insert_row_tr BEFORE INSERT ON public.campaigns FOR EACH ROW EXECUTE FUNCTION public.campaigns_before_insert_row_tr();


--
-- Name: conversations conversations_before_insert_row_tr; Type: TRIGGER; Schema: public; Owner: chatwoot
--

CREATE TRIGGER conversations_before_insert_row_tr BEFORE INSERT ON public.conversations FOR EACH ROW EXECUTE FUNCTION public.conversations_before_insert_row_tr();


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: chatwoot
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- PostgreSQL database dump complete
--

