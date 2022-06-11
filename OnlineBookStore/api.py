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
