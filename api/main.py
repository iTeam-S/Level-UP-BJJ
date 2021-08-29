import os
from flask import Flask , request, jsonify, render_template, send_from_directory
from conf import *
import mysql.connector, time
from datetime import datetime, timedelta
import jwt
from werkzeug.utils import secure_filename
import cv2
import time
#from flask_socketio import SocketIO, emit, disconnect

app = Flask(__name__)
#socket_ = SocketIO(app, async_mode=None)


def encode_auth_token(user_id):
	payload = {
		'exp': datetime.utcnow() + timedelta(days=7),
		'sub': user_id
	}
	return jwt.encode(
		payload,
		os.environ.get('TOKEN_KEY')
		algorithm='HS256'
	)

def verifToken(token):
	try:
		return jwt.decode(token, os.environ.get('TOKEN_KEY'), algorithms='HS256', options={"verify_signature": True})
	except Exception as err:
		print(err)
		return {"sub":0}

def is_admin(user_id):
	"""
		DESC : Fonction permettant de vérifier si un user est un administrateur ou pas
	"""
	db = mysql.connector.connect(**database())
	cursor = db.cursor()

	cursor.execute("""
		SELECT admin FROM Utilisateur WHERE id = %s
	""", (user_id,)
	)
	admin = cursor.fetchone()
	db.close()
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


app.config['MAX_CONTENT_LENGTH'] = 1000 * 1024 * 1024

path = os.getcwd()

if not os.path.isdir('data'):
	os.makedirs('data/videos')

UPLOAD_FOLDER = os.path.join(path, 'data/videos')

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

ALLOWED_EXTENSIONS = set(['mp4', 'mkv', 'avi', 'webm'])

def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

'''
@socket_.on('my_event', namespace='/test')
def test_message(message):
    session['receive_count'] = session.get('receive_count', 0) + 1
    emit('my_response',
         {'data': message['data'], 'count': session['receive_count']})


@socket_.on('my_broadcast_event', namespace='/test')
def test_broadcast_message(message):
    session['receive_count'] = session.get('receive_count', 0) + 1
    emit('my_response',
         {'data': message['data'], 'count': session['receive_count']},
         broadcast=True)


@socket_.on('disconnect_request', namespace='/test')
def disconnect_request():
    @copy_current_request_context
    def can_disconnect():
        disconnect()

    session['receive_count'] = session.get('receive_count', 0) + 1
    emit('my_response',
         {'data': 'Disconnected!', 'count': session['receive_count']},
         callback=can_disconnect)
'''

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

	db = mysql.connector.connect(**database())
	cursor = db.cursor()

	cursor.execute("""
		SELECT id, admin FROM Utilisateur WHERE mail = %s AND password = %s
	""", (mail, password)
	)

	user_data = cursor.fetchone()
	db.close()
	if user_data is not None:
		token = encode_auth_token(user_data[0])
		return jsonify({
			'token' : token,
			'id': user_data[0],
			'admin': user_data[1]
		}), 200
	else:
		return jsonify({'status': 'Adresse email ou mot de passe incorrect',}), 403


@app.route("/api/v1/get_all_modules/", methods=['POST'])
def get_all_modules():
	"""
		DESC : Fonction permettant de récuperer tous les modules
	"""

	data = request.get_json()
	
	token = data.get("token")
	user_id = data.get("user_id")

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403
	db = mysql.connector.connect(**database())
	cursor = db.cursor()

	cursor.execute("""
		SELECT id, nom FROM Module
	""")

	module_data = cursor.fetchall()
	db.close()

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

	db = mysql.connector.connect(**database())
	cursor = db.cursor()

	try : 
		cursor.execute("""
			INSERT INTO Module(nom) VALUES(%s)
		""",(nom,)
		)
		db.commit()
	
	except Exception as err:
		print(err)
		db.close()
		return jsonify({'status': 'Module existant !',}), 400
	db.close()
	return jsonify({'status': 'Création de module avec succès',}), 201


@app.route("/api/v1/update_module/", methods=['POST'])
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

	db = mysql.connector.connect(**database())
	cursor = db.cursor()

	try : 
		cursor.execute("""
			UPDATE Module SET nom = %s WHERE id = %s
		""",(nom, module_id)
		)
		db.commit()

	except Exception:
		db.close()
		return jsonify({'status': 'Module existant !'}), 400
	db.close()
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
	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	try : 
		cursor.execute("""
			DELETE FROM Module WHERE id = %s
		""",(module_id,)
		)
		db.commit()

	except Exception:
		db.close()
		return jsonify({'status': "Ce module est en cours d'utilisation"}), 400

	return jsonify({'status': 'Suppression de module avec succès'}), 204


@app.route('/api/v1/upload_video/', methods=['POST'])
def upload_video():
	"""
		DESC : Fonction permettant d'uploader un vidéo
	"""
	token = request.form.get('token')
	user_id = request.form.get('user_id')
	module_id = request.form.get('module_id')
	titre_video = request.form.get('titre_video')
	print(token, user_id)
	user_admin = is_admin(user_id)

	if user_admin != 1 :
		return {"status" : "Vous n'avez pas assez de droit !"}, 403

	if verifToken(token).get('sub') != int(user_id):
		return {"status" : "Erreur Token"}, 403


	if 'file' not in request.files:
		return jsonify({'status': 'No file selected'}), 400

	file = request.files['file']

	if file.filename == '':
		return jsonify({'status': 'No file selected'}), 400
	
	if file and allowed_file(file.filename):
		filename = str(time.time()) + secure_filename(file.filename)
		file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
		image_name = extract("./data/videos/"+filename)

		db = mysql.connector.connect(**database())
		cursor = db.cursor()
	
		cursor.execute("""
			INSERT INTO Video(titre, nom, image, module_id) VALUES(%s, %s, %s, %s)
		""",(titre_video, filename,  image_name, module_id)
		)
		db.commit()
		db.close()
		return jsonify({'status': 'Video uploaded successfully'}), 201

	else:
		return jsonify({'status': 'Allowed file types are mp4, mkv, avi, webm'}), 400
	

@app.route('/api/v1/get_all_videos/<int:limit>', methods=['GET'])
def get_all_videos(limit):
	"""
		DESC : Fonction permettant de récuperer tous les vidéos
	"""
	data = request.get_json()

	token = data.get('token')
	user_id = data.get('user_id')

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	
	cursor.execute("""
		SELECT * FROM Video ORDER BY id DESC LIMIT %s
	""",(limit,)
	)

	video_data = cursor.fetchall()
	db.close()
	return jsonify({"data": video_data}), 200


@app.route('/api/v1/get_videos/', methods=['POST'])
def get_videos():
	"""
		DESC : Fonction permettant de récuperer les vidéos
	"""
	data = request.get_json()
	
	module_id = data.get("module_id")
	user_id = data.get("user_id")
	limit =  data.get("limit")
	token = data.get('token')

	def struct_coms(coms):
		return {
			'id': coms[0],
			'date_post': coms[1],
			'text': coms[2],
			'user_id': coms[3],
			'user_email': coms[4]
		}

	def struct_video(video):
		cursor.execute("""
			SELECT C.id, date_poste, text, user_id, U.mail 
			FROM Commentaire C JOIN Utilisateur U on C.user_id = U.id
			WHERE video_id = %s ORDER BY id 
		""", (video[0],))
		coms_data = cursor.fetchall()
		return {
			'id': video[0],
			'titre': video[1],
			'date_upload': video[2],
			'nom': video[3],
			'image': video[4],
			'commentaire': list(map(struct_coms, coms_data))
		}

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403
	
	db = mysql.connector.connect(**database())
	cursor = db.cursor()

	resultat = []

	if module_id :
		cursor.execute("""
			SELECT id, nom FROM Module WHERE id = %s
		""",(module_id,)
		)
	else:
		cursor.execute("""
			SELECT id, nom FROM Module ORDER BY id 
		""")
	
	module_data = cursor.fetchall()

	for mdl in module_data:
		cursor.execute('''
			SELECT * FROM Video WHERE module_id = %s
			ORDER BY id DESC
		''', (mdl[0],))

		video_data = cursor.fetchall()[:limit]

		resultat.append(
			{
				'module_id': mdl[0],
				'nom': mdl[1],
				'videos': list(map(struct_video, video_data))
			}
		)

	return  jsonify({'data': resultat}), 200


@app.route("/api/v1/update_video/", methods=['POST'])
def update_video():
	"""
		DESC : Fonction permettant de modifier une vidéo'
	"""
	data = request.get_json()
	
	video_id = data.get("video_id")
	titre = data.get("titre")
	token = data.get("token")
	user_id = data.get("user_id")

	user_admin = is_admin(user_id)

	if user_admin != 1 :
		return {"status" : "Vous n'avez pas assez de droit !"}, 403

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403
	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	
	cursor.execute("""
		UPDATE Video SET titre = %s WHERE id = %s
	""",(titre, video_id)
	)
	db.commit()
	db.close()
	return jsonify({'status': 'Vidéo mise à jour avec succès'}), 204


@app.route("/api/v1/delete_video/", methods=['POST'])
def delete_video():
	"""
		DESC : Fonction permettant de supprimer une vidéo'
	"""
	data = request.get_json()
	
	video_id = data.get("video_id")
	token = data.get("token")
	user_id = data.get("user_id")

	user_admin = is_admin(user_id)

	if user_admin != 1 :
		return {"status" : "Vous n'avez pas assez de droit !"}, 403

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403
	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	
	cursor.execute("""
		DELETE FROM Video WHERE id = %s
	""",(video_id,)
	)
	db.commit()
	db.close()
	return jsonify({'status': 'Suppression de la vidéo avec succès'}), 204


@app.route('/api/v1/get_image/<image>', methods=['GET'])
def get_image(image):
	"""
		DESC : Fonction permettant de récuperer l'image d'une vidéo
	"""
	token = request.args.get("token")

	if verifToken(token).get('sub') == 0 :
		return {"status" : "Erreur Token"}, 403

	return send_from_directory(directory='./data/images/', path=image, as_attachment=True)


@app.route('/api/v1/get_video/<video>', methods=['GET'])
def get_video(video):
	"""
		DESC : Fonction permettant de récuperer la video d'une vidéo
	"""
	token = request.args.get("token")

	if verifToken(token).get('sub') == 0 :
		return {"status" : "Erreur Token"}, 403

	return send_from_directory(directory='./data/videos/', path=video, as_attachment=True)


@app.route('/api/v1/comment/', methods=['POST'])
def comment():
	# Recuperation des données envoyés
	data = request.get_json()
	video_id = data.get("video_id")
	token = data.get("token")
	user_id = data.get("user_id")
	text = data.get("text")

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

	# Initialisation du connecteur
	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	

	# Lancement des requetes
	cursor.execute(
		'INSERT INTO Commentaire(text, user_id, video_id) VALUES (%s, %s, %s)',
		(text, user_id, video_id)	
	)

	# Sauvegarde des Transactions et Fermeture.
	db.commit()
	db.close()

	return {"status" : "Commentaire enregistree"}, 201



if __name__=="__main__":
	app.run(host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT', 4444)))
