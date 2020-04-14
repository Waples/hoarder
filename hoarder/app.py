#!/usr/bin/env python
"""A simple crud snippet collector."""
#pylint: disable=C0103,C0115,C0116,E0401,R0903,W0703,W0622
from datetime import datetime
from flask import Flask, render_template, request, redirect
from flask_sqlalchemy import SQLAlchemy


app = Flask(__name__)       # flask init
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///snippets.db'
db = SQLAlchemy(app)


class Snippet(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(32), nullable=False)
    content = db.Column(db.String(600), nullable=False)
    date_created = db.Column(db.DateTime, default=datetime.utcnow)

    def __repr__(self):
        return '<Snippet %r>' % self.id


@app.route('/', methods=['POST', 'GET'])
def index():
    if request.method == 'POST':
        snippet_name = request.form['name']
        snippet_content = request.form['content']
        new_snippet = Snippet(name=snippet_name, content=snippet_content)
        try:
            db.session.add(new_snippet)
            db.session.commit()
            return redirect('/')
        except Exception as err:
            return f'There was an issue adding your snippet: {err}.'
    else:
        snippets = Snippet.query.order_by(Snippet.date_created).all()
        return render_template('index.html', snippets=snippets)


@app.route('/delete/<int:id>')
def delete(id):
    snippet_to_delete = Snippet.query.get_or_404(id)
    try:
        db.session.delete(snippet_to_delete)
        db.session.commit()
        return redirect('/')
    except Exception as err:
        return f'There was an issue deleting that snippet: {err}.'


@app.route('/update/<int:id>', methods=['GET', 'POST'])
def update(id):
    snippet = Snippet.query.get_or_404(id)
    if request.method == 'POST':
        snippet.content = request.form['content']
        try:
            db.session.commit()
            return redirect('/')
        except Exception as err:
            return f'There was an issue updating your snippet: {err}.'
    else:
        return render_template('update.html', snippet=snippet)


if __name__ == '__main__':
    app.run(debug=True, port=6060)
