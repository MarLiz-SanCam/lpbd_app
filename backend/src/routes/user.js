const {Router } = require('express');
const router = Router();

const mysqlConnection = require('../database/database');
router.get('/', (req, res) => {
    res.status(200).json('server on port 8000 and database is connecter'); 
});

router.get('/:usuarios', (req, res) => {
    mysqlConnection.query('select * from usuarios;', (err, rows, fields) => {
        if(!err){
            res.json(rows);
        }else{
            console.log(err);
        }
    });
});

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

router.post('/:usuarios', (req, res) => {
    const {idusuario, nombre_usuario, password} = req.body;
    console.log(req.body);
    mysqlConnection.query('insert into usuarios (idusuario, nombre_usuario, password) values(?,?,?);',
    [idusuario, nombre_usuario, password, ],(error, rows, fields)=>{
        if(!error){
                res.json({Status: 'Usuario creado'});
        }else{
                console.log(error);
        }
    });
});

router.put('/:usuarios/:idusuario', (req, res) => {
    const {idusuario, nombre_usuario, password} = req.body;
    console.log(req.body);
    mysqlConnection.query('update usuarios set nombre_usuario = ?, password = ? where idusuario = ?;',
    [nombre_usuario, password, idusuario],(error, rows, fields)=>{
        if(!error){
            res.json({Status: 'Usuario actualizado'});
        } else{
            console.log(error);
        }
    });
});

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

module.exports = router;