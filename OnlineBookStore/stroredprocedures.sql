-- to get book data
CREATE OR REPLACE FUNCTION GET_BOOKS() RETURNS json
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
        'users', loc_prod_json
    );
end;
$$;

-- to checkout book
CREATE OR REPLACE FUNCTION GET_CART(par_uid int) RETURNS json
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
                            'id', loc_prod_record.id,
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

-- to book_info
CREATE OR REPLACE FUNCTION GET_BOOK(par_id int) RETURNS json
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

-- to order page
CREATE OR REPLACE FUNCTION ADD_ORDER(par_uid int) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    loc_record record;
    sum_price numeric;
    time_now timestamp WITHOUT TIME ZONE DEFAULT now();
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

-- to verify address
CREATE OR REPLACE FUNCTION verify_address(par_id int) RETURNS json
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

-- to add cart
CREATE OR REPLACE FUNCTION ADD_TO_CART(par_uid int, par_bid int) RETURNS json
    LANGUAGE plpgsql
    AS $$
begin
    insert into cart (user_id, book_id) VALUES (par_uid, par_bid);
    RETURN json_build_object('status', 'OK');
end;
$$;

CREATE OR REPLACE FUNCTION GET_CART(par_uid int) RETURNS json
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
                            'id', loc_prod_record.id,
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

-- to delete cart item
CREATE OR REPLACE FUNCTION DELETE_CART_ITEM(par_uid int, par_cid int) RETURNS json
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

--to verify address
CREATE OR REPLACE FUNCTION verify_address(par_id int) RETURNS json
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

-- account page
CREATE OR REPLACE FUNCTION GET_USER(par_id int) RETURNS json
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
        'status', 'User not found!'
    );
    end if;
end;
$$;

-- to create update user
CREATE OR REPLACE FUNCTION update_user(par_id int, par_username text, par_email text, par_imfile text, 
                                        par_address text, par_state text, par_pcode int) 
    RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
    loc_record record;
    res text;
begin

    select into loc_record * from public.user where id = par_id;
    if loc_record is not null then
        update public.user set username = par_username, email = par_email, image_file = par_imfile, 
                            address = par_address, state = par_state, pincode = par_pcode where id = par_id;
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

-- to get details
CREATE OR REPLACE FUNCTION GET_DETAIL(par_user_id int, par_order_id int) RETURNS json
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

-- to update book
CREATE OR REPLACE FUNCTION update_book(par_id int, par_title text, par_author text, par_pubication text,
        par_isbn text, par_content text, par_price int, par_piece int, par_image_file text) 
    RETURNS json
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

-- to add book
CREATE OR REPLACE FUNCTION ADD_BOOK(par_title text, par_author text, par_pubication text,
        par_isbn text, par_content text, par_price int, par_piece int, par_image_file text) 
    RETURNS json
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
