import os
from flask import Flask , request, render_template
app = Flask(__name__)



@app.route('/')
def index():
	return "200_OK"


@app.route("/user/<int:username>")
def user(username):
	return "Je suis le compte de " + str(username)




if __name__=="__main__":
    	app.run(host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT', 4444)))
