import os
from flask import Flask , request, jsonify, flash, redirect, render_template
from conf import *
import mysql.connector, time
from datetime import date, datetime, timedelta
import jwt
from werkzeug.utils import secure_filename
import cv2
import time

app = Flask(__name__)

db = mysql.connector.connect(**database())
cursor = db.cursor()


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

def is_admin(user_id):
	"""
		DESC : Fonction permettant de vérifier si un user est un administrateur ou pas
	"""
	cursor.execute("""
		SELECT admin FROM Utilisateur WHERE id = %s
	""", (user_id,)
	)
	admin = cursor.fetchone()
	return admin[0]

def extract(video_name):
	"""
		DESC : Fonction permettant d'extraire l'image de la vidéo à la 20ème % de sa durée
	"""
	cam = cv2.VideoCapture(video_name)

	nb_frame = cam.get(cv2.CAP_PROP_FRAME_COUNT)
	start_cap = ((nb_frame / 30) * 0.20) * 1000
	
	try:
		os.makedirs('data/images')
	
	except OSError:
		print ('Directory already exists')

	cam.set(cv2.CAP_PROP_POS_MSEC, start_cap)  
	currentframe = start_cap
		
	ret,frame = cam.read(currentframe)

	if ret:
		name = 'image_' + str(time.time()) + '.jpg'
		cv2.imwrite("./data/images/"+name, frame)

		return name

	cam.release()
	cv2.destroyAllWindows()


app.config['MAX_CONTENT_LENGTH'] = 100 * 1024 * 1024

path = os.getcwd()

UPLOAD_FOLDER = os.path.join(path, 'data/videos')

if not os.path.isdir(UPLOAD_FOLDER):
	os.mkdir(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

ALLOWED_EXTENSIONS = set(['mp4', 'mkv', 'avi', 'webm'])

def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


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

	user_admin = is_admin(user_id)

	if user_admin != 1 :
		return {"status" : "Vous n'avez pas assez de droit !"}, 403

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

	user_admin = is_admin(user_id)

	if user_admin != 1 :
		return {"status" : "Vous n'avez pas assez de droit !"}, 403

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

	try : 
		cursor.execute("""
			INSERT INTO Module(nom) VALUES(%s)
		""",(nom)
		)
		db.commit()

	except Exception:
		return jsonify({'status': 'Module existant !',}), 400

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

	user_admin = is_admin(user_id)

	if user_admin != 1 :
		return {"status" : "Vous n'avez pas assez de droit !"}, 403

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

	try : 
		cursor.execute("""
			UPDATE Module SET nom = %s WHERE id = %s
		""",(nom, module_id)
		)
		db.commit()

	except Exception:
		return jsonify({'status': 'Module existant !'}), 400

	return jsonify({'status': 'Module mis à jour avec succès'}), 204


@app.route("/api/v1/delete_module/", methods=['DELETE'])
def delete_module():
	"""
		DESC : Fonction permettant de supprimer un module'
	"""
	data = request.get_json()
	
	module_id = data.get("module_id")
	token = data.get("token")
	user_id = data.get("user_id")

	user_admin = is_admin(user_id)

	if user_admin != 1 :
		return {"status" : "Vous n'avez pas assez de droit !"}, 403

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

	try : 
		cursor.execute("""
			DELETE FROM Module WHERE id = %s
		""",(module_id,)
		)
		db.commit()

	except Exception:
		return jsonify({'status': "Ce module est en cours d'utilisation"}), 400

	return jsonify({'status': 'Suppression de module avec succès'}), 204


@app.route('/api/v1/upload_video/', methods=['POST'])
def upload_video():
	"""
		DESC : Fonction permettant d'uploader un vidéo
	"""
	token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc3MjMwNzksInN1YiI6M30.U8qAatBoULsxrD3QkCPO8skGI5TiZ-UX9LyM93UM5dw"
	# token = request.form.get('token')
	user_id = 3
	module_id = 1
	titre_video = "Pompe 20 fois par jour, pourquoi ?"

	user_admin = is_admin(user_id)

	if user_admin != 1 :
		return {"status" : "Vous n'avez pas assez de droit !"}, 403

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
		image_name = extract("./data/videos/"+filename)

		cursor.execute("""
			INSERT INTO Video(titre, nom, image, module_id) VALUES(%s, %s, %s, %s)
		""",(titre_video, str(time.time())+filename,  image_name, module_id)
		)
		db.commit()

		return jsonify({'status': 'Video uploaded successfully'}), 201

	else:
		return jsonify({'status': 'Allowed file types are mp4, mkv, avi, webm'}), 400
	

@app.route('/api/v1/get_all_videos/<int:limit>', methods=['GET'])
def get_all_videos(limit):
	"""
		DESC : Fonction permettant de récuperer les vidéos
	"""
	token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc3MjMwNzksInN1YiI6M30.U8qAatBoULsxrD3QkCPO8skGI5TiZ-UX9LyM93UM5dw"
	# token = request.form.get('token')
	user_id = 3

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403
	
	cursor.execute("""
		SELECT * FROM Video ORDER BY id DESC LIMIT %s
	""",(limit,)
	)

	video_data = cursor.fetchall()

	return jsonify({"data": video_data}), 200

# result = [
# {'module_id': 1,
# 'nom': 'gv',
# 'videos': [ 
# 	{'id'}, {}
# ]}, {}
# ]


if __name__=="__main__":
	app.run(host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT', 4444)))
