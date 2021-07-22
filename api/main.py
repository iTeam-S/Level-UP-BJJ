import os
from flask import Flask , request, jsonify, flash, redirect, render_template
from conf import *
import mysql.connector, time
from datetime import date, datetime, timedelta
import jwt
from werkzeug.utils import secure_filename

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

def verifToken(token):
	try:
		return jwt.decode(token, options={"verify_signature": False})
	except:
		return {"sub":0}


app.config['MAX_CONTENT_LENGTH'] = 100 * 1024 * 1024

path = os.getcwd()

UPLOAD_FOLDER = os.path.join(path, 'uploads')

if not os.path.isdir(UPLOAD_FOLDER):
    os.mkdir(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

ALLOWED_EXTENSIONS = set(['mp4', 'mkv', 'avi'])

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


db = mysql.connector.connect(**database())
cursor = db.cursor()


@app.route('/')
def upload_form():
    return render_template('upload.html')


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

	data = request.get_json()
	
	token = data.get("token")
	user_id = data.get("user_id")

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

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
	token = data.get("token")
	user_id = data.get("user_id")

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

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
	
	module_id = data.get("module_id")
	nom = data.get("nom")
	token = data.get("token")
	user_id = data.get("user_id")

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

	try : 
		cursor.execute("""
			UPDATE Module SET nom = %s WHERE id = %s
		""",(nom, module_id)
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
	
	module_id = data.get("id")

	try : 
		cursor.execute("""
			DELETE FROM Module WHERE id = %s
		""",(module_id,)
		)
		db.commit()

	except Exception:
		return jsonify({'status': 'Bad request'}), 400

	return jsonify({'status': 'Suppression de module avec succès'}), 204


@app.route('/api/v1/upload_video/', methods=['POST'])
def upload_video():
	"""
		DESC : Fonction permettant d'uploader un vidéo
	"""
	token = request.form.get('token')
	user_id = request.form.get('user_id')

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

	if 'file' not in request.files:
		return jsonify({'status': 'No file selected'}), 400

	file = request.files['file']

	if file.filename == '':
		return jsonify({'status': 'No file selected'}), 400
	
	if file and allowed_file(file.filename):
		filename = secure_filename(file.filename)
		file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
		return jsonify({'status': 'Video uploaded successfully'}), 201
		
	else:
		return jsonify({'status': 'Allowed file types are mp4, mkv, avi'}), 400


if __name__=="__main__":
    app.run(host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT', 4444)))
