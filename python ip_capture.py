from flask import Flask, request, jsonify

app = Flask(__name__)

# Diccionario para almacenar IPs (puedes usar una base de datos en la práctica)
user_ips = {}

@app.route('/capture_ip/<user_id>', methods=['GET'])
def capture_ip(user_id):
    user_ip = request.remote_addr
    user_ips[user_id] = user_ip
    print(f"IP capturada para usuario {user_id}: {user_ip}")
    return jsonify({"message": "IP capturada con éxito"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
