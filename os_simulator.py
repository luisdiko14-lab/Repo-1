from flask import Flask, render_template_string, send_from_directory
import os

app = Flask(__name__)

# Basic layout template
LAYOUT = """
<!DOCTYPE html>
<html>
<head>
    <title>OS Simulator</title>
    <style>
        body { font-family: Segoe UI, Arial, sans-serif; background: #0078D7; color: white; margin: 0; height: 100vh; display: flex; flex-direction: column; }
        .taskbar { height: 40px; background: rgba(0,0,0,0.8); position: fixed; bottom: 0; width: 100%; display: flex; align-items: center; padding: 0 10px; }
        .start-btn { background: #00b06f; border: none; color: white; padding: 5px 15px; cursor: pointer; }
        .desktop { flex: 1; display: flex; justify-content: center; align-items: center; position: relative; }
        .window { background: white; color: black; border-radius: 5px; box-shadow: 0 0 20px rgba(0,0,0,0.5); padding: 20px; width: 400px; }
        .progress-bar { width: 100%; height: 20px; background: #eee; border-radius: 10px; overflow: hidden; margin-top: 10px; }
        .progress-inner { height: 100%; background: #00b06f; width: 0%; transition: width 0.1s; }
        input { width: 100%; padding: 8px; margin: 10px 0; border: 1px solid #ccc; box-sizing: border-box; }
        button { background: #00b06f; color: white; border: none; padding: 10px 20px; cursor: pointer; border-radius: 3px; }
        .clock { margin-left: auto; font-size: 14px; }
    </style>
</head>
<body>
    <div class="desktop">
        {% block content %}{% endblock %}
    </div>
    <div class="taskbar">
        <button class="start-btn">Start</button>
        <div class="clock" id="clock"></div>
    </div>
    <script>
        function updateClock() {
            const now = new Date();
            document.getElementById('clock').innerText = now.toLocaleTimeString();
        }
        setInterval(updateClock, 1000);
        updateClock();
    </script>
</body>
</html>
"""

@app.route('/')
def installer():
    return render_template_string(LAYOUT + """
    {% block content %}
    <div class="window">
        <h2>OS Simulator Installer</h2>
        <p>Welcome! Click below to begin the installation simulation.</p>
        <button onclick="startInstall()">Begin Installation</button>
        <div id="install-progress" style="display:none;">
            <p id="status">Extracting files...</p>
            <div class="progress-bar"><div id="bar" class="progress-inner"></div></div>
        </div>
    </div>
    <script>
    function startInstall() {
        document.querySelector('button').style.display = 'none';
        document.getElementById('install-progress').style.display = 'block';
        let width = 0;
        let bar = document.getElementById('bar');
        let status = document.getElementById('status');
        let id = setInterval(() => {
            if (width >= 100) {
                clearInterval(id);
                window.location.href = '/setup';
            } else {
                width++;
                bar.style.width = width + '%';
                if(width > 40) status.innerText = 'Installing components...';
                if(width > 80) status.innerText = 'Finalizing...';
            }
        }, 50);
    }
    </script>
    {% endblock %}
    """)

@app.route('/setup')
def setup():
    return render_template_string(LAYOUT + """
    {% block content %}
    <div class="window">
        <h2>Windows Setup</h2>
        <p>Please create your user account.</p>
        <input type="text" id="username" placeholder="Username">
        <input type="password" id="password" placeholder="Password">
        <button onclick="finishSetup()">Finish Setup</button>
    </div>
    <script>
    function finishSetup() {
        const user = document.getElementById('username').value;
        const pass = document.getElementById('password').value;
        if(!user || !pass) { alert('Please fill all fields'); return; }
        window.location.href = '/desktop?user=' + encodeURIComponent(user);
    }
    </script>
    {% endblock %}
    """)

@app.route('/desktop')
def desktop():
    return render_template_string(LAYOUT + """
    {% block content %}
    <div style="text-align:center;">
        <h1 style="font-size: 48px; text-shadow: 2px 2px 4px rgba(0,0,0,0.5);">Welcome to OS Simulator</h1>
        <p style="font-size: 24px;">Hello, {{ request.args.get('user', 'User') }}!</p>
    </div>
    {% endblock %}
    """)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
