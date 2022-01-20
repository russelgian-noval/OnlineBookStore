PGDMP         /                 z            onlinebooking    14.0    14.0 7    ,           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            -           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            .           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            /           1262    25174    onlinebooking    DATABASE     o   CREATE DATABASE onlinebooking WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_Philippines.1252';
    DROP DATABASE onlinebooking;
                postgres    false            �            1259    25189    admin    TABLE     �   CREATE TABLE public.admin (
    id integer NOT NULL,
    email character varying(120) NOT NULL,
    password character varying(60) NOT NULL
);
    DROP TABLE public.admin;
       public         heap    postgres    false            �            1259    25188    admin_id_seq    SEQUENCE     �   CREATE SEQUENCE public.admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.admin_id_seq;
       public          postgres    false    212            0           0    0    admin_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.admin_id_seq OWNED BY public.admin.id;
          public          postgres    false    211            �            1259    25198    book    TABLE     l  CREATE TABLE public.book (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    author character varying(100) NOT NULL,
    publication character varying(100) NOT NULL,
    "ISBN" character varying(100) NOT NULL,
    content text NOT NULL,
    price integer NOT NULL,
    piece integer NOT NULL,
    image_file character varying(20) NOT NULL
);
    DROP TABLE public.book;
       public         heap    postgres    false            �            1259    25197    book_id_seq    SEQUENCE     �   CREATE SEQUENCE public.book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.book_id_seq;
       public          postgres    false    214            1           0    0    book_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.book_id_seq OWNED BY public.book.id;
          public          postgres    false    213            �            1259    25207    cart    TABLE     r   CREATE TABLE public.cart (
    id integer NOT NULL,
    user_id integer NOT NULL,
    book_id integer NOT NULL
);
    DROP TABLE public.cart;
       public         heap    postgres    false            �            1259    25206    cart_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.cart_id_seq;
       public          postgres    false    216            2           0    0    cart_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;
          public          postgres    false    215            �            1259    25224    order    TABLE     �   CREATE TABLE public."order" (
    id integer NOT NULL,
    user_id integer NOT NULL,
    amount integer NOT NULL,
    order_date timestamp without time zone NOT NULL
);
    DROP TABLE public."order";
       public         heap    postgres    false            �            1259    25236 
   order_book    TABLE     �   CREATE TABLE public.order_book (
    id integer NOT NULL,
    user_id integer NOT NULL,
    book_id integer NOT NULL,
    order_id integer NOT NULL
);
    DROP TABLE public.order_book;
       public         heap    postgres    false            �            1259    25235    order_book_id_seq    SEQUENCE     �   CREATE SEQUENCE public.order_book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.order_book_id_seq;
       public          postgres    false    220            3           0    0    order_book_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.order_book_id_seq OWNED BY public.order_book.id;
          public          postgres    false    219            �            1259    25223    order_id_seq    SEQUENCE     �   CREATE SEQUENCE public.order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.order_id_seq;
       public          postgres    false    218            4           0    0    order_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.order_id_seq OWNED BY public."order".id;
          public          postgres    false    217            �            1259    25176    user    TABLE     4  CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying(20) NOT NULL,
    email character varying(120) NOT NULL,
    image_file character varying(20) NOT NULL,
    password character varying(60) NOT NULL,
    address text,
    state character varying(60),
    pincode integer
);
    DROP TABLE public."user";
       public         heap    postgres    false            �            1259    25175    user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.user_id_seq;
       public          postgres    false    210            5           0    0    user_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;
          public          postgres    false    209            v           2604    25192    admin id    DEFAULT     d   ALTER TABLE ONLY public.admin ALTER COLUMN id SET DEFAULT nextval('public.admin_id_seq'::regclass);
 7   ALTER TABLE public.admin ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    212    211    212            w           2604    25201    book id    DEFAULT     b   ALTER TABLE ONLY public.book ALTER COLUMN id SET DEFAULT nextval('public.book_id_seq'::regclass);
 6   ALTER TABLE public.book ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    214    213    214            x           2604    25210    cart id    DEFAULT     b   ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);
 6   ALTER TABLE public.cart ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215    216            y           2604    25227    order id    DEFAULT     f   ALTER TABLE ONLY public."order" ALTER COLUMN id SET DEFAULT nextval('public.order_id_seq'::regclass);
 9   ALTER TABLE public."order" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217    218            z           2604    25239    order_book id    DEFAULT     n   ALTER TABLE ONLY public.order_book ALTER COLUMN id SET DEFAULT nextval('public.order_book_id_seq'::regclass);
 <   ALTER TABLE public.order_book ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219    220            u           2604    25179    user id    DEFAULT     d   ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);
 8   ALTER TABLE public."user" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209    210            !          0    25189    admin 
   TABLE DATA           4   COPY public.admin (id, email, password) FROM stdin;
    public          postgres    false    212   P<       #          0    25198    book 
   TABLE DATA           i   COPY public.book (id, title, author, publication, "ISBN", content, price, piece, image_file) FROM stdin;
    public          postgres    false    214   �<       %          0    25207    cart 
   TABLE DATA           4   COPY public.cart (id, user_id, book_id) FROM stdin;
    public          postgres    false    216   {=       '          0    25224    order 
   TABLE DATA           B   COPY public."order" (id, user_id, amount, order_date) FROM stdin;
    public          postgres    false    218   �=       )          0    25236 
   order_book 
   TABLE DATA           D   COPY public.order_book (id, user_id, book_id, order_id) FROM stdin;
    public          postgres    false    220   �=                 0    25176    user 
   TABLE DATA           d   COPY public."user" (id, username, email, image_file, password, address, state, pincode) FROM stdin;
    public          postgres    false    210   >       6           0    0    admin_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.admin_id_seq', 1, false);
          public          postgres    false    211            7           0    0    book_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.book_id_seq', 2, true);
          public          postgres    false    213            8           0    0    cart_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.cart_id_seq', 2, true);
          public          postgres    false    215            9           0    0    order_book_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.order_book_id_seq', 2, true);
          public          postgres    false    219            :           0    0    order_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.order_id_seq', 2, true);
          public          postgres    false    217            ;           0    0    user_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.user_id_seq', 1, true);
          public          postgres    false    209            �           2606    25196    admin admin_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.admin DROP CONSTRAINT admin_email_key;
       public            postgres    false    212            �           2606    25194    admin admin_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.admin DROP CONSTRAINT admin_pkey;
       public            postgres    false    212            �           2606    25205    book book_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.book DROP CONSTRAINT book_pkey;
       public            postgres    false    214            �           2606    25212    cart cart_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_pkey;
       public            postgres    false    216            �           2606    25241    order_book order_book_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.order_book
    ADD CONSTRAINT order_book_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.order_book DROP CONSTRAINT order_book_pkey;
       public            postgres    false    220            �           2606    25229    order order_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public."order" DROP CONSTRAINT order_pkey;
       public            postgres    false    218            |           2606    25187    user user_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public."user" DROP CONSTRAINT user_email_key;
       public            postgres    false    210            ~           2606    25183    user user_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public."user" DROP CONSTRAINT user_pkey;
       public            postgres    false    210            �           2606    25185    user user_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public."user" DROP CONSTRAINT user_username_key;
       public            postgres    false    210            �           2606    25218    cart cart_book_id_fkey    FK CONSTRAINT     t   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id);
 @   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_book_id_fkey;
       public          postgres    false    3206    214    216            �           2606    25213    cart cart_user_id_fkey    FK CONSTRAINT     v   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);
 @   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_user_id_fkey;
       public          postgres    false    216    210    3198            �           2606    25247 "   order_book order_book_book_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_book
    ADD CONSTRAINT order_book_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id);
 L   ALTER TABLE ONLY public.order_book DROP CONSTRAINT order_book_book_id_fkey;
       public          postgres    false    220    3206    214            �           2606    25252 #   order_book order_book_order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_book
    ADD CONSTRAINT order_book_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id);
 M   ALTER TABLE ONLY public.order_book DROP CONSTRAINT order_book_order_id_fkey;
       public          postgres    false    220    3210    218            �           2606    25242 "   order_book order_book_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_book
    ADD CONSTRAINT order_book_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);
 L   ALTER TABLE ONLY public.order_book DROP CONSTRAINT order_book_user_id_fkey;
       public          postgres    false    3198    210    220            �           2606    25230    order order_user_id_fkey    FK CONSTRAINT     z   ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);
 D   ALTER TABLE ONLY public."order" DROP CONSTRAINT order_user_id_fkey;
       public          postgres    false    210    3198    218            !   -   x�3���H��L)J�KO�LwH�M���K���44261����� �\
�      #   �   x��AN�0E��)|��N;�,AB�f,ٸ��dH��N����������o��Q�.�0;(��bb�%�(|�d�퇅O�R̓yM̳���)j������ǧ�S{4o:�BP�<m(Ea�%��k��*�@I"iM�@@]P~�B���	��U:\y�L7�,0V?'����v
��Wg�%Kr��9�G�r���Ț�p2����-=����ej~l�4��`D      %      x������ � �      '   =   x�m��� �7W��p���_GȾ�F{tM!���Tg��/e�@?%��IW�؉�|��%      )      x�3�4A.#0m����� }         �   x�Uǻ�  ����4���L�J#�1Ը`-��~��g;�����f+����NK����R2ځ��̞�2|M/�|,�Ɲ�����D�b���S���b:�����/�����[���m�0���5!_�@у �~P�.G     