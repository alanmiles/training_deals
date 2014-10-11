--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: businesses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE businesses (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    street_address text,
    city character varying(255),
    state character varying(255),
    postal_code character varying(255),
    country character varying(255),
    latitude double precision,
    longitude double precision,
    hide_address boolean DEFAULT false,
    phone character varying(255),
    alt_phone character varying(255),
    email character varying(255),
    website character varying(255),
    logo character varying(255),
    image character varying(255),
    inactive boolean DEFAULT false,
    inactive_from timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: businesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE businesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: businesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE businesses_id_seq OWNED BY businesses.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    description character varying(255),
    genre_id integer,
    created_by integer DEFAULT 1,
    status integer DEFAULT 2,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: content_lengths; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE content_lengths (
    id integer NOT NULL,
    description character varying(255),
    "position" integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: content_lengths_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE content_lengths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_lengths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE content_lengths_id_seq OWNED BY content_lengths.id;


--
-- Name: durations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE durations (
    id integer NOT NULL,
    time_unit character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "position" integer
);


--
-- Name: durations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE durations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: durations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE durations_id_seq OWNED BY durations.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    product_id integer,
    start_date date,
    end_date date,
    start_time time without time zone,
    finish_time time without time zone,
    attendance_days character varying(255),
    time_of_day character varying(255),
    location character varying(255),
    note character varying(255),
    created_by integer,
    cancelled boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    price numeric(8,2),
    places_available integer DEFAULT 0,
    places_sold integer DEFAULT 0
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: genres; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE genres (
    id integer NOT NULL,
    description character varying(255),
    "position" integer,
    created_by integer DEFAULT 1,
    status integer DEFAULT 2,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE genres_id_seq OWNED BY genres.id;


--
-- Name: ownerships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ownerships (
    id integer NOT NULL,
    business_id integer,
    user_id integer,
    email_address character varying(255),
    contactable boolean DEFAULT false,
    phone character varying(255),
    "position" integer,
    created_by integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ownerships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ownerships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ownerships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ownerships_id_seq OWNED BY ownerships.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products (
    id integer NOT NULL,
    business_id integer,
    title character varying(255),
    ref_code character varying(255),
    topic_id integer,
    qualification character varying(255),
    training_method_id integer,
    duration_id integer,
    duration_number numeric(6,2),
    content_length_id integer,
    content_number numeric(6,2),
    currency character varying(255),
    standard_cost numeric(8,2),
    content text,
    outcome text,
    current boolean DEFAULT true,
    image character varying(255),
    web_link character varying(255),
    created_by integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE topics (
    id integer NOT NULL,
    description character varying(255),
    category_id integer,
    created_by integer DEFAULT 1,
    status integer DEFAULT 2,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topics_id_seq OWNED BY topics.id;


--
-- Name: training_methods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE training_methods (
    id integer NOT NULL,
    description character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "position" integer,
    event boolean DEFAULT false
);


--
-- Name: training_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE training_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE training_methods_id_seq OWNED BY training_methods.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    password_digest character varying(255),
    remember_token character varying(255),
    admin boolean DEFAULT false,
    vendor boolean DEFAULT false,
    location character varying(255),
    city character varying(255),
    country character varying(255),
    latitude double precision,
    longitude double precision,
    password_reset_token character varying(255),
    password_reset_sent_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: visitors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visitors (
    id integer NOT NULL,
    ip_address character varying(255),
    latitude double precision,
    longitude double precision,
    city character varying(255),
    country character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: visitors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visitors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visitors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visitors_id_seq OWNED BY visitors.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY businesses ALTER COLUMN id SET DEFAULT nextval('businesses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY content_lengths ALTER COLUMN id SET DEFAULT nextval('content_lengths_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY durations ALTER COLUMN id SET DEFAULT nextval('durations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY genres ALTER COLUMN id SET DEFAULT nextval('genres_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ownerships ALTER COLUMN id SET DEFAULT nextval('ownerships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY training_methods ALTER COLUMN id SET DEFAULT nextval('training_methods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visitors ALTER COLUMN id SET DEFAULT nextval('visitors_id_seq'::regclass);


--
-- Name: businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY businesses
    ADD CONSTRAINT businesses_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: content_lengths_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY content_lengths
    ADD CONSTRAINT content_lengths_pkey PRIMARY KEY (id);


--
-- Name: durations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY durations
    ADD CONSTRAINT durations_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: ownerships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ownerships
    ADD CONSTRAINT ownerships_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: training_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY training_methods
    ADD CONSTRAINT training_methods_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visitors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visitors
    ADD CONSTRAINT visitors_pkey PRIMARY KEY (id);


--
-- Name: index_businesses_on_country_and_city_and_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_businesses_on_country_and_city_and_name ON businesses USING btree (country, city, name);


--
-- Name: index_categories_on_genre_id_and_description; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_genre_id_and_description ON categories USING btree (genre_id, description);


--
-- Name: index_content_lengths_on_description; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_content_lengths_on_description ON content_lengths USING btree (description);


--
-- Name: index_durations_on_time_unit; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_durations_on_time_unit ON durations USING btree (time_unit);


--
-- Name: index_events_on_product_id_and_start_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_events_on_product_id_and_start_date ON events USING btree (product_id, start_date);


--
-- Name: index_genres_on_description; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_genres_on_description ON genres USING btree (description);


--
-- Name: index_ownerships_on_business_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_ownerships_on_business_id_and_user_id ON ownerships USING btree (business_id, user_id);


--
-- Name: index_products_on_business_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_on_business_id ON products USING btree (business_id);


--
-- Name: index_products_on_business_id_and_topic_id_and_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_products_on_business_id_and_topic_id_and_title ON products USING btree (business_id, topic_id, title);


--
-- Name: index_products_on_topic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_on_topic_id ON products USING btree (topic_id);


--
-- Name: index_topics_on_category_id_and_description; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_topics_on_category_id_and_description ON topics USING btree (category_id, description);


--
-- Name: index_training_methods_on_description; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_training_methods_on_description ON training_methods USING btree (description);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_remember_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_remember_token ON users USING btree (remember_token);


--
-- Name: index_visitors_on_ip_address; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visitors_on_ip_address ON visitors USING btree (ip_address);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140618085936');

INSERT INTO schema_migrations (version) VALUES ('20140618101826');

INSERT INTO schema_migrations (version) VALUES ('20140618102634');

INSERT INTO schema_migrations (version) VALUES ('20140621094728');

INSERT INTO schema_migrations (version) VALUES ('20140622085921');

INSERT INTO schema_migrations (version) VALUES ('20140626110820');

INSERT INTO schema_migrations (version) VALUES ('20140626110906');

INSERT INTO schema_migrations (version) VALUES ('20140628090208');

INSERT INTO schema_migrations (version) VALUES ('20140628113133');

INSERT INTO schema_migrations (version) VALUES ('20140628125945');

INSERT INTO schema_migrations (version) VALUES ('20140630093438');

INSERT INTO schema_migrations (version) VALUES ('20140701104938');

INSERT INTO schema_migrations (version) VALUES ('20140703224544');

INSERT INTO schema_migrations (version) VALUES ('20140706111617');

INSERT INTO schema_migrations (version) VALUES ('20140716085514');

INSERT INTO schema_migrations (version) VALUES ('20140724230151');

INSERT INTO schema_migrations (version) VALUES ('20140811115116');

INSERT INTO schema_migrations (version) VALUES ('20140811232710');

INSERT INTO schema_migrations (version) VALUES ('20140825133900');

INSERT INTO schema_migrations (version) VALUES ('20140830071819');

INSERT INTO schema_migrations (version) VALUES ('20140906003601');

INSERT INTO schema_migrations (version) VALUES ('20140924121201');

INSERT INTO schema_migrations (version) VALUES ('20141011094357');
