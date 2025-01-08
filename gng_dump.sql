--
-- PostgreSQL database dump
--

-- Dumped from database version 10.23 (Ubuntu 10.23-0ubuntu0.18.04.2+esm1)
-- Dumped by pg_dump version 12.18 (Ubuntu 12.18-0ubuntu0.20.04.1)

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

SET default_tablespace = '';

--
-- Name: accrue; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.accrue (
    event_id character varying(40),
    expense_id character varying(40)
);


ALTER TABLE public.accrue OWNER TO c370_s134;

--
-- Name: annotations; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.annotations (
    annotation_id integer NOT NULL,
    related_id character varying(40),
    related_type character varying(40),
    note text,
    date_added timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.annotations OWNER TO c370_s134;

--
-- Name: annotations_annotation_id_seq; Type: SEQUENCE; Schema: public; Owner: c370_s134
--

CREATE SEQUENCE public.annotations_annotation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.annotations_annotation_id_seq OWNER TO c370_s134;

--
-- Name: annotations_annotation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s134
--

ALTER SEQUENCE public.annotations_annotation_id_seq OWNED BY public.annotations.annotation_id;


--
-- Name: campaign; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.campaign (
    campaign_id character varying(40) NOT NULL,
    budget real,
    name character varying(255),
    startdate character varying(40),
    enddate character varying(40)
);


ALTER TABLE public.campaign OWNER TO c370_s134;

--
-- Name: donor; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.donor (
    member_id character varying(40) NOT NULL,
    donation_id character varying(40),
    amount real
);


ALTER TABLE public.donor OWNER TO c370_s134;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.employee (
    member_id character varying(40) NOT NULL,
    "position" character varying(40),
    salary real
);


ALTER TABLE public.employee OWNER TO c370_s134;

--
-- Name: event; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.event (
    event_id character varying(20) NOT NULL,
    name character varying(40),
    "Profit/Loss" real,
    type character varying(40),
    location character varying(40),
    date character varying(40)
);


ALTER TABLE public.event OWNER TO c370_s134;

--
-- Name: execute; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.execute (
    event_id character(40),
    volunteer_id character(40)
);


ALTER TABLE public.execute OWNER TO c370_s134;

--
-- Name: executes; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.executes (
    event_id character varying(40),
    volunteer_id character varying(40)
);


ALTER TABLE public.executes OWNER TO c370_s134;

--
-- Name: expenses; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.expenses (
    expense_id character varying(40) NOT NULL,
    type character varying(40),
    amount real
);


ALTER TABLE public.expenses OWNER TO c370_s134;

--
-- Name: fundedby; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.fundedby (
    campaign_id character varying(40),
    donor_id character varying(40)
);


ALTER TABLE public.fundedby OWNER TO c370_s134;

--
-- Name: member; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.member (
    member_id character varying(40) NOT NULL,
    name character varying(40),
    contact character varying(40)
);


ALTER TABLE public.member OWNER TO c370_s134;

--
-- Name: organize; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.organize (
    campaign_id character varying(40),
    phase_number integer,
    event_id character varying(40)
);


ALTER TABLE public.organize OWNER TO c370_s134;

--
-- Name: phases; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.phases (
    phase_number integer NOT NULL
);


ALTER TABLE public.phases OWNER TO c370_s134;

--
-- Name: plans; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.plans (
    campaign_id character varying(40),
    employee_id character varying(40)
);


ALTER TABLE public.plans OWNER TO c370_s134;

--
-- Name: tracks; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.tracks (
    website character varying(20),
    phase_number integer
);


ALTER TABLE public.tracks OWNER TO c370_s134;

--
-- Name: volunteer; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.volunteer (
    member_id character varying(40) NOT NULL,
    tier character varying(40)
);


ALTER TABLE public.volunteer OWNER TO c370_s134;

--
-- Name: website; Type: TABLE; Schema: public; Owner: c370_s134
--

CREATE TABLE public.website (
    page_name character varying(20) NOT NULL,
    status character varying(40),
    name character varying(40)
);


ALTER TABLE public.website OWNER TO c370_s134;

--
-- Name: annotations annotation_id; Type: DEFAULT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.annotations ALTER COLUMN annotation_id SET DEFAULT nextval('public.annotations_annotation_id_seq'::regclass);


--
-- Data for Name: accrue; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.accrue (event_id, expense_id) FROM stdin;
001_Event1	0000000001
001_Event2	0000000002
001_Event3	0000000003
001_Event4	0000000004
002_Event1	0000000005
002_Event2	0000000006
002_Event3	0000000007
002_Event4	0000000001
003_Event1	0000000002
003_Event2	0000000003
004_Event1	0000000004
004_Event2	0000000005
004_Event3	0000000006
\.


--
-- Data for Name: annotations; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.annotations (annotation_id, related_id, related_type, note, date_added) FROM stdin;
1	00000001	Member	This is a note related to a member.	2024-04-08 21:26:41.40965
2	001_Campaign	Campaign	This note pertains to a specific campaign.	2024-04-08 21:26:41.40965
3	002_Event	Event	An important note regarding an event.	2024-04-08 21:26:41.40965
4	00000002	Member	Another note related to a different member.	2024-04-08 21:26:41.40965
5	003_Event	Event	Further details on another event.	2024-04-08 21:26:41.40965
6	002_Campaign	Campaign	Campaign details needing attention.	2024-04-08 21:26:41.40965
7	00000003	Member	Note about another member's contribution.	2024-04-08 21:26:41.40965
8	004_Event	Event	Insights about this particular event.	2024-04-08 21:26:41.40965
9	00000001	Member	Cool guy!	2024-04-08 21:32:57.571763
10	00000001	Member	Nice guy	2024-04-08 22:54:04.041016
11	003_Event1	Event	Great weather	2024-04-08 22:54:09.898829
\.


--
-- Data for Name: campaign; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.campaign (campaign_id, budget, name, startdate, enddate) FROM stdin;
001	100	Making the world a better place	January 1st, 2024	January 31st, 2024
002	1000	Taking action, getting results	February 1st, 2024	February 28th, 2024
003	10000	Results with resolve	March 1st, 2024	March 31st, 2024
004	10000	You want great results, We wants great resolve	April 1st, 2024	April 30th, 2024
\.


--
-- Data for Name: donor; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.donor (member_id, donation_id, amount) FROM stdin;
00000014	00001	50
00000015	00002	100000
00000016	00003	750
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.employee (member_id, "position", salary) FROM stdin;
00000009	Manager	27000
00000010	Team Lead	21000
00000011	Accountant	32000
00000012	Recruiter	17000
00000013	CEO	100000
\.


--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.event (event_id, name, "Profit/Loss", type, location, date) FROM stdin;
001_Event1	Charity Fundraiser	5000	Fundraiser	Riverock Casino	January 5th, 2024
001_Event2	Community Cleanup	-200	Cleanup	Garry Point Park	January 12th, 2024
001_Event3	Education Seminar	800	Seminar	Southarm Community Centre	January 20th, 2024
001_Event4	Volunteer Appreciation Dinner	1500	Dinner	The Buck & Ear	January 28th, 2024
002_Event1	Workshop on Recycling	1200	Workshop	Richmond Centre	February 5th, 2024
002_Event2	Environmental Cleanup Day	-300	Cleanup	Iona Beach	February 12th, 2024
002_Event3	Tree Planting Initiative	600	Planting	Steveston Park	February 20th, 2024
002_Event4	Nature Expo	2500	Expo	West Richmond Community Centre	February 26th, 2024
003_Event1	Community Health Day	3000	Awareness	Catch Kitchen & Bar	March 5th, 2024
003_Event2	Blood Donation Drive	-500	Donation Drive	Ironwood Plaza	March 12th, 2024
004_Event1	Technology Expo	4000	Expo	Steveston Library	April 5th, 2024
004_Event2	Coding Bootcamp	-1500	Bootcamp	City of Richmond IT Department	April 12th, 2024
004_Event3	Coding in Java	2500	Lecture	University of Victoria	April 20th, 2024
001_Event15	Ched	50	Booze	Vegas	2024-07-17
001_Event8	Party	\N	\N	\N	2024-07-17
003_Event17	Swim	25	Fundraiser	Richmond	2024-03-03
001_Event14	Pool Party	900	Charity	Richmond	2024-04-19
001_Event21	Kyle Bday	-556	Birthday	Vancouver	2024-07-06
001_Event27	Blake	500	Gamer	GamerTown	2024-06-10 00:00:00
001_Event29	bart	555	party	local	April 04, 2024
\.


--
-- Data for Name: execute; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.execute (event_id, volunteer_id) FROM stdin;
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
001_Event1                              	00000001                                
001_Event2                              	00000002                                
001_Event3                              	00000003                                
001_Event4                              	00000004                                
002_Event1                              	00000005                                
002_Event2                              	00000006                                
002_Event3                              	00000007                                
002_Event4                              	00000008                                
003_Event1                              	00000001                                
003_Event2                              	00000002                                
004_Event1                              	00000003                                
004_Event2                              	00000004                                
004_Event3                              	00000005                                
\.


--
-- Data for Name: executes; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.executes (event_id, volunteer_id) FROM stdin;
001_Event1	00000001
001_Event2	00000002
001_Event3	00000003
001_Event4	00000004
002_Event1	00000005
002_Event2	00000006
002_Event3	00000007
002_Event4	00000008
003_Event1	00000001
003_Event2	00000002
004_Event1	00000003
004_Event2	00000004
004_Event3	00000005
001_Event1	00000001
003_Event17	01010101
\.


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.expenses (expense_id, type, amount) FROM stdin;
0000000001	Markers	75
0000000002	Salaries	220000
0000000003	Rent	3650
0000000004	Paper	250
0000000005	Internet	150
0000000006	Advertisements	500
0000000007	Maintenance	200
\.


--
-- Data for Name: fundedby; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.fundedby (campaign_id, donor_id) FROM stdin;
001	00000014
002	00000015
003	00000016
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.member (member_id, name, contact) FROM stdin;
00000001	Blake Stewart	778-968-1544
00000002	Emily Johnson	604-123-4567
00000003	Michael Smith	778-555-9876
00000004	Sarah Lee	604-789-1234
00000005	David Brown	778-222-3333
00000006	Emma Wilson	604-987-6543
00000007	Daniel Taylor	778-111-2222
00000008	Olivia Martinez	604-333-4444
00000009	Sophia Anderson	778-999-8888
00000010	Matthew Wilson	604-777-6666
00000011	Ava Thompson	778-444-3333
00000012	Noah White	604-222-1111
00000013	Grace Garcia	778-888-9999
00000014	Ethan Smith	604-111-2222
00000015	Sophie Johnson	778-333-4444
00000016	Liam Brown	604-555-6666
12345678	Blake	1758937592
11110000	Jim	123-123-1222
01010101	Bo	123-123-1244
\.


--
-- Data for Name: organize; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.organize (campaign_id, phase_number, event_id) FROM stdin;
001	1	001_Event1
001	2	001_Event2
001	3	001_Event3
001	4	001_Event4
002	1	002_Event1
002	2	002_Event2
002	3	002_Event3
002	4	002_Event4
001	\N	001_Event1
001	\N	001_Event8
003	\N	003_Event17
\.


--
-- Data for Name: phases; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.phases (phase_number) FROM stdin;
1
2
3
4
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.plans (campaign_id, employee_id) FROM stdin;
001	00000009
001	00000010
001	00000011
001	00000012
002	00000009
002	00000010
002	00000011
002	00000012
003	00000009
003	00000010
003	00000011
003	00000012
004	00000009
004	00000010
004	00000011
004	00000012
\.


--
-- Data for Name: tracks; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.tracks (website, phase_number) FROM stdin;
Home	1
Home	2
Home	3
Home	4
About	1
About	2
About	3
About	4
Services	1
Services	2
Services	3
Services	4
Contact	1
Contact	2
Contact	3
Contact	4
Campaigns	1
Campaigns	2
Campaigns	3
Campaigns	4
Campaign Phases	1
Campaign Phases	2
Campaign Phases	3
Campaign Phases	4
\.


--
-- Data for Name: volunteer; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.volunteer (member_id, tier) FROM stdin;
00000001	Veteran
00000002	Rookie
00000003	Rookie
00000004	Veteran
00000005	Rookie
00000006	Veteran
00000007	Veteran
00000008	Veteran
12345678	New
11110000	New
01010101	New
\.


--
-- Data for Name: website; Type: TABLE DATA; Schema: public; Owner: c370_s134
--

COPY public.website (page_name, status, name) FROM stdin;
Home	Active	Green-not-Greed
About	Active	Green-not-Greed
Services	Inactive	Green-not-Greed
Contact	Pending	Green-not-Greed
Campaigns	Active	Green-not-Greed
Campaign Phases	Active	Green-not-Greed
\.


--
-- Name: annotations_annotation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s134
--

SELECT pg_catalog.setval('public.annotations_annotation_id_seq', 11, true);


--
-- Name: annotations annotations_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.annotations
    ADD CONSTRAINT annotations_pkey PRIMARY KEY (annotation_id);


--
-- Name: campaign campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.campaign
    ADD CONSTRAINT campaign_pkey PRIMARY KEY (campaign_id);


--
-- Name: donor donor_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.donor
    ADD CONSTRAINT donor_pkey PRIMARY KEY (member_id);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (member_id);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (event_id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (expense_id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (member_id);


--
-- Name: phases phases_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.phases
    ADD CONSTRAINT phases_pkey PRIMARY KEY (phase_number);


--
-- Name: volunteer volunteer_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.volunteer
    ADD CONSTRAINT volunteer_pkey PRIMARY KEY (member_id);


--
-- Name: website website_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.website
    ADD CONSTRAINT website_pkey PRIMARY KEY (page_name);


--
-- Name: accrue accrue_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.accrue
    ADD CONSTRAINT accrue_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(event_id);


--
-- Name: accrue accrue_expense_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.accrue
    ADD CONSTRAINT accrue_expense_id_fkey FOREIGN KEY (expense_id) REFERENCES public.expenses(expense_id);


--
-- Name: donor donor_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.donor
    ADD CONSTRAINT donor_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.member(member_id);


--
-- Name: employee employee_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.member(member_id);


--
-- Name: executes executes_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.executes
    ADD CONSTRAINT executes_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(event_id);


--
-- Name: executes executes_volunteer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.executes
    ADD CONSTRAINT executes_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteer(member_id);


--
-- Name: fundedby fundedby_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.fundedby
    ADD CONSTRAINT fundedby_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaign(campaign_id);


--
-- Name: fundedby fundedby_donor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.fundedby
    ADD CONSTRAINT fundedby_donor_id_fkey FOREIGN KEY (donor_id) REFERENCES public.donor(member_id);


--
-- Name: organize organize_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.organize
    ADD CONSTRAINT organize_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaign(campaign_id);


--
-- Name: organize organize_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.organize
    ADD CONSTRAINT organize_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(event_id);


--
-- Name: organize organize_phase_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.organize
    ADD CONSTRAINT organize_phase_number_fkey FOREIGN KEY (phase_number) REFERENCES public.phases(phase_number);


--
-- Name: plans plans_campaign_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES public.campaign(campaign_id);


--
-- Name: plans plans_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(member_id);


--
-- Name: tracks tracks_phase_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_phase_number_fkey FOREIGN KEY (phase_number) REFERENCES public.phases(phase_number);


--
-- Name: tracks tracks_website_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_website_fkey FOREIGN KEY (website) REFERENCES public.website(page_name);


--
-- Name: volunteer volunteer_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s134
--

ALTER TABLE ONLY public.volunteer
    ADD CONSTRAINT volunteer_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.member(member_id);


--
-- PostgreSQL database dump complete
--

