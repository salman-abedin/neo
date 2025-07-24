from flask import Flask, jsonify, render_template_string

app = Flask(__name__)

# HTML template for the home page
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Simple Flask App</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        .endpoint { background: #f5f5f5; padding: 20px; margin: 10px 0; border-radius: 5px; }
        h1 { color: #333; }
        a { color: #007bff; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐍 Simple Flask App (V0.0.8)</h1>
        <p>Welcome to your dockerized Flask application!</p>
        
        <h2>Available Endpoints:</h2>
        
        <div class="endpoint">
            <h3><a href="/">/</a></h3>
            <p>Home page (this page)</p>
        </div>
        
        <div class="endpoint">
            <h3><a href="/api/hello">/api/hello</a></h3>
            <p>Returns a JSON greeting</p>
        </div>
        
        <div class="endpoint">
            <h3><a href="/api/status">/api/status</a></h3>
            <p>Returns application status</p>
        </div>
        
        <div class="endpoint">
            <h3><a href="/health">/health</a></h3>
            <p>Health check endpoint</p>
        </div>
    </div>
</body>
</html>
"""

@app.route('/')
def home():
    return render_template_string(HTML_TEMPLATE)

@app.route('/api/hello')
def hello():
    return jsonify({
        'message': 'Hello from Flask!',
        'status': 'success',
        'app': 'Simple Flask App'
    })

@app.route('/api/status')
def status():
    return jsonify({
        'status': 'running',
        'version': '1.0.0',
        'environment': 'docker'
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
