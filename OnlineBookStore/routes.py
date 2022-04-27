import os
import secrets
from PIL import Image
from flask import render_template, url_for, flash, redirect, request
from OnlineBookStore import app, db, bcrypt
from OnlineBookStore.forms import RegistrationForm, LoginForm, UpdateAccountForm, AdminLoginForm, AddBookForm, UpdateBookForm
from OnlineBookStore.models import User,Admin,Book,Cart,Order,OrderBook
from flask_login import login_user, current_user, logout_user, login_required
