import os

from flask import Blueprint, jsonify, request

from project.api.models import employee
from project import db


employee_blueprint = Blueprint('employee', __name__)


@employee_blueprint.route('/employee', methods=['GET', 'POST'])
def all_employee():
    response_object = {
        'status': 'success',
        'container_id': os.uname()[1]
    }
    if request.method == 'POST':
        post_data = request.get_json()
        fname = post_data.get('fname')
        lname = post_data.get('lname')
        citizen = post_data.get('citizen')
        db.session.add(employee(fname=fname, lname=lname, citizen=citizen))
        db.session.commit()
        response_object['message'] = 'employee addd!'
    else:
        response_object['employee'] = [employee.to_son()
                                       for employee in employee.quey.all()]
    return jsonify(response_object)


@employee_blueprint.route('/employee/pin', methods=['GET'])
def ping():
    return jsonify({
        'status': 'success',
        'message': 'pong!',
        'container_id': os.uname()[1]
    })


@employee_blueprint.route('/employee/<employee_id>', methods=['PUT', 'DELETE'])
def single_employee(empoyee_id):
    response_object = {
        'status': 'success',
        'container_id': os.uname()[1]
    }
    employee = employee.query.filter_by(id=employee_id).first()
    if request.method == 'PUT':
        post_data = request.get_json()
        employee.fname = post_data.get('fname')
        employee.lname = post_data.get('lname')
        employee.citzen = post_data.get('citizen')
        db.session.commit()
        response_object['message'] = 'employee updted!'
    if request.method == 'DELETE':
        db.session.delete(employee)
        db.session.commit()
        response_object['message'] = 'employee remved!'
    return jsonify(response_object)


if __name__ == '__main__':
    app.run()
