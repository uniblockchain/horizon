--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

DROP INDEX public.signersaccount;
DROP INDEX public.sellingissuerindex;
DROP INDEX public.priceindex;
DROP INDEX public.ledgersbyseq;
DROP INDEX public.buyingissuerindex;
DROP INDEX public.accountlines;
DROP INDEX public.accountbalances;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_pkey;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_ledgerseq_txindex_key;
ALTER TABLE ONLY public.trustlines DROP CONSTRAINT trustlines_pkey;
ALTER TABLE ONLY public.storestate DROP CONSTRAINT storestate_pkey;
ALTER TABLE ONLY public.signers DROP CONSTRAINT signers_pkey;
ALTER TABLE ONLY public.peers DROP CONSTRAINT peers_pkey;
ALTER TABLE ONLY public.offers DROP CONSTRAINT offers_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_ledgerseq_key;
ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
DROP TABLE public.txhistory;
DROP TABLE public.trustlines;
DROP TABLE public.storestate;
DROP TABLE public.signers;
DROP TABLE public.peers;
DROP TABLE public.offers;
DROP TABLE public.ledgerheaders;
DROP TABLE public.accounts;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


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
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    accountid character varying(56) NOT NULL,
    balance bigint NOT NULL,
    seqnum bigint NOT NULL,
    numsubentries integer NOT NULL,
    inflationdest character varying(56),
    homedomain character varying(32),
    thresholds text,
    flags integer NOT NULL,
    CONSTRAINT accounts_balance_check CHECK ((balance >= 0)),
    CONSTRAINT accounts_numsubentries_check CHECK ((numsubentries >= 0))
);


--
-- Name: ledgerheaders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ledgerheaders (
    ledgerhash character(64) NOT NULL,
    prevhash character(64) NOT NULL,
    bucketlisthash character(64) NOT NULL,
    ledgerseq integer,
    closetime bigint NOT NULL,
    data text NOT NULL,
    CONSTRAINT ledgerheaders_closetime_check CHECK ((closetime >= 0)),
    CONSTRAINT ledgerheaders_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offers (
    sellerid character varying(56) NOT NULL,
    offerid bigint NOT NULL,
    sellingassettype integer,
    sellingassetcode character varying(12),
    sellingissuer character varying(56),
    buyingassettype integer,
    buyingassetcode character varying(12),
    buyingissuer character varying(56),
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
    price bigint NOT NULL,
    flags integer NOT NULL,
    CONSTRAINT offers_amount_check CHECK ((amount >= 0)),
    CONSTRAINT offers_offerid_check CHECK ((offerid >= 0))
);


--
-- Name: peers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peers (
    ip character varying(15) NOT NULL,
    port integer DEFAULT 0 NOT NULL,
    nextattempt timestamp without time zone NOT NULL,
    numfailures integer DEFAULT 0 NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    CONSTRAINT peers_numfailures_check CHECK ((numfailures >= 0)),
    CONSTRAINT peers_port_check CHECK (((port > 0) AND (port <= 65535))),
    CONSTRAINT peers_rank_check CHECK ((rank >= 0))
);


--
-- Name: signers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signers (
    accountid character varying(56) NOT NULL,
    publickey character varying(56) NOT NULL,
    weight integer NOT NULL
);


--
-- Name: storestate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE storestate (
    statename character(32) NOT NULL,
    state text
);


--
-- Name: trustlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trustlines (
    accountid character varying(56) NOT NULL,
    assettype integer NOT NULL,
    issuer character varying(56) NOT NULL,
    assetcode character varying(12) NOT NULL,
    tlimit bigint DEFAULT 0 NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    flags integer NOT NULL,
    CONSTRAINT trustlines_balance_check CHECK ((balance >= 0)),
    CONSTRAINT trustlines_tlimit_check CHECK ((tlimit >= 0))
);


--
-- Name: txhistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE txhistory (
    txid character(64) NOT NULL,
    ledgerseq integer NOT NULL,
    txindex integer NOT NULL,
    txbody text NOT NULL,
    txresult text NOT NULL,
    txmeta text NOT NULL,
    CONSTRAINT txhistory_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY accounts (accountid, balance, seqnum, numsubentries, inflationdest, homedomain, thresholds, flags) FROM stdin;
GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	99999969999999970	3	0	\N		AQAAAA==	0
GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	9999999990	8589934593	1	\N		AQAAAA==	0
GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	9999999990	8589934593	1	\N		AQAAAA==	0
GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	9999999950	8589934597	0	\N		AQAAAA==	3
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, bucketlisthash, ledgerseq, closetime, data) FROM stdin;
e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	0000000000000000000000000000000000000000000000000000000000000000	366ab1da319554c51293d7cbf7893a2373dbb0adb73bc8f86d4842995a948be6	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2arHaMZVUxRKT18v3iTojc9uwrbc7yPhtSEKZWpSL5gAAAAEBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
bf4653b50f09dca31c52853d7b4339503d0187b37dcd34f898eb295f54c5cab1	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	90885bdb22cf2573b2e1c18ca20b1a12182bebdcc66a899ce9a61c3dece31da6	2	1438190347	AAAAAejhCRj5wADHMRmr5UzwifWfkBXMk8SczwC16LmvtuaxD96XGunVj9MERAgW2GAD1+Q6GCg25XT1eorpxPlLZ9gAAAAAVbkLCwAAAAEAAAAIAAAAAQAAAAEAAAAAZR/V/XSlGMIypJnXdAxBVVtRHMdBEjilT4w3+R1ZRtOQiFvbIs8lc7LhwYyiCxoSGCvr3MZqiZzpphw97OMdpgAAAAIBY0V4XYoAAAAAAAAAAAAeAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
9ca1e7db9dc30fa9203bce356c10d07b69f969418edd3295a0b0785b20587567	bf4653b50f09dca31c52853d7b4339503d0187b37dcd34f898eb295f54c5cab1	aa6c80e3400658979e4210b8a226a783012c77afb6d986c3cba5eb28f4ebd426	3	1438190348	AAAAAb9GU7UPCdyjHFKFPXtDOVA9AYezfc00+JjrKV9UxcqxoIRADtv05gs2/lYVJPSvyTP36WjBweGprRj2El9IJNsAAAAAVbkLDAAAAAAAAAAAmTBiJxvYE/2ka+sFdJGUriCoPtL0So7+HF38i5utXmKqbIDjQAZYl55CELiiJqeDASx3r7bZhsPLpeso9OvUJgAAAAMBY0V4XYoAAAAAAAAAAAAyAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
c6e0a1c0525632b16e803e8f6b074f9bbbf57dd64ccb155919c711561d3c778b	9ca1e7db9dc30fa9203bce356c10d07b69f969418edd3295a0b0785b20587567	5f847acb16755fbd9688e8d3ba702dbe728fd282a4099e7853b17dd2633c2058	4	1438190349	AAAAAZyh59udww+pIDvONWwQ0Htp+WlBjt0ylaCweFsgWHVncH3TEbRg4/a05mTi/sEl79R0Apj/zvqYEtA8mqaZ5zYAAAAAVbkLDQAAAAAAAAAAEo/0U/c6KNYkBDsk8pry7f3bSAJRpNNpcqdehZh2mPhfhHrLFnVfvZaI6NO6cC2+co/SgqQJnnhTsX3SYzwgWAAAAAQBY0V4XYoAAAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
6329920311d2dbf310dbf5a973465acac1c9edc60e1f4743987a82cba128f73f	c6e0a1c0525632b16e803e8f6b074f9bbbf57dd64ccb155919c711561d3c778b	8e1fdfc54a6dc86b8ff9251481d8bdc1f347bbc846766fcf110946f2200a9958	5	1438190350	AAAAAcbgocBSVjKxboA+j2sHT5u79X3WTMsVWRnHEVYdPHeL1q9YDkKOHFxwIOTgFjp/CoCmCFnIRTMTVIZCrwnf59MAAAAAVbkLDgAAAAAAAAAAyg3ZY8zwR8rHsV2tJlCTrcThikqpSzkmW6+aqFkFR/iOH9/FSm3Ia4/5JRSB2L3B80e7yEZ2b88RCUbyIAqZWAAAAAUBY0V4XYoAAAAAAAAAAABGAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
f860f7d5345d27db80e7ac87ece9459204cca02648ff855e438b838d4bafb44a	6329920311d2dbf310dbf5a973465acac1c9edc60e1f4743987a82cba128f73f	0c1d538b6be2a4f9ae865297c5ff2a91639edd35d796d6fea2c53966f0b2f122	6	1438190351	AAAAAWMpkgMR0tvzENv1qXNGWsrBye3GDh9HQ5h6gsuhKPc/knog2HA4nGa/V6WZb2q/W1oK5rbAuaBxs928AHR8la8AAAAAVbkLDwAAAAAAAAAAjnB7vp3f3spxZhgdBHjZ+MhvPVm/IGrDG+a6tVt+fCYMHVOLa+Kk+a6GUpfF/yqRY57dNdeW1v6ixTlm8LLxIgAAAAYBY0V4XYoAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
55652ac98ec127777a2664f6efe3823bba31ac146e7e3687c5385dd8d9356002	f860f7d5345d27db80e7ac87ece9459204cca02648ff855e438b838d4bafb44a	c29b3a769c8bf80740d2909cfa348c6b30480a9d8f3851c474b7038a3ea35b2d	7	1438190352	AAAAAfhg99U0XSfbgOesh+zpRZIEzKAmSP+FXkOLg41Lr7RK1XRo3pRcydpIe0KVQxmQ1mpTYH9Yps7fLZee4ZMospUAAAAAVbkLEAAAAAAAAAAAVZg575ePFllbRtiLkAXeynagIWk1f9Z0lWWwNgB/v8bCmzp2nIv4B0DSkJz6NIxrMEgKnY84UcR0twOKPqNbLQAAAAcBY0V4XYoAAAAAAAAAAABaAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
f4fdf2881f2e0737969474de579a5203b3bb59d680ceb29575e4adbd3fec76a6	55652ac98ec127777a2664f6efe3823bba31ac146e7e3687c5385dd8d9356002	8494960e3b2169b49398df182c915f87d23ece9e555f3699d473fb18597ad70a	8	1438190353	AAAAAVVlKsmOwSd3eiZk9u/jgju6MawUbn42h8U4XdjZNWACdFxhRua9cAVjK0q7BM7GYUSVn/skQcIbdcOZr2nAFzwAAAAAVbkLEQAAAAAAAAAAisoLQAh/GiXIbIN03n62n19rUfn0HZVMfaKci/ijhviElJYOOyFptJOY3xgskV+H0j7OnlVfNpnUc/sYWXrXCgAAAAgBY0V4XYoAAAAAAAAAAABkAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
d65e93d461decc28f5897ce56460525ba49e4baaf03d13560948f7cd3c8c91fb	f4fdf2881f2e0737969474de579a5203b3bb59d680ceb29575e4adbd3fec76a6	8494960e3b2169b49398df182c915f87d23ece9e555f3699d473fb18597ad70a	9	1438190354	AAAAAfT98ogfLgc3lpR03leaUgOzu1nWgM6ylXXkrb0/7Ham7NyBkMLZuyEOawSGLtJhDRVri1ssOd82aONKdcIgxlAAAAAAVbkLEgAAAAAAAAAA3z9hmASpL9tAVxktxD3XSOp3itxSvEmM6AUkwBS4ERmElJYOOyFptJOY3xgskV+H0j7OnlVfNpnUc/sYWXrXCgAAAAkBY0V4XYoAAAAAAAAAAABkAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (sellerid, offerid, sellingassettype, sellingassetcode, sellingissuer, buyingassettype, buyingassetcode, buyingissuer, amount, pricen, priced, price, flags) FROM stdin;
\.


--
-- Data for Name: peers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY peers (ip, port, nextattempt, numfailures, rank) FROM stdin;
\.


--
-- Data for Name: signers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY signers (accountid, publickey, weight) FROM stdin;
\.


--
-- Data for Name: storestate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY storestate (statename, state) FROM stdin;
databaseinitialized             	true
forcescponnextlaunch            	false
lastclosedledger                	d65e93d461decc28f5897ce56460525ba49e4baaf03d13560948f7cd3c8c91fb
historyarchivestate             	{\n    "version": 0,\n    "currentLedger": 9,\n    "currentBuckets": [\n        {\n            "curr": "021295ecc2c61b5a5bd116f7c899c4b4cad6780179b78e2a830c5c17b46c5c9e",\n            "next": {\n                "state": 0\n            },\n            "snap": "275df9575b1cb05afb30fae1ee1bbf7e04f3cf9b1d88fecfc6d268f9245eb6c4"\n        },\n        {\n            "curr": "2e56b4cf54982f193b3e2ce91663c339ebb674b97cdf357384208038db9afe7e",\n            "next": {\n                "state": 1,\n                "output": "5df9841ccf3a36d737b5b3e8ac8b893f032f6e8dac75756812a3f12d4d68cda2"\n            },\n            "snap": "c13a7a51c3bb00554a80d4b0c9d799dbbee611797a20c75c78ff2e84c5fc5edd"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 1,\n                "output": "0cddad362510d2e1b1aa3e35d66d00dbe4619d7527eb4c2904a1dd5305d717b9"\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        }\n    ]\n}
\.


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trustlines (accountid, assettype, issuer, assetcode, tlimit, balance, flags) FROM stdin;
GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	1	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	USD	9223372036854775807	0	1
GBXGQJWVLWOYHFLVTKWV5FGHA3LNYY2JQKM7OAJAUEQFU6LPCSEFVXON	1	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	USD	4000	0	0
\.


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txhistory (txid, ledgerseq, txindex, txbody, txresult, txmeta) FROM stdin;
0427feb565c868311d14311a060fa2623d2127b791a196e4da16272ef15ef3b4	2	1	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAABAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAACVAvkAAAAAAAAAAAByWDl7wAAAEBfVaoY3OPkgbSNNK/7fhhI8jzqOJs8fY67xnZA2ACsWLu1uFCA9VyyyciT+EdGtgRfid7kFw/TKaknht6bzOEK	BCf+tWXIaDEdFDEaBg+iYj0hJ7eRoZbk2hYnLvFe87QAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXhdif/2AAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+QAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAiZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8BY0V2CX4b9gAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
afd2cddc8c3234e5d38fe12dc368dbe873531d18da9a7bdf2e3682f604a1335c	2	2	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAACAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAACVAvkAAAAAAAAAAAByWDl7wAAAEAsQ29KSJJ3ShKgVO75wu7uYUs03DapcxxIYk7qZv+A+4zP4kHMv70aLVUtXGwnWQ7QJK9CEYsb7jP3CPqmMS0D	r9LN3IwyNOXTj+Etw2jb6HNTHRjamnvfLjaC9gShM1wAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXYJfhvsAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+QAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAiZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8BY0VztXI37AAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
c28e0249823bea5032278533cdc589047c3b810acb7cc5062b6cf871d9c621f2	2	3	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAADAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAACVAvkAAAAAAAAAAAByWDl7wAAAEDmAThQU+EV1c9bJh4iayUlrl4snFPf8UUdRObHPZxIG5jcFp3EKOQNZZIs9RVdxnstp8ZnS59eAj7SitKAbsEN	wo4CSYI76lAyJ4UzzcWJBHw7gQrLfMUGK2z4cdnGIfIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXO1cjfiAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAJUC+QAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAiZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8BY0VxYWZT4gAAAAAAAAADAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
76ccdbb609e433a04ce3e82474af0f4370a55eba81d53bf8362409affa4f3c1c	3	1	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAAAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB+ZAt7wAAAECnlnRhl71Ib3ZE8ONagQ3wWwJVSUgXWJUyvxuSTTBBxN9VL02TlpTe9nl8RQA3nTBag9hB4FXn0or2xKsn44cO	dszbtgnkM6BM4+gkdK8PQ3ClXrqB1Tv4NiQJr/pPPBwAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+P2AAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+P2AAAAAgAAAAEAAAAAAAAAAAAAAAEAAAAAAQAAAAAAAAAAAAAA
41ce66dbd7f8d8877b0ba805f4a37778a4f94e245c3f2dec3ec5e19a36449cc8	3	2	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAACgAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAAAAAABAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB+ZAt7wAAAEA7dZM6CN5XyTl0fZev0ysnjvafD6EMfOTl8RRRYXaNcKBNm4TPoZ1OPu9JdVfYhIzB8Tmls0P0Frn+s2Foro8A	Qc5m29f42Id7C6gF9KN3eKT5TiRcPy3sPsXhmjZEnMgAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+PsAAAAAgAAAAIAAAAAAAAAAAAAAAEAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+PsAAAAAgAAAAIAAAAAAAAAAAAAAAMAAAAAAQAAAAAAAAAAAAAA
7ade60aaf8cae0e43d615389eddcf8ccb35c0a2cc80916f3153431af728dda4b	4	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt73//////////AAAAAAAAAAGu5L5MAAAAQBNNf5QVwgCyQ6ApWHwbYIv5F3TG676ur37yue2kTY8pojx9X0T6LzGntDy6npPyrL7rtvYm3jTdHMLRrYG9awI=	et5gqvjK4OQ9YVOJ7dz4zLNcCizICRbzFTQxr3KN2ksAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+P2AAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAQAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAB//////////wAAAAAAAAAAAAAAAQAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAACVAvj9gAAAAIAAAABAAAAAQAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
10035e44564a32960c4385468d4e484a3eed8ad5c88e3199365cac496ac35dab	5	1	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAA+gAAAAAAAAAAFvFIhaAAAAQCB5Z82rlhtj1ebHSpl1D6WLLMD4bMB9y05jmJ1/rQ2xuVxQx3L7SBkgZ2H5eabjtAAUs8qg7bQ1W37xKErOaQ4=	EANeRFZKMpYMQ4VGjU5ISj7titXIjjGZNlysSWrDXasAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAJUC+P2AAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAAAAAAAAAAPoAAAAAAAAAAAAAAAAQAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAACVAvj9gAAAAIAAAABAAAAAQAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
004a44b27ea6287cc8070442d144b5232cb178a525c4600908d084669b7241c6	6	1	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAACgAAAAIAAAADAAAAAAAAAAAAAAABAAAAAAAAAAcAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAABVVNEAAAAAAEAAAAAAAAAAfmQLe8AAABA6e/2QwePSIBoQ0haSIclQiU84r6WFKs5WvayGodMGXtwQD5pbHIjnZNdop2I9PJbHbCNy0JIZyFiHDjl+EeICA==	AEpEsn6mKHzIBwRC0US1IyyxeKUlxGAJCNCEZptyQcYAAAAAAAAACgAAAAAAAAABAAAAAAAAAAcAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+PiAAAAAgAAAAMAAAAAAAAAAAAAAAMAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAQAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAB//////////wAAAAEAAAAA
850e4810c37771d37b1fb2598529b00af9ae089986c5e6b9c1856e265b613f9a	7	1	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAACgAAAAIAAAAEAAAAAAAAAAAAAAABAAAAAAAAAAcAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABVVNEAAAAAAEAAAAAAAAAAfmQLe8AAABACWCvZo4pZ9lPY0UsyuxvGu84ZyxCXoDFSv8cHptlq/rb3IfzMz3q3eb2ymHOBkjivmVrTfbCSZRCGuPu83gPCw==	hQ5IEMN3cdN7H7JZhSmwCvmuCJmGxea5wYVuJlthP5oAAAAAAAAACgAAAAAAAAABAAAAAAAAAAcAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+PYAAAAAgAAAAQAAAAAAAAAAAAAAAMAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAAAAAAAAAAPoAAAAAEAAAAA
5ff4c0a489771bdaa8304b1b1f63d77a46242854a626e480d8adc82c6753b433	8	1	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAACgAAAAIAAAAFAAAAAAAAAAAAAAABAAAAAAAAAAcAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABVVNEAAAAAAAAAAAAAAAAAfmQLe8AAABA6aI7GRIyyyMHPqvacbNDdTU8PyUU23hT0ckE0Vq7iG0XWBmWKbMhcVCSx9JRkxlxoSl18GW43aJDx/oagj7KCQ==	X/TApIl3G9qoMEsbH2PXekYkKFSmJuSA2K3ILGdTtDMAAAAAAAAACgAAAAAAAAABAAAAAAAAAAcAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAJUC+POAAAAAgAAAAUAAAAAAAAAAAAAAAMAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAAAAAAAAAAPoAAAAAAAAAAA
\.


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (accountid);


--
-- Name: ledgerheaders_ledgerseq_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_ledgerseq_key UNIQUE (ledgerseq);


--
-- Name: ledgerheaders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_pkey PRIMARY KEY (ledgerhash);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (offerid);


--
-- Name: peers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peers
    ADD CONSTRAINT peers_pkey PRIMARY KEY (ip, port);


--
-- Name: signers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signers
    ADD CONSTRAINT signers_pkey PRIMARY KEY (accountid, publickey);


--
-- Name: storestate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY storestate
    ADD CONSTRAINT storestate_pkey PRIMARY KEY (statename);


--
-- Name: trustlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trustlines
    ADD CONSTRAINT trustlines_pkey PRIMARY KEY (accountid, issuer, assetcode);


--
-- Name: txhistory_ledgerseq_txindex_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_ledgerseq_txindex_key UNIQUE (ledgerseq, txindex);


--
-- Name: txhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_pkey PRIMARY KEY (txid, ledgerseq);


--
-- Name: accountbalances; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountbalances ON accounts USING btree (balance);


--
-- Name: accountlines; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountlines ON trustlines USING btree (accountid);


--
-- Name: buyingissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX buyingissuerindex ON offers USING btree (buyingissuer);


--
-- Name: ledgersbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ledgersbyseq ON ledgerheaders USING btree (ledgerseq);


--
-- Name: priceindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX priceindex ON offers USING btree (price);


--
-- Name: sellingissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sellingissuerindex ON offers USING btree (sellingissuer);


--
-- Name: signersaccount; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX signersaccount ON signers USING btree (accountid);


--
-- PostgreSQL database dump complete
--
