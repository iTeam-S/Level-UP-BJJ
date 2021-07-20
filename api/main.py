import os
from flask import Flask , request, jsonify
from conf import *
import mysql.connector, time
from datetime import date, datetime, timedelta
import jwt

app = Flask(__name__)


def encode_auth_token(user_id):
    payload = {
        'exp': datetime.utcnow() + timedelta(days=7),
        'sub': user_id
    }
    return jwt.encode(
        payload,
        "MOT_SECRET_DECRYPTE",
        algorithm='HS256'
    )

db = mysql.connector.connect(**database())
cursor = db.cursor()


@app.route('/')
def index():
	return "200_OK"


@app.route("/api/v1/login/", methods=['POST'])
def login():
	"""
		DESC : Fonction permettant l'authentification d'un utilisateur
	"""
	data = request.get_json()
	mail = data.get("mail")
	password = data.get("password")

	cursor.execute("""
		SELECT id, admin FROM Utilisateur WHERE mail = %s AND password = %s
	""", (mail, password)
	)
	user_data = cursor.fetchone()

	if user_data is not None:
		token = encode_auth_token(user_data[0])
		return jsonify({
			'token' : token,
			'id': user_data[0],
			'admin': user_data[1]
		}), 200
	else:
		return jsonify({
			'status': 'Adresse email ou mot de passe incorrect',
		}), 403


if __name__=="__main__":
    	app.run(host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT', 4444)))

