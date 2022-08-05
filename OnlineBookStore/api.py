from flask import jsonify, request
from OnlineBookStore import app
from OnlineBookStore.conndb import spcall
from flask_login import login_required, current_user

@app.route('/api/books', methods=['GET'])
def get_books():
    result = spcall('get_books', ())[0][0]

    return jsonify(result)
 

  
@app.after_request
def add_cors(resp):
    resp.headers['Access-Control-Allow-Origin'] = request.headers.get('Origin', '*')
    resp.headers['Access-Control-Allow-Credentials'] = True
    resp.headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS, GET, PUT, DELETE'
    resp.headers['Access-Control-Allow-Headers'] = request.headers.get('Access-Control-Request-Headers',
                                                                             'Authorization')
    # set low for debugging

    if app.debug:
        resp.headers["Access-Control-Max-Age"] = '1'
    return resp
    
    # for order page
    
@app.route('/api/order', methods=['POST'])
@login_required
def create_order():
    user_id = current_user.id
    result = spcall('add_order', (user_id,), True)[0][0]
    return jsonify(result)

@app.route('/api/order', methods=['GET'])
@login_required
def get_orders():
    user_id = current_user.id
    result = spcall('get_orders', (user_id,))[0][0]
    return jsonify(result)

    # for checkout page

@app.route('/api/cart', methods=['GET'])
@login_required
def get_cart():
    user_id = current_user.id
    result = spcall('get_cart', (user_id,))[0][0]
    return jsonify(result)

@app.route('/api/cart', methods=['DELETE'])
@login_required
def delete_cart_item():
    data = request.get_json()
    print(data)
    user_id = current_user.id
    cart_id = data['cart_id']
    result = spcall('delete_cart_item', (user_id, cart_id), True)[0][0]
    return jsonify(result)

@app.route('/api/account', methods=['GET'])
@login_required
def get_account():
    user_id = current_user.id
    result = spcall('get_user', (user_id,))[0][0]
    return jsonify(result)

@app.route('/api/account', methods=['PUT'])
@login_required
def update_account():
    data = request.get_json()
    user_id = current_user.id
    if len(data['image_file']) <1:
        data['image_file'] = 'default.jpg'
    result = spcall('update_user', (user_id, data['username'], data['email'], data['image_file'], 
                    data['address'], data['state'], data['pincode']), True)[0][0]
    return jsonify(result)

# for book_info page

@app.route('/api/books/<int:book_id>', methods=['GET'])
def get_book(book_id):
        result = spcall('get_book', (book_id,))[0][0]
    
        return jsonify(result)
    
 # for cart page

@app.route('/api/cart', methods=['POST'])
@login_required
def add_to_cart():
    data = request.get_json()
    book_id = data['book_id']
    user_id = current_user.id
    result = spcall('add_to_cart', (user_id, book_id), True)[0][0]
    return jsonify(result)

@app.route('/api/cart', methods=['GET'])
@login_required
def get_cart():
    user_id = current_user.id
    result = spcall('get_cart', (user_id,))[0][0]
    return jsonify(result)

@app.route('/api/cart', methods=['DELETE'])
@login_required
def delete_cart_item():
    data = request.get_json()
    print(data)
    user_id = current_user.id
    cart_id = data['cart_id']
    result = spcall('delete_cart_item', (user_id, cart_id), True)[0][0]
    return jsonify(result)

# verify address
@app.route('/api/verify_address', methods=['GET'])
@login_required
def verify_address():
    user_id = current_user.id
    result = spcall('verify_address', (user_id), True)[0][0]
    return jsonify(result)

#get order
@app.route('/api/order/<int:order_id>', methods=['GET'])
@login_required
def get_order(order_id):
    result = spcall('get_detail', (current_user.id, order_id,))[0][0]
    return jsonify(result)

# update book
@app.route('/api/books/<int:book_id>', methods=['PUT'])
@login_required
def update_book_api(book_id):
    if current_user.role == 'admin':
        data = request.get_json()
        title = data['title']
        author = data['author']
        publication = data['publication']
        isbn = data['isbn']
        content = data['content']
        price = data['price']
        piece = data['piece']

        # get the old image name
        result = spcall('get_book', (book_id,))[0][0]

        if data['photo_image'] == None:
            name = result['image_file']
        else:
            name = save_picture(data['photo_image'])
            # delete the old image
            os.remove(f".\OnlineBookStore\static\Book_Image\{result['image_file']}")
        result = spcall('update_book', (book_id, title, author, publication, isbn, content, 
                                        price, piece, name), True)[0][0]
        return jsonify(result)
    else:
        abort(403)

def save_picture(image):
    print(guess_extension(guess_type(image)[0]))
    # handle the filename and directory
    extension = guess_extension(guess_type(image)[0])
    random_filename = ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(10))
    name = random_filename + extension

    # Save the image to uploads folder
    with open(f".\OnlineBookStore\static\Book_Image\{name}", "wb") as fh:
        im = Image.open(BytesIO(base64.b64decode(image.split(",")[1])))
        im.save(fh)

    return name

# add book
@app.route('/api/books', methods=['POST'])
@login_required
def add_book():
    if current_user.role == 'admin':
        data = request.get_json()
        title = data['title']
        author = data['author']
        publication = data['publication']
        isbn = data['isbn']
        content = data['content']
        price = data['price']
        piece = data['piece']
        name = save_picture(data['photo_image'])
        

        result = spcall('add_book', (title, author, publication, isbn, content, 
                                        price, piece, name), True)[0][0]
        return jsonify(result)
    else:
        abort(403)
