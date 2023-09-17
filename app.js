require('dotenv').config();

const express = require('express');
const nunjucks = require('nunjucks');
const path = require('path');
const { session } = require('./middlewares/session');

const testindexRouter = require('./routes/testIndex');
const authRouter = require('./routes/authRoutes');
const indexRouter = require('./routes/index');
<<<<<<< HEAD
const loginnRouter = require('./routes/loginn');
const faqRouter = require('./routes/faq');
=======
>>>>>>> 0288514ed5ad851df259c36be0249de4b550624a

const app = express();

// view template
nunjucks.configure('views', {
  autoescape: true,
  express: app,
});

app.set('views', path.join(__dirname, 'views'));
app.use(express.static('public'));
app.set('view engine', 'html');

// middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));
app.use(session);

app.use(testindexRouter);
app.use(authRouter);
app.use(indexRouter);
<<<<<<< HEAD
app.use(loginnRouter);
app.use(faqRouter);
=======
>>>>>>> 0288514ed5ad851df259c36be0249de4b550624a

// si no se encontro ningun recurso en alguna ruta
app.use((req, res) => {
  res.status(404).send('No se encontro esa pagina');
});

// error handler
app.use((err, req, res, next) => {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = process.env.NODE_ENV === 'development' ? err : {};
  console.log(err);
  res.status(500).send(err);
});

const PORT = process.env.PORT;

app.listen(PORT, () => {
  if (process.env.NODE_ENV === 'development') {
    console.log(`Server listening at http://localhost:${PORT}`);
  }
});
