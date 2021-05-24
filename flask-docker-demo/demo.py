from flask.cli import FlaskGroup
from flask import Flask
from project import create_app, db
from project.api.models import employee

app = create_app()
cli = FlaskGroup(create_app=create_app)


@cli.command('recreate_db')
def recreate_db():
    db.drop_all()
    db.create_all()
    db.session.commit()


@cli.command('seed_db')
def seed_db():
    """Seeds the database."""
    db.session.add(employee(
        fname='john',
        lname='doe',
        citizen=True
    ))
    db.session.add(employee(
        fname='Harry',
        lname='Rowling',
        citizen=False
    ))
    db.session.add(employee(
        fname='Ham',
        lname='Seuss',
        citizen=True
    ))
    db.session.commit()


if __name__ == '__main__':
    cli()
