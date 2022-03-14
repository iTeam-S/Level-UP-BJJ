import os
from flask import Flask , request, jsonify, render_template, send_from_directory
from flask_cors import CORS
from conf import database, TOKEN_PAYEMENT
import mysql.connector, time
from datetime import datetime, timedelta
import jwt
from werkzeug.utils import secure_filename
import cv2
import time
from random import randrange
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
# from send_code import send_mail
#from flask_socketio import SocketIO, emit, disconnect

webserver = Flask(__name__)
CORS(webserver)
#socket_ = SocketIO(app, async_mode=None)

webserver.config['MAX_CONTENT_LENGTH'] = 1000 * 1024 * 1024

path = os.getcwd()

if not os.path.isdir('data'):
	os.makedirs('data/videos')
	os.makedirs('data/covers')

UPLOAD_FOLDER = os.path.join(path, 'data/videos')

COVER_FOLDER = os.path.join(path, 'data/covers')

webserver.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

webserver.config['COVER_FOLDER'] = COVER_FOLDER

ALLOWED_EXTENSIONS_VIDEOS = set(['mp4', 'mkv', 'avi', 'webm'])

ALLOWED_EXTENSIONS_IMAGES = set(['jpg', 'png', 'jpeg'])


def encode_auth_token(user_id):
	payload = {
		'exp': datetime.utcnow() + timedelta(days=7),
		'sub': user_id
	}
	return jwt.encode(
		payload,
		os.environ.get('TOKEN_KEY'),
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
	return admin[0]


def send_mail(mail, content, objet):
	'''
		Fonction d'envoi de mail
	'''
	msg = MIMEMultipart('alternative')

	msg['Subject'] = objet
	msg['FROM'] = os.environ.get('MAIL_SENDER')
	msg['TO'] = mail

	message = MIMEText("@BJJ")

	html = MIMEText(f"""\
		<html>
			<body>
			  <div style="font-size:20">
				  <h3 style="color:blue"> BJJ Library ! </h3>
				  <br/>
				  {content}
			  </div>
			</body>
		</html>
	""", 'html')

	msg.attach(message)
	msg.attach(html)
	try:
		server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
		server.login(os.environ.get('MAIL_SENDER'), os.environ.get('MAIL_PASSWD'))
		server.sendmail(os.environ.get('MAIL_SENDER'), mail, msg.as_string())
		server.quit()
		return 0
	except Exception as err:
		print("Fa aona e", err)
		return 1


def extract(video_name):
	"""
		DESC : Fonction permettant d'extraire un image de la vidéo à 20% de sa durée
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


def allowed_file_video(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS_VIDEOS


def allowed_file_image(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS_IMAGES


@webserver.route('/')
def upload_form():
	return render_template('upload.html')


@webserver.route("/api/v1/login/", methods=['POST'])
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
		SELECT id, admin FROM Utilisateur WHERE mail = %s AND password = SHA2(%s, 224)
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


@webserver.route("/api/v1/forgot_password/", methods=['POST'])
def forgot():
	"""
		DESC : Fonction permettant de signaler un mot de passe oublié
	"""
	data = request.get_json()

	mail = data.get("mail")
	code = randrange(111111, 999999)
	db = mysql.connector.connect(**database())
	cursor = db.cursor()

	try:
		cursor.execute("""
			UPDATE Utilisateur SET code = SHA2(%s, 224) WHERE mail = %s
		""",(code, mail)
		)
		rowcount = cursor.rowcount
		db.commit()
		db.close()
		if rowcount == 0:
			raise Exception("Adresse Mail non trouvé")
		send_mail("Votre code de confirmation est : " + str(code), "Code de confirmation", mail)
		return {"status" : "Code de confirmation envoyé avec succès"}, 200
	
	except Exception as e:
		print(e)
		return jsonify({'status': "Cette adresse email n'est pas associée à un compte",}), 400


@webserver.route("/api/v1/verif_code/", methods=['POST'])
def confirmation():
	"""
		DESC : Fonction permettant vérifier le code de confirmation
	"""
	data = request.get_json()

	mail = data.get("mail")
	send_code = data.get("code")

	db = mysql.connector.connect(**database())
	cursor = db.cursor()

	cursor.execute("""
		UPDATE Utilisateur SET code = NULL, password = SHA2('', 224 )
		WHERE mail = %s AND code = SHA2(%s, 224) """
	, (mail, send_code))
	
	rowcount = cursor.rowcount
	db.commit() 

	if rowcount == 1:
		cursor.execute("""
			SELECT id, admin FROM Utilisateur WHERE mail = %s
		""", (mail,)
		)
		user_data = cursor.fetchone()
		db.close()
		token = encode_auth_token(user_data[0])
		return jsonify({
			'email': mail,
			'token': token,
			'id': user_data[0],
			'admin': user_data[1] == True
		}), 200
	db.close()
	return jsonify({'status': 'Code incorrecte.'}), 403
	
	
@webserver.route("/api/v1/get_all_modules/", methods=['POST'])
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


@webserver.route("/api/v1/create_module/", methods=['POST'])
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


@webserver.route('/api/v2/create_module/', methods=['POST'])
def create_module_v2():
	"""
		DESC : Fonction permettant de créer un module
	"""
	token = request.form.get('token')
	user_id = request.form.get('user_id')
	nom = request.form.get('nom')

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
	
	if file and allowed_file_image(file.filename):
		filename = str(time.time()) + secure_filename(file.filename)
		file.save(os.path.join(webserver.config['COVER_FOLDER'], filename))

		db = mysql.connector.connect(**database())
		cursor = db.cursor()
	
		cursor.execute("""
			INSERT INTO Module(nom, couverture, niveau) VALUES (%s, %s)
		""",(nom, filename)
		)
		db.commit()
		db.close()
		return jsonify({'status': 'Module created successfully'}), 201

	else:
		return jsonify({'status': 'Allowed file types are jpg, png, jpeg'}), 400


@webserver.route('/api/v2/get_cover/<cover>', methods=['GET'])
def get_cover(cover):
	"""
		DESC : Fonction permettant de récuperer la couverture d'un module
	"""
	token = request.args.get("token")

	if verifToken(token).get('sub') == 0 :
		return {"status" : "Erreur Token"}, 403

	return send_from_directory(directory='./data/covers/', path=cover, as_attachment=True)


@webserver.route("/api/v1/update_module/", methods=['POST'])
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


@webserver.route("/api/v1/delete_module/", methods=['DELETE'])
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


@webserver.route('/api/v1/upload_video/', methods=['POST'])
def upload_video():
	"""
		DESC : Fonction permettant d'uploader un vidéo
	"""
	token = request.form.get('token')
	user_id = request.form.get('user_id')
	module_id = request.form.get('module_id')
	niveau = request.form.get('niveau', 1)
	titre_video = request.form.get('titre_video')

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
	
	if file and allowed_file_video(file.filename):
		filename = str(time.time()) + secure_filename(file.filename)
		file.save(os.path.join(webserver.config['UPLOAD_FOLDER'], filename))
		image_name = extract("./data/videos/"+filename)

		db = mysql.connector.connect(**database())
		cursor = db.cursor()
	
		cursor.execute("""
			INSERT INTO Video(titre, nom, image, module_id, niveau) VALUES(%s, %s, %s, %s, %s)
		""",(titre_video, filename,  image_name, module_id, niveau)
		)
		db.commit()
		db.close()
		return jsonify({'status': 'Video uploaded successfully'}), 201

	else:
		return jsonify({'status': 'Allowed file types are mp4, mkv, avi, webm'}), 400
	

@webserver.route('/api/v1/get_all_videos/<int:limit>', methods=['GET'])
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


@webserver.route('/api/v1/get_videos/', methods=['POST'])
def get_videos():
	"""
		DESC : Fonction permettant de récuperer les vidéos
	"""
	data = request.get_json()
	
	module_id = data.get("module_id")
	user_id = data.get("user_id")
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
			'date_upload': video[2].strftime('%d %b %Y'),
			'nom': video[3],
			'image': video[4],
			'commentaire': list(map(struct_coms, coms_data)),
			'niveau': video[6]
		}

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403
	
	db = mysql.connector.connect(**database())
	cursor = db.cursor()

	resultat = []

	if module_id :
		cursor.execute("""
			SELECT id, nom, couverture FROM Module WHERE id = %s
		""",(module_id,)
		)
	else:
		cursor.execute("""
			SELECT id, nom, couverture FROM Module ORDER BY id 
		""")
	
	module_data = cursor.fetchall()

	for mdl in module_data:
		cursor.execute('''
			SELECT * FROM Video WHERE module_id = %s
			ORDER BY id DESC
		''', (mdl[0],))

		video_data = cursor.fetchall()

		resultat.append(
			{
				'module_id': mdl[0],
				'nom': mdl[1],
				'cover': mdl[2],
				'videos': list(map(struct_video, video_data))
			}
		)

	return  jsonify({'data': resultat}), 200


@webserver.route("/api/v1/update_video/", methods=['POST'])
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


@webserver.route("/api/v1/delete_video/", methods=['POST'])
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


@webserver.route('/api/v1/get_image/<image>', methods=['GET'])
def get_image(image):
	"""
		DESC : Fonction permettant de récuperer l'image d'une vidéo
	"""
	token = request.args.get("token")

	if verifToken(token).get('sub') == 0 :
		return {"status" : "Erreur Token"}, 403

	return send_from_directory(directory='./data/images/', path=image, as_attachment=True)


@webserver.route('/api/v1/get_video/<video>', methods=['GET'])
def get_video(video):
	"""
		DESC : Fonction permettant de récuperer la video d'une vidéo
	"""
	token = request.args.get("token")

	if verifToken(token).get('sub') == 0 :
		return {"status" : "Erreur Token"}, 403

	return send_from_directory(directory='./data/videos/', path=video, as_attachment=True)


@webserver.route('/api/v1/comment/', methods=['POST'])
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
	

	# Lancement des requêtes
	cursor.execute(
		'INSERT INTO Commentaire(text, user_id, video_id) VALUES (%s, %s, %s)',
		(text, user_id, video_id)	
	)

	# Sauvegarde des Transactions et Fermeture.
	db.commit()
	db.close()

	return {"status" : "Commentaire enregistree"}, 201


@webserver.route('/api/v1/get_notifications/', methods=['POST'])
def get_notifs():
	def struct_notifs(coms):
		return {
			'id': coms[0],
			'mail': coms[1],
			'titre': coms[2],
			'video_id': coms[3]
		}
	# Recuperation des données envoyés
	data = request.get_json()
	token = data.get("token")
	user_id = data.get("user_id")
	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

	user_admin = is_admin(user_id)
	if user_admin != 1 :
		return {"status" : "Vous n'avez pas assez de droit !"}, 403

	# Initialisation du connecteur
	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	
	# Lancement des requêtes
	cursor.execute('''
		SELECT C.id, U.mail, V.titre, V.id
		FROM Commentaire C JOIN Utilisateur U ON C.user_id = U.id
		JOIN Video V ON C.video_id = V.id
		WHERE C.notif=0 AND U.id <> %s
	''', (user_id,))
	result = list(map(struct_notifs, cursor.fetchall()))

	# Sauvegarde des Transactions et Fermeture.
	db.commit()
	db.close()

	return  jsonify({'data': result}), 200


@webserver.route('/api/v1/notif_view/', methods=['POST'])
def notif_view():
	"""
		DESC : Fonction permettant de mettre a jour notif commentaire'
	"""
	data = request.get_json()
	
	com_id = data.get("com_id")
	token = data.get("token")
	user_id = data.get("user_id")

	if verifToken(token).get('sub') != user_id:
		return {"status" : "Erreur Token"}, 403

	user_admin = is_admin(user_id)
	if user_admin != 1 :
		return {"status" : "Vous n'avez pas assez de droit !"}, 403

	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	
	cursor.execute("""
		UPDATE Commentaire set notif = 1 where id = %s
	""",(com_id,)
	)
	db.commit()
	db.close()
	return jsonify({'status': 'Suppression de la vidéo avec succès'}), 204


@webserver.route('/api/v1/check_mail', methods=['POST'])
def check_mail():
	"""
		DESC : Fonction permettant de vérifier la presence du mail dans la base'
	"""
	data = request.get_json()
	if not data:
		return jsonify({'status': 'Aucune donnée envoyé'}), 400
	mail = data.get("mail", '')

	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	
	cursor.execute("""
		SELECT COUNT(*) FROM Utilisateur WHERE mail = %s
	""",(mail,)
	)
	verif = cursor.fetchone()[0]
	db.commit()
	db.close()
	return jsonify({'data': verif}), 200


@webserver.route('/api/v1/create_account', methods=['POST'])
def create_account():
	"""
		DESC : Fonction permettant de créer un compte'
	"""
	data = request.get_json()
	
	mail = data.get("mail")
	password = data.get('password')
	payement_id = data.get("payement_id")
	
	if data.get("token") != TOKEN_PAYEMENT:
		return jsonify({"status" : "Erreur Token"}), 403

	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	try:
		cursor.execute("""
			INSERT INTO Utilisateur(mail, password, exp) VALUES(%s, SHA2(%s, 224), NOW() + INTERVAL 1 MONTH)
		""",(mail,password)
		)
		user_id = cursor.lastrowid

		cursor.execute("""
			INSERT INTO Payement(order_id, id_user, motif) VALUES (%s, %s, %s)
		""", (payement_id, user_id, 'INSCRIPTION'))

		db.commit()
		db.close()

	except Exception as err:
		print(err)
		db.rollback()
		db.close()
		return jsonify({"status" : "Erreur Interne"}), 500
	
	send_mail(
		mail,
		f"Votre mot de passe sur l'application BJJ est: <b>{password}</b>",
		'INSCRIPTION BJJ'
	)
	return jsonify(
		{ 
			'status': 'Création de compte avec succès',
			'id': user_id,
			'token': encode_auth_token(user_id),
			'email': mail,
			'admin': 0
		}
	), 201


@webserver.route('/api/v1/verif_expiration', methods=['POST'])
def verif_exp():
	"""
		DESC : Fonction permettant de vérifier la date d'expiration d'un utilisateur.'
	"""
	data = request.get_json()
	if not data:
		return jsonify({'status': 'Aucune donnée envoyé'}), 400
	
	user_id = data.get("user_id")
	token = data.get("token")

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	
	cursor.execute("""
		SELECT 
			CASE 
				WHEN exp > NOW() THEN True
				ELSE False
			END 
		FROM Utilisateur WHERE id = %s
	""",(user_id,)
	)
	verif = cursor.fetchone()[0]
	db.commit()
	db.close()
	return jsonify({'data': verif}), 200


@webserver.route('/api/v1/upgrade', methods=['POST'])
def upgrade():
	"""
		DESC : Fonction permettant de faire une renouvellement d'abonnement.'
	"""
	data = request.get_json()
	if not data:
		return jsonify({'status': 'Aucune donnée envoyé'}), 400
	
	user_id = data.get("user_id")
	token = data.get("token")
	payement_id = data.get("payement_id")

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	
	cursor.execute("""
		INSERT INTO Payement(order_id, id_user, motif) VALUES (%s, %s, %s)
	""",(payement_id, user_id, 'RENOUVELLEMENT')
	)

	cursor.execute("""
		UPDATE Utilisateur
			SET exp = NOW() + INTERVAL 1 MONTH 
		WHERE id = %s
	""",(user_id,)
	)
	db.commit()
	db.close()
	return jsonify({'data': 'ok'}), 202


@webserver.route('/api/v1/change_password', methods=['POST'])
def change_password():
	'''
		Route pour changer de mot de passe
	'''
	data = request.get_json()

	old_password = data.get("old_password")
	new_password = data.get("new_password")
	token = data.get("token")
	user_id = data.get("user_id")

	if verifToken(token).get('sub') != user_id :
		return {"status" : "Erreur Token"}, 403

	db = mysql.connector.connect(**database())
	cursor = db.cursor()

	cursor.execute('''
		UPDATE Utilisateur SET password = SHA2(%s, 224)
		WHERE id = %s and password = SHA2(%s, 224)
	''', (new_password, user_id, old_password))

	rowcount = cursor.rowcount
	db.commit()
	db.close()
	return jsonify({'data': rowcount!=0}), 200


@webserver.route('/api/v1/create_post', methods=['POST'])
def create_post():
	"""
		DESC : Fonction permettant de créer une publication'
	"""
	data = request.get_json()
	
	token = data.get("token")
	user_id = data.get("user_id")
	actu = data.get('post')

	if verifToken(token).get('sub') != user_id:
		return {"status" : "Erreur Token"}, 403

	user_admin = is_admin(user_id)
	if user_admin != 1 :
		return {"status" : "Vous n'avez pas assez de droit !"}, 403

	db = mysql.connector.connect(**database())
	cursor = db.cursor()

	if actu.get('type') == 'SONDAGE':

		cursor.execute("""
			INSERT INTO Actualite(text, contenue, id_user)
			VALUES (%s, %s, %s)
		""", (actu['text'], 1, user_id))
	
		actu_id = cursor.lastrowid
		for choix in actu.get('data'):
			cursor.execute("""
				INSERT INTO Sondage(actualite_id, choix)
				VALUES (%s, %s)
				""", 
				(actu_id, choix)
			)
	else:
		cursor.execute("""
			INSERT INTO Actualite(text, contenue, id_user)
			VALUES (%s, %s, %s)
			""", 
			(actu['text'], 0, user_id)
		)

	db.commit()
	db.close()
	return jsonify({'status': 'Création de post avec succes'}), 202


@webserver.route('/api/v1/vote', methods=['POST'])
def vote_sondage():
	"""
		Fonction permettant de choisir dans un sondage.
	"""
	data = request.get_json()
	
	token = data.get("token")
	user_id = data.get("user_id")
	sondage = data.get('sondage_id')

	if verifToken(token).get('sub') != user_id:
		return {"status" : "Erreur Token"}, 403

	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	cursor.execute("""
		INSERT INTO Sondage_utilisateur (user_id, sondage_id)
		VALUES (%s, %s)
	""", (user_id, sondage))

	db.commit()
	db.close()
	return jsonify({'status': 'Vote faite avec succès'}), 202


@webserver.route('/api/v1/unvote', methods=['POST'])
def unvote_sondage():
	"""
		Fonction permettant d'effacer le vote dans un sondage.
	"""
	data = request.get_json()
	
	token = data.get("token")
	user_id = data.get("user_id")
	sondage = data.get('sondage_id')

	if verifToken(token).get('sub') != user_id:
		return {"status" : "Erreur Token"}, 403

	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	cursor.execute("""
		DELETE FROM Sondage_utilisateur
		WHERE user_id = %s AND sondage_id = %s
	""", (user_id, sondage))

	db.commit()
	db.close()
	return jsonify({'status': 'Vote supprimé'}), 200


@webserver.route('/api/v1/delete_post', methods=['POST'])
def delete_post():
	"""
		Recupere la liste des actaulités
	"""
	data = request.get_json()
	
	token = data.get("token")
	user_id = data.get("user_id")
	actu = data.get("actualite_id")

	if verifToken(token).get('sub') != user_id:
		return {"status" : "Erreur Token"}, 403

	db = mysql.connector.connect(**database())
	cursor = db.cursor()
	cursor.execute("""
		DELETE FROM Actualite
		WHERE id = %s
		""", (actu, )
	)
	db.commit()
	db.close()
	return jsonify({'status': 'Post supprimé'}), 200



if __name__=="__main__":
	webserver.run(host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT', 4444)))
