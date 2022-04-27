from flask import jsonify, request
from OnlineBookStore import app
from OnlineBookStore.conndb import spcall
from flask_login import login_required, current_user
