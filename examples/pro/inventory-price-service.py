#!/usr/bin/env python3
"""The pricing rule of lesson 5.4 as a small outside service (Python 3, standard library only).

Simulation 101, lesson 5.4 (optional section). samples/pro/inventory-price-service.xml calls this program through ServiceCall,
protocol spicegrinder.servicecall/v1: the model POSTs JSON to http://127.0.0.1:8765/price; the service first asks for the model's
input ShelfForPrice (answering {"action": "need", ...}) and, once it has the smoothed stock and the current price, answers with the new
price ({"action": "result", ...}). The rule is the Reprice node of samples/pro/inventory-price-feedback.xml, to the cent:
    price := min(12, max(8, price + G * (21 - avg))),  G = 0.05

Run:   python3 samples/pro/inventory-price-service.py        (then, in another terminal, grind the model; stop with Ctrl+C)
It binds 127.0.0.1 only, so nothing outside this machine can reach it, and it keeps no state: the answer depends only on the request,
which is why a run through the service is repeatable. SpiceGrinder will not call it until service.url.allowlist in
~/.spicegrinder/preferences.properties contains http://127.0.0.1:8765/ (the model's header comment has the steps).
"""
import json
import math
from http.server import BaseHTTPRequestHandler, HTTPServer

G, TARGET, LOW, HIGH = 0.05, 21.0, 8.0, 12.0


def new_price(avg, price):
    v = min(HIGH, max(LOW, price + G * (TARGET - avg)))
    return math.floor(v * 100 + 0.5) / 100          # to the cent, half up (the model's round())


class Pricing(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"          # keep the connection open between the two requests of a row, as Java's HTTP client expects

    def do_POST(self):
        request = json.loads(self.rfile.read(int(self.headers["Content-Length"])))
        provided = request.get("provided", {})
        if "ShelfForPrice" not in provided:
            reply = {"action": "need", "inputs": ["ShelfForPrice"]}
        else:
            avg, price = (float(v) for v in provided["ShelfForPrice"])      # the cells avg, price
            reply = {"action": "result", "values": [repr(new_price(avg, price))]}
        body = json.dumps(reply).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    HTTPServer(("127.0.0.1", 8765), Pricing).serve_forever()
