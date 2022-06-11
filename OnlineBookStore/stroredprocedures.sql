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
