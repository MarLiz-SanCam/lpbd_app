const express = require('express');
const cors = require('cors');
const app = express();

// Settings
app.set('port', process.env.PORT || 8000);

// Middlewares
app.use(cors());
app.use(express.json());

// Routes
app.use(require('./routes/user'));

// Starting the server
app.listen(app.get('port'), () => {
    console.log('Server on port', app.get('port'));
});
