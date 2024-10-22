const {Router } = require('express');
const router = Router();

const mysqlConnection = require('../database/database');
router.get('/', (req, res) => {
    res.status(200).json('server on port 8000 and database is connecter'); 
});

//obtener usuarios
router.get('/:usuarios', (req, res) => {
    mysqlConnection.query('select * from usuarios;', (err, rows, fields) => {
        if(!err){
            res.json(rows);
        }else{
            console.log(err);
        }
    });
});

//obtener usuario
router.get('/:usuarios/:idusuario', (req, res) => {
    const {idusuario} = req.params;
    mysqlConnection.query('select * from usuarios where id = ?;',[id], (error, rows, fields) =>{
        if(!error){
            res.json(rows);
        }else{
            console.log(error);
        }
    });
});


//crear usuario
router.post('/:usuarios', (req, res) => {
    const {idusuario, nombre_usuario, nombre, apellido, password} = req.body;
    console.log(req.body);
    mysqlConnection.query('insert into usuarios (idusuario, nombre_usuario, nombre, apellido, password ) values(?,?,?,?,?);',
    [idusuario, nombre_usuario, nombre, apellido, password ],(error, rows, fields)=>{
        if(!error){
                res.json({Status: 'Usuario creado'});
        }else{
                console.log(error);
        }
    });
});

//actualizar usuario
router.put('/:usuarios/:idusuario', (req, res) => {
    const {idusuario, nombre_usuario, nombre, apellido, mail, password} = req.body;
    console.log(req.body);
    mysqlConnection.query('update usuarios set nombre_usuario = ?, nombre = ?, apellido = ?, password? where idusuario = ?;',
    [nombre_usuario, nombre, apellido, password, idusuario],(error, rows, fields)=>{
        if(!error){
            res.json({Status: 'Usuario actualizado'});
        } else{
            console.log(error);
        }
    });
});

//eliminar usuario
router.delete('/:usuarios/:idusuario', (req, res) => {
    const {idusuario} = req.params;
    mysqlConnection.query('delete from usuarios where idusuario = ?;', [idusuario], (error, rows, fields) =>{
        if(!error){
            res.json({Status: 'Usuario eliminado'});
        }else{
            res.json({Status: error});
        }
    });
});

//iniciar sesion
router.post('/:usuarios/:login', (req, res) => {
    const {nombre_usuario, password} = req.body;
    console.log(req.body);
    mysqlConnection.query('select * from usuarios where nombre_usuario = ? and password = ?;',
    [nombre_usuario, password],(error, rows, fields)=>{
        if(!error){
            res.json(rows);
        }else{
            console.log(error);
        }
    });
});

module.exports = router;