import http.server
import os
import sys

DIRECTORY = os.path.join(os.path.dirname(__file__), 'build', 'web')

class SPAHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def do_GET(self):
        # Translate the URL path to a filesystem path
        path = self.translate_path(self.path)
        # If the file exists, serve it normally
        if os.path.exists(path) and not os.path.isdir(path):
            return super().do_GET()
        if os.path.isdir(path):
            index_path = os.path.join(path, 'index.html')
            if os.path.exists(index_path):
                return super().do_GET()
        # Fallback to index.html for client-side routing
        self.path = '/index.html'
        return super().do_GET()

if __name__ == '__main__':
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    server = http.server.HTTPServer(('0.0.0.0', port), SPAHandler)
    print(f"Serving SPA from {DIRECTORY} on port {port}")
    server.serve_forever()
