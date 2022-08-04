from datetime import datetime
from OnlineBookStore import db, login_manager
from flask_login import UserMixin


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    image_file = db.Column(db.String(20), nullable=False, default='default.jpg')
    password = db.Column(db.String(60), nullable=False)
    address=db.Column(db.Text, nullable=True)
    state=db.Column(db.String(60), nullable=True)
    pincode=db.Column(db.Integer, nullable=True)
    role = db.Column(db.String(5), nullable=False, default='user')
    cart=db.relationship('Cart', backref='reader', lazy=True)
    order=db.relationship('Order', backref='buyer', lazy=True)
    orderbook=db.relationship('OrderBook', backref='orderby', lazy=True)

    def __repr__(self):
        return f"User('{self.id}', '{self.username}', '{self.email}', '{self.image_file}', '{self.password}'), '{self.role}'"
