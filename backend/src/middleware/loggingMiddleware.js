const loggingMiddleware = (req, res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`\n[${timestamp}] ${req.method} ${req.url}`);
  if (req.body && Object.keys(req.body).length > 0) {
    console.log('Body:', JSON.stringify(req.body, null, 2));
  }
  
  res.on('finish', () => {
    console.log(`Response: ${res.statusCode}`);
  });
  
  next();
};

module.exports = loggingMiddleware;
