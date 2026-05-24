module.exports = (req, res) => {
  res.setHeader('Content-Type', 'text/plain; charset=utf-8');
  res.status(200).send(
    'REST API PreLoved Shopping — FCM push. Topic default: preloved-shopping. Endpoints: /send-to-device, /send-to-multiple, /send-to-topic',
  );
};
