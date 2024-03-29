import email
import os
import secrets
from PIL import Image
from flask import render_template, url_for, flash, redirect, request, abort
from OnlineBookStore import app, db, bcrypt
from OnlineBookStore.forms import RegistrationForm
from OnlineBookStore.models import User
from flask_login import login_user, current_user, logout_user, login_required

@app.route("/login", methods=['GET'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    return render_template('public/login.html', title='Login')

@app.route('/login', methods=['POST'])
def login_post():
    email = request.form.get('email')
    password = request.form.get('password')
    remember = True if request.form.get('remember') == 'y' else False

    user = User.query.filter_by(email=email).first()
    
    if not user or not bcrypt.check_password_hash(user.password, password):
        return redirect(url_for('login'))

    login_user(user, remember=remember)

    if user.role == 'user':
        return redirect(url_for('home'))
    else:
        return redirect(url_for('admin'))

@app.route("/register", methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    form = RegistrationForm()
    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        user = User(username=form.username.data, email=form.email.data, password=hashed_password, role='user')
        db.session.add(user)
        db.session.commit()
        flash('Your account has been created! You are now able to log in', 'success')
        return redirect(url_for('login'))
    return render_template('register.html', title='Register', form=form)

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

@app.route("/detail/<int:order_id>")
def detail(order_id):
    return render_template('detail.html', title="Order Detail") 

@app.route("/logout")
def logout():
    logout_user()
    return redirect(url_for('home'))

@app.route("/cancel",methods=['POST'])
def cancel():
    flash('Transaction has been Cancelled', 'success')
    return redirect(url_for('cart'))

# account page
@app.route("/account", methods=['GET', 'POST'])
@login_required
def account():
    return render_template('account.html', title='Account')

@app.route("/admin")
def admin():
    if current_user.is_authenticated and current_user.role == 'admin':
        return render_template('admin.html', title='Admin Page')
    else:
        abort(403)
        
# Update book
@app.route("/update_book/<int:book_id>",methods=['GET', 'POST'])
@login_required
def update_book(book_id):
    if current_user.role=='admin':
        return render_template('update_book.html', title='Update Book')
    else:
        return redirect(url_for('login'))

# admin login
@app.route("/adminlogin",methods=['GET', 'POST'])
def adminlogin():
    if current_user.is_authenticated and current_user.role=='admin':
        return redirect(url_for('admin'))
    else:
        return redirect(url_for('login'))

# Add book
@app.route("/addbook",methods=['GET', 'POST'])
@login_required
def addbook():
    if current_user.role=='admin':
        return render_template('addbook.html', title='Add Book') 
    else:
        return redirect(url_for('login'))
