--
-- PostgreSQL database dump
--

-- Dumped from database version 14.15
-- Dumped by pg_dump version 14.15

-- Started on 2025-05-18 20:06:33

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

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 24833)
-- Name: Catalogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Catalogs" (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    value character varying(255) NOT NULL,
    text character varying(255),
    description text,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Catalogs" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24839)
-- Name: Catalogs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Catalogs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Catalogs_id_seq" OWNER TO postgres;

--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 220
-- Name: Catalogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Catalogs_id_seq" OWNED BY public."Catalogs".id;


--
-- TOC entry 221 (class 1259 OID 24840)
-- Name: Comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Comments" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "postId" integer NOT NULL,
    content text NOT NULL,
    "parentComment" integer,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Comments" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24846)
-- Name: Comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Comments_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Comments_id_seq" OWNER TO postgres;

--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 222
-- Name: Comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Comments_id_seq" OWNED BY public."Comments".id;


--
-- TOC entry 223 (class 1259 OID 24847)
-- Name: Contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Contracts" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "roomId" integer NOT NULL,
    "expiredAt" timestamp with time zone NOT NULL,
    "preMoney" double precision NOT NULL,
    notes character varying(255),
    "stayNumber" integer NOT NULL,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Contracts" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24851)
-- Name: Contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Contracts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Contracts_id_seq" OWNER TO postgres;

--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 224
-- Name: Contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Contracts_id_seq" OWNED BY public."Contracts".id;


--
-- TOC entry 225 (class 1259 OID 24852)
-- Name: Convenients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Convenients" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    image character varying(255) NOT NULL,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Convenients" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24858)
-- Name: Convenients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Convenients_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Convenients_id_seq" OWNER TO postgres;

--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 226
-- Name: Convenients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Convenients_id_seq" OWNED BY public."Convenients".id;


--
-- TOC entry 227 (class 1259 OID 24859)
-- Name: IndexCounters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."IndexCounters" (
    id integer NOT NULL,
    "roomId" integer NOT NULL,
    electric double precision DEFAULT '0'::double precision NOT NULL,
    water double precision DEFAULT '0'::double precision NOT NULL,
    caps boolean DEFAULT false,
    internet boolean DEFAULT false,
    date timestamp with time zone NOT NULL,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "isPayment" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."IndexCounters" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24868)
-- Name: IndexCounters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."IndexCounters_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."IndexCounters_id_seq" OWNER TO postgres;

--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 228
-- Name: IndexCounters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."IndexCounters_id_seq" OWNED BY public."IndexCounters".id;


--
-- TOC entry 229 (class 1259 OID 24869)
-- Name: Payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Payments" (
    id integer NOT NULL,
    "userId" integer,
    "roomId" integer,
    total integer,
    email character varying(255),
    status public."enum_Payments_status" DEFAULT 'Đang chờ'::public."enum_Payments_status",
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Payments" OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 24874)
-- Name: Payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Payments_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Payments_id_seq" OWNER TO postgres;

--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 230
-- Name: Payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Payments_id_seq" OWNED BY public."Payments".id;


--
-- TOC entry 231 (class 1259 OID 24875)
-- Name: Posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Posts" (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    star double precision DEFAULT '0'::double precision,
    address character varying(255) NOT NULL,
    "catalogId" integer NOT NULL,
    description text NOT NULL,
    "postedBy" integer NOT NULL,
    images text NOT NULL,
    views integer DEFAULT 0,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Posts" OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 24883)
-- Name: Posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Posts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Posts_id_seq" OWNER TO postgres;

--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 232
-- Name: Posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Posts_id_seq" OWNED BY public."Posts".id;


--
-- TOC entry 233 (class 1259 OID 24884)
-- Name: Profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Profiles" (
    id integer NOT NULL,
    "firstName" character varying(255),
    "lastName" character varying(255),
    email character varying(255),
    birthday timestamp with time zone,
    "CID" character varying(255),
    address character varying(255),
    gender public."enum_Profiles_gender" DEFAULT 'Khác'::public."enum_Profiles_gender",
    image character varying(255),
    "userId" integer NOT NULL,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Profiles" OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 24891)
-- Name: Profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Profiles_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Profiles_id_seq" OWNER TO postgres;

--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 234
-- Name: Profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Profiles_id_seq" OWNED BY public."Profiles".id;


--
-- TOC entry 235 (class 1259 OID 24892)
-- Name: Ratings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Ratings" (
    id integer NOT NULL,
    "postId" integer NOT NULL,
    content text,
    score double precision NOT NULL,
    "userId" integer NOT NULL,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Ratings" OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 24898)
-- Name: Ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Ratings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Ratings_id_seq" OWNER TO postgres;

--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 236
-- Name: Ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Ratings_id_seq" OWNED BY public."Ratings".id;


--
-- TOC entry 237 (class 1259 OID 24899)
-- Name: RequestRooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RequestRooms" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "priceRange" character varying(255),
    location character varying(255),
    "specialRequirements" text,
    "financialLimit" character varying(255),
    "numberOfPeople" integer,
    "numberOfVehicles" integer,
    "contactInfo" character varying(255),
    "isActive" boolean DEFAULT true,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."RequestRooms" OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 24907)
-- Name: RequestRooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."RequestRooms_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."RequestRooms_id_seq" OWNER TO postgres;

--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 238
-- Name: RequestRooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."RequestRooms_id_seq" OWNED BY public."RequestRooms".id;


--
-- TOC entry 239 (class 1259 OID 24908)
-- Name: Role_Users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Role_Users" (
    id integer NOT NULL,
    "userId" integer,
    "roleCode" character varying(255),
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Role_Users" OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 24912)
-- Name: Role_Users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Role_Users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Role_Users_id_seq" OWNER TO postgres;

--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 240
-- Name: Role_Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Role_Users_id_seq" OWNED BY public."Role_Users".id;


--
-- TOC entry 241 (class 1259 OID 24913)
-- Name: Roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Roles" (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    value character varying(255) NOT NULL,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Roles" OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 24919)
-- Name: Roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Roles_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Roles_id_seq" OWNER TO postgres;

--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 242
-- Name: Roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Roles_id_seq" OWNED BY public."Roles".id;


--
-- TOC entry 243 (class 1259 OID 24920)
-- Name: Room_Convenients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Room_Convenients" (
    id integer NOT NULL,
    "roomId" integer,
    "convenientId" integer,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Room_Convenients" OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 24924)
-- Name: Room_Convenients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Room_Convenients_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Room_Convenients_id_seq" OWNER TO postgres;

--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 244
-- Name: Room_Convenients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Room_Convenients_id_seq" OWNED BY public."Room_Convenients".id;


--
-- TOC entry 245 (class 1259 OID 24925)
-- Name: Rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Rooms" (
    id integer NOT NULL,
    "postId" integer NOT NULL,
    title character varying(255) NOT NULL,
    price double precision NOT NULL,
    area double precision NOT NULL,
    "stayMax" integer NOT NULL,
    "position" public."enum_Rooms_position" DEFAULT 'Còn trống'::public."enum_Rooms_position",
    "electricPrice" character varying(255) DEFAULT 0,
    "waterPrice" character varying(255) DEFAULT 0,
    "capsPrice" character varying(255) DEFAULT 0,
    "internetPrice" character varying(255) DEFAULT 0,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Rooms" OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 24936)
-- Name: Rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Rooms_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Rooms_id_seq" OWNER TO postgres;

--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 246
-- Name: Rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Rooms_id_seq" OWNED BY public."Rooms".id;


--
-- TOC entry 247 (class 1259 OID 24937)
-- Name: SequelizeMeta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE public."SequelizeMeta" OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 24940)
-- Name: Users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Users" (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    phone character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    "resetTokenPassword" character varying(255),
    "resetTokenExpire" timestamp with time zone,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Users" OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 24946)
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Users_id_seq" OWNER TO postgres;

--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 249
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Users_id_seq" OWNED BY public."Users".id;


--
-- TOC entry 250 (class 1259 OID 24947)
-- Name: Wishlists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Wishlists" (
    id integer NOT NULL,
    "postId" integer NOT NULL,
    "userId" integer NOT NULL,
    "isDeleted" boolean DEFAULT false,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Wishlists" OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 24951)
-- Name: Wishlists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Wishlists_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Wishlists_id_seq" OWNER TO postgres;

--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 251
-- Name: Wishlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Wishlists_id_seq" OWNED BY public."Wishlists".id;


--
-- TOC entry 3243 (class 2604 OID 33049)
-- Name: Catalogs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Catalogs" ALTER COLUMN id SET DEFAULT nextval('public."Catalogs_id_seq"'::regclass);


--
-- TOC entry 3245 (class 2604 OID 33050)
-- Name: Comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comments" ALTER COLUMN id SET DEFAULT nextval('public."Comments_id_seq"'::regclass);


--
-- TOC entry 3247 (class 2604 OID 33051)
-- Name: Contracts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Contracts" ALTER COLUMN id SET DEFAULT nextval('public."Contracts_id_seq"'::regclass);


--
-- TOC entry 3249 (class 2604 OID 33052)
-- Name: Convenients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Convenients" ALTER COLUMN id SET DEFAULT nextval('public."Convenients_id_seq"'::regclass);


--
-- TOC entry 3256 (class 2604 OID 33053)
-- Name: IndexCounters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."IndexCounters" ALTER COLUMN id SET DEFAULT nextval('public."IndexCounters_id_seq"'::regclass);


--
-- TOC entry 3259 (class 2604 OID 33054)
-- Name: Payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Payments" ALTER COLUMN id SET DEFAULT nextval('public."Payments_id_seq"'::regclass);


--
-- TOC entry 3263 (class 2604 OID 33055)
-- Name: Posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Posts" ALTER COLUMN id SET DEFAULT nextval('public."Posts_id_seq"'::regclass);


--
-- TOC entry 3266 (class 2604 OID 33056)
-- Name: Profiles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profiles" ALTER COLUMN id SET DEFAULT nextval('public."Profiles_id_seq"'::regclass);


--
-- TOC entry 3268 (class 2604 OID 33057)
-- Name: Ratings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ratings" ALTER COLUMN id SET DEFAULT nextval('public."Ratings_id_seq"'::regclass);


--
-- TOC entry 3272 (class 2604 OID 33058)
-- Name: RequestRooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RequestRooms" ALTER COLUMN id SET DEFAULT nextval('public."RequestRooms_id_seq"'::regclass);


--
-- TOC entry 3274 (class 2604 OID 33059)
-- Name: Role_Users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Role_Users" ALTER COLUMN id SET DEFAULT nextval('public."Role_Users_id_seq"'::regclass);


--
-- TOC entry 3276 (class 2604 OID 33060)
-- Name: Roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Roles" ALTER COLUMN id SET DEFAULT nextval('public."Roles_id_seq"'::regclass);


--
-- TOC entry 3278 (class 2604 OID 33061)
-- Name: Room_Convenients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Room_Convenients" ALTER COLUMN id SET DEFAULT nextval('public."Room_Convenients_id_seq"'::regclass);


--
-- TOC entry 3285 (class 2604 OID 33062)
-- Name: Rooms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rooms" ALTER COLUMN id SET DEFAULT nextval('public."Rooms_id_seq"'::regclass);


--
-- TOC entry 3287 (class 2604 OID 33063)
-- Name: Users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users" ALTER COLUMN id SET DEFAULT nextval('public."Users_id_seq"'::regclass);


--
-- TOC entry 3289 (class 2604 OID 33064)
-- Name: Wishlists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Wishlists" ALTER COLUMN id SET DEFAULT nextval('public."Wishlists_id_seq"'::regclass);


--
-- TOC entry 3471 (class 0 OID 24833)
-- Dependencies: 219
-- Data for Name: Catalogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Catalogs" (id, slug, value, text, description, "isDeleted", "createdAt", "updatedAt") FROM stdin;
1	trang-chu	Trang chủ	Tìm kiếm chỗ thuê ưng ý	Kênh thông tin Phòng trọ số 1 Việt Nam - Website đăng tin cho thuê phòng trọ, nhà nguyên căn, căn hộ, ở ghép nhanh, hiệu quả với 100.000+ tin đăng và 2.500.000 lượt xem mỗi tháng.	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
2	cho-thue-phong-tro	Cho thuê phòng trọ	Tho Thuê Phòng Trọ, Giá Rẻ, Tiện Nghi, Mới Nhất	Kênh thông tin Phòng trọ số 1 Việt Nam - Website đăng tin cho thuê phòng trọ, nhà nguyên căn, căn hộ, ở ghép nhanh, hiệu quả với 100.000+ tin đăng và 2.500.000 lượt xem mỗi tháng.	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
3	cho-thue-can-ho	Cho thuê căn hộ	Cho Thuê Căn Hộ Chung Cư, Giá Rẻ, View Đẹp, Mới Nhất	Cho thuê căn hộ - Kênh đăng tin cho thuê căn hộ số 1: giá rẻ, chính chủ, đầy đủ tiện nghi. Cho thuê chung cư với nhiều mức giá, diện tích cho thuê khác nhau.	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
4	tim-nguoi-o-ghep	Tìm người ở ghép	Tìm người ở ghép	Kênh thông tin Phòng trọ số 1 Việt Nam - Website đăng tin cho thuê phòng trọ, nhà nguyên căn, căn hộ, ở ghép nhanh, hiệu quả với 100.000+ tin đăng và 2.500.000 lượt xem mỗi tháng.	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
6	yeu-cau-tim-phong	Yêu cầu tìm phòng	Yêu cầu tìm phòng	yêu cầu tìm phòng thường được sử dụng trong các ứng dụng, hệ thống hoặc trang web để người dùng có thể tìm kiếm và yêu cầu đặt phòng	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
\.


--
-- TOC entry 3473 (class 0 OID 24840)
-- Dependencies: 221
-- Data for Name: Comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Comments" (id, "userId", "postId", content, "parentComment", "isDeleted", "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 3475 (class 0 OID 24847)
-- Dependencies: 223
-- Data for Name: Contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Contracts" (id, "userId", "roomId", "expiredAt", "preMoney", notes, "stayNumber", "isDeleted", "createdAt", "updatedAt") FROM stdin;
11	19	65	2025-05-24 00:30:18.881-07	0	Payment from nguyenvana@gmail.com	1	f	2025-04-24 00:30:18.882-07	2025-04-24 00:30:18.882-07
13	19	78	2025-05-26 18:43:27.516-07	0	Payment from admin123@gmail.com	1	f	2025-04-26 18:43:27.52-07	2025-04-26 18:43:27.52-07
6	19	57	2025-06-06 07:40:18.994-07	0	Payment from nguyenvanduc2k3333@gmail.com	1	f	2025-05-06 07:40:18.994-07	2025-05-06 07:40:18.994-07
7	6	3	2025-06-11 07:01:25.687-07	0	Payment from duc@gmail.com	1	f	2025-05-11 07:01:25.698-07	2025-05-11 07:01:25.698-07
8	1	60	2025-06-16 09:36:37.632-07	0	Payment from nguyenvanduc2k3@gmail.com	1	f	2025-05-16 09:36:37.644-07	2025-05-16 09:36:37.644-07
9	9	62	2025-06-16 09:40:31.933-07	0	Payment from aa123@gmail.com	1	f	2025-05-16 09:40:31.934-07	2025-05-16 09:40:31.934-07
10	22	60	2025-06-17 03:52:21.682-07	0	Payment from nguyenvanduc2072003@gmail.com	1	f	2025-05-17 03:52:21.683-07	2025-05-17 03:52:21.683-07
\.


--
-- TOC entry 3477 (class 0 OID 24852)
-- Dependencies: 225
-- Data for Name: Convenients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Convenients" (id, name, image, "isDeleted", "createdAt", "updatedAt") FROM stdin;
1	Wifi miễn phí	/convenients/wifi.svg	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
2	Chỗ đỗ xe miễn phí	/convenients/parkcar.svg	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
3	Có máy giặt chung	/convenients/washing.svg	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
4	Điều hòa nhiệt độ	/convenients/conditioner.svg	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
\.


--
-- TOC entry 3479 (class 0 OID 24859)
-- Dependencies: 227
-- Data for Name: IndexCounters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."IndexCounters" (id, "roomId", electric, water, caps, internet, date, "isDeleted", "createdAt", "updatedAt", "isPayment") FROM stdin;
8	62	300	10	t	t	2025-04-24 17:00:00-07	f	2025-04-24 17:19:03.114-07	2025-04-24 17:19:28.807-07	t
9	65	100	16	t	t	2025-04-24 17:00:00-07	f	2025-04-24 22:20:14.033-07	2025-04-24 22:20:54.093-07	t
10	65	300	10	f	f	2025-04-24 17:00:00-07	f	2025-04-24 22:22:38.925-07	2025-04-24 22:24:52.257-07	t
1	59	100	10	f	f	2025-05-05 17:00:00-07	f	2025-05-06 07:08:36.201-07	2025-05-06 07:18:10.478-07	t
2	57	111	100	t	t	0011-11-10 16:07:02-07:52:58	f	2025-05-06 07:36:21.339-07	2025-05-06 07:37:08.52-07	t
3	57	10	100	t	t	0011-11-10 16:07:02-07:52:58	f	2025-05-06 07:40:59.451-07	2025-05-06 07:42:04.882-07	t
5	62	100	100	t	t	2025-05-24 17:00:00-07	f	2025-05-16 09:41:36.839-07	2025-05-16 09:42:38.429-07	t
4	60	10	100	t	t	2003-06-24 17:00:00-07	f	2025-05-16 09:39:06.507-07	2025-05-17 03:54:59.62-07	t
6	60	10	100	t	t	2025-05-16 17:00:00-07	f	2025-05-17 04:15:12.165-07	2025-05-17 04:15:12.165-07	f
\.


--
-- TOC entry 3481 (class 0 OID 24869)
-- Dependencies: 229
-- Data for Name: Payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Payments" (id, "userId", "roomId", total, email, status, "isDeleted", "createdAt", "updatedAt") FROM stdin;
59	19	65	4500000	nguyenvana@gmail.com	Thành công	f	2025-04-24 00:30:18.881-07	2025-04-24 00:30:37.572-07
60	19	62	3800000	nguyenvana@gmail.com	Thành công	f	2025-04-24 17:18:04.469-07	2025-04-24 17:18:23.349-07
61	\N	62	5200000	\N	Thành công	f	2025-04-24 17:19:28.809-07	2025-04-24 17:19:28.809-07
62	\N	65	5320000	\N	Thành công	f	2025-04-24 22:20:54.096-07	2025-04-24 22:20:54.096-07
63	\N	65	5900000	\N	Thành công	f	2025-04-24 22:24:52.26-07	2025-04-24 22:24:52.26-07
64	19	78	8000000	admin123@gmail.com	Đang chờ	f	2025-04-26 18:43:27.518-07	2025-04-26 18:43:27.518-07
1	1	57	2500000	nguyenvanduc2k3@gmail.com	Thành công	f	2025-05-06 07:00:18.974-07	2025-05-06 07:01:22.9-07
2	1	57	2500000	nguyenvanduc2k3@gmail.com	Thành công	f	2025-05-06 07:00:30.913-07	2025-05-06 07:01:22.9-07
3	1	59	3000000	duc@gmail.com	Thành công	f	2025-05-06 07:04:43.316-07	2025-05-06 07:05:17.595-07
4	1	64	1900000	nguyenvanduc2k3@gmail.com	Thành công	f	2025-05-06 07:06:44.621-07	2025-05-06 07:06:51.911-07
5	\N	59	3450000	\N	Thành công	f	2025-05-06 07:18:10.486-07	2025-05-06 07:18:10.486-07
6	1	57	2500000	asddsa@gmail.com	Thành công	f	2025-05-06 07:35:47.17-07	2025-05-06 07:35:56.06-07
7	\N	57	4423000	\N	Thành công	f	2025-05-06 07:37:08.525-07	2025-05-06 07:37:08.525-07
8	19	57	2500000	nguyenvanduc2k3333@gmail.com	Thành công	f	2025-05-06 07:40:18.994-07	2025-05-06 07:40:25.827-07
9	\N	57	4120000	\N	Thành công	f	2025-05-06 07:42:00.217-07	2025-05-06 07:42:00.217-07
10	\N	57	4120000	\N	Thành công	f	2025-05-06 07:42:04.894-07	2025-05-06 07:42:04.894-07
11	6	3	1000	duc@gmail.com	Đang chờ	f	2025-05-11 07:01:25.698-07	2025-05-11 07:01:25.698-07
12	1	60	3500000	nguyenvanduc2k3@gmail.com	Thành công	f	2025-05-16 09:36:37.643-07	2025-05-16 09:38:04.489-07
13	9	62	3800000	aa123@gmail.com	Thành công	f	2025-05-16 09:40:31.934-07	2025-05-16 09:40:55.336-07
14	\N	62	6200000	\N	Thành công	f	2025-05-16 09:42:38.437-07	2025-05-16 09:42:38.437-07
15	22	60	3500000	nguyenvanduc2072003@gmail.com	Thành công	f	2025-05-17 03:52:21.683-07	2025-05-17 03:52:48.238-07
16	\N	60	5590000	\N	Thành công	f	2025-05-17 03:54:59.623-07	2025-05-17 03:54:59.623-07
\.


--
-- TOC entry 3483 (class 0 OID 24875)
-- Dependencies: 231
-- Data for Name: Posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Posts" (id, title, star, address, "catalogId", description, "postedBy", images, views, "isDeleted", "createdAt", "updatedAt") FROM stdin;
32	Phòng trọ Bửu Long gần Đại học Lạc Hồng	5	Đường Nguyễn Du, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	2	<div style="max-width: 700px; margin: 20px auto; padding: 24px; border-radius: 12px; border: 1px solid #ddd; box-shadow: 0 4px 10px rgba(0,0,0,0.05); font-family: 'Segoe UI', sans-serif; background-color: #fff;">\n<h2 style="color: #24a772; margin-bottom: 8px;">Ph&ograve;ng trọ Bửu Long gần Đại học Lạc Hồng</h2>\n<p style="font-size: 16px; color: #555; margin: 0 0 12px;">Cần cho thu&ecirc; ph&ograve;ng trọ mới, sạch đẹp, nằm tại vị tr&iacute; đắc địa <strong>Đường Nguyễn Du, Phường Bửu Long, Th&agrave;nh phố Bi&ecirc;n H&ograve;a, Đồng Nai</strong> &ndash; ngay trung t&acirc;m khu vực sinh vi&ecirc;n v&agrave; d&acirc;n cư sầm uất, chỉ c&aacute;ch <strong>Đại học Lạc Hồng</strong> v&agrave;i ph&uacute;t đi xe m&aacute;y hoặc đi bộ.</p>\n<p style="font-size: 15px; color: #444; margin-bottom: 12px;">Ph&ograve;ng được thiết kế th&ocirc;ng tho&aacute;ng, đ&oacute;n nắng tự nhi&ecirc;n, c&oacute; cửa sổ rộng, đảm bảo kh&ocirc;ng gian sinh hoạt thoải m&aacute;i v&agrave; ri&ecirc;ng tư. Diện t&iacute;ch hợp l&yacute;, ph&ugrave; hợp với nhu cầu của sinh vi&ecirc;n hoặc người đi l&agrave;m đang t&igrave;m kiếm một nơi ở ổn định, sạch sẽ v&agrave; an to&agrave;n.</p>\n<ul style="list-style: none; padding-left: 0; font-size: 15px; color: #444; line-height: 1.8; margin-bottom: 20px;">\n<li>🏡 <strong>Kh&ocirc;ng gian:</strong> Tho&aacute;ng m&aacute;t, y&ecirc;n tĩnh, c&oacute; g&aacute;c lửng (nếu cần)</li>\n<li>🛏️ <strong>Nội thất:</strong> C&oacute; sẵn quạt, giường, tủ, wifi mạnh</li>\n<li>🚿 <strong>Tiện nghi:</strong> Toilet ri&ecirc;ng, bếp nấu, nước m&aacute;y</li>\n<li>🛵 <strong>Gửi xe:</strong> C&oacute; khu để xe trong nh&agrave; an to&agrave;n</li>\n<li>📍 <strong>Tiện &iacute;ch xung quanh:</strong> Gần chợ, qu&aacute;n ăn, si&ecirc;u thị mini, cafe, ph&ograve;ng gym</li>\n<li>🔐 <strong>An ninh:</strong> Khu vực d&acirc;n cư hiện hữu, camera gi&aacute;m s&aacute;t, kh&oacute;a cửa an to&agrave;n</li>\n<li>📶 <strong>Kết nối:</strong> Giao th&ocirc;ng thuận tiện, kết nối dễ d&agrave;ng c&aacute;c tuyến đường ch&iacute;nh</li>\n</ul>\n</div>	20	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745471932/rvcftct9kuybnbuxg5eb.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745471933/rhvzzkaxskgu4zrsidtx.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745471934/wabt6xws2s4lpkzo5lkn.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745471934/htbndrd1soye6uw1g8y9.jpg"]	20	f	2025-04-23 22:20:52.712-07	2025-05-17 03:57:01.172-07
33	Thuê phòng trọ giá rẻ gần ĐH Lạc Hồng, CAP Bửu Long	5	4d,kp3, Đường Nguyễn Đình Chiểu, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	2	<div style="max-width: 700px; margin: 24px auto; padding: 24px; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background-color: #fff; font-family: 'Segoe UI', sans-serif;">\n<h2 style="color: #24a772; margin-bottom: 12px;">Ph&ograve;ng trọ gi&aacute; rẻ gần Đại học Lạc Hồng &ndash; Bửu Long</h2>\n<p style="font-size: 16px; color: #555; margin-bottom: 12px;">Cho thu&ecirc; ph&ograve;ng trọ gi&aacute; rẻ, vị tr&iacute; thuận lợi tại <strong>4D, Khu phố 3, Đường Nguyễn Đ&igrave;nh Chiểu, Phường Bửu Long, TP. Bi&ecirc;n H&ograve;a, Đồng Nai</strong>. C&aacute;ch <strong>Đại học Lạc Hồng</strong> chỉ khoảng 3 ph&uacute;t đi xe, l&yacute; tưởng cho sinh vi&ecirc;n v&agrave; người đi l&agrave;m cần chỗ ở ổn định, tiết kiệm.</p>\n<p style="font-size: 15px; color: #444; margin-bottom: 12px;">Ph&ograve;ng nằm trong khu vực d&acirc;n cư an ninh, y&ecirc;n tĩnh, s&aacute;t chợ v&agrave; c&aacute;c tiện &iacute;ch hằng ng&agrave;y. Diện t&iacute;ch vừa đủ cho 1&ndash;2 người ở, c&oacute; kh&ocirc;ng gian sinh hoạt ri&ecirc;ng, tho&aacute;ng m&aacute;t v&agrave; dễ decor lại theo nhu cầu c&aacute; nh&acirc;n.</p>\n<ul style="list-style: none; padding-left: 0; font-size: 15px; color: #444; line-height: 1.8; margin-bottom: 16px;">\n<li>💰 <strong>Gi&aacute; thu&ecirc;:</strong> Cực kỳ hợp l&yacute;, ph&ugrave; hợp sinh vi&ecirc;n</li>\n<li>🛏️ <strong>Tiện nghi:</strong> C&oacute; sẵn wifi, chỗ để xe, khu vệ sinh ri&ecirc;ng</li>\n<li>🔌 <strong>Điện nước:</strong> T&iacute;nh theo gi&aacute; nh&agrave; nước hoặc đồng hồ ri&ecirc;ng</li>\n<li>📍 <strong>Khu vực:</strong> Gần chợ Bửu Long, tạp h&oacute;a, cafe, ph&ograve;ng gym</li>\n<li>🔐 <strong>An ninh:</strong> Khu d&acirc;n cư hiện hữu, y&ecirc;n tĩnh, an to&agrave;n</li>\n<li>🚶&zwj;♀️ <strong>Khoảng c&aacute;ch:</strong> 300m đến cổng Đại học Lạc Hồng</li>\n</ul>\n<p style="font-size: 14px; color: #888;">📌 Ưu ti&ecirc;n sinh vi&ecirc;n thu&ecirc; l&acirc;u d&agrave;i hoặc người đi l&agrave;m ổn định. Li&ecirc;n hệ trực tiếp để xem ph&ograve;ng (li&ecirc;n hệ ở phần m&ocirc; tả th&ecirc;m).</p>\n</div>	18	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745472276/bnuwhr7ixsiakdhqevgi.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745472277/wcsefygrdpelhkft01mn.jpg"]	12	f	2025-04-23 22:26:15.283-07	2025-05-17 04:21:49.345-07
31	Cho thuê phòng trọ mới xây 150m2 Bửu Long	0	Khu Phố 5, Phường Bửu long, Khu Văn Miếu Trấn Biên, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	2	<div style="max-width: 700px; margin: 20px auto; padding: 24px; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 12px rgba(0,0,0,0.05); font-family: 'Segoe UI', sans-serif; background-color: #fff;">\n<h2 style="color: #24a772; margin-bottom: 8px;">Cho thu&ecirc; nh&agrave; g&aacute;c lửng mới x&acirc;y 150m&sup2; &ndash; Bửu Long</h2>\n<p style="margin: 0; font-size: 16px; color: #666;">Khu Phố 5, P. Bửu Long, Khu Văn Miếu Trấn Bi&ecirc;n, TP. Bi&ecirc;n H&ograve;a, Đồng Nai</p>\n<hr style="margin: 16px 0; border: none; border-top: 1px solid #eee;">\n<div style="display: flex; flex-wrap: wrap; gap: 12px; font-size: 15px; color: #333;">\n<div><strong>Diện t&iacute;ch sử dụng:</strong> 150 m&sup2;</div>\n<div><strong>Diện t&iacute;ch đất:</strong> 100 m&sup2;</div>\n<div><strong>Ph&ograve;ng ngủ:</strong> 4 ph&ograve;ng</div>\n<div><strong>Ph&ograve;ng vệ sinh:</strong> 2 ph&ograve;ng</div>\n<div><strong>Tổng số tầng:</strong> 2 tầng</div>\n<div><strong>Chiều ngang:</strong> 5 m</div>\n<div><strong>Chiều d&agrave;i:</strong> 20 m</div>\n<div><strong>Hướng:</strong> Đ&ocirc;ng</div>\n<div><strong>Vị tr&iacute;:</strong> Nh&agrave; hẻm xe hơi</div>\n<div><strong>Ph&aacute;p l&yacute;:</strong> Giấy tờ viết tay</div>\n<div><strong>Nội thất:</strong> Đầy đủ</div>\n</div>\n</div>	18	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745471343/ehu1twv9ragwwbumzglx.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745471345/hexsyuepylshjucs8qex.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745471345/fnshmfkyltk9l82gezue.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745471346/xk750yxrsdjgbmu7ekxy.jpg"]	24	f	2025-04-23 22:10:45.098-07	2025-05-16 09:04:17.068-07
38	Cho thuê chung cư Bửu Long 2 phòng ngủ view đẹp an ninh tiện ích	0	Chung Cư, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	3	<div style="max-width: 700px; margin: 24px auto; padding: 24px; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background-color: #fff; font-family: 'Segoe UI', sans-serif;">\n<h2 style="color: #24a772; margin-bottom: 12px;">Cho thu&ecirc; chung cư Bửu Long &ndash; 2 ph&ograve;ng ngủ, view đẹp, an ninh, tiện &iacute;ch đầy đủ</h2>\n<p style="font-size: 16px; color: #555; margin-bottom: 12px;">Căn hộ cần cho thu&ecirc; thuộc khu <strong>chung cư Bửu Long</strong>, tọa lạc tại <strong>Phường Bửu Long, TP. Bi&ecirc;n H&ograve;a, Đồng Nai</strong>. Khu d&acirc;n cư hiện đại, y&ecirc;n tĩnh, d&acirc;n tr&iacute; cao &ndash; gần trường học, chợ, c&ocirc;ng vi&ecirc;n v&agrave; nhiều tiện &iacute;ch kh&aacute;c.</p>\n<p style="font-size: 15px; color: #444; margin-bottom: 12px;">Căn hộ c&oacute; <strong>2 ph&ograve;ng ngủ</strong>, diện t&iacute;ch tho&aacute;ng m&aacute;t, thiết kế mở, đặc biệt c&oacute; <strong>view đẹp từ ban c&ocirc;ng</strong>, đ&oacute;n gi&oacute; trời tự nhi&ecirc;n. Ph&ugrave; hợp cho gia đ&igrave;nh nhỏ, vợ chồng trẻ hoặc nh&acirc;n vi&ecirc;n l&agrave;m việc tại khu vực Bi&ecirc;n H&ograve;a.</p>\n<ul style="list-style: none; padding-left: 0; font-size: 15px; color: #444; line-height: 1.8; margin-bottom: 16px;">\n<li>🏡 <strong>Thiết kế:</strong> 2 ph&ograve;ng ngủ, ph&ograve;ng kh&aacute;ch, bếp, toilet ri&ecirc;ng, ban c&ocirc;ng</li>\n<li>🪟 <strong>View:</strong> Hướng nh&igrave;n đẹp, tho&aacute;ng m&aacute;t, &aacute;nh s&aacute;ng tự nhi&ecirc;n</li>\n<li>🛋️ <strong>Nội thất:</strong> C&oacute; thể thương lượng th&ecirc;m nếu thu&ecirc; d&agrave;i hạn</li>\n<li>❄️ <strong>Tiện nghi:</strong> C&oacute; thang m&aacute;y, chỗ đậu xe, bảo vệ 24/7</li>\n<li>🛒 <strong>Gần:</strong> Si&ecirc;u thị mini, chợ, cafe, trường học, khu vui chơi</li>\n<li>🔐 <strong>An ninh:</strong> Camera gi&aacute;m s&aacute;t, d&acirc;n cư hiện hữu, y&ecirc;n tĩnh</li>\n</ul>\n<p style="font-size: 14px; color: #888;">📌 Li&ecirc;n hệ để xem nh&agrave; thực tế. Ưu ti&ecirc;n kh&aacute;ch thu&ecirc; l&acirc;u d&agrave;i, thiện ch&iacute; &ndash; hỗ trợ dọn v&agrave;o nhanh ch&oacute;ng.</p>\n</div>	20	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745474388/xx9ivifb51h5dlk5pbes.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745474389/jffdqlonv9uxighp0opb.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745474389/yts38gm5k9rlwiq51c7p.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745474390/l9vhgkc9gedh6heb8j3f.jpg"]	0	f	2025-04-23 23:03:18.244-07	2025-04-23 23:03:18.244-07
39	Căn hộ ngay trường song ngữ lạc hồng	0	Đường Nguyễn Bỉnh Khiêm, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	3	<div style="max-width: 700px; margin: 24px auto; padding: 24px; border-radius: 12px; border: 1px solid #ddd; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background-color: #fff; font-family: 'Segoe UI', sans-serif;">\n<h2 style="color: #24a772; margin-bottom: 12px;">Căn hộ ngay Trường Song ngữ Lạc Hồng &ndash; Đầy đủ tiện nghi, v&agrave;o ở ngay</h2>\n<p style="font-size: 16px; color: #555; margin-bottom: 12px;">Cho thu&ecirc; căn hộ vị tr&iacute; cực kỳ thuận tiện, nằm ngay <strong>Trường Song ngữ Lạc Hồng</strong> &ndash; <strong>Đường Nguyễn Bỉnh Khi&ecirc;m, Phường Bửu Long, TP. Bi&ecirc;n H&ograve;a, Đồng Nai</strong>. Khu d&acirc;n cư y&ecirc;n tĩnh, an ninh tốt, ph&ugrave; hợp cho gi&aacute;o vi&ecirc;n, gia đ&igrave;nh nhỏ hoặc người đi l&agrave;m cần chỗ ở ổn định l&acirc;u d&agrave;i.</p>\n<p style="font-size: 15px; color: #444; margin-bottom: 12px;">Căn hộ được bố tr&iacute; hợp l&yacute;, th&ocirc;ng tho&aacute;ng, đầy đủ nội thất cơ bản. Diện t&iacute;ch ph&ugrave; hợp cho 1&ndash;2 người, c&oacute; ban c&ocirc;ng phơi đồ v&agrave; đ&oacute;n nắng. Chỉ cần x&aacute;ch vali v&agrave;o l&agrave; ở!</p>\n<ul style="list-style: none; padding-left: 0; font-size: 15px; color: #444; line-height: 1.8; margin-bottom: 16px;">\n<li>🛏️ <strong>1&ndash;2 ph&ograve;ng ngủ:</strong> C&oacute; giường, nệm, tủ quần &aacute;o</li>\n<li>🛋️ <strong>Ph&ograve;ng kh&aacute;ch:</strong> Sofa, b&agrave;n tr&agrave; nhỏ</li>\n<li>🍳 <strong>Bếp:</strong> Bếp gas hoặc điện, tủ bếp, bồn rửa</li>\n<li>🧺 <strong>Ban c&ocirc;ng:</strong> C&oacute; m&aacute;y giặt hoặc chỗ phơi đồ ri&ecirc;ng</li>\n<li>❄️ <strong>Tiện nghi:</strong> M&aacute;y lạnh, nước n&oacute;ng lạnh, wifi</li>\n<li>📍 <strong>Gần:</strong> Trường học, chợ, cửa h&agrave;ng tiện lợi, qu&aacute;n ăn, cafe</li>\n<li>🔐 <strong>An ninh:</strong> Khu d&acirc;n cư văn minh, y&ecirc;n tĩnh</li>\n</ul>\n<p style="font-size: 14px; color: #888;">📌 Gi&aacute; tốt &ndash; ưu ti&ecirc;n kh&aacute;ch thu&ecirc; ổn định, l&acirc;u d&agrave;i. C&oacute; hỗ trợ xem nh&agrave; trực tiếp trong giờ h&agrave;nh ch&iacute;nh.</p>\n</div>	18	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745474624/x1aopowqro8krbzfkfo2.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745474625/sknhylhhrvacknlwhrbe.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745474626/bpdveuoui5pa9ktfeujd.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745474627/co6oagmxetx4eukcllfl.jpg"]	1	f	2025-04-23 23:05:09.745-07	2025-05-12 05:43:23.774-07
37	CHO THUÊ CĂN HỘ CHUNG CƯ BỬU LONG – GIÁ TỐT 2 phòng ngủ 2 máy lạnh	0	Chung Cư Bửu Long, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	3	<div style="max-width: 700px; margin: 24px auto; padding: 24px; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background-color: #fff; font-family: 'Segoe UI', sans-serif;">\n<h2 style="color: #24a772; margin-bottom: 12px;">CHO THU&Ecirc; CĂN HỘ CHUNG CƯ BỬU LONG &ndash; GI&Aacute; TỐT, 2 PH&Ograve;NG NGỦ, 2 M&Aacute;Y LẠNH</h2>\n<p style="font-size: 16px; color: #555; margin-bottom: 12px;">Căn hộ cho thu&ecirc; tại <strong>Chung cư Bửu Long, Phường Bửu Long, TP. Bi&ecirc;n H&ograve;a, Đồng Nai</strong> &ndash; vị tr&iacute; trung t&acirc;m khu d&acirc;n cư an ninh, sạch sẽ, thuận tiện di chuyển đến c&aacute;c tuyến đường ch&iacute;nh, gần chợ, trường học v&agrave; si&ecirc;u thị.</p>\n<p style="font-size: 15px; color: #444; margin-bottom: 12px;">Thiết kế căn hộ hợp l&yacute; với <strong>2 ph&ograve;ng ngủ ri&ecirc;ng biệt</strong>, ph&ograve;ng kh&aacute;ch, khu bếp v&agrave; ban c&ocirc;ng đ&oacute;n gi&oacute;. Đặc biệt, đ&atilde; được trang bị sẵn <strong>2 m&aacute;y lạnh</strong>, nội thất cơ bản &ndash; người thu&ecirc; chỉ cần dọn v&agrave;o l&agrave; ở ngay, kh&ocirc;ng cần mua sắm th&ecirc;m.</p>\n<ul style="list-style: none; padding-left: 0; font-size: 15px; color: #444; line-height: 1.8; margin-bottom: 16px;">\n<li>🛏️ <strong>2 ph&ograve;ng ngủ:</strong> Rộng r&atilde;i, c&oacute; tủ v&agrave; giường cơ bản</li>\n<li>🛋️ <strong>Ph&ograve;ng kh&aacute;ch:</strong> S&aacute;ng sủa, kết nối với ban c&ocirc;ng</li>\n<li>❄️ <strong>M&aacute;y lạnh:</strong> C&oacute; sẵn 2 m&aacute;y lạnh cho ph&ograve;ng ngủ</li>\n<li>🍽️ <strong>Bếp:</strong> Tủ bếp tr&ecirc;n/dưới, bếp gas hoặc điện</li>\n<li>🚿 <strong>Toilet:</strong> Ri&ecirc;ng biệt, sạch sẽ, c&oacute; nước n&oacute;ng</li>\n<li>🚗 <strong>Chỗ để xe:</strong> Rộng r&atilde;i, c&oacute; bảo vệ</li>\n<li>📍 <strong>Tiện &iacute;ch xung quanh:</strong> Gần chợ Bửu Long, Vinmart, trường học, cafe</li>\n</ul>\n<p style="font-size: 14px; color: #888;">📌 Gi&aacute; thu&ecirc; hợp l&yacute; &ndash; ph&ugrave; hợp hộ gia đ&igrave;nh nhỏ, vợ chồng trẻ hoặc nh&acirc;n vi&ecirc;n c&ocirc;ng t&aacute;c l&acirc;u d&agrave;i tại Bi&ecirc;n H&ograve;a. Ưu ti&ecirc;n kh&aacute;ch thu&ecirc; ổn định, c&oacute; thể v&agrave;o ở ngay.</p>\n</div>	18	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745474241/zvuxnj4eg3qkrfgxjg6v.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745474242/vqy9unzbdg8fv24f3i89.jpg"]	3	f	2025-04-23 22:58:06.256-07	2025-05-16 08:40:21.455-07
42	Tìm người ở ghép nhà nguyên căn 1T2L gần ngay song ngữ Lạc Hồng	0	Gần Song Ngữ Lạc Hồng, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	4	<div style="max-width: 700px; margin: 24px auto; padding: 24px; border-radius: 12px; border: 1px solid #ddd; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background-color: #fff; font-family: 'Segoe UI', sans-serif;">\n<h2 style="color: #e67e22; margin-bottom: 12px;">T&igrave;m người ở gh&eacute;p &ndash; Nh&agrave; nguy&ecirc;n căn 1 trệt 2 lầu, gần Trường Song ngữ Lạc Hồng</h2>\n<p style="font-size: 16px; color: #555; margin-bottom: 12px;">Cần t&igrave;m 1&ndash;2 bạn ở gh&eacute;p tại <strong>nh&agrave; nguy&ecirc;n căn 1 trệt 2 lầu</strong>, vị tr&iacute; <strong>gần Trường Song ngữ Lạc Hồng</strong>, thuộc <strong>Phường Bửu Long, TP. Bi&ecirc;n H&ograve;a, Đồng Nai</strong>. Nh&agrave; rộng, thiết kế đẹp, khu d&acirc;n cư y&ecirc;n tĩnh, an ninh tốt.</p>\n<p style="font-size: 15px; color: #444; margin-bottom: 12px;">Nh&agrave; đang c&oacute; sẵn người ở, cần th&ecirc;m bạn để chia sẻ chi ph&iacute;. Kh&ocirc;ng gian sống văn minh, sạch sẽ, ri&ecirc;ng tư. Ưu ti&ecirc;n bạn sinh vi&ecirc;n hoặc người đi l&agrave;m gọn g&agrave;ng, h&ograve;a đồng.</p>\n<ul style="list-style: none; padding-left: 0; font-size: 15px; color: #444; line-height: 1.8; margin-bottom: 16px;">\n<li>🏡 <strong>Nh&agrave; nguy&ecirc;n căn:</strong> 1 trệt 2 lầu, ban c&ocirc;ng, s&acirc;n để xe</li>\n<li>🛏️ <strong>Ph&ograve;ng ngủ:</strong> C&oacute; sẵn nệm, tủ, quạt, cửa sổ tho&aacute;ng</li>\n<li>❄️ <strong>Tiện nghi:</strong> M&aacute;y lạnh, wifi mạnh, m&aacute;y giặt, bếp nấu chung</li>\n<li>🚿 <strong>WC:</strong> Ri&ecirc;ng biệt, sạch sẽ, nước m&aacute;y mạnh</li>\n<li>🔐 <strong>Giờ giấc tự do:</strong> Kh&ocirc;ng chung chủ</li>\n<li>📍 <strong>Gần:</strong> Song ngữ Lạc Hồng, chợ, qu&aacute;n ăn, mini mart</li>\n</ul>\n<p style="font-size: 14px; color: #888;">📌 Chi ph&iacute; share hợp l&yacute;: <strong>từ 1.2 &ndash; 1.5 triệu/người/th&aacute;ng</strong> đ&atilde; gồm điện, nước, wifi. C&oacute; thể dọn v&agrave;o ở ngay. Inbox/Zalo để xem ph&ograve;ng!</p>\n</div>	11	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745475375/plxgc1mm3twn5nuvjvqe.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745475376/ksrvdl4qlq8dcgbckuqb.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745475378/z6nlhhhim1xlygpaed1b.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745475379/vxh8lx7zrqwco5uez5a6.jpg"]	18	f	2025-04-23 23:17:05.46-07	2025-05-16 23:20:27.228-07
40	TÌM NGƯỜI Ở GHÉP NHÀ NGUYÊN CĂN PHƯỜNG BỬU LONG	0	Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	4	<div style="max-width: 700px; margin: 24px auto; padding: 24px; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background-color: #fff; font-family: 'Segoe UI', sans-serif;">\n<h2 style="color: #e67e22; margin-bottom: 12px;">T&Igrave;M NGƯỜI Ở GH&Eacute;P NH&Agrave; NGUY&Ecirc;N CĂN &ndash; PHƯỜNG BỬU LONG</h2>\n<p style="font-size: 16px; color: #555; margin-bottom: 12px;">M&igrave;nh cần t&igrave;m 1 bạn ở gh&eacute;p c&ugrave;ng trong <strong>nh&agrave; nguy&ecirc;n căn</strong> tại <strong>Phường Bửu Long, Th&agrave;nh phố Bi&ecirc;n H&ograve;a, Đồng Nai</strong>. Nh&agrave; rộng r&atilde;i, sạch sẽ, y&ecirc;n tĩnh, đ&atilde; c&oacute; đầy đủ tiện nghi, chỉ cần dọn v&agrave;o l&agrave; ở ngay.</p>\n<p style="font-size: 15px; color: #444; margin-bottom: 12px;">Hiện tại nh&agrave; c&oacute; 2 người (sinh vi&ecirc;n/đi l&agrave;m), cần th&ecirc;m 1 bạn ở gh&eacute;p để share chi ph&iacute;. Ưu ti&ecirc;n bạn gọn g&agrave;ng, lịch sự, t&ocirc;n trọng kh&ocirc;ng gian chung. M&ocirc;i trường sống l&agrave;nh mạnh, văn minh.</p>\n<ul style="list-style: none; padding-left: 0; font-size: 15px; color: #444; line-height: 1.8; margin-bottom: 16px;">\n<li>🏠 <strong>Nh&agrave; nguy&ecirc;n căn:</strong> 1 trệt 1 lầu, c&oacute; s&acirc;n để xe</li>\n<li>🛏️ <strong>Ph&ograve;ng:</strong> Rộng r&atilde;i, ri&ecirc;ng tư hoặc ngủ chung t&ugrave;y thỏa thuận</li>\n<li>❄️ <strong>Tiện nghi:</strong> M&aacute;y lạnh, m&aacute;y giặt, tủ lạnh, wifi mạnh</li>\n<li>🍽️ <strong>Bếp:</strong> C&oacute; sẵn đồ d&ugrave;ng nấu ăn, tủ bếp gọn g&agrave;ng</li>\n<li>🛁 <strong>WC:</strong> Nước m&aacute;y, sạch sẽ, c&oacute; nước n&oacute;ng</li>\n<li>🔐 <strong>Giờ giấc tự do:</strong> Kh&ocirc;ng chung chủ</li>\n<li>📍 <strong>Gần:</strong> Trường học, chợ, qu&aacute;n ăn, cafe</li>\n</ul>\n<p style="font-size: 14px; color: #888;">💬 Chi ph&iacute; share hợp l&yacute; &ndash; dao động khoảng <strong>1 &ndash; 1.2 triệu/người/th&aacute;ng</strong> bao gồm điện nước. Bạn n&agrave;o quan t&acirc;m th&igrave; inbox hoặc li&ecirc;n hệ để xem nh&agrave; nh&eacute;!</p>\n</div>	11	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745475143/hngbcklzhzmpf9i3so6p.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745475144/svfxraxmbjyvusg2jqmg.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745475145/qchvplcatdcxhkagsptp.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745475147/yidnkqzuwsjqejb7aytb.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745475150/stwedfivy8x0plbbato0.jpg"]	7	f	2025-04-23 23:13:33.823-07	2025-05-12 05:10:28.753-07
34	Cho thuê phòng trọ Khu dân cư Bửu Long	0	 Đường Nguyễn Ái Quốc, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	2	<div style="max-width: 700px; margin: 24px auto; padding: 24px; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background-color: #fff; font-family: 'Segoe UI', sans-serif;">\n<h2 style="color: #24a772; margin-bottom: 12px;">Cho thu&ecirc; ph&ograve;ng trọ khu d&acirc;n cư Bửu Long &ndash; Bi&ecirc;n H&ograve;a</h2>\n<p style="font-size: 16px; color: #555; margin-bottom: 12px;">Cần cho thu&ecirc; ph&ograve;ng trọ nằm ngay trong <strong>khu d&acirc;n cư Bửu Long</strong>, vị tr&iacute; mặt tiền <strong>Đường Nguyễn &Aacute;i Quốc, Phường Bửu Long, Th&agrave;nh phố Bi&ecirc;n H&ograve;a, Đồng Nai</strong>. Giao th&ocirc;ng thuận tiện, khu vực an ninh, sạch sẽ, gần chợ, gần trường học v&agrave; c&aacute;c tiện &iacute;ch hằng ng&agrave;y.</p>\n<p style="font-size: 15px; color: #444; margin-bottom: 12px;">Ph&ograve;ng rộng r&atilde;i, tho&aacute;ng m&aacute;t, được x&acirc;y dựng ki&ecirc;n cố, nền cao r&aacute;o, kh&ocirc;ng ngập &uacute;ng. Khu vực d&acirc;n cư hiện hữu, y&ecirc;n tĩnh, ph&ugrave; hợp cho sinh vi&ecirc;n, nh&acirc;n vi&ecirc;n văn ph&ograve;ng hoặc hộ gia đ&igrave;nh nhỏ đang t&igrave;m chỗ ở l&acirc;u d&agrave;i v&agrave; ổn định.</p>\n<ul style="list-style: none; padding-left: 0; font-size: 15px; color: #444; line-height: 1.8; margin-bottom: 16px;">\n<li>🏠 <strong>Diện t&iacute;ch:</strong> Nhiều lựa chọn từ 15&ndash;25m&sup2; (ph&ugrave; hợp 1&ndash;2 người)</li>\n<li>🛏️ <strong>Nội thất:</strong> C&oacute; sẵn wifi, quạt, toilet ri&ecirc;ng, khu bếp nấu</li>\n<li>🚪 <strong>Lối đi ri&ecirc;ng:</strong> Giờ giấc tự do, kh&ocirc;ng chung chủ</li>\n<li>🛵 <strong>Chỗ để xe:</strong> C&oacute; m&aacute;i che, an ninh 24/7</li>\n<li>📍 <strong>Tiện &iacute;ch:</strong> Gần chợ Bửu Long, si&ecirc;u thị mini, trạm xe bu&yacute;t, Đại học Lạc Hồng</li>\n<li>🔐 <strong>An ninh:</strong> Khu d&acirc;n cư c&oacute; camera, h&agrave;ng x&oacute;m th&acirc;n thiện</li>\n</ul>\n<p style="font-size: 14px; color: #888;">📌 Ưu ti&ecirc;n người thu&ecirc; d&agrave;i hạn, thu&ecirc; 2&ndash;3 th&aacute;ng c&oacute; thể thương lượng gi&aacute;. Li&ecirc;n hệ chủ nh&agrave; để biết chi tiết v&agrave; xem ph&ograve;ng trực tiếp.</p>\n</div>	20	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745472569/cxlrsxjpmd6cziklo4g3.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745472570/j52ajqwqdsgqqegg4dxy.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745472571/u7buekxj0i28agzpotco.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745472572/gcl44etopueolbk5sayy.jpg"]	4	f	2025-04-23 22:41:26.542-07	2025-05-16 09:26:19.165-07
35	Chung cư Bửu Long full nội thất 2PN có thể dọn vào ở ngay	0	 Nguyễn Bỉnh Khiêm, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	3	<div style="max-width: 700px; margin: 24px auto; padding: 24px; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background-color: #fff; font-family: 'Segoe UI', sans-serif;">\n<h2 style="color: #24a772; margin-bottom: 12px;">Chung cư Bửu Long &ndash; Full nội thất 2 ph&ograve;ng ngủ, dọn v&agrave;o ở ngay</h2>\n<p style="font-size: 16px; color: #555; margin-bottom: 12px;">Cần cho thu&ecirc; căn hộ chung cư đầy đủ nội thất cao cấp, tọa lạc tại <strong>đường Nguyễn Bỉnh Khi&ecirc;m, Phường Bửu Long, Th&agrave;nh phố Bi&ecirc;n H&ograve;a, Đồng Nai</strong>. Vị tr&iacute; trung t&acirc;m, giao th&ocirc;ng thuận tiện, gần trường học, si&ecirc;u thị, v&agrave; c&aacute;c tiện &iacute;ch cộng đồng.</p>\n<p style="font-size: 15px; color: #444; margin-bottom: 12px;">Căn hộ gồm <strong>2 ph&ograve;ng ngủ, 1 ph&ograve;ng kh&aacute;ch, bếp, ban c&ocirc;ng v&agrave; nh&agrave; vệ sinh ri&ecirc;ng</strong>. Diện t&iacute;ch rộng r&atilde;i, thiết kế tho&aacute;ng m&aacute;t, ph&ugrave; hợp cho hộ gia đ&igrave;nh nhỏ, cặp vợ chồng trẻ hoặc nh&acirc;n vi&ecirc;n văn ph&ograve;ng đang cần nơi ở tiện nghi để dọn v&agrave;o ngay m&agrave; kh&ocirc;ng cần sắm sửa th&ecirc;m.</p>\n<ul style="list-style: none; padding-left: 0; font-size: 15px; color: #444; line-height: 1.8; margin-bottom: 16px;">\n<li>🛏️ <strong>2 ph&ograve;ng ngủ:</strong> Đầy đủ giường, nệm, tủ quần &aacute;o</li>\n<li>🛋️ <strong>Ph&ograve;ng kh&aacute;ch:</strong> Sofa, b&agrave;n tr&agrave;, kệ tivi</li>\n<li>🍳 <strong>Bếp:</strong> Bếp &acirc;m, tủ bếp tr&ecirc;n/dưới, m&aacute;y h&uacute;t m&ugrave;i</li>\n<li>🧺 <strong>Ban c&ocirc;ng:</strong> C&oacute; sẵn m&aacute;y giặt, phơi đồ tho&aacute;ng gi&oacute;</li>\n<li>❄️ <strong>Tiện nghi kh&aacute;c:</strong> M&aacute;y lạnh, tivi, tủ lạnh, r&egrave;m cửa, wifi</li>\n<li>🚗 <strong>B&atilde;i xe:</strong> An ninh, c&oacute; m&aacute;i che</li>\n<li>📍 <strong>Tiện &iacute;ch khu vực:</strong> Gần chợ, trường, cafe, c&ocirc;ng vi&ecirc;n Văn Miếu Trấn Bi&ecirc;n</li>\n</ul>\n<p style="font-size: 14px; color: #888;">📌 Căn hộ sạch đẹp, v&agrave;o ở ngay &ndash; ưu ti&ecirc;n kh&aacute;ch thu&ecirc; d&agrave;i hạn. Li&ecirc;n hệ ch&iacute;nh chủ để biết th&ecirc;m th&ocirc;ng tin v&agrave; xem căn thực tế.</p>\n</div>	18	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745473707/ive2kuvrydtqm1xlnxz5.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745473708/lm0ortaeijdvxqvhpbob.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745473709/dtjpswlltzk1hrxyu6fd.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745473710/lo6zsnmj0qwrvnezxexs.jpg"]	1	f	2025-04-23 22:48:35.513-07	2025-05-06 06:15:17.007-07
41	Tìm người ở ghép nhà đẹp góc 2 mặt tiền 1T3L ngay song ngữ Lạc Hồng	0	Khu Dân Cư, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	4	<div style="max-width: 700px; margin: 24px auto; padding: 24px; border-radius: 12px; border: 1px solid #ddd; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background-color: #fff; font-family: 'Segoe UI', sans-serif;">\n<h2 style="color: #e67e22; margin-bottom: 12px;">T&Igrave;M NGƯỜI Ở GH&Eacute;P &ndash; NH&Agrave; ĐẸP G&Oacute;C 2 MẶT TIỀN 1 TRỆT 3 LẦU, GẦN SONG NGỮ LẠC HỒNG</h2>\n<p style="font-size: 16px; color: #555; margin-bottom: 12px;">Cần t&igrave;m người ở gh&eacute;p tại <strong>nh&agrave; nguy&ecirc;n căn 1 trệt 3 lầu</strong>, vị tr&iacute; cực đẹp <strong>g&oacute;c 2 mặt tiền</strong> ngay <strong>Trường Song ngữ Lạc Hồng</strong>, thuộc <strong>Khu d&acirc;n cư, Phường Bửu Long, TP. Bi&ecirc;n H&ograve;a, Đồng Nai</strong>.</p>\n<p style="font-size: 15px; color: #444; margin-bottom: 12px;">Nh&agrave; thiết kế hiện đại, kh&ocirc;ng gian sống tho&aacute;ng m&aacute;t, nhiều &aacute;nh s&aacute;ng tự nhi&ecirc;n, c&oacute; ban c&ocirc;ng, s&acirc;n thượng phơi đồ ri&ecirc;ng, chỗ để xe thoải m&aacute;i. M&ocirc;i trường sống y&ecirc;n tĩnh, an to&agrave;n, th&iacute;ch hợp cho bạn sinh vi&ecirc;n hoặc nh&acirc;n vi&ecirc;n văn ph&ograve;ng cần ở l&acirc;u d&agrave;i.</p>\n<ul style="list-style: none; padding-left: 0; font-size: 15px; color: #444; line-height: 1.8; margin-bottom: 16px;">\n<li>🏠 <strong>Nh&agrave; 1T3L:</strong> C&oacute; 3 ph&ograve;ng ngủ, 3 toilet, bếp, ph&ograve;ng kh&aacute;ch, s&acirc;n thượng</li>\n<li>🪟 <strong>View:</strong> G&oacute;c 2 mặt tiền, cực tho&aacute;ng, nhiều cửa sổ</li>\n<li>🛏️ <strong>Ph&ograve;ng ở gh&eacute;p:</strong> Giường, nệm, tủ ri&ecirc;ng &ndash; sạch sẽ, ri&ecirc;ng tư</li>\n<li>❄️ <strong>Tiện nghi:</strong> M&aacute;y lạnh, m&aacute;y giặt, tủ lạnh, nước n&oacute;ng lạnh, wifi mạnh</li>\n<li>🍽️ <strong>Bếp chung:</strong> Đầy đủ dụng cụ, nấu ăn thoải m&aacute;i</li>\n<li>🛵 <strong>Gửi xe:</strong> C&oacute; chỗ đậu trong s&acirc;n</li>\n<li>📍 <strong>Vị tr&iacute;:</strong> Ngay trường Song ngữ Lạc Hồng, gần chợ, cafe, gym</li>\n</ul>\n<p style="font-size: 14px; color: #888;">📌 Ưu ti&ecirc;n người ở gọn g&agrave;ng, th&acirc;n thiện, đi l&agrave;m hoặc sinh vi&ecirc;n. Gi&aacute; share si&ecirc;u hợp l&yacute; &ndash; <strong>từ 1.2 triệu/người/th&aacute;ng</strong> bao điện nước. Inbox/Zalo để xem nh&agrave; nh&eacute;!</p>\n</div>	11	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745475312/epfcrsub3k6xdte97yfz.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745475313/dpplwt0pfnjsgeaz5u3x.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745475314/lyhll6esd2juinxsgupi.jpg"]	10	f	2025-04-23 23:15:47.555-07	2025-05-17 04:12:41.875-07
36	Cho thuê căn hộ đầy đủ nội thất gần trường Song ngữ Lạc Hồng, Bửu Long	0	Đường N4, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai	3	<div style="max-width: 700px; margin: 24px auto; padding: 24px; border-radius: 12px; border: 1px solid #e0e0e0; box-shadow: 0 4px 12px rgba(0,0,0,0.05); background-color: #fff; font-family: 'Segoe UI', sans-serif;">\n<h2 style="color: #24a772; margin-bottom: 12px;">Cho thu&ecirc; căn hộ đầy đủ nội thất &ndash; Gần Trường Song ngữ Lạc Hồng, Bửu Long</h2>\n<p style="font-size: 16px; color: #555; margin-bottom: 12px;">Căn hộ cần cho thu&ecirc; nằm tại <strong>Đường N4, Phường Bửu Long, TP. Bi&ecirc;n H&ograve;a, Đồng Nai</strong>, chỉ c&aacute;ch <strong>Trường Song ngữ Lạc Hồng</strong> v&agrave;i ph&uacute;t di chuyển. Vị tr&iacute; y&ecirc;n tĩnh, d&acirc;n cư hiện hữu, rất th&iacute;ch hợp cho hộ gia đ&igrave;nh nhỏ hoặc người đi l&agrave;m muốn t&igrave;m nơi ở l&acirc;u d&agrave;i, tiện nghi.</p>\n<p style="font-size: 15px; color: #444; margin-bottom: 12px;">Căn hộ đ&atilde; được trang bị đầy đủ nội thất, thiết kế hiện đại, kh&ocirc;ng gian ấm c&uacute;ng, c&oacute; thể v&agrave;o ở ngay m&agrave; kh&ocirc;ng cần mua sắm th&ecirc;m. Diện t&iacute;ch hợp l&yacute;, bố tr&iacute; th&ocirc;ng minh, tối ưu h&oacute;a kh&ocirc;ng gian sống v&agrave; sinh hoạt.</p>\n<ul style="list-style: none; padding-left: 0; font-size: 15px; color: #444; line-height: 1.8; margin-bottom: 16px;">\n<li>🛏️ <strong>Ph&ograve;ng ngủ:</strong> Giường, nệm, tủ đồ</li>\n<li>🛋️ <strong>Ph&ograve;ng kh&aacute;ch:</strong> Sofa, b&agrave;n tr&agrave;, tivi</li>\n<li>🍳 <strong>Bếp:</strong> Bếp từ, tủ bếp, bồn rửa</li>\n<li>🧼 <strong>Toilet ri&ecirc;ng:</strong> C&oacute; m&aacute;y nước n&oacute;ng, sạch sẽ</li>\n<li>❄️ <strong>Tiện nghi kh&aacute;c:</strong> M&aacute;y lạnh, m&aacute;y giặt, wifi</li>\n<li>🛵 <strong>Chỗ để xe:</strong> C&oacute; m&aacute;i che, an to&agrave;n</li>\n<li>📍 <strong>Tiện &iacute;ch khu vực:</strong> Gần chợ, trường học, qu&aacute;n ăn, si&ecirc;u thị mini</li>\n</ul>\n<p style="font-size: 14px; color: #888;">📌 Ưu ti&ecirc;n người thu&ecirc; d&agrave;i hạn &ndash; hỗ trợ dọn v&agrave;o nhanh, xem ph&ograve;ng trực tiếp trong giờ h&agrave;nh ch&iacute;nh. Li&ecirc;n hệ ch&iacute;nh chủ để biết th&ecirc;m chi tiết.</p>\n</div>	20	["https://res.cloudinary.com/dm73atrbj/image/upload/v1745474158/xor6xlpeyc8ovter4kg0.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745474159/tot4qokmpdjc51qkqg9k.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745474160/zechdet6lxd57kazrmdn.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1745474161/gjpfkenljrbk1f83hdzy.jpg"]	3	f	2025-04-23 22:56:53.224-07	2025-05-17 03:48:24.76-07
1	CẦN TÌM NGƯỜI Ở GHÉP – NHÀ ĐẸP GÓC 2 MẶT TIỀN 1 TRỆT 3 LẦU, GẦN SONG NGỮ LẠC HỒNG	0	Tổ 21, khu phố 4, phường bửu long, thành phố biên hòa 	4	<p>Thu&ecirc; ph&ograve;ng trọ gi&aacute; rẻ gần ĐH Lạc Hồng, CAP Bửu Long<br>Địa chỉ: 4d,kp3, Đường Nguyễn Đ&igrave;nh Chiểu, Phường Bửu Long, Th&agrave;nh phố Bi&ecirc;n H&ograve;a, Đồng Nai</p>\n<p>🌟 M&ocirc; tả:</p>\n<p>Ph&ograve;ng trọ gi&aacute; rẻ gần Đại học Lạc Hồng &ndash; Bửu Long<br>Cho thu&ecirc; ph&ograve;ng trọ gi&aacute; rẻ, vị tr&iacute; thuận lợi tại 4D, Khu phố 3, Đường Nguyễn Đ&igrave;nh Chiểu, Phường Bửu Long, TP. Bi&ecirc;n H&ograve;a, Đồng Nai. C&aacute;ch Đại học Lạc Hồng chỉ khoảng 3 ph&uacute;t đi xe, l&yacute; tưởng cho sinh vi&ecirc;n v&agrave; người đi l&agrave;m cần chỗ ở ổn định, tiết kiệm.<br>Ph&ograve;ng nằm trong khu vực d&acirc;n cư an ninh, y&ecirc;n tĩnh, s&aacute;t chợ v&agrave; c&aacute;c tiện &iacute;ch hằng ng&agrave;y. Diện t&iacute;ch vừa đủ cho 1&ndash;2 người ở, c&oacute; kh&ocirc;ng gian sinh hoạt ri&ecirc;ng, tho&aacute;ng m&aacute;t v&agrave; dễ decor lại theo nhu cầu c&aacute; nh&acirc;n.</p>\n<p>💰 Gi&aacute; thu&ecirc;: Cực kỳ hợp l&yacute;, ph&ugrave; hợp sinh vi&ecirc;n<br>🛏️ Tiện nghi: C&oacute; sẵn wifi, chỗ để xe, khu vệ sinh ri&ecirc;ng<br>🔌 Điện nước: T&iacute;nh theo gi&aacute; nh&agrave; nước hoặc đồng hồ ri&ecirc;ng<br>📍 Khu vực: Gần chợ Bửu Long, tạp h&oacute;a, cafe, ph&ograve;ng gym<br>🔐 An ninh: Khu d&acirc;n cư hiện hữu, y&ecirc;n tĩnh, an to&agrave;n<br>🚶&zwj;♀️ Khoảng c&aacute;ch: 300m đến cổng Đại học Lạc Hồng</p>\n<p>📌 Ưu ti&ecirc;n sinh vi&ecirc;n thu&ecirc; l&acirc;u d&agrave;i hoặc người đi l&agrave;m ổn định. Li&ecirc;n hệ trực tiếp để xem ph&ograve;ng (li&ecirc;n hệ ở phần m&ocirc; tả th&ecirc;m).</p>\n<p><br>🏠 Danh s&aacute;ch ph&ograve;ng:<br>- Ph&ograve;ng 102: 1.500.000 VNĐ<br>- Ph&ograve;ng 205: 1.900.000 VNĐ</p>\n<p>Xem chi tiết tại: http://localhost:5173/tin-dang/33/thue-phong-tro-gia-re-gan-djh-lac-hong-cap-buu-long</p>	11	["https://res.cloudinary.com/dm73atrbj/image/upload/v1746964495/h3gg6hm140nzx1qybmdl.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746964496/nimnpv10v06xigtpixzc.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746964498/loxebxgluvmkgmwsqaz5.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746964499/r9ufazkgumcp3ejfqz7l.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746964500/srtrjtp1mvf1xpguyhdx.jpg"]	28	t	2025-05-11 04:55:34.432-07	2025-05-11 05:09:35.487-07
3	Tìm ở ghép nhà đẹp góc 2 mặt tiền 1T3L ngay song ngữ Lạc Hồng	0	Địa chỉ: Khu Dân Cư, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai Ngày cập nhật gần nhất: 11/05/2025	4	<table style="border-collapse: collapse; width: 99.9652%;" border="1"><colgroup><col style="width: 100%;"></colgroup>\n<tbody>\n<tr>\n<td>\n<h2>T&Igrave;M NGƯỜI Ở GH&Eacute;P &ndash; NH&Agrave; ĐẸP G&Oacute;C 2 MẶT TIỀN 1 TRỆT 3 LẦU, GẦN SONG NGỮ LẠC HỒNG</h2>\n<p>Cần t&igrave;m người ở gh&eacute;p tại&nbsp;<strong>nh&agrave; nguy&ecirc;n căn 1 trệt 3 lầu</strong>, vị tr&iacute; cực đẹp&nbsp;<strong>g&oacute;c 2 mặt tiền</strong>&nbsp;ngay&nbsp;<strong>Trường Song ngữ Lạc Hồng</strong>, thuộc&nbsp;<strong>Khu d&acirc;n cư, Phường Bửu Long, TP. Bi&ecirc;n H&ograve;a, Đồng Nai</strong>.</p>\n<p>Nh&agrave; thiết kế hiện đại, kh&ocirc;ng gian sống tho&aacute;ng m&aacute;t, nhiều &aacute;nh s&aacute;ng tự nhi&ecirc;n, c&oacute; ban c&ocirc;ng, s&acirc;n thượng phơi đồ ri&ecirc;ng, chỗ để xe thoải m&aacute;i. M&ocirc;i trường sống y&ecirc;n tĩnh, an to&agrave;n, th&iacute;ch hợp cho bạn sinh vi&ecirc;n hoặc nh&acirc;n vi&ecirc;n văn ph&ograve;ng cần ở l&acirc;u d&agrave;i.</p>\n<ul>\n<li>🏠&nbsp;<strong>Nh&agrave; 1T3L:</strong>&nbsp;C&oacute; 3 ph&ograve;ng ngủ, 3 toilet, bếp, ph&ograve;ng kh&aacute;ch, s&acirc;n thượng</li>\n<li>🪟&nbsp;<strong>View:</strong>&nbsp;G&oacute;c 2 mặt tiền, cực tho&aacute;ng, nhiều cửa sổ</li>\n<li>🛏️&nbsp;<strong>Ph&ograve;ng ở gh&eacute;p:</strong>&nbsp;Giường, nệm, tủ ri&ecirc;ng &ndash; sạch sẽ, ri&ecirc;ng tư</li>\n<li>❄️&nbsp;<strong>Tiện nghi:</strong>&nbsp;M&aacute;y lạnh, m&aacute;y giặt, tủ lạnh, nước n&oacute;ng lạnh, wifi mạnh</li>\n<li>🍽️&nbsp;<strong>Bếp chung:</strong>&nbsp;Đầy đủ dụng cụ, nấu ăn thoải m&aacute;i</li>\n<li>🛵&nbsp;<strong>Gửi xe:</strong>&nbsp;C&oacute; chỗ đậu trong s&acirc;n</li>\n<li>📍&nbsp;<strong>Vị tr&iacute;:</strong>&nbsp;Ngay trường Song ngữ Lạc Hồng, gần chợ, cafe, gym</li>\n</ul>\n<p>📌 Ưu ti&ecirc;n người ở gọn g&agrave;ng, th&acirc;n thiện, đi l&agrave;m hoặc sinh vi&ecirc;n. Gi&aacute; share si&ecirc;u hợp l&yacute; &ndash;&nbsp;<strong>từ 1.2 triệu/người/th&aacute;ng</strong> bao điện nước. Inbox/Zalo để xem nh&agrave; nh&eacute;!</p>\n</td>\n</tr>\n</tbody>\n</table>	6	["https://res.cloudinary.com/dm73atrbj/image/upload/v1746972595/yw2igt07vgeoqw4dl0gy.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746972596/z68ekmppcywqdi7aosba.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746972596/wzcoah2uf7fyxbmbrb1q.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746972597/jhkwmyfvgf3nlncljato.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746972598/enfcikohikfjkepaddn9.jpg"]	3	t	2025-05-11 07:10:36.919-07	2025-05-11 07:14:29.943-07
2	Phong Trọ 	0	Phong Trọ 	4	<p>Phong Trọ Phong Trọ Phong Trọ v</p>	6	["https://res.cloudinary.com/dm73atrbj/image/upload/v1746971925/na0fsdzdj3dmeovgucoo.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746971927/robg6sds3ijfsvvlrzwk.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746971927/exaqixyoaz1pz34ibhbu.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746971928/hvphlxkduxfxenfj9y5g.jpg"]	5	t	2025-05-11 06:59:08.33-07	2025-05-11 07:02:56.679-07
7	Cho thuê phòng trọ sạch sẽ	0	96/11, Đường Đồng Khởi, Phường Tân Hiệp, Thành phố Biên Hòa, Đồng Nai	2	<div style="font-family: Arial, sans-serif; padding: 16px; border: 1px solid #ccc; border-radius: 8px; background-color: #f9f9f9; max-width: 600px; line-height: 1.6;">\n<h3 style="margin-bottom: 12px; color: #2c3e50;">📄 Th&ocirc;ng tin ph&ograve;ng trọ</h3>\n<p><strong>📏 Diện t&iacute;ch:</strong> 16 m&sup2;</p>\n<p><strong>💰 Số tiền cọc:</strong> 500.000 đ/th&aacute;ng</p>\n<p style="margin-top: 12px;"><strong>📞 SĐT Li&ecirc;n hệ:</strong> 097301 *** <button style="margin-left: 8px; padding: 4px 8px; background-color: #3498db; border: none; color: white; border-radius: 4px; cursor: pointer;">Hiện SĐT</button></p>\n<ul style="margin-top: 12px; padding-left: 20px;">\n<li>✔️ Ph&ograve;ng trọ trong khu d&acirc;n cư an ninh</li>\n</ul>\n</div>	20	["https://res.cloudinary.com/dm73atrbj/image/upload/v1747051116/u5tndfthgvglf7tovzbi.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1747051116/y0agbpqzbkvjtomy6fkk.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1747051117/esc4x7fadhhu1brelvdx.jpg"]	3	f	2025-05-12 04:59:37.514-07	2025-05-12 05:10:48.315-07
4	m ở ghép nhà đẹp góc 2 mặt tiền 1T3L ngay song ngữ Lạc Hồng	0	Địa chỉ: Địa chỉ: Khu Dân Cư, Phường Bửu Long, Thành phố Biên Hòa, Đồng Nai Ngày cập nhật gần nhất: 11/05/2025 Ngày cập nhật gần nhất: 11/05/2025	4	<table style="border-collapse: collapse; width: 98.7491%; height: 358px;" border="1"><colgroup><col style="width: 100%;"></colgroup>\n<tbody>\n<tr>\n<td>\n<h2 style="text-align: center;">T&Igrave;M NGƯỜI Ở GH&Eacute;P &ndash; NH&Agrave; ĐẸP G&Oacute;C 2 MẶT TIỀN 1 TRỆT 3 LẦU, GẦN SONG NGỮ LẠC HỒNG</h2>\n<p style="text-align: center;">LI&Ecirc;N HỆ : 0312312313</p>\n<p>Cần t&igrave;m người ở gh&eacute;p tại&nbsp;<strong>nh&agrave; nguy&ecirc;n căn 1 trệt 3 lầu</strong>, vị tr&iacute; cực đẹp&nbsp;<strong>g&oacute;c 2 mặt tiền</strong>&nbsp;ngay&nbsp;<strong>Trường Song ngữ Lạc Hồng</strong>, thuộc&nbsp;<strong>Khu d&acirc;n cư, Phường Bửu Long, TP. Bi&ecirc;n H&ograve;a, Đồng Nai</strong>.</p>\n<p>Nh&agrave; thiết kế hiện đại, kh&ocirc;ng gian sống tho&aacute;ng m&aacute;t, nhiều &aacute;nh s&aacute;ng tự nhi&ecirc;n, c&oacute; ban c&ocirc;ng, s&acirc;n thượng phơi đồ ri&ecirc;ng, chỗ để xe thoải m&aacute;i. M&ocirc;i trường sống y&ecirc;n tĩnh, an to&agrave;n, th&iacute;ch hợp cho bạn sinh vi&ecirc;n hoặc nh&acirc;n vi&ecirc;n văn ph&ograve;ng cần ở l&acirc;u d&agrave;i.</p>\n<ul>\n<li>🏠&nbsp;<strong>Nh&agrave; 1T3L:</strong>&nbsp;C&oacute; 3 ph&ograve;ng ngủ, 3 toilet, bếp, ph&ograve;ng kh&aacute;ch, s&acirc;n thượng</li>\n<li>🪟&nbsp;<strong>View:</strong>&nbsp;G&oacute;c 2 mặt tiền, cực tho&aacute;ng, nhiều cửa sổ</li>\n<li>🛏️&nbsp;<strong>Ph&ograve;ng ở gh&eacute;p:</strong>&nbsp;Giường, nệm, tủ ri&ecirc;ng &ndash; sạch sẽ, ri&ecirc;ng tư</li>\n<li>❄️&nbsp;<strong>Tiện nghi:</strong>&nbsp;M&aacute;y lạnh, m&aacute;y giặt, tủ lạnh, nước n&oacute;ng lạnh, wifi mạnh</li>\n<li>🍽️&nbsp;<strong>Bếp chung:</strong>&nbsp;Đầy đủ dụng cụ, nấu ăn thoải m&aacute;i</li>\n<li>🛵&nbsp;<strong>Gửi xe:</strong>&nbsp;C&oacute; chỗ đậu trong s&acirc;n</li>\n<li>📍&nbsp;<strong>Vị tr&iacute;:</strong>&nbsp;Ngay trường Song ngữ Lạc Hồng, gần chợ, cafe, gym</li>\n</ul>\n<p>📌 Ưu ti&ecirc;n người ở gọn g&agrave;ng, th&acirc;n thiện, đi l&agrave;m hoặc sinh vi&ecirc;n. Gi&aacute; share si&ecirc;u hợp l&yacute; &ndash;&nbsp;<strong>từ 1.2 triệu/người/th&aacute;ng</strong> bao điện nước. Inbox/Zalo để xem nh&agrave; nh&eacute;!</p>\n<p style="text-align: center;">&nbsp;</p>\n<p>&nbsp;</p>\n</td>\n</tr>\n<tr>\n<td>\n<h2>&nbsp;</h2>\n</td>\n</tr>\n</tbody>\n</table>	6	["https://res.cloudinary.com/dm73atrbj/image/upload/v1746972735/ipq1i0arb6ztpc8z11kk.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746972736/xkwylutq7n5v6i690fyo.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746972737/ujdnjrruf2dn3z5nrfis.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746972738/oym0537rqeqsrinyatmg.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1746972738/jhlvuiqtr5mhltbt83qo.jpg"]	0	t	2025-05-11 07:12:47.367-07	2025-05-11 07:14:27.215-07
6	Cho thuê phòng trọ sạch sẽ, an ninh	0	  96/11, Đường Đồng Khởi, Phường Tân Hiệp, Thành phố Biên Hòa, Đồng Nai	2	<div style="font-family: Arial, sans-serif; padding: 16px; border: 1px solid #ccc; border-radius: 8px; background-color: #f9f9f9; max-width: 600px; line-height: 1.6;">\n<h3 style="margin-bottom: 12px; color: #2c3e50;">📄 Th&ocirc;ng tin ph&ograve;ng trọ</h3>\n<p><strong>📏 Diện t&iacute;ch:</strong> 16 m&sup2;</p>\n<p><strong>💰 Số tiền cọc:</strong> 500.000 đ/th&aacute;ng</p>\n<p style="margin-top: 12px;"><strong>📞 SĐT Li&ecirc;n hệ:</strong> 0123455678 <button style="margin-left: 8px; padding: 4px 8px; background-color: #3498db; border: none; color: white; border-radius: 4px; cursor: pointer;">Hiện SĐT</button></p>\n<ul style="margin-top: 12px; padding-left: 20px;">\n<li>✔️ Ph&ograve;ng trọ trong khu d&acirc;n cư an ninh</li>\n</ul>\n</div>	20	["https://res.cloudinary.com/dm73atrbj/image/upload/v1747050976/wlowyihsasqxay6h3jqb.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1747050977/iv87bwkwytzjc5n4bvhh.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1747050978/pzfzhznkwtjs9eyzkcir.jpg"]	3	t	2025-05-12 04:56:23.629-07	2025-05-12 04:58:06.826-07
8	1	0	1	4	<p>1</p>	6	["https://res.cloudinary.com/dm73atrbj/image/upload/v1747222655/v5ydmxg20evapzgienwy.jpg"]	2	f	2025-05-14 04:37:49.212-07	2025-05-14 04:37:57.87-07
5	TÌM NGƯỜI Ở GHÉP NHÀ NGUYÊN CĂN – PHƯỜNG BỬU LONG	0	Biên Hòa	4	<div style="font-family: Arial, sans-serif; padding: 16px; border: 1px solid #ddd; border-radius: 8px; background-color: #fff; max-width: 700px; line-height: 1.6;">\n<h3 style="color: #d35400; font-size: 20px;">🧑&zwj;🤝&zwj;🧑 T&Igrave;M NGƯỜI Ở GH&Eacute;P NH&Agrave; NGUY&Ecirc;N CĂN &ndash; PHƯỜNG BỬU LONG</h3>\n<p>M&igrave;nh cần t&igrave;m 1 bạn ở gh&eacute;p trong nh&agrave; nguy&ecirc;n căn tại <strong>Phường Bửu Long, Th&agrave;nh phố Bi&ecirc;n H&ograve;a, Đồng Nai</strong>. Nh&agrave; rộng r&atilde;i, sạch sẽ, y&ecirc;n tĩnh, đ&atilde; c&oacute; đầy đủ tiện nghi, chỉ cần dọn v&agrave;o l&agrave; ở ngay.</p>\n<p>Hiện tại nh&agrave; c&oacute; 2 người (sinh vi&ecirc;n/đi l&agrave;m), cần th&ecirc;m 1 bạn ở gh&eacute;p để share chi ph&iacute;. Ưu ti&ecirc;n bạn gọn g&agrave;ng, lịch sự, t&ocirc;n trọng kh&ocirc;ng gian chung. M&ocirc;i trường sống l&agrave;nh mạnh, văn minh.</p>\n<ul style="list-style: none; padding-left: 0; margin-top: 10px;">\n<li style="margin-bottom: 4px;">🏠 <strong>Nh&agrave; nguy&ecirc;n căn:</strong> 1 trệt 1 lầu, c&oacute; s&acirc;n để xe</li>\n<li style="margin-bottom: 4px;">🛏 <strong>Ph&ograve;ng:</strong> Rộng r&atilde;i, ri&ecirc;ng tư hoặc ngủ chung t&ugrave;y thỏa thuận</li>\n<li style="margin-bottom: 4px;">🔌 <strong>Tiện nghi:</strong> M&aacute;y lạnh, m&aacute;y giặt, tủ lạnh, wifi mạnh</li>\n<li style="margin-bottom: 4px;">🍳 <strong>Bếp:</strong> C&oacute; sẵn đồ d&ugrave;ng nấu ăn, tủ bếp gọn g&agrave;ng</li>\n<li style="margin-bottom: 4px;">🚽 <strong>WC:</strong> Nước m&aacute;y, sạch sẽ, c&oacute; nước n&oacute;ng</li>\n<li style="margin-bottom: 4px;">🕐 <strong>Giờ giấc tự do:</strong> Kh&ocirc;ng chung chủ</li>\n<li style="margin-bottom: 4px;">📍 <strong>Gần:</strong> Trường học, chợ, qu&aacute;n ăn, cafe</li>\n</ul>\n<p style="margin-top: 12px;">💸 <strong>Chi ph&iacute; share hợp l&yacute;</strong> &ndash; dao động khoảng <strong>1 &ndash; 1.2 triệu/người/th&aacute;ng</strong> (bao gồm điện nước).</p>\n<p>📩 Bạn n&agrave;o quan t&acirc;m th&igrave; inbox hoặc li&ecirc;n hệ để xem nh&agrave; nh&eacute;!</p>\n</div>	11	["https://res.cloudinary.com/dm73atrbj/image/upload/v1747049636/zkrxas7kxjnakl9zsg5a.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1747049637/rmxtkted2h8q4vzvfdn9.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1747049638/gqwyjefjpnv0hipyghbp.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1747049639/mfpvfdusvkehp968bd1d.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1747049640/uxuqwfcfxjdyzcmjb7wp.jpg"]	14	f	2025-05-12 04:34:13.312-07	2025-05-16 07:56:00.19-07
9	TÌM NGƯỜI Ở GHÉP NHÀ NGUYÊN CĂN – PHƯỜNG BỬU LONGG	0	Tổ 21, khu phố 4, phường bửu long, thành phố biên hòa 	4	<h3>🧑&zwj;🤝&zwj;🧑 T&Igrave;M NGƯỜI Ở GH&Eacute;P NH&Agrave; NGUY&Ecirc;N CĂN &ndash; PHƯỜNG BỬU LONG</h3>\n<p>M&igrave;nh cần t&igrave;m 1 bạn ở gh&eacute;p trong nh&agrave; nguy&ecirc;n căn tại&nbsp;<strong>Phường Bửu Long, Th&agrave;nh phố Bi&ecirc;n H&ograve;a, Đồng Nai</strong>. Nh&agrave; rộng r&atilde;i, sạch sẽ, y&ecirc;n tĩnh, đ&atilde; c&oacute; đầy đủ tiện nghi, chỉ cần dọn v&agrave;o l&agrave; ở ngay.</p>\n<p>Hiện tại nh&agrave; c&oacute; 2 người (sinh vi&ecirc;n/đi l&agrave;m), cần th&ecirc;m 1 bạn ở gh&eacute;p để share chi ph&iacute;. Ưu ti&ecirc;n bạn gọn g&agrave;ng, lịch sự, t&ocirc;n trọng kh&ocirc;ng gian chung. M&ocirc;i trường sống l&agrave;nh mạnh, văn minh.</p>\n<ul>\n<li>🏠&nbsp;<strong>Nh&agrave; nguy&ecirc;n căn:</strong>&nbsp;1 trệt 1 lầu, c&oacute; s&acirc;n để xe</li>\n<li>🛏&nbsp;<strong>Ph&ograve;ng:</strong>&nbsp;Rộng r&atilde;i, ri&ecirc;ng tư hoặc ngủ chung t&ugrave;y thỏa thuận</li>\n<li>🔌&nbsp;<strong>Tiện nghi:</strong>&nbsp;M&aacute;y lạnh, m&aacute;y giặt, tủ lạnh, wifi mạnh</li>\n<li>🍳&nbsp;<strong>Bếp:</strong>&nbsp;C&oacute; sẵn đồ d&ugrave;ng nấu ăn, tủ bếp gọn g&agrave;ng</li>\n<li>🚽&nbsp;<strong>WC:</strong>&nbsp;Nước m&aacute;y, sạch sẽ, c&oacute; nước n&oacute;ng</li>\n<li>🕐&nbsp;<strong>Giờ giấc tự do:</strong>&nbsp;Kh&ocirc;ng chung chủ</li>\n<li>📍&nbsp;<strong>Gần:</strong>&nbsp;Trường học, chợ, qu&aacute;n ăn, cafe</li>\n</ul>\n<p>💸&nbsp;<strong>Chi ph&iacute; share hợp l&yacute;</strong>&nbsp;&ndash; dao động khoảng&nbsp;<strong>1 &ndash; 1.2 triệu/người/th&aacute;ng</strong>&nbsp;(bao gồm điện nước).</p>\n<p>📩 Bạn n&agrave;o quan t&acirc;m th&igrave; inbox hoặc li&ecirc;n hệ để xem nh&agrave; nh&eacute;!</p>	1	["https://res.cloudinary.com/dm73atrbj/image/upload/v1747407413/lcvmihql9anqxdszredm.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1747407414/v9na1ennskqla8mm7slf.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1747407415/t66komdjvtxspsd9uqn3.jpg","https://res.cloudinary.com/dm73atrbj/image/upload/v1747407416/qhaii85ddqzra4lnnonr.jpg"]	2	f	2025-05-16 07:57:29.398-07	2025-05-17 04:12:36.53-07
\.


--
-- TOC entry 3485 (class 0 OID 24884)
-- Dependencies: 233
-- Data for Name: Profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Profiles" (id, "firstName", "lastName", email, birthday, "CID", address, gender, image, "userId", "isDeleted", "createdAt", "updatedAt") FROM stdin;
7	Trọ	Chủ	chutro@gmail.com	\N	0978123612312	Chưa cập nhật	Nam	https://res.cloudinary.com/dm73atrbj/image/upload/v1745460957/kstftc1cxkvhtqzw5nl9.png	18	f	2025-04-23 19:16:02.036-07	2025-04-23 19:21:45.007-07
8	Đức	Văn	nguyenvanduc2k3333@gmail.com	2003-11-10 16:00:00-08	123123	HCM	Nữ	https://res.cloudinary.com/dm73atrbj/image/upload/v1745461285/mlbsaynni5cvux3lbkhg.png	19	f	2025-04-23 19:16:56.049-07	2025-05-06 07:40:19.026-07
3	duc	nguyen	nguyenvanduc2k333@gmail.com	\N	12312312321	TP HCM	Nam	\N	5	f	2025-05-11 04:17:05.391-07	2025-05-11 04:17:05.433-07
5	duc	Duc	duc@gmail.com	0011-11-10 16:07:02-07:52:58	12312332	HCM	Nữ	\N	6	f	2025-05-11 06:58:16.888-07	2025-05-11 07:05:34.262-07
4	van	Nguyễn Văn Đức	asddsa@gmail.com	\N	025484561	ád	Nữ	https://res.cloudinary.com/dm73atrbj/image/upload/v1747050673/ucfonramryaho6aegjcg.png	3	f	2025-05-11 06:54:56.736-07	2025-05-12 04:51:21.442-07
1	Trị Viên	Quản	nguyenvanduc2k3@gmail.com	2002-10-02 17:00:00-07	066202014476	Đăk Lăk	Nam	https://res.cloudinary.com/dm73atrbj/image/upload/v1747050699/yx1v5b9pvgyorgvi8wxn.png	11	f	2024-10-10 14:55:36.768-07	2025-05-12 04:51:44.246-07
9	Trọ 2	Chủ	nguyenvanduc2072003@gmail.com	\N	054203002710	Chưa cập nhật	Nam	https://res.cloudinary.com/dm73atrbj/image/upload/v1745461190/qukz0adyfl8skpawr9gi.png	20	f	2025-04-23 19:19:54.713-07	2025-05-12 04:54:13.275-07
6	\N	\N	\N	\N	\N	\N	Khác	\N	2	f	2025-05-12 05:38:05.803-07	2025-05-12 05:38:05.859-07
10	Thu	Thu	du123c@gmail.com	\N	02584200271	HCM	Nam	\N	7	f	2025-05-12 05:40:41.914-07	2025-05-12 05:40:41.931-07
11	Nguyen	Duc	Nguyen@gmail.com	\N	025002710	HCM	Nam	\N	8	f	2025-05-12 05:51:20.836-07	2025-05-12 05:52:22.739-07
2	Đức	Văn	nguyenvanduc2k3@gmail.com	1222-11-10 16:07:02-07:52:58	123123	HCM	Nam	\N	1	f	2025-05-06 07:00:30.947-07	2025-05-16 09:36:37.683-07
12	Thư		aa123@gmail.com	2000-01-19 16:00:00-08	123123	HCM	Khác	\N	9	f	2025-05-16 09:40:31.968-07	2025-05-16 09:40:31.968-07
13	Đức	Văn	nguyenvanduc2072003@gmail.com	0011-11-10 16:07:02-07:52:58	12312332	HCM	Khác	\N	22	f	2025-05-17 03:52:21.719-07	2025-05-17 03:52:21.719-07
\.


--
-- TOC entry 3487 (class 0 OID 24892)
-- Dependencies: 235
-- Data for Name: Ratings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Ratings" (id, "postId", content, score, "userId", "isDeleted", "createdAt", "updatedAt") FROM stdin;
1	32		5	5	f	2025-05-11 04:29:10.224-07	2025-05-11 04:29:10.224-07
2	33		5	20	f	2025-05-12 05:03:31.238-07	2025-05-12 05:03:31.238-07
\.


--
-- TOC entry 3489 (class 0 OID 24899)
-- Dependencies: 237
-- Data for Name: RequestRooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."RequestRooms" (id, "userId", "priceRange", location, "specialRequirements", "financialLimit", "numberOfPeople", "numberOfVehicles", "contactInfo", "isActive", "createdAt", "updatedAt") FROM stdin;
12	20	1	1	1		1	0	0912345678	f	2025-05-14 05:11:25.625-07	2025-05-14 05:14:05.384-07
13	20	1	1	1		1	0	0912345678	f	2025-05-14 05:14:44.976-07	2025-05-14 05:14:49.289-07
14	1	123	123	123		1	0	0911223344	f	2025-05-14 05:15:13.904-07	2025-05-14 05:15:16.146-07
15	1	123	123	123		1	0	0911223344	f	2025-05-14 05:15:21.272-07	2025-05-14 05:15:44.065-07
16	6	123	123	123	123	1	0	0984913315	f	2025-05-14 05:15:40.369-07	2025-05-14 05:15:49.947-07
17	1	1	1	1		1	0	0911223344	f	2025-05-14 05:16:49.439-07	2025-05-14 05:16:52.456-07
18	1	123	123	123	123	1	0	0911223344	f	2025-05-14 05:16:59.079-07	2025-05-14 05:17:05.402-07
20	6	123	123	123		1	0	0984913315	f	2025-05-14 05:17:44.55-07	2025-05-14 05:17:46.337-07
19	6	1	1			1	0	0984913315	f	2025-05-14 05:17:41.103-07	2025-05-14 05:17:49.687-07
21	11	1	1	1	1	1	0	0967626481	f	2025-05-14 05:18:49.409-07	2025-05-14 05:18:53.528-07
22	11	1	1	1	1	1	0	0967626481	f	2025-05-14 05:22:10.729-07	2025-05-14 05:22:12.553-07
23	11	123	123	123	123	1	0	0967626481	f	2025-05-14 06:41:59.742-07	2025-05-14 06:42:01.999-07
24	20	12	123	123	123	1	0	0912345678	f	2025-05-16 09:29:15.03-07	2025-05-16 09:29:26.269-07
25	20	4 triệu - 5 triệu 	Bửu long	Có wifi miễn phí, có nhà xe an ninh	5triệu	2	2	03507073622	f	2025-05-17 03:44:57.418-07	2025-05-17 03:45:15.252-07
\.


--
-- TOC entry 3491 (class 0 OID 24908)
-- Dependencies: 239
-- Data for Name: Role_Users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Role_Users" (id, "userId", "roleCode", "isDeleted", "createdAt", "updatedAt") FROM stdin;
22	18	USER	f	2025-04-23 19:14:15.145-07	2025-04-23 19:14:15.145-07
23	18	MANAGER	f	2025-04-23 19:14:15.145-07	2025-04-23 19:14:15.145-07
24	19	USER	f	2025-04-23 19:14:37.636-07	2025-04-23 19:14:37.636-07
25	20	USER	f	2025-04-23 19:17:49.283-07	2025-04-23 19:17:49.283-07
26	20	MANAGER	f	2025-04-23 19:17:49.283-07	2025-04-23 19:17:49.283-07
1	1	USER	f	2025-05-06 06:13:31.143-07	2025-05-06 06:13:31.143-07
6	4	USER	f	2025-05-08 00:03:08.256-07	2025-05-08 00:03:08.256-07
7	4	MANAGER	f	2025-05-08 00:03:08.256-07	2025-05-08 00:03:08.256-07
8	5	USER	f	2025-05-11 04:16:45.493-07	2025-05-11 04:16:45.493-07
9	5	MANAGER	f	2025-05-11 04:16:45.493-07	2025-05-11 04:16:45.493-07
10	6	USER	f	2025-05-11 06:57:54.41-07	2025-05-11 06:57:54.41-07
11	3	MANAGER	f	2025-05-12 04:51:21.455-07	2025-05-12 04:51:21.455-07
12	3	USER	f	2025-05-12 04:51:21.455-07	2025-05-12 04:51:21.455-07
14	11	ADMIN	f	2025-05-12 04:51:44.251-07	2025-05-12 04:51:44.251-07
15	2	MANAGER	f	2025-05-12 05:38:05.865-07	2025-05-12 05:38:05.865-07
16	7	USER	f	2025-05-12 05:39:35.21-07	2025-05-12 05:39:35.21-07
17	7	MANAGER	f	2025-05-12 05:39:35.21-07	2025-05-12 05:39:35.21-07
19	8	MANAGER	f	2025-05-12 05:52:22.753-07	2025-05-12 05:52:22.753-07
20	8	USER	f	2025-05-12 05:52:22.753-07	2025-05-12 05:52:22.753-07
21	9	USER	f	2025-05-16 09:39:48.26-07	2025-05-16 09:39:48.26-07
27	16	USER	f	2025-05-17 03:51:23.601-07	2025-05-17 03:51:23.601-07
28	21	USER	f	2025-05-17 03:51:23.627-07	2025-05-17 03:51:23.627-07
29	17	USER	f	2025-05-17 03:51:23.629-07	2025-05-17 03:51:23.629-07
30	22	USER	f	2025-05-17 03:51:44.078-07	2025-05-17 03:51:44.078-07
\.


--
-- TOC entry 3493 (class 0 OID 24913)
-- Dependencies: 241
-- Data for Name: Roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Roles" (id, code, value, "isDeleted", "createdAt", "updatedAt") FROM stdin;
1	ADMIN	Quản trị viên	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
2	MANAGER	Chủ trọ	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
3	USER	Thành viên	f	2024-09-23 10:21:31.55-07	2024-09-23 10:21:31.55-07
\.


--
-- TOC entry 3495 (class 0 OID 24920)
-- Dependencies: 243
-- Data for Name: Room_Convenients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Room_Convenients" (id, "roomId", "convenientId", "isDeleted", "createdAt", "updatedAt") FROM stdin;
81	57	2	f	2025-04-23 22:10:45.147-07	2025-04-23 22:10:45.147-07
82	57	3	f	2025-04-23 22:10:45.147-07	2025-04-23 22:10:45.147-07
83	57	4	f	2025-04-23 22:10:45.147-07	2025-04-23 22:10:45.147-07
84	58	1	f	2025-04-23 22:10:45.147-07	2025-04-23 22:10:45.147-07
85	58	2	f	2025-04-23 22:10:45.147-07	2025-04-23 22:10:45.147-07
86	58	3	f	2025-04-23 22:10:45.147-07	2025-04-23 22:10:45.147-07
87	58	4	f	2025-04-23 22:10:45.147-07	2025-04-23 22:10:45.147-07
88	59	1	f	2025-04-23 22:10:45.147-07	2025-04-23 22:10:45.147-07
89	59	2	f	2025-04-23 22:10:45.147-07	2025-04-23 22:10:45.147-07
90	59	3	f	2025-04-23 22:10:45.147-07	2025-04-23 22:10:45.147-07
91	59	4	f	2025-04-23 22:10:45.147-07	2025-04-23 22:10:45.147-07
92	60	1	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
93	60	2	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
94	60	3	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
95	60	4	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
96	61	1	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
97	61	2	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
98	61	3	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
99	61	4	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
100	62	1	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
101	62	2	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
102	62	3	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
103	62	4	f	2025-04-23 22:20:52.727-07	2025-04-23 22:20:52.727-07
107	64	2	f	2025-04-23 22:26:15.308-07	2025-04-23 22:26:15.308-07
108	64	3	f	2025-04-23 22:26:15.308-07	2025-04-23 22:26:15.308-07
109	65	2	f	2025-04-23 22:41:26.584-07	2025-04-23 22:41:26.584-07
110	65	3	f	2025-04-23 22:41:26.584-07	2025-04-23 22:41:26.584-07
111	65	4	f	2025-04-23 22:41:26.584-07	2025-04-23 22:41:26.584-07
112	66	2	f	2025-04-23 22:41:26.584-07	2025-04-23 22:41:26.584-07
113	66	3	f	2025-04-23 22:41:26.584-07	2025-04-23 22:41:26.584-07
114	66	4	f	2025-04-23 22:41:26.584-07	2025-04-23 22:41:26.584-07
115	67	2	f	2025-04-23 22:41:26.584-07	2025-04-23 22:41:26.584-07
116	67	3	f	2025-04-23 22:41:26.584-07	2025-04-23 22:41:26.584-07
117	67	4	f	2025-04-23 22:41:26.584-07	2025-04-23 22:41:26.584-07
118	70	2	f	2025-04-23 22:56:53.237-07	2025-04-23 22:56:53.237-07
119	70	3	f	2025-04-23 22:56:53.237-07	2025-04-23 22:56:53.237-07
120	70	4	f	2025-04-23 22:56:53.237-07	2025-04-23 22:56:53.237-07
121	71	2	f	2025-04-23 22:56:53.237-07	2025-04-23 22:56:53.237-07
122	71	3	f	2025-04-23 22:56:53.237-07	2025-04-23 22:56:53.237-07
123	71	4	f	2025-04-23 22:56:53.237-07	2025-04-23 22:56:53.237-07
124	72	2	f	2025-04-23 22:58:06.269-07	2025-04-23 22:58:06.269-07
125	72	3	f	2025-04-23 22:58:06.269-07	2025-04-23 22:58:06.269-07
126	72	4	f	2025-04-23 22:58:06.269-07	2025-04-23 22:58:06.269-07
127	73	1	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
128	73	2	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
129	73	3	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
130	73	4	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
131	74	1	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
132	74	2	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
133	74	3	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
134	74	4	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
135	75	1	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
136	75	2	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
137	75	3	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
138	75	4	f	2025-04-23 23:03:18.255-07	2025-04-23 23:03:18.255-07
139	76	2	f	2025-04-23 23:05:09.76-07	2025-04-23 23:05:09.76-07
140	76	3	f	2025-04-23 23:05:09.76-07	2025-04-23 23:05:09.76-07
141	76	4	f	2025-04-23 23:05:09.76-07	2025-04-23 23:05:09.76-07
142	77	2	f	2025-04-23 23:05:09.76-07	2025-04-23 23:05:09.76-07
143	77	3	f	2025-04-23 23:05:09.76-07	2025-04-23 23:05:09.76-07
144	77	4	f	2025-04-23 23:05:09.76-07	2025-04-23 23:05:09.76-07
148	79	2	f	2025-04-23 23:15:47.563-07	2025-04-23 23:15:47.563-07
149	79	3	f	2025-04-23 23:15:47.563-07	2025-04-23 23:15:47.563-07
150	79	4	f	2025-04-23 23:15:47.563-07	2025-04-23 23:15:47.563-07
1	80	1	f	2025-05-06 06:57:07.029-07	2025-05-06 06:57:07.029-07
2	80	2	f	2025-05-06 06:57:07.029-07	2025-05-06 06:57:07.029-07
3	80	3	f	2025-05-06 06:57:07.029-07	2025-05-06 06:57:07.029-07
4	80	4	f	2025-05-06 06:57:07.029-07	2025-05-06 06:57:07.029-07
5	78	1	f	2025-05-06 07:21:20.667-07	2025-05-06 07:21:20.667-07
6	78	2	f	2025-05-06 07:21:20.667-07	2025-05-06 07:21:20.667-07
7	78	3	f	2025-05-06 07:21:20.667-07	2025-05-06 07:21:20.667-07
8	78	4	f	2025-05-06 07:21:20.667-07	2025-05-06 07:21:20.667-07
9	2	1	f	2025-05-11 05:00:02.413-07	2025-05-11 05:00:02.413-07
10	2	2	f	2025-05-11 05:00:02.413-07	2025-05-11 05:00:02.413-07
11	2	3	f	2025-05-11 05:00:02.413-07	2025-05-11 05:00:02.413-07
12	2	4	f	2025-05-11 05:00:02.413-07	2025-05-11 05:00:02.413-07
13	1	1	f	2025-05-11 05:00:08.799-07	2025-05-11 05:00:08.799-07
14	1	2	f	2025-05-11 05:00:08.799-07	2025-05-11 05:00:08.799-07
15	1	3	f	2025-05-11 05:00:08.799-07	2025-05-11 05:00:08.799-07
16	1	4	f	2025-05-11 05:00:08.799-07	2025-05-11 05:00:08.799-07
17	63	1	f	2025-05-11 05:08:57.509-07	2025-05-11 05:08:57.509-07
18	63	2	f	2025-05-11 05:08:57.509-07	2025-05-11 05:08:57.509-07
19	63	3	f	2025-05-11 05:08:57.509-07	2025-05-11 05:08:57.509-07
20	63	4	f	2025-05-11 05:08:57.509-07	2025-05-11 05:08:57.509-07
21	3	1	f	2025-05-11 06:59:08.35-07	2025-05-11 06:59:08.35-07
22	3	2	f	2025-05-11 06:59:08.35-07	2025-05-11 06:59:08.35-07
23	3	3	f	2025-05-11 06:59:08.35-07	2025-05-11 06:59:08.35-07
24	3	4	f	2025-05-11 06:59:08.35-07	2025-05-11 06:59:08.35-07
25	4	1	f	2025-05-11 07:10:36.931-07	2025-05-11 07:10:36.931-07
26	4	2	f	2025-05-11 07:10:36.931-07	2025-05-11 07:10:36.931-07
27	4	3	f	2025-05-11 07:10:36.931-07	2025-05-11 07:10:36.931-07
28	4	4	f	2025-05-11 07:10:36.931-07	2025-05-11 07:10:36.931-07
29	9	1	f	2025-05-12 04:59:37.523-07	2025-05-12 04:59:37.523-07
30	9	2	f	2025-05-12 04:59:37.523-07	2025-05-12 04:59:37.523-07
31	9	3	f	2025-05-12 04:59:37.523-07	2025-05-12 04:59:37.523-07
32	9	4	f	2025-05-12 04:59:37.523-07	2025-05-12 04:59:37.523-07
33	10	1	f	2025-05-12 04:59:37.523-07	2025-05-12 04:59:37.523-07
34	10	2	f	2025-05-12 04:59:37.523-07	2025-05-12 04:59:37.523-07
35	10	3	f	2025-05-12 04:59:37.523-07	2025-05-12 04:59:37.523-07
36	10	4	f	2025-05-12 04:59:37.523-07	2025-05-12 04:59:37.523-07
37	11	1	f	2025-05-14 04:37:49.26-07	2025-05-14 04:37:49.26-07
38	12	1	f	2025-05-16 07:57:29.451-07	2025-05-16 07:57:29.451-07
39	12	2	f	2025-05-16 07:57:29.451-07	2025-05-16 07:57:29.451-07
40	12	3	f	2025-05-16 07:57:29.451-07	2025-05-16 07:57:29.451-07
41	12	4	f	2025-05-16 07:57:29.451-07	2025-05-16 07:57:29.451-07
\.


--
-- TOC entry 3497 (class 0 OID 24925)
-- Dependencies: 245
-- Data for Name: Rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Rooms" (id, "postId", title, price, area, "stayMax", "position", "electricPrice", "waterPrice", "capsPrice", "internetPrice", "isDeleted", "createdAt", "updatedAt") FROM stdin;
58	31	Phòng 2	2800000	25	4	Còn trống	3500	15000	45000	45000	f	2025-04-23 22:10:45.137-07	2025-04-23 22:10:45.137-07
61	32	Phòng 2.5	3500000	27	4	Còn trống	4000	20000	50000	0	f	2025-04-23 22:20:52.725-07	2025-04-23 22:20:52.725-07
66	34	Phòng 3.5	4800000	29	3	Còn trống	4000	20000	50000	50000	f	2025-04-23 22:41:26.578-07	2025-04-23 22:41:26.578-07
67	34	Phòng 3.7	5000000	26	4	Còn trống	4000	20000	50000	50000	f	2025-04-23 22:41:26.578-07	2025-04-23 22:41:26.578-07
68	35	Phòng 20	5500000	30	4	Còn trống	4500	20000	120000	130000	f	2025-04-23 22:49:21.45-07	2025-04-23 22:49:21.45-07
69	35	Phòng 21	6000000	30	3	Còn trống	4000	20000	120000	130000	f	2025-04-23 22:49:46.2-07	2025-04-23 22:49:46.2-07
70	36	Phòng 1.7	5500000	30	4	Còn trống	4000	20000	0	100000	f	2025-04-23 22:56:53.234-07	2025-04-23 22:56:53.234-07
71	36	Phòng 2.5	6000000	30	3	Còn trống	4000	20000	0	100000	f	2025-04-23 22:56:53.234-07	2025-04-23 22:56:53.234-07
72	37	Phòng 303	3500000	20	3	Còn trống	4000	20000	0	120000	f	2025-04-23 22:58:06.267-07	2025-04-23 22:58:06.267-07
73	38	Phòng 102	5500000	30	4	Còn trống	4000	20000	0	0	f	2025-04-23 23:03:18.252-07	2025-04-23 23:03:18.252-07
74	38	Phòng 202	6000000	32	4	Còn trống	4000	20000	0	0	f	2025-04-23 23:03:18.252-07	2025-04-23 23:03:18.252-07
75	38	Phòng 303	6000000	35	4	Còn trống	4000	20000	0	0	f	2025-04-23 23:03:18.252-07	2025-04-23 23:03:18.252-07
76	39	Phòng 35	5500000	30	3	Còn trống	4000	20000	0	100000	f	2025-04-23 23:05:09.756-07	2025-04-23 23:05:09.756-07
77	39	Phòng 38	5800000	32	4	Còn trống	4000	20000	0	100000	f	2025-04-23 23:05:09.756-07	2025-04-23 23:05:09.756-07
79	41	Nhà nguyên căn	9000000	35	6	Còn trống	4000	20000	100000	150000	f	2025-04-23 23:15:47.561-07	2025-04-23 23:15:47.561-07
80	42	Nhà nguyên căn	7500000	30	5	Còn trống	4000	20000	100000	100000	f	2025-04-23 23:17:05.472-07	2025-05-06 06:57:07.012-07
12	9	Nha trọ an ninh	900000	20	2	Còn trống	10	100	100	300	f	2025-05-16 07:57:29.447-07	2025-05-16 07:57:29.447-07
62	32	Phòng 3.2	3800000	27	4	Đã thuê	4000	20000	0	0	f	2025-04-23 22:20:52.725-07	2025-05-16 09:40:55.336-07
60	32	Phòng 1.1	3500000	25	4	Đã thuê	4000	20000	50000	0	f	2025-04-23 22:20:52.725-07	2025-05-17 03:52:48.238-07
59	31	Phòng 3	3000000	25	4	Còn trống	3000	15000	45000	45000	f	2025-04-23 22:10:45.137-07	2025-05-06 07:19:09.613-07
64	33	Phòng 205	1900000	17	2	Còn trống	3000	15000	0	50000	f	2025-04-23 22:26:15.303-07	2025-05-06 07:19:21.298-07
65	34	Phòng 3.2	4500000	27	4	Còn trống	4000	20000	50000	50000	f	2025-04-23 22:41:26.578-07	2025-05-06 07:20:47.547-07
57	31	Phòng 1	2500000	18	4	Còn trống	3000	15000	45000	45000	f	2025-04-23 22:10:45.137-07	2025-05-11 04:53:42.381-07
78	40	Nhà nguyên căn	8000000	40	5	Còn trống	4000	20000	120000	150000	f	2025-04-23 23:13:33.83-07	2025-05-11 04:53:51.473-07
2	1	CẦN TÌM NGƯỜI Ở GHÉP	1250000	20	1	Còn trống	850	47000	25000	20000	f	2025-05-11 04:55:34.462-07	2025-05-11 05:00:02.409-07
1	1	CẦN TÌM NGƯỜI Ở GHÉP	2500000	30	2	Còn trống	700	66000	10000	45000	f	2025-05-11 04:55:34.462-07	2025-05-11 05:00:08.796-07
63	33	Phòng 102	1500000	15	3	Còn trống	3500	15000	-1	50000	f	2025-04-23 22:26:15.303-07	2025-05-11 05:08:57.506-07
4	3	nhà đẹp góc 2 mặt tiền 1T3L ngay song ngữ Lạc Hồng	100000	100000	2	Còn trống	100000	100000	100000	100000	f	2025-05-11 07:10:36.93-07	2025-05-11 07:10:36.93-07
3	2	Phong Trọ 	1000	1	2	Còn trống	10000	111	111	12	f	2025-05-11 06:59:08.347-07	2025-05-11 07:13:54.568-07
5	5	Phòng thường 2 người ở	1500000	25	2	Còn trống	1000	50000	20000	45000	f	2025-05-12 04:34:13.345-07	2025-05-12 04:34:13.345-07
6	5	Phòng thường 1 người ở	750000	16	1	Còn trống	2000	25000	15000	20000	f	2025-05-12 04:34:13.345-07	2025-05-12 04:34:13.345-07
7	5	Phòng VIP 2 người ở	2500000	30	2	Còn trống	700	66000	10000	45000	f	2025-05-12 04:34:13.345-07	2025-05-12 04:34:13.345-07
8	5	Phòng VIP 1 người ở	1250000	20	1	Còn trống	850	47000	25000	20000	f	2025-05-12 04:34:13.345-07	2025-05-12 04:34:13.345-07
9	7	 phòng trọ sạch sẽ, an ninh	2500000	30	2	Còn trống	700	66000	10000	45000	f	2025-05-12 04:59:37.52-07	2025-05-12 04:59:37.52-07
10	7	 phòng trọ sạch sẽ, an ninh	1250000	20	1	Còn trống	850	47000	25000	20000	f	2025-05-12 04:59:37.52-07	2025-05-12 04:59:37.52-07
11	8	1	1	1	1	Còn trống	1	1	1	1	f	2025-05-14 04:37:49.256-07	2025-05-14 04:37:49.256-07
\.


--
-- TOC entry 3499 (class 0 OID 24937)
-- Dependencies: 247
-- Data for Name: SequelizeMeta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."SequelizeMeta" (name) FROM stdin;
20231221151942-create-user.js
20231221152644-create-role.js
20231221152931-create-role-user.js
20231221153648-create-catalog.js
20231221160237-create-post.js
20231221161000-create-comment.js
20231221161238-create-rating.js
20231221161626-create-wishlist.js
20231226130637-create-profile.js
20231226130723-create-room.js
20231226130738-create-contract.js
20231226130801-create-convenient.js
20231226130937-create-index-counter.js
20231226131035-create-room-convenient.js
20240109063931-create-payment.js
20240407063933-add-col-index-counter.js
\.


--
-- TOC entry 3500 (class 0 OID 24940)
-- Dependencies: 248
-- Data for Name: Users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Users" (id, username, phone, password, "resetTokenPassword", "resetTokenExpire", "isDeleted", "createdAt", "updatedAt") FROM stdin;
20	Chủ trọ A	0912345678	$2b$10$c.ovn9MVCKF48HTC.Cnov.ZujzqeSN5J0Lw0WQLQLqyZv6KZALLCy	\N	\N	f	2025-04-23 19:17:49.28-07	2025-05-17 04:04:10.435-07
18	Chủ trọ B	0987654321	$2b$10$EjGFazVWeLKBJzrA37O/8ezS0DR1XBSzl8n/SbwLCbKzf4qPcOO1y	\N	\N	f	2025-04-23 19:14:15.14-07	2025-04-23 19:21:45.007-07
19	Khách Thuê	0987123456	$2b$10$EjGFazVWeLKBJzrA37O/8ezS0DR1XBSzl8n/SbwLCbKzf4qPcOO1y	\N	\N	f	2025-04-23 19:14:37.633-07	2025-04-23 19:21:29.338-07
4	thư	0357073621	$2b$10$05LxHi64U0kciAghrJ6rEO3idvkTq32QE5YDyDxn3tk4XuoewGoR2	\N	\N	f	2025-05-08 00:03:08.239-07	2025-05-08 00:03:08.239-07
5	Chủ Trọ 1	0357073625	$2b$10$ZW5HOrTPpPxoTQ/PRLcUleHGzO4v7RK56dxGJGraZadxW1JTmGtzW	\N	\N	f	2025-05-11 04:16:45.466-07	2025-05-11 04:17:05.433-07
6	Khách Thuê	0984913315	$2b$10$btZltwPyW2NuQPNjCAZV6etx9HwJrDmU72H2BpMkBF6CicH9lBhw.	\N	\N	f	2025-05-11 06:57:54.397-07	2025-05-11 07:05:34.262-07
3	duc	0357073222	$2b$10$YU/ddkv11fc3fYFbXPO2M..0r7Fio2FDTpVz2IwoqYo2hf881dpJm	\N	\N	f	2025-05-07 07:15:22.705-07	2025-05-12 04:51:21.442-07
2	thu	123456789	$2b$10$blNEmEupgbwZ5TYf6i4ABObD1Y.8Vo/wIwKA0S0eADqbQVz7uvCqK	\N	\N	f	2025-05-07 07:14:01.291-07	2025-05-12 05:38:05.86-07
7	Anh thu	0377755231	$2b$10$cCxMP3tZz3RRCA1Zc9bUsunZuxeYHSRhjL7FztyTvk3iW1zJ6.H4G	\N	\N	f	2025-05-12 05:39:35.208-07	2025-05-12 05:40:41.931-07
1	Nguyễn Văn Đức	0911223344	$2b$10$EjGFazVWeLKBJzrA37O/8ezS0DR1XBSzl8n/SbwLCbKzf4qPcOO1y	\N	\N	f	2025-05-06 06:13:31.135-07	2025-05-12 05:44:07.714-07
8	123456	0397775522	$2b$10$X8liWoE306MQdQmJeIHIs.ghqEmvyIvq/fKRaONpftXIRpBuPWJa6	\N	\N	f	2025-05-12 05:50:51.406-07	2025-05-12 05:52:22.739-07
9	Khách Thuê	0397775523	$2b$10$jVJ5KD4KAm3GuHyKeHyRnOQ78Oh5ZOvQRf3KdivOzvY5zdxNOFUE6	\N	\N	f	2025-05-16 09:39:48.258-07	2025-05-16 09:39:48.258-07
11	ADMIN	0967626481	$2b$10$KNpxGZnCZ/mFfWt5/lk4auVYZOjI6HS8NM4pPcnY5SDUBWSKDrkBC	8629be6b6a4caf465c0a63bf14284b4b9d3d0ab0	2025-05-17 04:41:03.224-07	f	2024-09-23 10:26:06.211-07	2025-05-17 03:41:03.227-07
10	123456	09676264812	$2b$10$aPxfw9SgJL/c06oWcfp1sO3IL7IsKmrlxCybt9500mj/UCEgwN6sS	\N	\N	f	2025-05-17 03:49:27.102-07	2025-05-17 03:49:27.102-07
12	123456	0967626482	$2b$10$/ET87hEAvOIGKFnP/9gsdOwp6.1psFaBW21hYp7uko6TXeg0vrCEW	\N	\N	f	2025-05-17 03:49:32.282-07	2025-05-17 03:49:32.282-07
13	Alo	0967626488	$2b$10$poya7rJ46RoTLx4Y.le4reTr641o5G0rAwshLQr6PKGyYsHhR6wtq	\N	\N	f	2025-05-17 03:49:43.02-07	2025-05-17 03:49:43.02-07
14	Alo	03545454412	$2b$10$R/obU246/0m26wAQ0ky9cevHW/a70ySiK4zL0KmZPPXwRtYSlOxKG	\N	\N	f	2025-05-17 03:49:49.874-07	2025-05-17 03:49:49.874-07
15	Alo	0357073629	$2b$10$jsj65jNRdUXstgiZSKRj.OBmTmdx3D49AIcdhVoGO1lk5i.gGMx06	\N	\N	f	2025-05-17 03:50:02.413-07	2025-05-17 03:50:02.413-07
16	Alo	03545454412	$2b$10$h6n5dmE8.zzsV2XomXBkgOTHw684tQdIrkDfueKBMyO5moRkc6WYe	\N	\N	f	2025-05-17 03:51:23.207-07	2025-05-17 03:51:23.207-07
17	Alo	0967626488	$2b$10$eJGxVzLbVb9sAWZ1qByRmOoS/rER9L37WteAePP5YjbOOOE97LC4C	\N	\N	f	2025-05-17 03:51:23.278-07	2025-05-17 03:51:23.278-07
21	123456	0967626482	$2b$10$gbW3MXMctEL1bDjtSV.Dheoh2eHRHRlyyD1Vlc5b8k55WJHlrC7X.	\N	\N	f	2025-05-17 03:51:23.527-07	2025-05-17 03:51:23.527-07
22	Khách Thuê	0337504571	$2b$10$lyepkx0h3qFok4fN15fRwOd67bM069OIngm1AqihUOSqzt.cgieUK	\N	\N	f	2025-05-17 03:51:44.076-07	2025-05-17 03:51:44.076-07
\.


--
-- TOC entry 3502 (class 0 OID 24947)
-- Dependencies: 250
-- Data for Name: Wishlists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Wishlists" (id, "postId", "userId", "isDeleted", "createdAt", "updatedAt") FROM stdin;
9	36	19	f	2025-04-24 17:17:19.773-07	2025-04-24 17:17:19.773-07
10	35	19	f	2025-04-24 17:17:21.375-07	2025-04-24 17:17:21.375-07
7	32	11	t	2025-04-24 00:23:53.251-07	2025-04-24 22:19:13.812-07
5	35	11	t	2025-04-24 00:22:31.505-07	2025-04-24 22:19:14.516-07
6	34	11	t	2025-04-24 00:23:52.506-07	2025-04-24 22:19:15.366-07
3	39	11	t	2025-04-24 00:06:34.303-07	2025-04-24 22:19:16.391-07
2	42	18	t	2025-05-06 07:14:18.281-07	2025-05-06 07:19:50.504-07
8	42	11	t	2025-04-24 00:24:49.532-07	2025-05-06 07:23:05.895-07
13	39	1	t	2025-05-06 07:23:40.041-07	2025-05-06 07:23:58.513-07
4	36	11	t	2025-04-24 00:22:29.58-07	2025-05-06 07:24:11.993-07
18	41	1	t	2025-05-06 07:24:24.689-07	2025-05-06 07:34:08.986-07
20	32	5	t	2025-05-11 04:28:54.782-07	2025-05-11 04:29:33.452-07
19	31	5	t	2025-05-11 04:28:54.134-07	2025-05-11 04:29:34.252-07
21	42	5	f	2025-05-11 04:34:24.414-07	2025-05-11 04:34:24.414-07
22	41	5	f	2025-05-11 04:34:25.221-07	2025-05-11 04:34:25.221-07
24	37	3	t	2025-05-11 06:57:19.221-07	2025-05-11 06:57:23.756-07
23	36	3	t	2025-05-11 06:57:18.269-07	2025-05-11 06:57:24.564-07
1	37	11	t	2025-04-24 00:03:38.062-07	2025-05-11 07:08:49.627-07
17	38	11	t	2025-05-06 07:24:14.858-07	2025-05-11 07:08:50.491-07
26	40	20	t	2025-05-12 05:00:09.916-07	2025-05-12 05:00:23.623-07
25	42	20	t	2025-05-12 05:00:09.262-07	2025-05-12 05:00:24.292-07
27	36	20	f	2025-05-16 08:30:53.592-07	2025-05-16 08:30:53.592-07
14	38	1	f	2025-05-06 07:23:40.874-07	2025-05-17 03:47:29.248-07
11	32	1	t	2025-05-06 07:23:37.697-07	2025-05-17 03:47:43.632-07
16	36	1	f	2025-05-06 07:24:01.953-07	2025-05-17 03:47:50.815-07
15	37	1	f	2025-05-06 07:23:41.905-07	2025-05-17 03:47:51.544-07
28	35	1	f	2025-05-17 03:47:52.634-07	2025-05-17 03:47:52.634-07
12	33	1	t	2025-05-06 07:23:38.865-07	2025-05-17 03:48:06.84-07
\.


--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 220
-- Name: Catalogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Catalogs_id_seq"', 1, false);


--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 222
-- Name: Comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Comments_id_seq"', 1, false);


--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 224
-- Name: Contracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Contracts_id_seq"', 10, true);


--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 226
-- Name: Convenients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Convenients_id_seq"', 1, false);


--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 228
-- Name: IndexCounters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."IndexCounters_id_seq"', 6, true);


--
-- TOC entry 3530 (class 0 OID 0)
-- Dependencies: 230
-- Name: Payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Payments_id_seq"', 16, true);


--
-- TOC entry 3531 (class 0 OID 0)
-- Dependencies: 232
-- Name: Posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Posts_id_seq"', 9, true);


--
-- TOC entry 3532 (class 0 OID 0)
-- Dependencies: 234
-- Name: Profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Profiles_id_seq"', 13, true);


--
-- TOC entry 3533 (class 0 OID 0)
-- Dependencies: 236
-- Name: Ratings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Ratings_id_seq"', 2, true);


--
-- TOC entry 3534 (class 0 OID 0)
-- Dependencies: 238
-- Name: RequestRooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."RequestRooms_id_seq"', 25, true);


--
-- TOC entry 3535 (class 0 OID 0)
-- Dependencies: 240
-- Name: Role_Users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Role_Users_id_seq"', 30, true);


--
-- TOC entry 3536 (class 0 OID 0)
-- Dependencies: 242
-- Name: Roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Roles_id_seq"', 1, false);


--
-- TOC entry 3537 (class 0 OID 0)
-- Dependencies: 244
-- Name: Room_Convenients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Room_Convenients_id_seq"', 41, true);


--
-- TOC entry 3538 (class 0 OID 0)
-- Dependencies: 246
-- Name: Rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Rooms_id_seq"', 12, true);


--
-- TOC entry 3539 (class 0 OID 0)
-- Dependencies: 249
-- Name: Users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_id_seq"', 22, true);


--
-- TOC entry 3540 (class 0 OID 0)
-- Dependencies: 251
-- Name: Wishlists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Wishlists_id_seq"', 28, true);


--
-- TOC entry 3291 (class 2606 OID 24969)
-- Name: Catalogs Catalogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Catalogs"
    ADD CONSTRAINT "Catalogs_pkey" PRIMARY KEY (id);


--
-- TOC entry 3293 (class 2606 OID 24971)
-- Name: Catalogs Catalogs_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Catalogs"
    ADD CONSTRAINT "Catalogs_slug_key" UNIQUE (slug);


--
-- TOC entry 3295 (class 2606 OID 24973)
-- Name: Comments Comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comments"
    ADD CONSTRAINT "Comments_pkey" PRIMARY KEY (id);


--
-- TOC entry 3297 (class 2606 OID 24975)
-- Name: Contracts Contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Contracts"
    ADD CONSTRAINT "Contracts_pkey" PRIMARY KEY (id);


--
-- TOC entry 3299 (class 2606 OID 24977)
-- Name: Convenients Convenients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Convenients"
    ADD CONSTRAINT "Convenients_pkey" PRIMARY KEY (id);


--
-- TOC entry 3301 (class 2606 OID 24979)
-- Name: IndexCounters IndexCounters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."IndexCounters"
    ADD CONSTRAINT "IndexCounters_pkey" PRIMARY KEY (id);


--
-- TOC entry 3303 (class 2606 OID 24981)
-- Name: Payments Payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Payments"
    ADD CONSTRAINT "Payments_pkey" PRIMARY KEY (id);


--
-- TOC entry 3305 (class 2606 OID 24983)
-- Name: Posts Posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Posts"
    ADD CONSTRAINT "Posts_pkey" PRIMARY KEY (id);


--
-- TOC entry 3307 (class 2606 OID 24985)
-- Name: Profiles Profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Profiles"
    ADD CONSTRAINT "Profiles_pkey" PRIMARY KEY (id);


--
-- TOC entry 3309 (class 2606 OID 24987)
-- Name: Ratings Ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ratings"
    ADD CONSTRAINT "Ratings_pkey" PRIMARY KEY (id);


--
-- TOC entry 3311 (class 2606 OID 24989)
-- Name: RequestRooms RequestRooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RequestRooms"
    ADD CONSTRAINT "RequestRooms_pkey" PRIMARY KEY (id);


--
-- TOC entry 3313 (class 2606 OID 24991)
-- Name: Role_Users Role_Users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Role_Users"
    ADD CONSTRAINT "Role_Users_pkey" PRIMARY KEY (id);


--
-- TOC entry 3315 (class 2606 OID 24993)
-- Name: Roles Roles_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Roles"
    ADD CONSTRAINT "Roles_code_key" UNIQUE (code);


--
-- TOC entry 3317 (class 2606 OID 24995)
-- Name: Roles Roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Roles"
    ADD CONSTRAINT "Roles_pkey" PRIMARY KEY (id);


--
-- TOC entry 3319 (class 2606 OID 24997)
-- Name: Roles Roles_value_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Roles"
    ADD CONSTRAINT "Roles_value_key" UNIQUE (value);


--
-- TOC entry 3321 (class 2606 OID 24999)
-- Name: Room_Convenients Room_Convenients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Room_Convenients"
    ADD CONSTRAINT "Room_Convenients_pkey" PRIMARY KEY (id);


--
-- TOC entry 3323 (class 2606 OID 25001)
-- Name: Rooms Rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rooms"
    ADD CONSTRAINT "Rooms_pkey" PRIMARY KEY (id);


--
-- TOC entry 3325 (class 2606 OID 25003)
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- TOC entry 3327 (class 2606 OID 25005)
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- TOC entry 3329 (class 2606 OID 25007)
-- Name: Wishlists Wishlists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Wishlists"
    ADD CONSTRAINT "Wishlists_pkey" PRIMARY KEY (id);


--
-- TOC entry 3330 (class 2606 OID 25008)
-- Name: RequestRooms RequestRooms_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RequestRooms"
    ADD CONSTRAINT "RequestRooms_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Users"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3331 (class 2606 OID 25013)
-- Name: Rooms Rooms_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Rooms"
    ADD CONSTRAINT "Rooms_postId_fkey" FOREIGN KEY ("postId") REFERENCES public."Posts"(id);


-- Completed on 2025-05-18 20:06:34

--
-- PostgreSQL database dump complete
--

