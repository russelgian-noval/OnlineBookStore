from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_login import LoginManager

app = Flask(__name__, static_url_path='/static')
app.config['SECRET_KEY'] = 'eebd384deb482dfef8f476d9f2adbe56'
app.config['SQLALCHEMY_DATABASE_URI']='postgresql://postgres:root@localhost:5432/db.sql'
db = SQLAlchemy(app)
bcrypt = Bcrypt(app)
login_manager = LoginManager(app)
login_manager.login_view = 'login'
login_manager.login_message_category = 'info'

from OnlineBookStore import routes
from OnlineBookStore import api
