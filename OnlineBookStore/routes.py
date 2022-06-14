import os
import secrets
from PIL import Image
from flask import render_template, url_for, flash, redirect, request
from OnlineBookStore import app, db, bcrypt
from OnlineBookStore.forms import RegistrationForm, LoginForm, UpdateAccountForm, AdminLoginForm, AddBookForm, UpdateBookForm
from OnlineBookStore.models import User,Admin,Book,Cart,Order,OrderBook
from flask_login import login_user, current_user, logout_user, login_required


@app.route("/")
def index():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    return render_template('public/index.html')

# homepage
@app.route("/home")
@login_required
def home():
    return render_template('home.html')

@app.route("/about")
def about():
    return render_template('about.html', title='About')

@app.route("/contact")
def contact():
    return render_template('contact.html', title='Contact Page')

# checkout
@app.route("/checkout")
@login_required
def checkout():
    return render_template('checkout.html')

# order
@app.route("/order")
def order():
    return render_template('order.html', title="order") 

# book_info
@app.route("/book_info/<int:book_id>")
def book_info(book_id):
    return render_template('book_info.html')

# cart
@app.route("/cart")
def cart():
    return render_template('cart.html', title="cart")

