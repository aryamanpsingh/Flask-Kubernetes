import datetime

from flask import current_app
from sqlalchemy.sql import func

from project import db


class employee(db.Model):

    __tablename__ = 'employees'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    fname = db.Column(db.String(255), nullable=False)
    lname = db.Column(db.String(255), nullable=False)
    citizen = db.Column(db.Boolean(), default=False, nullable=False)

    def __init__(self, fname, lname, citizen):
        self.fname = fname
        self.lname = lname
        self.citizen = citizen

    def to_json(self):
        return {
            'id': self.id,
            'fname': self.fname,
            'lname': self.lname,
            'citizen': self.citizen
        }
