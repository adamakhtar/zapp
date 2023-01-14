--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Homebrew)
-- Dumped by pg_dump version 14.5 (Homebrew)

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
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: heading_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.heading_sections (
    id bigint NOT NULL,
    title character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: heading_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.heading_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: heading_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.heading_sections_id_seq OWNED BY public.heading_sections.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identities (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    hashed_password character varying(255) NOT NULL,
    confirmed_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.identities_id_seq OWNED BY public.identities.id;


--
-- Name: identities_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identities_tokens (
    id bigint NOT NULL,
    identity_id bigint NOT NULL,
    token bytea NOT NULL,
    context character varying(255) NOT NULL,
    sent_to character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL
);


--
-- Name: identities_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.identities_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.identities_tokens_id_seq OWNED BY public.identities_tokens.id;


--
-- Name: issues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.issues (
    id bigint NOT NULL,
    title character varying(255),
    account_id bigint,
    newsletter_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.issues_id_seq OWNED BY public.issues.id;


--
-- Name: lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lists (
    id bigint NOT NULL,
    name character varying(255),
    twitter_id bigint,
    account_id bigint,
    newsletter_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lists_id_seq OWNED BY public.lists.id;


--
-- Name: newsletters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.newsletters (
    id bigint NOT NULL,
    name character varying(255),
    account_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    subdomain character varying(255) NOT NULL
);


--
-- Name: newsletters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.newsletters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: newsletters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.newsletters_id_seq OWNED BY public.newsletters.id;


--
-- Name: oauth_credentials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_credentials (
    id bigint NOT NULL,
    token character varying(255),
    secret character varying(255),
    reference character varying(255),
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    service_id character varying(255)
);


--
-- Name: oauth_credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_credentials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_credentials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_credentials_id_seq OWNED BY public.oauth_credentials.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sections (
    id bigint NOT NULL,
    rank integer NOT NULL,
    issue_id bigint,
    tweet_section_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    heading_section_id bigint,
    text_section_id bigint
);


--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sections_id_seq OWNED BY public.sections.id;


--
-- Name: text_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.text_sections (
    id bigint NOT NULL,
    body text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: text_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.text_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: text_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.text_sections_id_seq OWNED BY public.text_sections.id;


--
-- Name: tweet_section_medias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tweet_section_medias (
    id bigint NOT NULL,
    url character varying(255),
    thumbnail_url character varying(255),
    tweet_section_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: tweet_section_medias_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tweet_section_medias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tweet_section_medias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tweet_section_medias_id_seq OWNED BY public.tweet_section_medias.id;


--
-- Name: tweet_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tweet_sections (
    id bigint NOT NULL,
    text text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    user_name character varying(255),
    user_screen_name character varying(255),
    user_profile_image_url character varying(255),
    retweet_count integer,
    favorite_count integer
);


--
-- Name: tweet_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tweet_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tweet_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tweet_sections_id_seq OWNED BY public.tweet_sections.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    identity_id bigint,
    account_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: heading_sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heading_sections ALTER COLUMN id SET DEFAULT nextval('public.heading_sections_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities ALTER COLUMN id SET DEFAULT nextval('public.identities_id_seq'::regclass);


--
-- Name: identities_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities_tokens ALTER COLUMN id SET DEFAULT nextval('public.identities_tokens_id_seq'::regclass);


--
-- Name: issues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues ALTER COLUMN id SET DEFAULT nextval('public.issues_id_seq'::regclass);


--
-- Name: lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lists ALTER COLUMN id SET DEFAULT nextval('public.lists_id_seq'::regclass);


--
-- Name: newsletters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.newsletters ALTER COLUMN id SET DEFAULT nextval('public.newsletters_id_seq'::regclass);


--
-- Name: oauth_credentials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_credentials ALTER COLUMN id SET DEFAULT nextval('public.oauth_credentials_id_seq'::regclass);


--
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections ALTER COLUMN id SET DEFAULT nextval('public.sections_id_seq'::regclass);


--
-- Name: text_sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.text_sections ALTER COLUMN id SET DEFAULT nextval('public.text_sections_id_seq'::regclass);


--
-- Name: tweet_section_medias id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tweet_section_medias ALTER COLUMN id SET DEFAULT nextval('public.tweet_section_medias_id_seq'::regclass);


--
-- Name: tweet_sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tweet_sections ALTER COLUMN id SET DEFAULT nextval('public.tweet_sections_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: heading_sections heading_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.heading_sections
    ADD CONSTRAINT heading_sections_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities_tokens identities_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities_tokens
    ADD CONSTRAINT identities_tokens_pkey PRIMARY KEY (id);


--
-- Name: issues issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: lists lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);


--
-- Name: newsletters newsletters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.newsletters
    ADD CONSTRAINT newsletters_pkey PRIMARY KEY (id);


--
-- Name: oauth_credentials oauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_credentials
    ADD CONSTRAINT oauth_credentials_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: text_sections text_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.text_sections
    ADD CONSTRAINT text_sections_pkey PRIMARY KEY (id);


--
-- Name: tweet_section_medias tweet_section_medias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tweet_section_medias
    ADD CONSTRAINT tweet_section_medias_pkey PRIMARY KEY (id);


--
-- Name: tweet_sections tweet_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tweet_sections
    ADD CONSTRAINT tweet_sections_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: identities_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX identities_email_index ON public.identities USING btree (email);


--
-- Name: identities_tokens_context_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX identities_tokens_context_token_index ON public.identities_tokens USING btree (context, token);


--
-- Name: identities_tokens_identity_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX identities_tokens_identity_id_index ON public.identities_tokens USING btree (identity_id);


--
-- Name: issues_account_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX issues_account_id_index ON public.issues USING btree (account_id);


--
-- Name: issues_newsletter_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX issues_newsletter_id_index ON public.issues USING btree (newsletter_id);


--
-- Name: lists_account_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX lists_account_id_index ON public.lists USING btree (account_id);


--
-- Name: lists_newsletter_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX lists_newsletter_id_index ON public.lists USING btree (newsletter_id);


--
-- Name: newsletters_account_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX newsletters_account_id_index ON public.newsletters USING btree (account_id);


--
-- Name: newsletters_subdomain_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX newsletters_subdomain_index ON public.newsletters USING btree (subdomain);


--
-- Name: oauth_credentials_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX oauth_credentials_user_id_index ON public.oauth_credentials USING btree (user_id);


--
-- Name: sections_issue_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sections_issue_id_index ON public.sections USING btree (issue_id);


--
-- Name: sections_tweet_section_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sections_tweet_section_id_index ON public.sections USING btree (tweet_section_id);


--
-- Name: tweet_section_medias_tweet_section_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tweet_section_medias_tweet_section_id_index ON public.tweet_section_medias USING btree (tweet_section_id);


--
-- Name: users_identity_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_identity_id_index ON public.users USING btree (identity_id);


--
-- Name: identities_tokens identities_tokens_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities_tokens
    ADD CONSTRAINT identities_tokens_identity_id_fkey FOREIGN KEY (identity_id) REFERENCES public.identities(id) ON DELETE CASCADE;


--
-- Name: issues issues_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: issues issues_newsletter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_newsletter_id_fkey FOREIGN KEY (newsletter_id) REFERENCES public.newsletters(id);


--
-- Name: lists lists_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: lists lists_newsletter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_newsletter_id_fkey FOREIGN KEY (newsletter_id) REFERENCES public.newsletters(id);


--
-- Name: newsletters newsletters_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.newsletters
    ADD CONSTRAINT newsletters_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: oauth_credentials oauth_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_credentials
    ADD CONSTRAINT oauth_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: sections sections_heading_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_heading_section_id_fkey FOREIGN KEY (heading_section_id) REFERENCES public.heading_sections(id);


--
-- Name: sections sections_issue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_issue_id_fkey FOREIGN KEY (issue_id) REFERENCES public.issues(id);


--
-- Name: sections sections_text_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_text_section_id_fkey FOREIGN KEY (text_section_id) REFERENCES public.text_sections(id);


--
-- Name: sections sections_tweet_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_tweet_section_id_fkey FOREIGN KEY (tweet_section_id) REFERENCES public.tweet_sections(id);


--
-- Name: tweet_section_medias tweet_section_medias_tweet_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tweet_section_medias
    ADD CONSTRAINT tweet_section_medias_tweet_section_id_fkey FOREIGN KEY (tweet_section_id) REFERENCES public.tweet_sections(id);


--
-- Name: users users_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: users users_identity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_identity_id_fkey FOREIGN KEY (identity_id) REFERENCES public.identities(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20221022052156);
INSERT INTO public."schema_migrations" (version) VALUES (20221022062742);
INSERT INTO public."schema_migrations" (version) VALUES (20221022063319);
INSERT INTO public."schema_migrations" (version) VALUES (20221022132650);
INSERT INTO public."schema_migrations" (version) VALUES (20221022132809);
INSERT INTO public."schema_migrations" (version) VALUES (20221026110858);
INSERT INTO public."schema_migrations" (version) VALUES (20221029082907);
INSERT INTO public."schema_migrations" (version) VALUES (20221029083621);
INSERT INTO public."schema_migrations" (version) VALUES (20221029112601);
INSERT INTO public."schema_migrations" (version) VALUES (20221030125452);
INSERT INTO public."schema_migrations" (version) VALUES (20221030125522);
INSERT INTO public."schema_migrations" (version) VALUES (20221031122350);
INSERT INTO public."schema_migrations" (version) VALUES (20221031122358);
INSERT INTO public."schema_migrations" (version) VALUES (20221127075721);
INSERT INTO public."schema_migrations" (version) VALUES (20221204043058);
INSERT INTO public."schema_migrations" (version) VALUES (20221204062727);
INSERT INTO public."schema_migrations" (version) VALUES (20221208122226);
INSERT INTO public."schema_migrations" (version) VALUES (20221211050246);
INSERT INTO public."schema_migrations" (version) VALUES (20221230063337);
INSERT INTO public."schema_migrations" (version) VALUES (20230113145234);
