CREATE FUNCTION public.add_book(par_title text, par_author text, par_pubication text, par_isbn text, par_content text, par_price integer, par_piece integer, par_image_file text) RETURNS json
    LANGUAGE plpgsql
    AS $$
	begin
		-- Add order
		insert into public.book (title, author, publication, isbn, content, price, piece, image_file) 
				values (par_title, par_author, par_pubication, par_isbn, par_content, par_price, par_price, par_image_file);
		-- Return json
		return jsonb_build_object('status', 'OK');
	end;
$$;


--
-- TOC entry 227 (class 1255 OID 44237)
-- Name: add_order(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_order(par_uid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    loc_record record;
    sum_price numeric;
    time_now timestamp WITHOUT time ZONE DEFAULT now();
    loc_order_id int;
    res text;
begin
    -- Get total price from cart
    sum_price := 0;
    FOR loc_record IN SELECT book.price FROM cart JOIN book ON cart.book_id = book.id WHERE user_id = par_uid LOOP
        sum_price := sum_price + loc_record.price;
    END LOOP;
    -- Add order
    insert into public.order (user_id, amount, order_date) values (par_uid, sum_price, time_now);
    
    -- Get order id
    SELECT currval('order_id_seq') INTO loc_order_id;
    -- Loop through cart and add to order_book and subtract from stock
    FOR loc_record IN SELECT * FROM cart WHERE user_id = par_uid LOOP
        insert into public.order_book (user_id, book_id, order_id) values (par_uid, loc_record.book_id, loc_order_id);
        update public.book set piece = piece - 1 where id = loc_record.book_id;
    END LOOP;
    -- Delete cart
    delete from cart where user_id = par_uid;
    -- Return json
    return jsonb_build_object('status', 'OK');
end;
$$;


--
-- TOC entry 210 (class 1255 OID 44218)
-- Name: add_to_cart(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.add_to_cart(par_uid integer, par_bid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
begin
    insert into cart (user_id, book_id) VALUES (par_uid, par_bid);
	RETURN json_build_object('status', 'OK');
end;
$$;


--
-- TOC entry 233 (class 1255 OID 52407)
-- Name: delete_book(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.delete_book(par_bid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_record_cart record;
	loc_record_orderbook record;
	loc_record record;
	result text;
	result_photo text;
begin
	select into loc_record_cart * from cart where book_id=par_bid;
	select into loc_record_orderbook * from order_book where book_id=par_bid;
    if loc_record_cart is null and loc_record_orderbook is null then
		select into loc_record * from book where id=par_bid;
        delete from book where id = par_bid;
        result = 'OK';
		result_photo = loc_record.image_file;
    else
        result = 'There are pending order of the book.';
		result_photo = 'Not Found';
    end if;
	return json_build_object(
		'status', result,
		'image', result_photo
	);
end;
$$;


--
-- TOC entry 211 (class 1255 OID 44227)
-- Name: delete_cart_item(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.delete_cart_item(par_uid integer, par_cid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_record record;
	result text;
begin
	select into loc_record * from cart where id=par_cid and user_id=par_uid;
    if loc_record is null then
        result = 'Cart item not found';
    else
        delete from cart where user_id = par_uid and id = par_cid;
        result = 'OK';
    end if;
	
	return json_build_object(
		'status', result
	);
end;
$$;


--
-- TOC entry 236 (class 1255 OID 44216)
-- Name: get_book(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_book(par_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_record record;
    res text;
begin

	select into loc_record * from book where id = par_id;
    if loc_record is not null then
        return json_build_object(
            'status', 'OK',
            'id', loc_record.id,
            'title', loc_record.title,
            'author', loc_record.author,
			'ISBN', loc_record.isbn,
            'publication', loc_record.publication,
            'content', loc_record.content,
            'price', loc_record.price,
            'piece', loc_record.piece,
            'image_file', loc_record.image_file
        );
	else
	return json_build_object(
		'status', 'Book not found!'
	);
    end if;
end;
$$;


--
-- TOC entry 225 (class 1255 OID 44214)
-- Name: get_books(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_books() RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_prod_record record;
	loc_prod_json json[];
	loc_size int default 0;
begin
	for loc_prod_record in 
	select * from book loop
		loc_prod_json = loc_prod_json ||
						json_build_object(
                            'id', loc_prod_record.id,
                            'title', loc_prod_record.title,
                            'author', loc_prod_record.author,
                            'publication', loc_prod_record.publication,
                            'content', loc_prod_record.content,
                            'price', loc_prod_record.price,
                            'piece', loc_prod_record.piece,
                            'image_file', loc_prod_record.image_file
						);
		loc_size = loc_size + 1;
	end loop;
	
	return json_build_object(
		'status', 'OK',
		'size', loc_size,
		'books', loc_prod_json
	);
end;
$$;


--
-- TOC entry 226 (class 1255 OID 44226)
-- Name: get_cart(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_cart(par_uid integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_prod_record record;
	loc_prod_json json[];
	loc_size int default 0;
begin
	for loc_prod_record in 
	select cart.id, book.image_file, book.title, book.author, book.price from book 
    JOIN cart ON book.id = cart.book_id where cart.user_id = par_uid 
    loop
		loc_prod_json = loc_prod_json ||
						json_build_object(
                            'cart_id', loc_prod_record.id,
							'image_file', loc_prod_record.image_file,
                            'title', loc_prod_record.title,
                            'author', loc_prod_record.author,
                            'price', loc_prod_record.price
						);
		loc_size = loc_size + 1;
	end loop;
	
	return json_build_object(
		'status', 'OK',
		'size', loc_size,
		'cart', loc_prod_json
	);
end;
$$;


--
-- TOC entry 234 (class 1255 OID 44241)
-- Name: get_detail(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_detail(par_user_id integer, par_order_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
    loc_order_record record;
    loc_order json;
    loc_user_record record;
    loc_user json;
	loc_record record;
	loc_json json[];
	loc_size int default 0;
begin
	for loc_record in 
	select o.id, b.title, b.price from order_book o join book b on o.book_id = b.id where o.order_id = par_order_id loop
		loc_json = loc_json ||
						json_build_object(
                            'id', loc_record.id,
                            'title', loc_record.title,
                            'price', loc_record.price
						);
		loc_size = loc_size + 1;
	end loop;

    select into loc_order_record * from public.order where id = par_order_id;
    loc_order = jsonb_build_object(
        'id', loc_order_record.id,
        'amount', loc_order_record.amount,
        'order_date', loc_order_record.order_date
    );

    select into loc_user_record * from public.user where id = par_user_id;
    loc_user = jsonb_build_object(
        'id', loc_user_record.id,
        'username', loc_user_record.username,
        'email', loc_user_record.email,
        'address', loc_user_record.address,
        'state', loc_user_record.state,
        'pincode', loc_user_record.pincode
    );
	
	return json_build_object(
		'status', 'OK',
		'order_size', loc_size,
		'orders', loc_json,
        'order', loc_order,
        'user', loc_user
	);
end;
$$;


--
-- TOC entry 231 (class 1255 OID 44239)
-- Name: get_orders(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_orders(par_user_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_prod_record record;
	loc_prod_json json[];
	loc_size int default 0;
begin
	for loc_prod_record in 
	select o.*, u.username from public.order o join public.user u on o.user_id = u.id where o.user_id = par_user_id loop
		loc_prod_json = loc_prod_json ||
						json_build_object(
                            'id', loc_prod_record.id,
                            'user_id', loc_prod_record.user_id,
                            'amount', loc_prod_record.amount,
                            'order_date', loc_prod_record.order_date,
                            'username', loc_prod_record.username
						);
		loc_size = loc_size + 1;
	end loop;
	
	return json_build_object(
		'status', 'OK',
		'size', loc_size,
		'orders', loc_prod_json
	);
end;
$$;


--
-- TOC entry 229 (class 1255 OID 52403)
-- Name: get_user(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user(par_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_record record;
    res text;
begin

	select into loc_record * from public.user where id = par_id;
    if loc_record is not null then
        return json_build_object(
            'status', 'OK',
            'user', jsonb_build_object(
				'id', loc_record.id,
				'username', loc_record.username,
				'email', loc_record.email,
				'image_file', loc_record.image_file,
				'address', loc_record.address,
				'state', loc_record.state,
				'pincode', loc_record.pincode
			)
        );
	else
	return json_build_object(
		'status', 'Book not found!'
	);
    end if;
end;
$$;


--
-- TOC entry 212 (class 1255 OID 52405)
-- Name: get_user_pass(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_pass(par_email text) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_record record;
    res text;
begin
	select into loc_record * from public.user where email = par_email;
    if loc_record is not null then
        return json_build_object(
            'status', 'OK',
            'user', jsonb_build_object(
				'password', loc_record.password
			)
        );
	else
	return json_build_object(
		'status', 'User not found!'
	);
    end if;
end;
$$;


--
-- TOC entry 213 (class 1255 OID 44215)
-- Name: get_users(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_users() RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_prod_record record;
	loc_prod_json json[];
	loc_size int default 0;
begin
	for loc_prod_record in 
	select * from book loop
		loc_prod_json = loc_prod_json ||
						json_build_object(
                            'id', loc_prod_record.id,
                            'title', loc_prod_record.title,
                            'author', loc_prod_record.author,
                            'publication', loc_prod_record.publication,
                            'ISBN', loc_prod_record.ISBN,
                            'content', loc_prod_record.content,
                            'price', loc_prod_record.price,
                            'piece', loc_prod_record.piece,
                            'image_file', loc_prod_record.image_file
						);
		loc_size = loc_size + 1;
	end loop;
	
	return json_build_object(
		'status', 'OK',
		'size', loc_size,
		'books', loc_prod_json
	);
end;
$$;


--
-- TOC entry 235 (class 1255 OID 52408)
-- Name: update_book(integer, text, text, text, text, text, integer, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_book(par_id integer, par_title text, par_author text, par_pubication text, par_isbn text, par_content text, par_price integer, par_piece integer, par_image_file text) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_record record;
    res text;
begin

	select into loc_record * from book where id = par_id;
    if loc_record is not null then
        update book set title = par_title, author = par_author, publication = par_pubication, 
							isbn = par_isbn, content = par_content, price = par_price, piece = par_piece, image_file = par_image_file where id = par_id;
		return json_build_object(
			'status', 'OK'
		);
	else
	return json_build_object(
		'status', 'Book not found!'
	);
    end if;
end;
$$;


--
-- TOC entry 230 (class 1255 OID 52404)
-- Name: update_user(integer, text, text, text, text, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_user(par_id integer, par_username text, par_email text, par_imfile text, par_address text, par_state text, par_pcode integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_record record;
    res text;
begin

	select into loc_record * from public.user where id = par_id;
    if loc_record is not null then
        update public.user set username = par_username, email = par_email, image_file = par_imfile, address = par_address, state = par_state, pincode = par_pcode where id = par_id;
		return json_build_object(
			'status', 'OK'
		);
	else
	return json_build_object(
		'status', 'User not found!'
	);
    end if;
end;
$$;


--
-- TOC entry 232 (class 1255 OID 44228)
-- Name: verify_address(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.verify_address(par_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
	loc_record record;
    res text;
begin
	select into loc_record * from public.user where id = par_id;
	if 
		loc_record.address != null 
		or loc_record.state != NULL 
		or loc_record.pincode != null
    then
        res = 'OK';
    else
        res = 'Please enter your address and state and pincode';
    end if;

    return json_build_object('status', res);
end;
$$;

--
-- TOC entry 200 (class 1259 OID 44126)
-- Name: book; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    author character varying(100) NOT NULL,
    publication character varying(100) NOT NULL,
    isbn character varying(100) NOT NULL,
    content text NOT NULL,
    price integer NOT NULL,
    piece integer NOT NULL,
    image_file character varying(20) NOT NULL
);


--
-- TOC entry 201 (class 1259 OID 44132)
-- Name: book_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3053 (class 0 OID 0)
-- Dependencies: 201
-- Name: book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.book_id_seq OWNED BY public.book.id;


--
-- TOC entry 202 (class 1259 OID 44134)
-- Name: cart; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart (
    id integer NOT NULL,
    user_id integer NOT NULL,
    book_id integer NOT NULL
);


--
-- TOC entry 203 (class 1259 OID 44137)
-- Name: cart_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3054 (class 0 OID 0)
-- Dependencies: 203
-- Name: cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;


--
-- TOC entry 204 (class 1259 OID 44139)
-- Name: order; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."order" (
    id integer NOT NULL,
    user_id integer NOT NULL,
    amount integer NOT NULL,
    order_date timestamp without time zone NOT NULL
);


--
-- TOC entry 205 (class 1259 OID 44142)
-- Name: order_book; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_book (
    id integer NOT NULL,
    user_id integer NOT NULL,
    book_id integer NOT NULL,
    order_id integer NOT NULL
);


--
-- TOC entry 206 (class 1259 OID 44145)
-- Name: order_book_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3055 (class 0 OID 0)
-- Dependencies: 206
-- Name: order_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_book_id_seq OWNED BY public.order_book.id;


--
-- TOC entry 207 (class 1259 OID 44147)
-- Name: order_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3056 (class 0 OID 0)
-- Dependencies: 207
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_id_seq OWNED BY public."order".id;


--
-- TOC entry 208 (class 1259 OID 44149)
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying(20) NOT NULL,
    email character varying(120) NOT NULL,
    image_file character varying(20) NOT NULL,
    password character varying(60) NOT NULL,
    address text,
    state character varying(60),
    pincode integer,
    role character varying(5)
);


--
-- TOC entry 209 (class 1259 OID 44155)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3057 (class 0 OID 0)
-- Dependencies: 209
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 2892 (class 2604 OID 44158)
-- Name: book id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book ALTER COLUMN id SET DEFAULT nextval('public.book_id_seq'::regclass);


--
-- TOC entry 2893 (class 2604 OID 44159)
-- Name: cart id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);


--
-- TOC entry 2894 (class 2604 OID 44160)
-- Name: order id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order" ALTER COLUMN id SET DEFAULT nextval('public.order_id_seq'::regclass);


--
-- TOC entry 2895 (class 2604 OID 44161)
-- Name: order_book id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_book ALTER COLUMN id SET DEFAULT nextval('public.order_book_id_seq'::regclass);


--
-- TOC entry 2896 (class 2604 OID 44162)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 2898 (class 2606 OID 44168)
-- Name: book book_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (id);


--
-- TOC entry 2900 (class 2606 OID 44170)
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- TOC entry 2904 (class 2606 OID 44172)
-- Name: order_book order_book_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_book
    ADD CONSTRAINT order_book_pkey PRIMARY KEY (id);


--
-- TOC entry 2902 (class 2606 OID 44174)
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- TOC entry 2906 (class 2606 OID 44176)
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- TOC entry 2908 (class 2606 OID 44178)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2910 (class 2606 OID 44180)
-- Name: user user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 2911 (class 2606 OID 44181)
-- Name: cart cart_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id);


--
-- TOC entry 2912 (class 2606 OID 44186)
-- Name: cart cart_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- TOC entry 2914 (class 2606 OID 44191)
-- Name: order_book order_book_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_book
    ADD CONSTRAINT order_book_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id);


--
-- TOC entry 2915 (class 2606 OID 44196)
-- Name: order_book order_book_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_book
    ADD CONSTRAINT order_book_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);


--
-- TOC entry 2916 (class 2606 OID 44201)
-- Name: order_book order_book_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_book
    ADD CONSTRAINT order_book_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- TOC entry 2913 (class 2606 OID 44206)
-- Name: order order_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


-- Completed on 2022-08-20 05:04:43

--
-- PostgreSQL database dump complete
--

INSERT INTO public.book (id, title, author, publication, isbn, content, price, piece, image_file) VALUES (1, 'A Harry Potter and the Philosophers Stone', 'J.K. Rowling', 'Bloomsbury Publishing', '12345678915', 'Escape to Hogwarts with the unmissable series that has sparked a lifelong reading journey for children and families all over the world. The magic starts here.', 329, -5, 'ce3fdfb1ab04a4cf.jpg');


--
-- TOC entry 3055 (class 0 OID 44149)
-- Dependencies: 208
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public."user" (id, username, email, image_file, password, address, state, pincode, role) VALUES (6, 'testadmin', 'test@admin.com', 'image', '$2b$12$W6dD.2rp8M2hM7I.xDTQ3.DVQx6lqsqlKBur6zHxK8/g.6hh8ymJi', NULL, NULL, NULL, 'admin');
INSERT INTO public."user" (id, username, email, image_file, password, address, state, pincode, role) VALUES (5, 'test', 'test@test.com', 'default.jpg', '$2b$12$W6dD.2rp8M2hM7I.xDTQ3.DVQx6lqsqlKBur6zHxK8/g.6hh8ymJi', NULL, 'Lanao Del Norte', 9200, 'user');


--
-- TOC entry 3049 (class 0 OID 44134)
-- Dependencies: 202
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3051 (class 0 OID 44139)
-- Dependencies: 204
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public."order" (id, user_id, amount, order_date) VALUES (13, 5, 329, '2022-08-09 22:27:30.630143');


--
-- TOC entry 3052 (class 0 OID 44142)
-- Dependencies: 205
-- Data for Name: order_book; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.order_book (id, user_id, book_id, order_id) VALUES (11, 5, 1, 13);
