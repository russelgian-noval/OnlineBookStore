## Online Book Store
 ---
 
Using Flask-RESTapi and JS

1. `pip install pipenv` - download `pipenv` package if not installed
2. `pipenv install` - install from Pipfile
3. `pipenv shell` - to activate the virtual environment

For more info, [click here.](https://pipenv-fork.readthedocs.io/en/latest/basics.html)

## Database setup

Create a new database in your PostgreSQL server and run the sql script `db.sql`

## Configuration

Go to `OnlineBookStore/__init__.py` and change the `app.config['SQLALCHEMY_DATABASE_URI']` to your database URI.

---

## Run

`python run.py` to run the web application.

Default credentials:$\\$
**User**$\\$
Username: *test*$\\$
Password: *test@test.com* $\\$

**User**$\\$
Username: *test*$\\$
Password: *test@admin.com*
