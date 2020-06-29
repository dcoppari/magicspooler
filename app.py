import os
import tempfile
import subprocess

from flask import request, url_for, send_file
from flask_api import FlaskAPI, status, exceptions
from flask_httpauth import HTTPBasicAuth

app = FlaskAPI(__name__)
auth = HTTPBasicAuth()


@auth.verify_password
def verify_password(username, password):

    MAGICSPOOLER_USER=os.getenv("MAGICSPOOLER_USER", "")
    MAGICSPOOLER_PASSWORD=os.getenv("MAGICSPOOLER_PASSWORD", "")

    if MAGICSPOOLER_PASSWORD == "":
        return False

    if MAGICSPOOLER_USER == "":
        MAGICSPOOLER_USER = MAGICSPOOLER_PASSWORD

    return (username == MAGICSPOOLER_USER and password == MAGICSPOOLER_PASSWORD)

@app.route("/chrome/pdf", methods=['GET', 'POST'])
@auth.login_required
def chrome_pdf_url():
    """
    Convert an URL or Web Page to PDF using Headless Chrome
    """

    output = ""
    url = request.values.get("url")

    if url != "":
        output = subprocess.getoutput("magicspooler.sh --chrome-to-pdf " + url)

    return evaluates_output(output)

@app.route("/chrome/image", methods=['GET', 'POST'])
@auth.login_required
def chrome_image_url():
    """
    Convert an URL or Web Page to Image using Headless Chrome.
    """

    output = ""
    url = request.values.get("url")

    if url != "":
        output = subprocess.getoutput("magicspooler.sh --chrome-to-png " + url)

    return evaluates_output(output, 'image/png', 'png')

@app.route("/libreoffice/pdf", methods=['POST'])
@auth.login_required
def libreoffice_pdf():
    """
    Convert Office Document or Image File to PDF format using LibreOffice
    """

    output = ""

    if 'file' not in request.files:
        return '', status.HTTP_400_BAD_REQUEST

    file = request.files['file']

    if file.filename == '':
        return '', status.HTTP_400_BAD_REQUEST

    TEMP_FOLDER=tempfile.mkdtemp()

    sourcefile = os.path.join(TEMP_FOLDER, file.filename)
    file.save(sourcefile)

    output = subprocess.getoutput("magicspooler.sh --office-to-pdf " + sourcefile)

    return evaluates_output(output)

@app.route("/")
def hello():
    return "Hello World!", status.HTTP_200_OK



def evaluates_output(output, mimetype='application/pdf', extension='pdf'):

    if output.startswith('NOK'):
        return '', status.HTTP_400_BAD_REQUEST

    file = output.split()

    return send_file( file[1], mimetype, True, 'Document.' + extension )



if __name__ == "__main__":
    app.run( host="0.0.0.0", port=5000, debug=True )