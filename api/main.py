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
		return jsonify({'status': 'Adresse email ou mot de passe incorrect',}), 403


@app.route("/api/v1/get_all_modules/", methods=['GET'])
def get_all_modules():
	"""
		DESC : Fonction permettant de récuperer tous les modules
	"""

	cursor.execute("""
		SELECT id, nom FROM Module
	""")

	module_data = cursor.fetchall()

	if module_data is not None :
		return jsonify({"data": module_data}), 200
	
	else:
		return jsonify({'status': 'Bad request',}), 400


@app.route("/api/v1/create_module/", methods=['POST'])
def create_module():
	"""
		DESC : Fonction permettant de créer un module'
	"""
	data = request.get_json()
	
	nom = data.get("nom")

	try : 
		cursor.execute("""
			INSERT INTO Module(nom) VALUES("%s")
		""",(nom)
		)

	except Exception:
		return jsonify({'status': 'Module existant',}), 400

	return jsonify({'status': 'Création de module avec succès',}), 201


@app.route("/api/v1/update_module/", methods=['PUT'])
def update_module():
	"""
		DESC : Fonction permettant de modifier un module'
	"""
	data = request.get_json()
	
	id_module = data.get("id")
	nom = data.get("nom")

	try : 
		cursor.execute("""
			UPDATE Module SET nom = %s WHERE id = %s
		""",(nom, id_module)
		)
		db.commit()

	except Exception:
		return jsonify({'status': 'Bad request'}), 400

	return jsonify({'status': 'Module mis à jour avec succès'}), 204


@app.route("/api/v1/delete_module/", methods=['DELETE'])
def delete_module():
	"""
		DESC : Fonction permettant de supprimer un module'
	"""
	data = request.get_json()
	
	id_module = data.get("id")

	try : 
		cursor.execute("""
			DELETE FROM Module WHERE id = %s
		""",(id_module,)
		)
		db.commit()

	except Exception:
		return jsonify({'status': 'Bad request'}), 400

	return jsonify({'status': 'Suppression de module avec succès'}), 204


if __name__=="__main__":
    app.run(host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT', 4444)))

