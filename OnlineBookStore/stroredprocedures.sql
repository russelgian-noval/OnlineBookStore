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
