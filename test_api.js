const http = require('http');
const data = JSON.stringify({
  name: "Test Alert",
  type: "overspeed",
  devices: [0],
  notifications: { push: 1 },
  active: "1"
});

const options = {
  hostname: '82.114.179.170',
  port: 30080,
  path: '/api/add_alert?lang=en&user_api_hash=$2y$10$5RACGMNxUdz3h1ug9yAttu95U2acugM0YG1K5wx01ZrNMvpL6BWMS',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Content-Length': Buffer.byteLength(data)
  }
};

const req = http.request(options, res => {
  let body = '';
  res.on('data', chunk => body += chunk);
  res.on('end', () => console.log(`Status: ${res.statusCode}\nBody: ${body}`));
});

req.on('error', e => console.error(e));
req.write(data);
req.end();
